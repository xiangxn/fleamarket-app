import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/style.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_refresh_indicator.dart';
import 'package:bitsflea/widgets/ext_circle_avatar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

class ReviewerListRoute extends StatelessWidget {
  List<Widget> _buildBtn(ReviewerListProvider model, Style style) {
    if (model.isReviewer() == false) {
      return <Widget>[
        IconButton(
          onPressed: () => model.applyReviewer(),
          icon: Icon(FontAwesomeIcons.userTie, color: style.primarySwatch),
        )
      ];
    }
    return <Widget>[];
  }

  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    final userModel = Provider.of<UserModel>(context, listen: false);
    return BaseRoute<ReviewerListProvider>(
      // listen: true,
      provider: ReviewerListProvider(context),
      builder: (_, model, loading) {
        print("ReviewerListRoute build.......");
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                centerTitle: true,
                title: Text(model.translate('reviewer_list.title')),
                backgroundColor: style.headerBackgroundColor,
                brightness: Brightness.light,
                textTheme: style.headerTextTheme,
                iconTheme: style.headerIconTheme,
                actions: _buildBtn(model, style)),
            body: FutureBuilder(
              future: model.fetchReviewers(isRefresh: true),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CustomRefreshIndicator(
                      onRefresh: () => model.fetchReviewers(isRefresh: true),
                      onLoad: () => model.fetchReviewers(isLoad: true),
                      child: ListView.separated(
                        // physics: ClampingScrollPhysics(),
                        itemCount: model.list.data.length,
                        itemBuilder: (_, i) {
                          return Selector<ReviewerListProvider, Reviewer>(
                            selector: (ctx, provider) => provider.list.data[i],
                            builder: (ctx, reviewer, _) {
                              return InkWell(
                                onTap: () => model.onToHome(reviewer.user),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          ExtCircleAvatar(reviewer.user.head, 40, strokeWidth: 0),
                                          Padding(
                                            padding: EdgeInsets.only(left: 16),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(reviewer.user.nickname),
                                                Text(
                                                    model.translate('combo_text.user_credit',
                                                        translationParams: {"amount": reviewer.user.creditValue.toString()}),
                                                    style: TextStyle(fontSize: 13, color: Colors.grey[700]))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                            Container(
                                              width: 70,
                                              child: Text(
                                                model.translate('combo_text.vote_count', translationParams: {"count": reviewer.votedCount.toString()}),
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.thumb_up,
                                                color: reviewer.voterApprove.any((e) => e.toInt() == userModel.user?.userid) ? Colors.green : Colors.grey,
                                              ),
                                              onPressed: () => model.support(reviewer),
                                            ),
                                            IconButton(
                                              icon: Icon(
                                                Icons.thumb_down,
                                                color: reviewer.voterAgainst.any((e) => e.toInt() == userModel.user?.userid) ? Colors.red : Colors.grey,
                                              ),
                                              onPressed: () => model.against(reviewer),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        separatorBuilder: (_, i) => Divider(color: Colors.grey[300], height: 1),
                      ));
                }
                return loading;
              },
            ));
      },
    );
  }
}

class ReviewerListProvider extends BaseProvider {
  ReviewerListProvider(BuildContext context) : super(context) {
    _list = new DataPage<Reviewer>();
  }

  DataPage<Reviewer> _list;
  DataPage<Reviewer> get list => _list;

  fetchReviewers({bool isRefresh = false, bool isLoad = false}) async {
    if (isLoad && _list.hasMore() == false) return;
    setBusy();
    if (isRefresh) _list.clean();
    final res = await api.getReviewers(_list.pageNo, _list.pageSize);
    if (res.code == 0) {
      var data = convertPageList(res.data, "reviewerPage", Reviewer());
      if (data.data.length > 0) {
        data.update(_list.data);
        _list = data;
        if (_list.hasMore()) {
          _list.pageNo += 1;
        }
      }
    }
    setBusy();
    // notifyListeners();
  }

  void onToHome(User user) {
    pushNamed(ROUTE_USER_HOME, arguments: user);
  }

  bool isReviewer() {
    final user = Provider.of<UserModel>(context, listen: false).user;
    return user?.isReviewer ?? false;
  }

  void applyReviewer() {
    pushNamed(ROUTE_APPLY_REVIEWER);
  }

  support(Reviewer reviewer) async {
    final um = Provider.of<UserModel>(context, listen: false);
    if (um.user.userid == reviewer.user.userid) {
      showToast(this.translate("reviewer_list.vote_error_1"));
      return;
    }
    if (reviewer.voterApprove.any((e) => e.toInt() == um.user.userid) || reviewer.voterAgainst.any((e) => e.toInt() == um.user.userid)) {
      showToast(this.translate("reviewer_list.vote_already"));
      return;
    }
    showLoading();
    final res = await api.voteReviewer(um.keys[1], um.user.userid, um.user.eosid, reviewer.user.userid, true);
    closeLoading();
    if (res.code == 0) {
      Reviewer r = reviewer.clone();
      r.voterApprove.add($fixnum.Int64.parseInt(um.user.userid.toString()));
      r.votedCount += 1;
      int idx = _list.data.indexWhere((e) => e.user.userid == reviewer.user.userid);
      _list.data[idx] = r;
      notifyListeners();
    } else if (res.code == 500) {
      showToast(getErrorMessage(res.msg));
    } else {
      showToast(this.translate("reviewer_list.vote_error"));
    }
  }

  against(Reviewer reviewer) async {
    final um = Provider.of<UserModel>(context, listen: false);
    if (um.user.userid == reviewer.user.userid) {
      showToast(this.translate("reviewer_list.vote_error_1"));
      return;
    }
    if (reviewer.voterAgainst.any((e) => e.toInt() == um.user.userid) || reviewer.voterApprove.any((e) => e.toInt() == um.user.userid)) {
      showToast(this.translate("reviewer_list.vote_already"));
      return;
    }
    showLoading();
    final res = await api.voteReviewer(um.keys[1], um.user.userid, um.user.eosid, reviewer.user.userid, false);
    closeLoading();
    if (res.code == 0) {
      Reviewer r = reviewer.clone();
      r.voterAgainst.add($fixnum.Int64.parseInt(um.user.userid.toString()));
      r.votedCount -= 1;
      int idx = _list.data.indexWhere((e) => e.user.userid == reviewer.user.userid);
      _list.data[idx] = r;
      notifyListeners();
    } else if (res.code == 500) {
      showToast(getErrorMessage(res.msg));
    } else {
      showToast(this.translate("reviewer_list.vote_error"));
    }
  }
}
