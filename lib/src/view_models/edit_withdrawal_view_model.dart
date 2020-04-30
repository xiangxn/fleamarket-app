import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditWithdrawalViewModel extends BaseViewModel{
  EditWithdrawalViewModel(BuildContext context, String withdrawal) : super(context){
    _controller.text = withdrawal ?? '';
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  paste() async {
    ClipboardData data = await Clipboard.getData('text/plain');
    _controller.text += data.text;
  }

  submit(){
    super.pop(_controller.text);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}