import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/models/address.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class MineAddressViewModel extends BaseViewModel{
  MineAddressViewModel(BuildContext context) : super(context){
    fetchAddress();
  }

  List<Address> _list = [];
  List<Address> get list => _list;

  fetchAddress() async {
    super.setBusy();
    var process = accountService.fetchAddressByUser(userId);
    ExtResult res = await super.processing(process, showLoading: false);
    print(res.data);
    if(res.code == 0){
      _list = res.data;
    }
    notifyListeners();
    super.setBusy();
  }

  toEdit([Address address]) async {
    var newList = await super.pushNamed(EDIT_ADDRESS_ROUTE, arguments: address);
    if(newList != null){
      _list = newList;
      notifyListeners();
    }
    
    // if(updAddress != null && updAddress is Address){
    //   updAddress.isDefault = _list.length == 0;
    //   if(address != null){
        
    //     _list[_list.indexOf(address)] = updAddress;
    //   }else{
    //     _list.insert(0, updAddress);
    //   }
    //   notifyListeners();
    // }
  }

  setDefault(Address address) async {
    var process = accountService.setAddressDefault(address.id, address.userid);
    ExtResult res = await super.processing(process);
    if(res.success){
      _list = res.data;
    }
    notifyListeners();
  }

  delete(Address address) async {
    bool dialogRes = await super.confirm(super.locale.translation('message.delete_address'));
    if(dialogRes){
      var process = accountService.delAddress(address.id, address.userid);
      ExtResult res = await super.processing(process);
      if(res.success){
        _list = res.data;
      }
      // super.loading();
      // bool preIsDefault = address.isDefault;

      // _list.removeWhere((addr) => addr.id == address.id);
      // super.loading();
      // _list.removeAt(inx);
      // if(preIsDefault && _list.length > 0){
      //   _list.first.isDefault = true;
      // }
      notifyListeners();
    }
  }
}