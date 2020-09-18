import 'dart:convert';

import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';

class Profile {
  User user;
  String token;
  String tokenTime;
  int theme;
  int lastLogin;
  String locale;
  List<EOSPrivateKey> keys;

  Profile() {
    theme = Global.themes.keys.first;
    keys = new List<EOSPrivateKey>();
  }

  Profile.fromJson(Map<String, dynamic> json) {
    this.token = json['token'];
    this.theme = json['theme'];
    this.lastLogin = json['lastLogin'];
    this.locale = json['locale'];
    this.tokenTime = json['tokenTime'];
    if (json['user'] != null) this.user = User()..mergeFromProto3Json(json['user']);
    keys = new List<EOSPrivateKey>();
    keys.addAll((json['keys'] as List<dynamic>).map((e) => EOSPrivateKey.fromString(e.toString())).toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user == null ? null : this.user.toProto3Json();
    data['token'] = this.token;
    data['theme'] = this.theme;
    data['lastLogin'] = this.lastLogin;
    data['locale'] = this.locale;
    data['tokenTime'] = this.tokenTime;
    data['keys'] = this.keys.map((e) => e.toString()).toList();
    return data;
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }

  void setToken(String token, String time) {
    this.token = token;
    this.tokenTime = time;
  }

  void cleanUser() {
    this.lastLogin = this.user.userid;
    this.user = null;
    this.token = null;
    this.keys.clear();
    this.keys = new List<EOSPrivateKey>();
  }
}
