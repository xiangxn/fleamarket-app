import 'dart:convert';

import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:flutter/material.dart';

class Profile {
  User user;
  String token;
  String tokenTime;
  int theme;
  int lastLogin;
  String locale;

  Profile(){
    theme = Colors.red[500].value;
  }

  Profile.fromJson(Map<String, dynamic> json) {
    this.token = json['token'];
    this.theme = json['theme'];
    this.lastLogin = json['lastLogin'];
    this.locale = json['locale'];
    this.tokenTime = json['tokenTime'];
    this.user = User.fromJson(jsonEncode(json['user']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user.toProto3Json();
    data['token'] = this.token;
    data['theme'] = this.theme;
    data['lastLogin'] = this.lastLogin;
    data['locale'] = this.locale;
    data['tokenTime'] = this.tokenTime;
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
}
