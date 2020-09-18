import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/type.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'custom_button.dart';
import 'ext_circle_avatar.dart';

class UserCard extends StatelessWidget {
  UserCard({Key key, this.user, this.updateUser}) : super(key: key);
  final User user;
  final UpdateObjectCallback<User> updateUser;

  @override
  Widget build(BuildContext context) {
    print("user card build..........");
    return BaseRoute<UserCardProvider>(
        listen: true,
        provider: UserCardProvider(context, user, updateUser),
        builder: (_, provider, __) {
          final style = Provider.of<ThemeModel>(context, listen: false).theme;
          return InkWell(
            onTap: provider.toUserHome,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: ExtCircleAvatar(user.head, 60, strokeWidth: 0),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(user.nickname),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      user.isReviewer ? FontAwesomeIcons.userTie : FontAwesomeIcons.solidUser,
                                      color: Colors.grey[700],
                                      size: 14,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8),
                                      child: Text(
                                        user.isReviewer ? provider.translate('user_profile.user_reviewer') : provider.translate('user_profile.user_normal'),
                                        style: style.smallFont,
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  provider.translate('combo_text.user_credit', translationParams: {"amount": (user.creditValue ?? 0).toString()}),
                                  style: style.smallFont,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      CustomButton(
                        fontSize: 14,
                        width: 80,
                        height: 30,
                        active: !(provider.isMe),
                        onTap: provider.updateUser,
                        text: provider.hasFollow ? provider.translate('user_card.followed') : provider.translate('user_card.follow'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

// 1，在单个对象里面操作，完成之后通知列表更新
// 2，去掉这个ViewModel，通过列表传递点击函数，可以方便列表更新，但是多个操作就需要传递多个点击函数
class UserCardProvider extends BaseProvider {
  UserCardProvider(BuildContext context, User user, UpdateObjectCallback<User> updateUser) : super(context) {
    _user = user;
    _updateUser = updateUser;
  }

  User _user;
  UpdateObjectCallback<User> _updateUser;

  User get user => _user;
  bool get hasFollow {
    final um = Provider.of<UserModel>(context, listen: false);
    final flag = um.hasFollow(user.userid);
    return flag;
  }

  bool get isMe {
    final me = Provider.of<UserModel>(context, listen: false).user;
    return _user.userid == me.userid;
  }

  int counter = 0;

  updateUser() async {
    if (_updateUser != null) {
      await _updateUser(obj: user);
    }
    notifyListeners();
  }

  toUserHome() {
    pushNamed(ROUTE_USER_HOME, arguments: _user);
  }

  @override
  void dispose() {
    _user = null;
    _updateUser = null;
    super.dispose();
  }
}
