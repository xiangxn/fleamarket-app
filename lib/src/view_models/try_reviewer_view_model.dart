import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TryReviewerViewModel extends BaseViewModel{
  TryReviewerViewModel(BuildContext context) : super(context){
    fetchTerms();
  }

  String _terms;
  bool _isAgree = false;
  
  String get terms => _terms;
  bool get isAgree => _isAgree;
  

  agree(bool val){
    _isAgree = val;
    notifyListeners();
  }

  fetchTerms() async {
    super.setBusy();
    await Future.delayed(Duration(milliseconds: 600));
    _terms = await rootBundle.loadString('assets/fleamarket.txt');
    super.setBusy();
    notifyListeners();
  }

  submit(){
    if(!_isAgree){
      super.toast(super.locale.translation('message.agree_terms'));
    }else{
      super.pop();
    }
  }

}