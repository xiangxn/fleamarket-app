import 'constant.dart';
import 'data_api.dart';

import 'dart:convert';
import 'package:amap_location/amap_location.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/models/district.dart';
import 'package:permission_handler/permission_handler.dart' as sysper;

class Address {
  String code;
  District privonce;
  District city;
  District district;
  Address({this.code, this.privonce, this.city, this.district});

  @override
  String toString() {
    return '${privonce.name} ${city?.name ?? ''} ${district.name}';
  }
}

class LocationData {
  DataApi _api;
  String _adcode;
  District _district;

  District get district => _district;
  String get locationAdcode => _adcode;

  LocationData(DataApi api) {
    _api = api;
    updateLocation();
    fetchDistricts();
  }

  Address getAddress([String adcode]) {
    adcode ??= _adcode;
    if (adcode != null && adcode.isNotEmpty && _district != null) {
      String privonceCode = adcode.substring(0, 2) + '0000';
      District privonce = _district.districts.firstWhere((d) => d.adcode == privonceCode);
      String cityCode = adcode.substring(0, 4) + '00';
      District city;
      District dis;
      if (privonce.districts.first.level == CITY_LV) {
        city = privonce.districts.firstWhere((d) => d.adcode == cityCode);
        dis = city.districts.firstWhere((d) => d.adcode == adcode);
      } else {
        dis = privonce.districts.firstWhere((d) => d.adcode == adcode);
      }
      return Address(code: adcode, privonce: privonce, city: city, district: dis);
    }
    return null;
  }

  fetchDistricts() async {
    /// 默认从本地获取
    var districtJson = Global.prefs.getString(CACHE_DISTRICT);
    if (districtJson != null && districtJson.isNotEmpty) {
      _district = District.fromJson(json.decode(districtJson));
    }

    /// 如果缓存里面也没有，或者缓存里面有，但是已经超过24小时未更新则重新请求
    if (_district == null || (_district.level == COUNTRY_LV && DateTime.now().difference(_district.lastUpdate).inHours > 24)) {
      _district = await _api.fetchDistricts();
      if (_district != null) {
        Global.prefs.setString(CACHE_DISTRICT, json.encode(_district.toJson()));
      }
    }
  }

  updateLocation() async {
    // Map<PermissionGroup, PermissionStatus> permission = await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
    // if (permission[PermissionGroup.locationWhenInUse] == PermissionStatus.granted) {
    Map<sysper.Permission, sysper.PermissionStatus> permission = await [sysper.Permission.locationWhenInUse].request();
    if (permission[sysper.Permission.locationWhenInUse] == sysper.PermissionStatus.granted) {
      await AMapLocationClient.startup(AMapLocationOption(desiredAccuracy: CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
      AMapLocation address = await AMapLocationClient.getLocation(true);
      _adcode = address?.adcode;
      if (_adcode != null && _adcode.isNotEmpty) {
        Global.console('update location done $_adcode');
      }

      // DateTime start = DateTime.now();
      // // 第一种库
      // Location location = await AmapLocation.fetchLocation();
      // if(location != null){
      //   _adcode = await location.adCode;
      //   print('第一种方式获取定位 $_adcode ${DateTime.now().difference(start).inMilliseconds}');
      // }

      // start = DateTime.now();
      // // 第二种库
      // await AMapLocationClient.startup(AMapLocationOption(desiredAccuracy:CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
      // AMapLocation address = await AMapLocationClient.getLocation(true);
      // _adcode = address?.adcode;
      // print('第二种方式获取定位 $address ${address?.adcode} ${address?.city} ${address?.province} ${address?.district} ${DateTime.now().difference(start).inMilliseconds}');
    }
  }
}
