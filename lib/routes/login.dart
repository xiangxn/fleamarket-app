import 'dart:async';
import 'dart:convert';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/data_api.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/grpc/google/protobuf/wrappers.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/text_form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginRoute extends StatelessWidget {
  Widget _buildPhoneField(LoginProvider provider, [Key key]) {
    return TextFormInput(
      spKey: key,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      keyboardType: TextInputType.number,
      hintText: provider.translate('login.phone'),
      prefixIcon: FontAwesomeIcons.phoneAlt,
      inputFormatters: [LengthLimitingTextInputFormatter(11)],
      onSaved: provider.phone,
      validator: provider.validatePhone,
    );
  }

  Widget _buildPwdField(LoginProvider provider) {
    return Selector<LoginProvider, bool>(
      selector: (_, provider) => provider.obscure,
      builder: (_, obscure, __) {
        return TextFormInput(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          obscure: obscure,
          hintText: provider.translate('login.password'),
          prefixIcon: FontAwesomeIcons.key,
          onSaved: provider.password,
          validator: provider.validatePassword,
          enableInteractiveSelection: false,
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
              size: 16,
            ),
            onPressed: provider.setObscure,
          ),
        );
      },
    );
  }

  Widget _buildMasterBtn(String text, Function onTap) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      width: double.infinity,
      child: CustomButton(
        text: text,
        onTap: onTap,
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildVcodeField(LoginProvider provider) {
    return Selector<LoginProvider, int>(
      selector: (_, provider) => provider.vcodeCounter,
      builder: (_, vcodeCounter, __) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: TextFormInput(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                keyboardType: TextInputType.number,
                prefixIcon: FontAwesomeIcons.envelope,
                validator: provider.validateVcode,
                onSaved: provider.vcode,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                hintText: provider.translate('login.vcode'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: CustomButton(
                padding: EdgeInsets.all(16),
                width: 120,
                text: vcodeCounter > 0
                    ? provider.translate('login.vcode_counter', translationParams: {"vcode": vcodeCounter.toString()})
                    : provider.translate('login.get_vcode'),
                onTap: vcodeCounter == 0 ? provider.sendVcode : null,
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildRecommendedField(LoginProvider provider) {
    return TextFormInput(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      // keyboardType: TextInputType.emailAddress,
      hintText: provider.translate('login.recommended'),
      prefixIcon: FontAwesomeIcons.userFriends,
      inputFormatters: [LengthLimitingTextInputFormatter(12)],
      onSaved: provider.recommended,
      validator: provider.validateRecommended,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<LoginProvider>(
      provider: LoginProvider(context),
      builder: (ctx, provider, __) {
        final style = Provider.of<ThemeModel>(ctx).theme;
        return Scaffold(
          appBar: AppBar(
            title: Text(provider.translate('title')),
            centerTitle: true,
          ),
          body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Column(
                children: <Widget>[
                  TabBar(
                    controller: provider.tabController,
                    labelColor: style.primarySwatch,
                    unselectedLabelColor: Colors.black,
                    tabs: provider.tabs
                        .map((f) => Tab(
                              text: f,
                            ))
                        .toList(),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: TabBarView(
                          controller: provider.tabController,
                          children: <Widget>[
                            // view 1 ===============
                            Form(
                              key: provider.loginFormKey,
                              child: Column(
                                children: <Widget>[
                                  _buildPhoneField(provider),
                                  _buildPwdField(provider),
                                  _buildMasterBtn(provider.translate('login.login_text'), provider.login)
                                ],
                              ),
                            ),
                            // View 2 =================
                            SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Form(
                                key: provider.registerFormKey,
                                child: Column(
                                  children: <Widget>[
                                    _buildPhoneField(provider, provider.phoneKey),
                                    _buildPwdField(provider),
                                    _buildVcodeField(provider),
                                    _buildRecommendedField(provider),
                                    _buildMasterBtn(provider.translate('login.register_text'), provider.register)
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  )
                ],
              )),
        );
      },
    );
  }
}

class LoginProvider extends BaseProvider implements TickerProvider {
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
  DataApi _api;

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

  LoginProvider(BuildContext context) : super(context) {
    _tabs = [
      translate('login.login_text'),
      translate('login.register_text'),
    ];
    _api = DataApi();
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

  Future<bool> _login(String phone, String password) async {
    final keys = generateKeys(phone, password);
    _api.setKey(keys[2]);
    _api.setPhone(phone);
    final result = await _api.getUserByPhone(phone);
    if (result.code == 0) {
      final str = StringValue();
      result.data.unpackInto(str);
      dynamic data = jsonDecode(str.value)['users']['edges'];
      if (data.length < 1) {
        return false;
      }
      data = data[0]['node'];
      if (keys[2].toEOSPublicKey().toString() == data['authKey'].toString()) {
        Global.profile.user = User()..mergeFromProto3Json(data);
        Global.profile.keys = keys;
        return true;
      }
    }
    return false;
  }

  login() {
    if (_loginFormKey.currentState.validate()) {
      _loginFormKey.currentState.save();
      showLoading();
      _login(_phone, _password).then((val) {
        closeLoading();
        if (val) {
          pop(0);
        } else {
          showToast(translate("login.failure"));
        }
      });
    }
  }

  Future<BaseReply> _register(String phone, String password, String smsCode, String referral) async {
    List<EOSPrivateKey> keys = generateKeys(phone, password);
    final res = await _api.register(phone, keys[0].toEOSPublicKey().toString(), keys[1].toEOSPublicKey().toString(),
        smsCode: smsCode, referral: referral, authKey: keys[2].toEOSPublicKey().toString());
    if (res.code == 0) {
      Global.profile.keys = keys;
      _api.setKey(keys[2]);
      _api.setPhone(phone);
      var user = User();
      res.data.unpackInto(user);
      Global.profile.user = user;
    }
    return res;
  }

  Future<bool> checkRecommended() async {
    if (_recommended == null || _recommended.length == 0) {
      //暂不用验证码
      return true;
    } else {
      final res = await _api.getUserByEosid(_recommended);
      if (res.code == 0) {
        final data = convertEdgeList(res.data, "users");
        return data.length > 0;
      } else {
        return false;
      }
    }
  }

  register() {
    if (_registerFormKey.currentState.validate()) {
      _registerFormKey.currentState.save();
      checkRecommended().then((result) {
        if (result) {
          final res = _register(_phone, _password, _vcode, _recommended);
          processing(res).then((result) {
            if (result.code == 0) pop(0);
          });
        } else {
          showToast(translate("login.invalid_ref"));
        }
      });
    }
  }

  sendVcode() async {
    if (_phoneKey.currentState.validate() && !super.busy) {
      _phoneKey.currentState.save();
      setBusy();
      final res = await _api.sendSmsCode(_phone);
      if (res) {
        Global.prefs.setString(STORE_VCODE_TIMER, DateTime.now().toString());
        checkVcodeTimer();
      }
      super.setBusy();
    }
  }

  checkVcodeTimer([int reset, DateTime vcodeTimer]) {
    reset ??= TIMER_RESET;
    vcodeTimer ??= DateTime.parse(Global.prefs.getString(STORE_VCODE_TIMER) ?? '1900-01-01');
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
      return translate('login.phone_empty');
    } else if (!reg.hasMatch(val)) {
      return translate('login.phone_invalid');
    } else {
      return null;
    }
  }

  String validatePassword(val) {
    RegExp reg = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    if (val.length == 0) {
      return translate('login.password_empty');
    } else if (!reg.hasMatch(val)) {
      return translate('login.password_invalid');
    } else {
      return null;
    }
  }

  String validateVcode(val) {
    if (val.length != 6) {
      return translate('login.vcode_invalid');
    } else {
      return null;
    }
  }

  String validateRecommended(val) {
    RegExp reg = RegExp(r'^[a-z1-5.]{11}[a-z1-5]$');
    if (val.length > 0 && !reg.hasMatch(val)) {
      return translate('login.recommended_invalid');
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
