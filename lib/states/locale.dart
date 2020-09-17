import 'dart:ui';

import 'package:bitsflea/states/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LocaleModel extends ProfileChangeNotifier {
  // 获取当前用户的APP语言配置Locale类，如果为null，则语言跟随系统语言
  Locale getLocale() {
    if (profile.locale == null) return null;
    var t = profile.locale.split("_");
    // return Locale(t[0], t[1]);
    return Locale(t[0]);
  }

  // 获取当前Locale的字符串表示
  String get locale => profile.locale;

  // 用户改变APP语言后，通知依赖项更新，新语言会立即生效
  setLocale(BuildContext context, String locale) async {
    if (locale != profile.locale) {
      profile.locale = locale;
      await FlutterI18n.refresh(context, getLocale());
      notifyListeners();
    }
  }
}
