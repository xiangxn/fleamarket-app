import 'package:amap_location/amap_location.dart';
import 'package:fleamarket/src/common/data_api.dart';
// import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/district.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService{
  DataApi _api ;
  String _adcode ;
  District _district ;

  District get district => _district;
  String get locationAdcode => _adcode;

  LocationService(DataApi api){
    _api = api;
    updateLocation();
    fetchDistricts();
  }

  String getAddress([String adcode]){
    adcode ??= _adcode;
    if(adcode != null && _district != null){
      String privonceCode = adcode.substring(0, 2) + '0000';
      District privonce = _district.districts.firstWhere((d) => d.adcode == privonceCode);
      String cityCode = adcode.substring(0, 4) + '00';
      District city;
      District district;
      if(privonce.districts.first.level == CITY_LV){
        city = privonce.districts.firstWhere((d) => d.adcode == cityCode);
        district = city.districts.firstWhere((d) => d.adcode == adcode);
      }else{
        district = privonce.districts.firstWhere((d) => d.adcode == adcode);
      }
      return '${privonce.name} ${city?.name ?? ''} ${district.name}';
    }
    return null;
  }

  fetchDistricts() async {
    District district;
    /// 默认从本地获取
    var districtJson = Utils.getStore(CACHE_DISTRICT, true);
    if(districtJson != null){
      district = District.fromJson(districtJson);
    }
    /// 如果缓存里面也没有，或者缓存里面有，但是已经超过24小时未更新则重新请求
    if(district == null || (district.level == COUNTRY_LV && DateTime.now().difference(district.lastUpdate).inHours > 24)){
      district = await _api.fetchDistricts();
      if(district != null){
        Utils.setStore(CACHE_DISTRICT, district.toJson());
      }
    }
    _district = district;
  }

  updateLocation() async {
    Map<PermissionGroup, PermissionStatus> permission = await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
    if(permission[PermissionGroup.locationWhenInUse] == PermissionStatus.granted){
      await AMapLocationClient.startup(AMapLocationOption(desiredAccuracy:CLLocationAccuracy.kCLLocationAccuracyHundredMeters));
      AMapLocation address = await AMapLocationClient.getLocation(true);
      _adcode = address?.adcode;
      print('update location done $_adcode');
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