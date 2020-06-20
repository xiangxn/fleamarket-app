import 'dart:async';

import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/grpc/bitsflea.pb.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'base_view_model.dart';

class LoginViewModel extends BaseViewModel implements TickerProvider {
  TabController _tabController;
  bool _isActive = true;
  List<String> _tabs;
  bool _obscure = true;
  String _phone;
  String _password;
  String _vcode;
  String _recommended;
  int _vcodeCounter = 0;
  GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  GlobalKey<FormFieldState> _phoneKey = GlobalKey<FormFieldState>();

  TabController get tabController => _tabController;
  List<String> get tabs => _tabs;
  get loginFormKey => _loginFormKey;
  get registerFormKey => _registerFormKey;
  get phoneKey => _phoneKey;
  get obscure => _obscure;
  get vcodeCounter => _vcodeCounter;

  phone(String val) => _phone = val;
  password(String val) => _password = val;
  vcode(String val) => _vcode = val;
  recommended(String val) => _recommended = val;

  LoginViewModel(BuildContext context) : super(context) {
    _tabs = [
      super.locale.translation('login.login_text'),
      super.locale.translation('login.register_text'),
    ];
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(viewChangeListener);
    checkVcodeTimer();
  }

  setActive() {
    _isActive = !_isActive;
  }

  setObscure() {
    _obscure = !_obscure;
    notifyListeners();
  }

  viewChangeListener() {
    _obscure = true;
    FocusScope.of(context).requestFocus(FocusNode());
    notifyListeners();
  }

  updateUser() async {
    await Future.delayed(Duration(milliseconds: 10));
    super.pop(0);
  }

  login() async {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      loading(true);
      accountService.login(_phone, _password).then((val) {
        updateUser();
      });
    }
  }

  register() async {
    if (_registerFormKey.currentState.validate()) {
      _registerFormKey.currentState.save();
      super.loading();
      final recommendedRes = await checkRecommended();
      if (recommendedRes) {
        final res = await accountService.register(_phone, _password, _vcode, _recommended);
        super.loading();
        if (res != null) {
          updateUser();
        } else {
          super.toast("注册失败");
        }
      } else {
        super.loading();
        super.toast("无效的引荐人");
      }
    }
  }

  Future<bool> checkRecommended() async {
    if (_recommended == null || _recommended.length == 0) {
      return true;
    } else {
      final res = await accountService.validateReferral(_recommended);
      return res;
    }
  }

  sendVcode() async {
    if (_phoneKey.currentState.validate() && !super.busy) {
      _phoneKey.currentState.save();
      print('_phone ${_phone}');
      super.setBusy();
      var process = accountService.sendVcode(_phone);
      ExtResult res = await super.processing(process, showLoading: false);
      if (res.code == 0) {
        Utils.setStore(VCODE_TIMER, DateTime.now().toString());
        checkVcodeTimer();
      }
      super.setBusy();
    }
  }

  checkVcodeTimer([int reset, DateTime vcodeTimer]) {
    reset ??= TIMER_RESET;
    vcodeTimer ??= DateTime.parse(Utils.getStore(VCODE_TIMER) ?? '1900-01-01');
    int diff = DateTime.now().difference(vcodeTimer).inSeconds;
    _vcodeCounter = reset - diff;
    if (_vcodeCounter <= 0) {
      _vcodeCounter = 0;
    } else {
      Timer(Duration(seconds: 1), () {
        if (_isActive) {
          checkVcodeTimer(reset, vcodeTimer);
        }
      });
    }
    notifyListeners();
  }

  String validatePhone(val) {
    RegExp reg = RegExp(r'^[1](([3][0-9])|([4][5-9])|([5][0-3,5-9])|([6][5,6])|([7][0-8])|([8][0-9])|([9][1,8,9]))[0-9]{8}$');
    if (val.length == 0) {
      return super.locale.translation('login.phone_empty');
    } else if (!reg.hasMatch(val)) {
      return super.locale.translation('login.phone_invalid');
    } else {
      return null;
    }
  }

  String validatePassword(val) {
    RegExp reg = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (val.length == 0) {
      return super.locale.translation('login.password_empty');
    } else if (!reg.hasMatch(val)) {
      return super.locale.translation('login.password_invalid');
    } else {
      return null;
    }
  }

  String validateVcode(val) {
    if (val.length != 6) {
      return super.locale.translation('login.vcode_invalid');
    } else {
      return null;
    }
  }

  String validateRecommended(val) {
    RegExp reg = RegExp(r'^[a-z1-5.]{11}[a-z1-5]$');
    if (val.length > 0 && !reg.hasMatch(val)) {
      return super.locale.translation('login.recommended_invalid');
    } else {
      return null;
    }
  }

  @override
  Ticker createTicker(onTick) {
    return Ticker(onTick);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController?.removeListener(viewChangeListener);
    _tabController?.dispose();
  }
}
