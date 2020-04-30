import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/models/district.dart';
import 'package:fleamarket/src/services/location_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AddressSelectorViewModel extends BaseViewModel{
  LocationService _locationService;
  String _location;
  District _district;
  List<District> _districtLevel = [];
  ScrollController _controller = ScrollController();

  String get location => _location;
  District get district => _district;
  bool get isTop => _districtLevel.length == 0;
  ScrollController get controller => _controller;

  AddressSelectorViewModel(BuildContext context) : super(context){
    _locationService = Provider.of<LocationService>(context);
    initCurLocation();
  }

  initCurLocation(){
    _location = _locationService.getAddress() ?? super.locale.translation('address_selector.no_permission');
    _district = _locationService.district;
  }

  animateToTop(){
    _controller.animateTo(0, duration: Duration(milliseconds: 10), curve: Curves.easeIn);
  }

  selectCurrent() async {
    if(!super.busy){
      String adcode = _locationService.locationAdcode;
      if(adcode == null){
        Map<PermissionGroup, PermissionStatus> status = await PermissionHandler().requestPermissions([
          PermissionGroup.locationWhenInUse
        ]);
        if(status[PermissionGroup.locationWhenInUse] != PermissionStatus.granted){
          bool res = await super.confirm(super.locale.translation('permission.location'));
          if(res){
            bool canOpen = await PermissionHandler().openAppSettings();
          }
        }
      }else{
        super.pop(adcode);
      }
    }
  }

  selectAddress(District district){
    if(district.level == DISTRICT_LV){
      super.pop(district.adcode);
    }else{
      _districtLevel.add(district);
      _district = district;
      animateToTop();
      notifyListeners();
    }
  }

  back(){
    if(_districtLevel.length == 0){
      super.pop();
    }else{
      _districtLevel.removeLast();
      if(_districtLevel.length == 0){
        _district = _locationService.district;
      }else{
        _district = _districtLevel.last;
      }
      animateToTop();
      notifyListeners();
    }
  }

  @override
  void onResumed() async {
    super.setBusy();
    await _locationService.updateLocation();
    initCurLocation();
    notifyListeners();
    super.setBusy();
  }
}