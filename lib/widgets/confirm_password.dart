

import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmPassword extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseRoute<ConfirmPasswordProvider>(
      provider: ConfirmPasswordProvider(context),
      builder: (_, model, __){
        return AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: Duration(milliseconds: 100),
          child: TextField(
            obscureText: true,
            textInputAction: TextInputAction.done,
            controller: model.controller,
            focusNode: model.focusNode,
            autofocus: true,
            autocorrect: false,
            enableSuggestions: false,
            onSubmitted: model.onSubmit,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 8),
              isDense: true,
              hintText: model.translate('message.hint_password'),
              suffix: CustomButton(
                autoUnfocus: false,
                onTap: model.onSubmit,
                margin: EdgeInsets.symmetric(horizontal: 4),
                text: model.translate('controller.ok'),
              )
            ),
            
          ),
        );
      },
    );    
  }

}

class ConfirmPasswordProvider extends BaseProvider{
  ConfirmPasswordProvider(BuildContext context) : super(context);

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  TextEditingController get controller => _controller;
  FocusNode get focusNode => _focusNode;

  void onSubmit([String str]) async {
    str ??= _controller.text;
    FocusScope.of(context).requestFocus(_focusNode);
    if(str.isEmpty){
      this.showToast(translate('message.password_empty'));
    }else{
      final um = Provider.of<UserModel>(context,listen: false);
      showLoading();
      bool v = await validateKey(um.user.phone, str,um.keys[2]);
      closeLoading();
      if(v){
        this.pop(str);
      }else{
        this.showToast(translate('message.password_error'));
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _focusNode?.dispose();
  }
}