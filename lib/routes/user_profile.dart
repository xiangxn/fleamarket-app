import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/routes/home.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/custom_refresh_indicator.dart';
import 'package:bitsflea/widgets/ext_circle_avatar.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class UserProfilePage extends StatelessWidget {
  final HomeProvider homeProvider;
  UserProfilePage({Key key, @required this.homeProvider}) : super(key: key);
  Widget _buildChunk(String mark, int count, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Text(count.toString(), style: TextStyle(fontSize: 16, color: Colors.grey[900])),
          Text(
            mark,
            style: TextStyle(color: Colors.grey[600]),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<UserProfileProvider>(
      listen: true,
      provider: UserProfileProvider(context, homeProvider),
      builder: (_, provider, __) {
        return Selector<UserProfileProvider, User>(
          selector: (_, provider) => provider.currentUser,
          builder: (_, user, __) {
            // print("user:$user");
            final style = Provider.of<ThemeModel>(context).theme;
            return CustomRefreshIndicator(
                onRefresh: provider.refreshUser,
                child: SingleChildScrollView(
                  controller: provider.controller,
                  physics: ClampingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                        color: style.backgroundColor,
                        child: Row(
                          children: <Widget>[
                            GestureDetector(
                              child: ExtCircleAvatar(user?.head, 80, strokeWidth: 0),
                              onTap: provider.toEdit,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      user?.nickname ?? '-',
                                      style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: 15),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            user?.isReviewer ?? false ? FontAwesomeIcons.userTie : FontAwesomeIcons.solidUser,
                                            color: Colors.grey[700],
                                            size: 16,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Text(
                                                user?.isReviewer ?? false
                                                    ? provider.translate('user_profile.user_reviewer')
                                                    : provider.translate('user_profile.user_normal'),
                                                style: TextStyle(color: Colors.grey[900])),
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: provider.copy,
                                      child: RichText(
                                        text: TextSpan(
                                            text: provider.translate('user_profile.recommended'),
                                            style: TextStyle(color: Colors.grey[700]),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: user?.eosid ?? '0',
                                                style: TextStyle(color: Colors.black),
                                              )
                                            ]),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              height: 80,
                              width: 30,
                              child: IconButton(
                                icon: Icon(FontAwesomeIcons.userEdit, size: 20, color: Colors.grey[700]),
                                onPressed: provider.toEdit,
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        margin: EdgeInsets.only(bottom: 10, top: 20),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                          _buildChunk(provider.translate('user_profile.favorite'), user?.followTotal ?? 0, () => provider.pushNamed(ROUTE_MINE_FAVORITE)),
                          _buildChunk(provider.translate('user_profile.follow'), user?.favoriteTotal ?? 0, () => provider.pushNamed(ROUTE_MINE_FOCUS)),
                          _buildChunk(provider.translate('user_profile.fans'), user?.fansTotal ?? 0, () => provider.pushNamed(ROUTE_MINE_FANS)),
                        ]),
                      ),
                      LineButtonGroup(children: [
                        LineButtonItem(
                            text: provider.translate('user_profile.mine_publish'),
                            subText: (user?.postsTotal ?? 0).toString(),
                            prefixIcon: Icons.shop,
                            onTap: () => provider.pushNamed(ROUTE_MINE_PUBLISH)),
                        LineButtonItem(
                          text: provider.translate('user_profile.mine_buy'),
                          subText: (user?.buyTotal ?? 0).toString(),
                          prefixIcon: Icons.archive,
                          onTap: () => provider.pushNamed(ROUTE_MINE_BUY),
                        ),
                        LineButtonItem(
                          text: provider.translate('user_profile.mine_sell'),
                          subText: (user?.sellTotal ?? 0).toString(),
                          prefixIcon: Icons.unarchive,
                          onTap: () => provider.pushNamed(ROUTE_MINE_SELL),
                        ),
                        LineButtonItem(
                          text: provider.translate('user_profile.mine_recommended'),
                          subText: (user?.referralTotal ?? 0).toString(),
                          prefixIcon: Icons.account_box,
                          onTap: () => provider.pushNamed(ROUTE_MINE_INVITE),
                        ),
                      ]),
                      LineButtonGroup(margin: EdgeInsets.only(top: 10), children: [
                        LineButtonItem(
                            text: provider.translate('user_profile.mine_balances'),
                            prefixIcon: Icons.monetization_on,
                            onTap: () => provider.pushNamed(ROUTE_MINE_BALANCES)),
                        LineButtonItem(
                            text: provider.translate('user_profile.mine_keys'), prefixIcon: Icons.vpn_key, onTap: () => provider.pushNamed(ROUTE_MINE_KEYS)),
                        LineButtonItem(
                          text: provider.translate('user_profile.mine_address'),
                          prefixIcon: Icons.location_on,
                          onTap: () => provider.pushNamed(ROUTE_MINE_ADDRESS),
                        ),
                        LineButtonItem(
                          text: provider.translate('user_profile.mine_withdrawal'),
                          prefixIcon: Icons.call_to_action,
                          onTap: () => provider.pushNamed(ROUTE_MINE_WITHDRAWAL),
                        ),
                      ]),
                      LineButtonGroup(
                        margin: EdgeInsets.only(top: 10),
                        children: <Widget>[
                          LineButtonItem(
                            text: provider.translate('user_profile.mine_vote'),
                            prefixIcon: Icons.account_balance,
                            onTap: () => provider.pushNamed(ROUTE_MINE_VOTE),
                          ),
                          user?.isReviewer ?? false
                              ? LineButtonItem(
                                  text: provider.translate('user_profile.audit_goods'),
                                  prefixIcon: Icons.assignment,
                                  onTap: () => provider.pushNamed(ROUTE_AUDIT_GOODS),
                                )
                              : LineButtonItem(
                                  text: provider.translate('user_profile.try_reviewer'),
                                  prefixIcon: Icons.assignment_ind,
                                  onTap: () => provider.pushNamed(ROUTE_TRY_REVIEWER),
                                )
                        ],
                      ),
                      LineButtonGroup(
                        margin: EdgeInsets.only(top: 10),
                        children: [
                          LineButtonItem(text: provider.translate('user_profile.version'), subText: Global.appInfo.version, prefixIcon: Icons.info),
                          LineButtonItem(
                              text: provider.translate('user_profile.about'), prefixIcon: Icons.insert_emoticon, onTap: () => provider.pushNamed(ROUTE_ABOUT))
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 30),
                        width: double.infinity,
                        child: CustomButton(
                          text: provider.translate('user_profile.logout'),
                          color: Colors.red,
                          onTap: provider.logout,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      )
                    ],
                  ),
                ));
          },
        );
      },
    );
  }
}

