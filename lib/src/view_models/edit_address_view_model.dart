import 'package:fleamarket/src/models/address.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/services/account_service.dart';
import 'package:fleamarket/src/services/location_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:fleamarket/src/views/address_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditAddressViewModel extends BaseViewModel{
  EditAddressViewModel(BuildContext context, Address address) : super(context){
    _address = address;
    _accountService = Provider.of(context, listen: false);
    _locationService = Provider.of(context, listen: false);
    if(_address == null){
      _address = Address();
      _address.position = _locationService.getAddress();
    }
    _consigneeController.text = _address.name ?? '';
    _phoneController.text = _address.phone ?? '';
    _positionController.text = _address.position ?? '';
    _detailController.text = _address.address ?? '';
    _postcodeController.text = _address.postcode ?? '';
  }

  AccountService _accountService;
  Address _address ;
  TextEditingController _consigneeController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _detailController = TextEditingController();
  TextEditingController _postcodeController = TextEditingController();
  LocationService _locationService;

  Address get address => _address;
  TextEditingController get consigneeController => _consigneeController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get positionController => _positionController;
  TextEditingController get detailController => _detailController;
  TextEditingController get postcodeController => _postcodeController;

  @override
  void dispose() {
    super.dispose();
    _consigneeController?.dispose();
    _phoneController?.dispose();
    _positionController?.dispose();
    _detailController?.dispose();
    _postcodeController?.dispose();
  }

  bool validate(){
    String phone = _phoneController.text;
    RegExp reg = RegExp(r'^[1](([3][0-9])|([4][5-9])|([5][0-3,5-9])|([6][5,6])|([7][0-8])|([8][0-9])|([9][1,8,9]))[0-9]{8}$');
    bool flag = false;
    if(_consigneeController.text.isEmpty){
      super.toast(super.locale.translation('message.consignee_empty'));
    }else if(_positionController.text.isEmpty){
      super.toast(super.locale.translation('message.position_empty'));
    }else if(phone.isEmpty){
      super.toast(super.locale.translation('message.contact_empty'));
    }else if(!reg.hasMatch(phone)){
      super.toast(super.locale.translation('message.phone_invalid'));
    }else{
      flag = true;
    }
    return flag;
  }

  showAddressSelector() async {
    FocusScope.of(context).requestFocus(FocusNode());
    Widget screen = AddressSelector(
      title: super.locale.translation('publish.address_selector'),
    );
    String adcode = await super.dialog(screen);
    if(adcode != null){
      _address.position = _locationService.getAddress(adcode);
      _positionController.text = _address.position;
      notifyListeners();
    }
  }

  submit() async {
    FocusScope.of(context).requestFocus(FocusNode());
    if(validate()){
      _address.userid = super.user.userid;
      _address.name = _consigneeController.text;
      _address.phone = _phoneController.text;
      _address.position = _positionController.text;
      _address.address = _detailController.text;
      _address.postcode = _postcodeController.text.isEmpty ? '000000' : _postcodeController.text;
      var process;
      if(_address.id != null){
        process = _accountService.updAddress(_address);
      }else{
        process = _accountService.addAddress(_address);
      }
      ExtResult res = await super.processing(process);
      if(res.success){
        super.pop(res.data);
      }
    }
  }
}