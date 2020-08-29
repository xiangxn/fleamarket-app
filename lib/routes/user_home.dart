import 'dart:ui';

import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/routes/product_list.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/ext_circle_avatar.dart';
import 'package:bitsflea/widgets/extended_nested_scroll_view.dart';
import 'package:bitsflea/widgets/nested_scroll_view_inner_scroll_position_key_widget.dart';
import 'package:bitsflea/widgets/user_card_group.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserHomeRoute extends StatelessWidget {
  UserHomeRoute({Key key, this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return BaseRoute<UserHomeProvider>(
      // listen: true,
      provider: UserHomeProvider(context, user),
      builder: (_, provider, loading) {
        final style = Provider.of<ThemeModel>(context).theme;
        return Scaffold(
            body: provider.busy
                ? loading
                : NestedScrollView(
                    innerScrollPositionKeyBuilder: provider.tabKeyBuilder,
                    headerSliverBuilder: (_, flag) {
                      return <Widget>[
                        SliverAppBar(
                          expandedHeight: 180, // 经测试 header 和 tabbar高度为90，expandedHeight多出来的为中间内容(可隐藏)高度
                          pinned: true,
                          floating: false,
                          snap: false,
                          centerTitle: true,
                          title: Text(provider.curUser.nickname),
                          backgroundColor: style.headerBackgroundColor,
                          brightness: Brightness.light,
                          textTheme: style.headerTextTheme,
                          iconTheme: style.headerIconTheme,
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              children: <Widget>[
                                Positioned.fill(
                                    child: Image(
                                  image: NetworkImage(provider.curUser.head),
                                  fit: BoxFit.cover,
                                )),
                                Positioned.fill(
                                    child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                  child: Container(
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                )),
                                Positioned(
                                    top: 80,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        children: <Widget>[
                                          ExtCircleAvatar(provider.curUser.head, 60, strokeWidth: 0),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(left: 16),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 8),
                                                    child: Text(
                                                      provider.translate('combo_text.user_credit',
                                                          translationParams: {"amount": "${provider.curUser.creditValue ?? 0}"}),
                                                      style: TextStyle(fontSize: 13),
                                                    ),
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        provider.curUser.isReviewer == false ? FontAwesomeIcons.solidUser : FontAwesomeIcons.userTie,
                                                        color: Colors.grey[700],
                                                        size: 16,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 10),
                                                        child: Text(
                                                            provider.curUser.isReviewer == false
                                                                ? provider.translate('user_profile.user_normal')
                                                                : provider.translate('user_profile.user_reviewer'),
                                                            style: TextStyle(fontSize: 13, color: Colors.grey[900])),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Selector<UserHomeProvider, bool>(
                                            selector: (ctx, provider) => provider.hasFollow,
                                            builder: (ctx, has, _) {
                                              return CustomButton(
                                                onTap: () => provider.follow(obj: provider.curUser),
                                                text: has ? provider.translate('user_card.followed') : provider.translate('user_card.follow'),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                          bottom: TabBar(
                              controller: provider.controller,
                              unselectedLabelColor: Colors.grey[700],
                              labelColor: Colors.black,
                              labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              tabs: provider.tabs.map((t) => Tab(text: t)).toList()),
                        ),
                      ];
                    },
                    body: MediaQuery.removePadding(
                        removeTop: true,
                        context: context,
                        child: TabBarView(
                          controller: provider.controller,
                          children: <Widget>[
                            NestedScrollViewInnerScrollPositionKeyWidget(
                                provider.tabKeys[0],
                                FutureBuilder(
                                    future: provider.fetchProductPage(page: DataPage<Product>()),
                                    builder: (ctx, snapshot) {
                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return ProductList(productPage: snapshot.data, onGetData: provider.fetchProductPage);
                                      }
                                      return loading;
                                    })),
                            NestedScrollViewInnerScrollPositionKeyWidget(
                                provider.tabKeys[1],
                                UserCardGroup(
                                  refresh: provider.fetchFollows,
                                )),
                            NestedScrollViewInnerScrollPositionKeyWidget(
                                provider.tabKeys[2],
                                UserCardGroup(
                                  refresh: provider.fetchFans,
                                  updateUser: provider.follow,
                                )),
                          ],
                        )),
                  ));
      },
    );
  }
}

class UserHomeProvider extends BaseProvider implements TickerProvider {
  UserHomeProvider(BuildContext context, User user) : super(context) {
    _tabs = [translate('user_home.other_publish'), translate('user_home.other_follow'), translate('user_home.other_fans')];
    _controller = TabController(length: _tabs.length, vsync: this);
    init(isInit: true, user: user);
  }

  User _user;
  List<String> _tabs;
  TabController _controller;

  User get curUser => _user;
  List<String> get tabs => _tabs;
  TabController get controller => _controller;

  bool get hasFollow {
    final um = Provider.of<UserModel>(context, listen: false);
    final flag = um.hasFollow(_user.userid);
    return flag;
  }

  List<Key> tabKeys = [Key('ExtTab0'), Key('ExtTab1'), Key('ExtTab2')];

  Key tabKeyBuilder() {
    return Key('ExtTab${_controller.index}');
  }

  Future<void> fetchUser({bool notify = true}) async {
    final res = await api.getUserByUserid(_user.userid);
    if (res.code == 0) {
      _user = convertEdge<User>(res.data, "users", User());
      if (notify) {
        notifyListeners();
      }
    }
    return;
  }

  Future<DataPage<Product>> fetchProductPage({DataPage<Product> page, int categoryid}) async {
    final res = await api.getProductsByPublisher(_user.userid, page.pageNo, page.pageSize);
    if (res.code == 0) {
      var data = convertPageList<Product>(res.data, "productByPublisher", Product());
      data.update(page.data);
      if (data.hasMore()) data.pageNo += 1;
      return data;
    }
    return page;
  }

  Future<DataPage<User>> fetchFollows({int pageNo, int pageSize, String key = "followByFollower", String key2 = "user"}) async {
    final res = await api.getFollowByFollower(_user.userid, pageNo, pageSize);
    if (res.code == 0) {
      var data = convertPageList(res.data, key, User(), key2: key2);
      return data;
    }
    return DataPage<User>();
  }

  Future<DataPage<User>> fetchFans({int pageNo, int pageSize, String key = "followByUser", String key2 = "follower"}) async {
    final res = await api.getFollowByUser(_user.userid, pageNo, pageSize);
    if (res.code == 0) {
      var data = convertPageList(res.data, key, User(), key2: key2);
      return data;
    }
    return DataPage<User>();
  }

  init({bool isInit = false, User user}) async {
    setBusy();
    if (isInit) {
      _user = user;
    }
    // await fetchUser(notify: false);
    // await fetchProductPage(notify: false);
    // await fetchFollows(notify: false);
    // await fetchFans(notify: false);
    setBusy();
    notifyListeners();
  }

  Future<void> follow({User obj}) async {
    final um = Provider.of<UserModel>(context, listen: false);
    if (um.hasFollow(obj.userid)) {
      showLoading();
      final res = await api.unFollow(obj.userid, um.user.userid);
      closeLoading();
      if (res) {
        um.removeFollow(obj.userid);
        notifyListeners();
      }
    } else {
      showLoading();
      final res = await api.follow(obj.userid, um.user.userid);
      closeLoading();
      if (res) {
        um.addFollow(obj.userid);
        notifyListeners();
      }
    }
  }

  @override
  Ticker createTicker(onTick) {
    return Ticker(onTick);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
