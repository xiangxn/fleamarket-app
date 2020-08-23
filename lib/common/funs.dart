import 'dart:convert';
import 'dart:math';

import 'package:bitsflea/grpc/google/protobuf/any.pb.dart';
import 'package:bitsflea/grpc/google/protobuf/wrappers.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';

List<T> convertEdgeList<T extends GeneratedMessage>(Any data, String key, T type) {
  var val = StringValue();
  data.unpackInto(val);
  final json = jsonDecode(val.value);
  List<T> list = [];
  (json[key]['edges'] as List<dynamic>).forEach((e) {
    var obj = type.createEmptyInstance();
    obj.mergeFromProto3Json(e['node']);
    list.add(obj);
  });
  return list;
}

T convertEdge<T extends GeneratedMessage>(Any data, String key, T typeObj) {
  var val = StringValue();
  data.unpackInto(val);
  final json = jsonDecode(val.value);
  final list = (json[key]['edges'] as List<dynamic>);
  if (list.length > 0) {
    typeObj.mergeFromProto3Json(list[0]['node']);
    return typeObj;
  }
  return null;
}

DataPage<T> convertPageList<T extends GeneratedMessage>(Any data, String key, T type, {String key2}) {
  var val = StringValue();
  data.unpackInto(val);
  final json = jsonDecode(val.value);
  // print("convertPageList$json");
  return DataPage<T>.fromJson(json[key], type, key2: key2);
}

List<EOSPrivateKey> generateKeys(String phone, String password) {
  EOSPrivateKey ownerKey = EOSPrivateKey.fromSeed('$phone $password owner');
  EOSPrivateKey activeKey = EOSPrivateKey.fromSeed('$phone $password active');
  EOSPrivateKey authKey = EOSPrivateKey.fromSeed('$phone $password auth');
  return [ownerKey, activeKey, authKey];
}

formatPrice(String price) {
  double p = double.tryParse(price);
  if (p % p.floor() == 0) return p.floor().toString();
  return p.toString();
}

formatPrice2(String price) {
  List<String> ps = price.split(" ");
  double p = double.tryParse(ps[0]);
  if (p % p.floor() == 0) return "${p.floor().toString()} ${ps[1]}";
  return "${p.toString()} ${ps[1]}";
}

Key randomKey() {
  return Key(DateTime.now().toIso8601String() + Random.secure().nextInt(10000).toString());
}
