import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/ext_system.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/services/account_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:fleamarket/src/view_models/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PersonalViewModel extends BaseViewModel{
  AccountService _accountService ;
  HomeViewModel _homeViewModel ;
  ExtSystem _extSystem;
  ScrollController _controller;

  ExtSystem get extSystem => _extSystem;
  ScrollController get controller => _controller;

  PersonalViewModel(BuildContext context, HomeViewModel homeViewModel) : super(context){
    _accountService = Provider.of<AccountService>(context, listen: false);
    _homeViewModel = homeViewModel;
    _extSystem = Provider.of<ExtSystem>(context, listen: false);
    _controller = ScrollController();
  }

  Future<void> refreshUser() async {
    if(super.user != null){
      var process = _accountService.fetchUser(super.user.userid);
      ExtResult res = await super.processing(process, showLoading: false);
      if(_accountService.updateUser(res.data)){
        notifyListeners();
        refreshToken();
      }
    }
    return ;
  }

  refreshToken() async {
    if(super.user != null){
      String token = Utils.getStore(TOKEN);
      String tokenTimer = Utils.getStore(TOKEN_TIMER) ?? '1900-01-01';
      int diff = DateTime.now().difference(DateTime.parse(tokenTimer)).inHours;
      if(diff > TIMER_TOKEN){
        _accountService.refreshToken(super.user.userid, token);
      }
    }
  }

  logout() async {
    _accountService.logout(super.user.userid);
    _homeViewModel.setPage(0);
    _controller.animateTo(0, duration: Duration(milliseconds: 10), curve: Curves.easeIn);
  }

  copy() {
    Clipboard.setData(ClipboardData(text: super.user.eosid));
    super.toast(super.locale.translation('personal.copy'));
  }

  toEdit() async {
    await super.pushNamed(USER_EDIT_ROUTE);
  }

  /// 申请评审员
  tryReviewer(){
    print(super.user.creditValue);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  void onResumed() {
    refreshToken();
  }

}