import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/view_models/personal_view_model.dart';
import 'package:fleamarket/src/view_models/shop_view_model.dart';
import 'package:flutter/material.dart';
import 'base_view_model.dart';

class HomeViewModel extends BaseViewModel{
  int _pageInx = 0;
  ShopViewModel _shopViewModel;
  PersonalViewModel _personalViewModel;

  get pageInx => _pageInx;
  get shopViewModel => _shopViewModel;
  get personalViewModel => _personalViewModel;

  HomeViewModel(BuildContext context) : super(context){
    _shopViewModel = ShopViewModel(context);
    _personalViewModel = PersonalViewModel(context, this);
  }

  setPage(int inx) async {
    if(_pageInx != inx){
      if(inx == 1 && super.user == null){
        var res = await super.pushNamed(LOGIN_ROUTE);
        if(res == 0){
          _pageInx = inx;
          notifyListeners();
        }
      }else{
        _pageInx = inx;
        notifyListeners();
      }
    }
  }

  toPublish() async {
    if(super.user != null){
      var res = await super.pushNamed(PUBLISH_ROUTE);
    }else{
      var res = await super.pushNamed(LOGIN_ROUTE);
    }
    
  }

}