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

class PersonalViewModel extends BaseViewModel {
  HomeViewModel _homeViewModel;
  ExtSystem _extSystem;
  ScrollController _controller;

  ExtSystem get extSystem => _extSystem;
  ScrollController get controller => _controller;

  PersonalViewModel(BuildContext context, HomeViewModel homeViewModel) : super(context) {
    _homeViewModel = homeViewModel;
    _extSystem = Provider.of<ExtSystem>(context, listen: false);
    _controller = ScrollController();
  }

  Future<void> refreshUser() async {
    if (currentUser != null) {
      var process = accountService.fetchUser(userId);
      final res = await super.processing(process, showLoading: false);
      notifyListeners();
    }
    return;
  }

  logout() async {
    accountService.logout(userId);
    _homeViewModel.setPage(0);
    _controller.animateTo(0, duration: Duration(milliseconds: 10), curve: Curves.easeIn);
  }

  copy() {
    Clipboard.setData(ClipboardData(text: userEosId));
    super.toast(super.locale.translation('personal.copy'));
  }

  toEdit() async {
    await super.pushNamed(USER_EDIT_ROUTE);
  }

  /// 申请评审员
  tryReviewer() {
    
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  void onResumed() {
    
  }
}
