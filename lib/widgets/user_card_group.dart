import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/type.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/widgets/user_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_refresh_indicator.dart';

class UserCardGroup extends StatelessWidget {
  UserCardGroup({Key key, this.refresh, this.controller, this.updateUser}) : super(key: key);
  final RefreshPageCallback<DataPage<User>> refresh;
  final ScrollController controller;
  final UpdateObjectCallback<User> updateUser;

  @override
  Widget build(BuildContext context) {
    print('build user card group***************');
    return BaseRoute<UserCardGroupProvider>(
        // listen: true,
        provider: UserCardGroupProvider(context, refresh, updateUser: updateUser),
        builder: (_, provider, loading) {
          return FutureBuilder(
              future: provider.fetch(isRefresh: true),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var page = provider.page;
                  return CustomRefreshIndicator(
                    onRefresh: () => provider.fetch(isRefresh: true),
                    onLoad: provider.fetch,
                    child: ListView.builder(
                        controller: controller,
                        physics: ClampingScrollPhysics(),
                        itemCount: page.data.length,
                        itemBuilder: (_, i) => Selector<UserCardGroupProvider, User>(
                              selector: (_, __) => page.data[i],
                              builder: (_, user, __) {
                                return UserCard(
                                  key: randomKey(),
                                  user: user,
                                  updateUser: provider.updateUser,
                                );
                              },
                            )),
                  );
                } else {
                  return loading;
                }
              });
        });
  }
}

class UserCardGroupProvider extends BaseProvider {
  UserCardGroupProvider(BuildContext context, RefreshPageCallback refresh, {UpdateObjectCallback<User> updateUser}) : super(context) {
    _refresh = refresh;
    _updateUser = updateUser;
    _page = DataPage<User>();
  }

  DataPage<User> _page;
  RefreshPageCallback<DataPage<User>> _refresh;
  UpdateObjectCallback<User> _updateUser;

  DataPage<User> get page => _page;

  Future<void> fetch({bool isRefresh = false}) async {
    setBusy();
    if (isRefresh) {
      _page.clean();
    }
    var data = await _refresh(pageNo: _page.pageNo, pageSize: _page.pageSize);
    data.update(_page.data);
    _page = data;
    setBusy();
    notifyListeners();
  }

  Future<void> updateUser({User obj}) async {
    int inx = _page.data.indexWhere((u) => u.userid == obj.userid);
    _page.data[inx] = obj.clone()..fansTotal -= 1;
    if (_updateUser != null) await _updateUser(obj: _page.data[inx]);
    notifyListeners();
  }

  @override
  void dispose() {
    _refresh = null;
    _updateUser = null;
    super.dispose();
  }
}