import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/common/style.dart';
import 'package:flutter/material.dart';

import 'profile.dart';

class ThemeModel extends ProfileChangeNotifier {
  // 获取当前主题，如果为设置主题，则默认使用红色主题
  Style get theme => Global.themes[profile.theme];


  // 主题改变后，通知其依赖项，新主题会立即生效
  set setTheme(ColorSwatch color) {
    if (color != theme.primarySwatch) {
      profile.theme = color[500].value;
      notifyListeners();
    }
  }
}
