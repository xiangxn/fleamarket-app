import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/models/profile.dart';
import 'package:flutter/material.dart';

class ProfileChangeNotifier extends ChangeNotifier {
  Profile get profile => Global.profile;

  @override
  void notifyListeners() {
    Global.saveProfile(); //保存Profile变更
    super.notifyListeners(); //通知依赖的Widget更新
  }
}
