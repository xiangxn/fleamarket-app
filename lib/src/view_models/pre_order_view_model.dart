import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/models/address.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/services/account_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:fleamarket/src/widgets/address_select_card_group.dart';
import 'package:fleamarket/src/widgets/confirm_password.dart';
import 'package:flutter/material.dart';

class PreOrderViewModel extends BaseViewModel{
  PreOrderViewModel(BuildContext context, Goods goods) : super(context){
    _goods = goods;
    initAddress();
  }

  AccountService _accountService;
  Goods _goods;
  List<Address> _addressList;
  Address _address;

  Address get address => _address ;

  initAddress([bool test = false]) async {
    _addressList = test ? [Address(),Address(),Address(),Address(),Address()] : [] ;
    _address = _addressList.length == 0 ? null : _addressList.firstWhere((add) => add.isDefault);
    notifyListeners();
  }

  submit() async {
    if(_address == null){
      super.toast(super.locale.translation('message.order_no_address'));
    }else{
      String password = await showModalBottomSheet(
        context: context,
        builder: (_) => ConfirmPassword()
      );
      print('return password $password');
      super.pushAndRepalceUntil(MINE_BUY_ROUTE, DETAIL_ROUTE, result: 'im pre order and need to refresh');
    }
  }

  selectAddress() async {
    if(_addressList.length != null){
      await super.pushNamed(MINE_ADDRESS_ROUTE);
      initAddress(true);
    }else{
      Widget screen = AddressSelectCardGroup(
        addressList: _addressList,
      );
      Address address = await super.dialog(screen);
      if(address != null){
        _address = address;
        notifyListeners();
        print(_address.phone);
      }  
    }
    
  }

}