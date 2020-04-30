import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutViewModel extends BaseViewModel{
  AboutViewModel(BuildContext context) : super(context){
    super.setBusy();
    rootBundle.loadString('assets/fleamarket.txt').then((res){
      super.setBusy();
      readme = res;
      notifyListeners();
    });
  }

  String readme = '';

}