import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class ExtSystem extends ChangeNotifier{
  
  String appName;
  String buildNumber;
  String packageName;
  String version;

  init() async {
    PackageInfo info = await PackageInfo.fromPlatform();
    this.appName = info.appName;
    this.buildNumber = info.buildNumber;
    this.packageName = info.packageName;
    this.version = info.version;
  }
}