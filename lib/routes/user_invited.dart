import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/user_card_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserInvitedRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context).theme;
    return BaseRoute<UserInvitedProvider>(
      provider: UserInvitedProvider(context),
      builder: (_, provider, loading) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('user_invited.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: UserCardGroup(refresh: provider.fetchInvited, updateUser: provider.updateUser));
      },
    );
  }
}

class UserInvitedProvider extends BaseProvider {
  UserInvitedProvider(BuildContext context) : super(context);

  Future<DataPage<User>> fetchInvited({int pageNo, int pageSize, String key = "userInvited",String key2}) async {
    final user = Provider.of<UserModel>(context, listen: false).user;
    final res = await api.getInvitedUser(user.userid, pageNo, pageSize);
    if (res.code == 0) {
      var data = convertPageList(res.data, key, User());
      return data;
    }
    return DataPage<User>();
  }

  Future<void> updateUser({User obj}) async {
    final um = Provider.of<UserModel>(context, listen: false);
    if (um.hasFollow(obj.userid)) {
      final res = await api.unFollow(obj.userid, um.user.userid);
      if (res) {
        um.removeFollow(obj.userid);
      }
    } else {
      final res = await api.follow(obj.userid, um.user.userid);
      if (res) {
        um.addFollow(obj.userid);
      }
    }
  }
}
