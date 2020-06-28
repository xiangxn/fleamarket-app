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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cryptor/cryptor.dart';

class Utils {
  static Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    return;
  }

  static SharedPreferences _prefs;

  static SharedPreferences get prefs => _prefs;

  // static Future<List<dynamic>> getConfig({String key}) async {
  //   String res = await rootBundle.loadString('assets/testData.json');
  //   return json.decode(res)[key];
  // }

  static String encrypt(String password, String src) {
    return Cryptor.encrypt(src, password);
  }

  static String decrypt(String password, String encrypted) {
    return Cryptor.decrypt(encrypted, password);
  }

  static Future<dynamic> getJson(String path) async {
    String res = await rootBundle.loadString(path);
    return json.decode(res);
  }

  static setStore(String key, dynamic val) {
    assert(key != null && val != null);
    if (val is bool) {
      _prefs.setBool(key, val);
    } else if (val is int) {
      _prefs.setInt(key, val);
    } else if (val is double) {
      _prefs.setDouble(key, val);
    } else if (val is String) {
      _prefs.setString(key, val);
    } else if (val is List<String>) {
      print('set list string');
      _prefs.setStringList(key, val);
    } else {
      _prefs.setString(key, json.encode(val));
    }
  }

  static dynamic getStore(String key, [bool autoConver = false]) {
    assert(key != null);
    var res = _prefs.get(key);
    if (autoConver && res != null) {
      return json.decode(res);
    } else {
      return res;
    }
  }

  static clearStore([String key]) async {
    bool res = key == null ? await _prefs.clear() : await _prefs.remove(key);
    return res;
  }

  static List<EOSPrivateKey> generateKeys(String phone, String password) {
    EOSPrivateKey ownerKey = EOSPrivateKey.fromSeed('$phone $password owner');
    EOSPrivateKey activeKey = EOSPrivateKey.fromSeed('$phone $password active');
    EOSPrivateKey authKey = EOSPrivateKey.fromSeed('$phone $password auth');
    return [ownerKey, activeKey, authKey];
  }

  static bool validateKey(String phone, String password, {String owner, String active, String auth, List<EOSPrivateKey> keys}) {
    if (keys == null) keys = generateKeys(phone, password);
    if (owner == null) owner = getStore(KEY_OWNER);
    if (active == null) active = getStore(KEY_ACTIVE);
    if (auth == null) auth = getStore(KEY_AUTH);
    final k0 = decrypt(password, owner);
    final k1 = decrypt(password, active);
    final k2 = decrypt(password, auth);
    return keys[0].toString() == k0 && keys[1].toString() == k1 && keys[2].toString() == k2;
  }

  static Future<Uint8List> getImageData(String path) async {
    Response res = await Dio().get(path, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(res.data);
  }

  /// path 以 http 开头，则说明从网络获取图片，否则为本地获取
  /// width、height 指定图片裁剪宽、高
  static Future<ExtImage> getImage(String path, [int width, int height]) async {
    assert(path != null && path.length > 0);
    Uint8List bytes;
    if (path.startsWith('http')) {
      Response res = await Dio().get(path, options: Options(responseType: ResponseType.bytes));
      bytes = Uint8List.fromList(res.data);
    } else {
      bytes = await File(path).readAsBytes();
    }
    Image tmp = Image.memory(bytes, cacheWidth: width, cacheHeight: height);
    Completer<ExtImage> cp = Completer();
    tmp.image.resolve(ImageConfiguration()).addListener(ImageStreamListener((ImageInfo info, bool _) {
      cp.complete(ExtImage(tmp, info.image.width, info.image.height));
    }));
    return cp.future;
  }

  static reports(Object obj, StackTrace stack) async {
    DeviceInfoPlugin device = DeviceInfoPlugin();
    String str;
    _buildStr(id, system, version, model) {
      return 'ID: $id \nSystem: $system \nVersion: $version \nmodel: $model \n';
    }

    if (Platform.isAndroid) {
      AndroidDeviceInfo info = await device.androidInfo;
      str = _buildStr(info.androidId, 'android', 'V ${info.version.release} API ${info.version.sdkInt}', info.model);
    } else if (Platform.isIOS) {
      IosDeviceInfo info = await device.iosInfo;
      str = _buildStr(info.identifierForVendor, info.systemName, info.systemVersion, info.utsname.machine);
    }
    print('=============== device ===============');
    print(str);
    print('=============== Error ===============');
    print(obj);
    print(stack);
  }

  static Key randomKey() {
    return Key(DateTime.now().toIso8601String() + Random.secure().nextInt(10000).toString());
  }

  static formatDateTime(String dateString) {
    if (dateString == null) {
      return null;
    }
    return DateTime.parse(dateString);
  }

  static Image createImage(Future<Uint8List> fu) {
    Image img;
    fu.then((imgData) {
      img = Image.memory(imgData, fit: BoxFit.cover);
    });
    return img;
  }

  static dynamic getUserAttr(dynamic user, String att) {
    if (user != null) return user[att];
    return null;
  }
}
