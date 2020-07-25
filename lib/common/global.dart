import 'dart:convert';

import 'package:bitsflea/common/data_api.dart';
import 'package:bitsflea/common/style.dart';
import 'package:bitsflea/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _themes = <int, Style>{Colors.red[500].value: new Style(), Colors.green[500].value: new Style()..primarySwatch = Colors.green};

class Global {
  static SharedPreferences _prefs;
  static Profile profile = Profile();
  // 可选的主题列表
  static Map<int, Style> get themes => _themes;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
    var _profile = _prefs.getString("profile");
    if (_profile != null) {
      try {
        profile = Profile.fromJson(jsonDecode(_profile));
      } catch (e) {
        print(e);
      }
    }
    DataApi.init();
  }

  // 持久化Profile信息
  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));

  static SharedPreferences get prefs => _prefs;
}
