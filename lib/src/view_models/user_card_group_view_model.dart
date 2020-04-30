import 'package:fleamarket/src/common/type_defs.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class UserCardGroupViewModel extends BaseViewModel{
  UserCardGroupViewModel(BuildContext context, RefreshPageCallback refresh) : super(context){
    _refresh = refresh;
    _page = ExtPage<User>();
    fetch();
  }

  ExtPage<User> _page;
  RefreshPageCallback _refresh;

  ExtPage<User> get page => _page;

  Future<void> fetch({bool isRefresh = false}) async {
    super.setBusy();
    if(isRefresh){
      _page.clean();
    }
    var process = _refresh(pageNo: _page.pageNo, pageSize: _page.pageSize);
    ExtResult res = await super.processing(process, showLoading: false);
    if(res.code == 0){
      _page = res.data..update(_page.data);
    }
    super.setBusy();
    notifyListeners();
  }

  void updateUser({User obj}) {
    int inx = _page.data.indexWhere((u) => u.userid == obj.userid);
    _page.data[inx] = obj.clone();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

}