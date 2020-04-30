import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class ConfirmPasswordViewModel extends BaseViewModel{
  ConfirmPasswordViewModel(BuildContext context) : super(context);

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  TextEditingController get controller => _controller;
  FocusNode get focusNode => _focusNode;

  bool _testFlag = false;

  void onSubmit([String str]) async {
    str ??= _controller.text;
    FocusScope.of(context).requestFocus(_focusNode);
    if(str.isEmpty){
      super.toast(super.locale.translation('message.password_empty'));
    }else{
      if(_testFlag){
        super.loading();
        await Future.delayed(Duration(milliseconds: 1600));
        super.loading();
        super.pop(str);
      }else{
        _testFlag = true;
        super.toast(super.locale.translation('message.password_error'));
      }
      // if(Utils.validateKey(super.user.phone, str)){
      //   super.loading();
      //   await Future.delayed(Duration(milliseconds: 1600));
      //   super.loading();
      //   super.pop(str);
      // }else{
      //   super.toast(super.locale.translation('message.password_error'));
      // }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
    _focusNode?.dispose();
  }
}