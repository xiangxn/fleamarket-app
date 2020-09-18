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

class UserFollowRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("user follow build..............");
    return BaseRoute<UserFollowProvider>(
      listen: true,
      provider: UserFollowProvider(context),
      builder: (_, provider, loading) {
        final style = Provider.of<ThemeModel>(context, listen: false).theme;
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('user_follow.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: UserCardGroup(refresh: provider.fetchFollow, updateUser: provider.updateUser));
      },
    );
  }
}

class UserFollowProvider extends BaseProvider {
  UserFollowProvider(BuildContext context) : super(context);

  Future<DataPage<User>> fetchFollow({int pageNo, int pageSize, String key = "followByFollower", String key2 = "user"}) async {
    final user = Provider.of<UserModel>(context,listen: false).user;
    final res = await api.getFollowByFollower(user.userid, pageNo, pageSize);
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
