import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/type_defs.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/services/account_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 1，在单个对象里面操作，完成之后通知列表更新
// 2，去掉这个ViewModel，通过列表传递点击函数，可以方便列表更新，但是多个操作就需要传递多个点击函数
class UserCardViewModel extends BaseViewModel{
  UserCardViewModel(BuildContext context, User user, UpdateObjectCallback<User> updateUser) : super(context){
    _accountService = Provider.of(context, listen: false);
    _user = user;
    _updateUser = updateUser;
    _isFocus = false;
  }

  AccountService _accountService;
  User _user;
  UpdateObjectCallback<User> _updateUser ;
  bool _isFocus;

  User get user => _user;
  bool get isFocus => _isFocus;

  int counter = 0;

  focusUser() async {
    // 正常逻辑
    // _user.fansTotal = (_user.fansTotal ?? 0) + 1;
    // _updateUser(user: _user);

    // 模拟逻辑
    _isFocus = !_isFocus;
    notifyListeners();
  }

  toUserHome(){
    super.pushNamed(MINE_HOME_ROUTE, arguments: _user);
  }

  @override
  void dispose() {
    super.dispose();
  }
}