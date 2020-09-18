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

class UserFansRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    return BaseRoute<UserFansProvider>(
      provider: UserFansProvider(context),
      builder: (_, provider, loading) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('user_fans.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: UserCardGroup(
              refresh: provider.fetchFans,
              updateUser: provider.updateUser,
            ));
      },
    );
  }
}

class UserFansProvider extends BaseProvider {
  UserFansProvider(BuildContext context) : super(context);

  Future<DataPage<User>> fetchFans({int pageNo, int pageSize, String key = "followByUser", String key2 = "follower"}) async {
    final user = Provider.of<UserModel>(context, listen: false).user;
    final res = await api.getFollowByUser(user.userid, pageNo, pageSize);
    if (res.code == 0) {
      var data = convertPageList(res.data, key, User(), key2: key2);
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
