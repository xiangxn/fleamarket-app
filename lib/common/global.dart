import 'dart:convert';

import 'package:amap_location/amap_location.dart';
import 'package:bitsflea/models/app_info.dart';
import 'package:bitsflea/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data_api.dart';
import 'style.dart';
import 'constant.dart';

final _themes = <int, Style>{Colors.red[500].value: new Style(), Colors.green[500].value: new Style()..primarySwatch = Colors.green};

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();
  // 可选的主题列表
  static Map<int, Style> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // App信息
  static AppInfo get appInfo => _appInfo;
  static AppInfo _appInfo;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    await AMapLocationClient.setApiKey(KEY_AMAP);
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
        console("global init: $profile");
      } catch (e) {
        print(e);
      }
    }
    // 包信息
    _appInfo = new AppInfo();
    await _appInfo.init();

    DataApi.init();
  }

  // 持久化Profile信息
  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));

  static removeProfile() => _prefs.remove("profile");

  static SharedPreferences get prefs => _prefs;

  static console(Object msg) {
    if (isRelease == false) print(msg);
  }
}