class UserProfileProvider extends BaseProvider {
  ScrollController _controller;
  HomeProvider _homeProvider;

  UserProfileProvider(BuildContext context, HomeProvider homeProvider) : super(context) {
    _controller = ScrollController();
    _homeProvider = homeProvider;
  }

  User get currentUser => Provider.of<UserModel>(context, listen: false).user;
  ScrollController get controller => _controller;

  Future<bool> refreshUser() async {
    final um = Provider.of<UserModel>(context, listen: false);
    if (um.user != null) {
      final process = api.getUserByUserid(um.user.userid);
      final res = await processing(process, loading: false);
      if (res.code == 0) {
        User user = convertEdge<User>(res.data, "users", User());
        if (user == null) {
          return false;
        }
        user.head = URL_IPFS_GATEWAY + user.head;
        um.user = user;
        return true;
      }
    }
    return false;
  }

  logout() async {
    final um = Provider.of<UserModel>(context, listen: false);
    um.logout();
    api.delKey();
    _homeProvider.setPage(0);
    _controller.animateTo(0, duration: Duration(milliseconds: 10), curve: Curves.easeIn);
  }

  copy() {
    final user = Provider.of<UserModel>(context).user;
    Clipboard.setData(ClipboardData(text: user.eosid));
    showToast(translate('user_profile.copy'));
  }

  toEdit() async {
    await pushNamed(ROUTE_USER_EDIT);
  }

  /// 申请评审员
  tryReviewer() {}

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
