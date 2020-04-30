import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
// import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/models/ext_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils{

  static Future<void> initSharedPreferences() async{
    _prefs = await SharedPreferences.getInstance();
    return ;
  }

  static SharedPreferences _prefs ;

  static SharedPreferences get prefs => _prefs;

  // static Future<List<dynamic>> getConfig({String key}) async {
  //   String res = await rootBundle.loadString('assets/testData.json');
  //   return json.decode(res)[key];
  // }

  static Future<dynamic> getJson(String path) async{
    String res = await rootBundle.loadString(path);
    return json.decode(res);
  }

  static setStore(String key, dynamic val){
    assert(key != null && val != null);
    if(val is bool){
      _prefs.setBool(key, val);
    }else if(val is int){
      _prefs.setInt(key, val);
    }else if(val is double){
      _prefs.setDouble(key, val);
    }else if(val is String){
      _prefs.setString(key, val);
    }else if(val is List<String>){
      print('set list string');
      _prefs.setStringList(key, val);
    }else{
      _prefs.setString(key, json.encode(val));
    }
  }

  static dynamic getStore(String key, [bool autoConver = false]){
    assert(key != null);
    var res = _prefs.get(key);
    if(autoConver && res != null){
      return json.decode(res);
    }else{
      return res;
    }
  }

  static clearStore([String key]) async {
    bool res = key == null ? await _prefs.clear() : await _prefs.remove(key);
    return res;
  }

  static List<EOSPrivateKey> generateKeys(String phone, String password){
    EOSPrivateKey ownerKey = EOSPrivateKey.fromSeed('$phone $password owner');
    EOSPrivateKey activeKey = EOSPrivateKey.fromSeed('$phone $password active');
    return [
      ownerKey,
      activeKey
    ];
  }

  /// 0 owner
  /// 1 active
  static EOSPrivateKey recoverKey([int inx = 1]){
    String keys = getStore(KEYS);
    if(keys == null){
      return null;
    }else{
      int len = (keys.length / 2).round();
      keys = reverseKey(keys);
      return EOSPrivateKey.fromString(keys.substring(inx * len, (inx + 1) * len));
    }
  }

  static String reverseKey(String str){
    List<String> list = str.split('');
    for(int i = 0 ; i < (str.length / 3).round() ; i++){
      int inx = i + 1;
      String tmp = list[inx];
      list[inx] = list[list.length - inx];
      list[list.length - inx] = tmp;
    }
    return list.join();
  }

  static saveKeys(List<EOSPrivateKey> keys){
    setStore(KEYS, reverseKey(keys[0].toString() + keys[1].toString()));
  }

  static bool validateKey(String phone, String password){
    List<EOSPrivateKey> keys = generateKeys(phone, password);
    return keys[0].toEOSPublicKey().toString() == recoverKey(0).toEOSPublicKey().toString() && 
           keys[1].toEOSPublicKey().toString() == recoverKey(1).toEOSPublicKey().toString();
  }

  // static Future<Location> getLocation() async {
  //   Map<PermissionGroup, PermissionStatus> permission = await PermissionHandler().requestPermissions([PermissionGroup.locationWhenInUse]);
  //   if(permission[PermissionGroup.locationWhenInUse] == PermissionStatus.granted){
  //     Location location = await AmapLocation.fetchLocation();
  //     return location;
  //   }
  //   return null;
  // }

  // static Future<String> getLocationString() async {
  //   DateTime start = DateTime.now();
  //   Location location = await Utils.getLocation();
  //   if(location != null){
  //     String province = await location.province;
  //     String city = await location.city;
  //     String district = await location.district;
  //     String xx = await location.adCode;
  //     print(xx);
  //     print('获取地址耗时 ${DateTime.now().difference(start).inMilliseconds}');
  //     return '$province $city $district';
  //   }
  //   return null;
  // }

  static Future<Uint8List> getImageData(String path) async {
    Response res = await Dio().get(path, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(res.data);
  }

  /// path 以 http 开头，则说明从网络获取图片，否则为本地获取
  /// width、height 指定图片裁剪宽、高
  static Future<ExtImage> getImage(String path, [int width, int height]) async {
    assert(path != null && path.length > 0);
    Uint8List bytes;
    if(path.startsWith('http')){
      Response res = await Dio().get(path, options: Options(responseType: ResponseType.bytes));
      bytes = Uint8List.fromList(res.data);
    }else{
      bytes = await File(path).readAsBytes();
    }
    Image tmp = Image.memory(bytes, cacheWidth: width, cacheHeight: height);
    Completer<ExtImage> cp = Completer();
    tmp.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _){
      cp.complete(ExtImage(tmp, info.image.width, info.image.height));
    }));
    return cp.future;
  }

  static reports(Object obj, StackTrace stack) async {
    DeviceInfoPlugin device = DeviceInfoPlugin();
    String str;
    _buildStr(id, system, version, model){
      return 'ID: $id \nSystem: $system \nVersion: $version \nmodel: $model \n';
    }
    if(Platform.isAndroid){
      AndroidDeviceInfo info = await device.androidInfo;
      str = _buildStr(info.androidId, 'android', 'V ${info.version.release} API ${info.version.sdkInt}', info.model);
    }else if(Platform.isIOS){
      IosDeviceInfo info = await device.iosInfo;
      str = _buildStr(info.identifierForVendor, info.systemName, info.systemVersion, info.utsname.machine);
    }
    print('=============== device ===============');
    print(str);
    print('=============== Error ===============');
    print(obj);
    print(stack);
  }

  static Key randomKey(){
    return Key(DateTime.now().toIso8601String()+Random.secure().nextInt(10000).toString());
  }

  static formatDateTime(String dateString){
    if(dateString == null){
      return null;
    }
    return DateTime.parse(dateString);
  }

}