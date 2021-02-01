import 'dart:convert';

import 'package:amap_location/amap_location.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/app_info.dart';
import 'package:bitsflea/models/profile.dart';
import 'package:bitsflea/models/coin.dart';
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

  //配置
  static Config _config;
  static Config get config => _config;
  static Map<String, Coin> _coins;
  static Map<String, Coin> get coins => _coins;

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
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

    //配置
    DataApi.init();
    await AMapLocationClient.setApiKey(KEY_AMAP);
    await getConfig();
    await getCoins();
  }

  static Future<void> getCoins() async {
    _coins = Map<String, Coin>();
    DataApi api = DataApi();
    final cs = await api.getCoins();
    cs.forEach((e) {
      if (e["sym"] == "4,CNY" && config.showCNY == false) return;
      List<String> sym = e['sym'].split(",");
      Coin c = Coin();
      c.fee = double.parse(e['fee'].split(" ")[0]);
      c.precision = int.parse(sym[0]);
      c.isOut = e['is_out'] == 1;
      _coins[sym[1]] = c;
    });
  }

  static Future<void> getConfig() async {
    String str = getCache(CONFIG_KEY, minutes: 1440);
    if (str == null || str.isEmpty || str == "{}") {
      _config = await DataApi().getConfig();
      str = jsonEncode(_config.toProto3Json());
      if (str != null) setCache(CONFIG_KEY, str, dt: DateTime.now());
    } else {
      _config = Config();
      _config.mergeFromProto3Json(jsonDecode(str));
    }
    console("config: { $config }");
  }

  // 持久化Profile信息
  static saveProfile() => _prefs.setString("profile", jsonEncode(profile.toJson()));

  static removeProfile() => _prefs.remove("profile");

  static SharedPreferences get prefs => _prefs;

  static console(Object msg) {
    if (isRelease == false) print(msg);
  }

  static setCache(String key, String value, {DateTime dt}) {
    if (dt != null) {
      _prefs.setString("dt_$key", dt.toString());
    }
    _prefs.setString(key, value);
  }

  static getCache(String key, {int minutes = 30}) {
    final t = _prefs.getString("dt_$key");
    if (t != null && t.isNotEmpty) {
      final diff = DateTime.now().difference(DateTime.parse(t));
      if (diff.inMinutes >= minutes) {
        _prefs.remove(key);
        _prefs.remove("dt_$key");
        return null;
      }
    }
    return _prefs.getString(key);
  }

  static cleanCache(String key) {
    _prefs.remove(key);
    _prefs.remove("dt_$key");
  }
}
