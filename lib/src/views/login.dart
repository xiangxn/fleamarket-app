import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/login_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:fleamarket/src/widgets/text_form_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  Widget _buildPhoneField(LoginViewModel model, [Key key]) {
    return TextFormInput(
      spKey: key,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      keyboardType: TextInputType.number,
      hintText: model.locale.translation('login.phone'),
      prefixIcon: FontAwesomeIcons.phoneAlt,
      inputFormatters: [LengthLimitingTextInputFormatter(11)],
      onSaved: model.phone,
      validator: model.validatePhone,
    );
  }

  Widget _buildPwdField(LoginViewModel model) {
    return Selector<LoginViewModel, bool>(
      selector: (_, provider) => provider.obscure,
      builder: (_, obscure, __) {
        return TextFormInput(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
          obscure: obscure,
          hintText: model.locale.translation('login.password'),
          prefixIcon: FontAwesomeIcons.key,
          onSaved: model.password,
          validator: model.validatePassword,
          enableInteractiveSelection: false,
          suffixIcon: IconButton(
            icon: Icon(
              obscure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
              size: 16,
            ),
            onPressed: model.setObscure,
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

  Widget _buildVcodeField(LoginViewModel model) {
    var locale = model.locale;
    return Selector<LoginViewModel, int>(
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
                validator: model.validateVcode,
                onSaved: model.vcode,
                inputFormatters: [LengthLimitingTextInputFormatter(6)],
                hintText: locale.translation('login.vcode'),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 20, 0),
              child: CustomButton(
                padding: EdgeInsets.all(16),
                width: 120,
                text: vcodeCounter > 0 ? locale.translation('login.vcode_counter', [vcodeCounter.toString()]) : locale.translation('login.get_vcode'),
                onTap: vcodeCounter == 0 ? model.sendVcode : null,
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildRecommendedField(LoginViewModel model) {
    return TextFormInput(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
      // keyboardType: TextInputType.emailAddress,
      hintText: model.locale.translation('login.recommended'),
      prefixIcon: FontAwesomeIcons.userFriends,
      inputFormatters: [LengthLimitingTextInputFormatter(12)],
      onSaved: model.recommended,
      validator: model.validateRecommended,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      model: LoginViewModel(context),
      builder: (_, model, __) {
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            title: Text(locale.translation('app.title')),
            centerTitle: true,
          ),
          body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Column(
                children: <Widget>[
                  TabBar(
                    controller: model.tabController,
                    labelColor: Style.mainColor,
                    unselectedLabelColor: Colors.black,
                    tabs: model.tabs
                        .map((f) => Tab(
                              text: f,
                            ))
                        .toList(),
                  ),
                  Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: TabBarView(
                          controller: model.tabController,
                          children: <Widget>[
                            // view 1 ===============
                            Form(
                              key: model.loginFormKey,
                              child: Column(
                                children: <Widget>[
                                  _buildPhoneField(model),
                                  _buildPwdField(model),
                                  _buildMasterBtn(locale.translation('login.login_text'), model.login)
                                ],
                              ),
                            ),
                            // View 2 =================
                            SingleChildScrollView(
                              physics: ClampingScrollPhysics(),
                              child: Form(
                                key: model.registerFormKey,
                                child: Column(
                                  children: <Widget>[
                                    _buildPhoneField(model, model.phoneKey),
                                    _buildPwdField(model),
                                    _buildVcodeField(model),
                                    _buildRecommendedField(model),
                                    _buildMasterBtn(locale.translation('login.register_text'), model.register)
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
