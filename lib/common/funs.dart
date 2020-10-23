import 'dart:convert';
import 'dart:math';

import 'package:bitsflea/common/constant.dart';
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

List<T> convertList<T extends GeneratedMessage>(Any data, String key, T type) {
  var val = StringValue();
  data.unpackInto(val);
  final json = jsonDecode(val.value);
  List<T> list = [];
  (json[key] as List).forEach((e) {
    var obj = type.createEmptyInstance();
    obj.mergeFromProto3Json(e);
    list.add(obj);
  });
  return list;
}

List<EOSPrivateKey> generateKeys(String phone, String password) {
  EOSPrivateKey ownerKey = EOSPrivateKey.fromSeed('$phone $password owner');
  EOSPrivateKey activeKey = EOSPrivateKey.fromSeed('$phone $password active');
  EOSPrivateKey authKey = EOSPrivateKey.fromSeed('$phone $password auth');
  return [ownerKey, activeKey, authKey];
}

Future<bool> validateKey(String phone, String password, EOSPrivateKey auth) async {
  EOSPrivateKey authKey = EOSPrivateKey.fromSeed('$phone $password auth');
  return authKey.toEOSPublicKey().toString() == auth.toEOSPublicKey().toString();
}

formatPrice(String price) {
  double p = double.tryParse(price) ?? 0;
  if (p % p.floor() == 0) return p.floor().toString();
  return p.toString();
}

formatPrice2(String price) {
  List<String> ps = price.split(" ");
  if (ps.length == 2) {
    double p = double.tryParse(ps[0]) ?? 0;
    if (p % p.floor() == 0) return "${p.floor().toString()} ${ps[1]}";
    return "${p.toString()} ${ps[1]}";
  }
  return "";
}

formatPrice3(double price) {
  if (price % price.floor() == 0) return price.floor().toString();
  return price.toString();
}

String addPrice(String price1, String price2) {
  double p1 = double.tryParse(price1.split(" ")[0]) ?? 0;
  double p2 = double.tryParse(price2.split(" ")[0]) ?? 0;
  double p = p1 + p2;
  List<String> ps = price1.split(" ");
  if (ps.length == 2) {
    if (p % p.floor() == 0) return "${p.floor().toString()} ${ps[1]}";
    return "${p.toString()} ${ps[1]}";
  }
  return formatPrice3(p);
}

Key randomKey() {
  return Key(DateTime.now().toIso8601String() + Random.secure().nextInt(10000).toString());
}

String getErrorMessage(String src) {
  if (src.startsWith("assertion failure with message: ")) return src.split(": ")[1];
  return src;
}

String getIPFSUrl(String path) {
  return path.startsWith("http://") || path.startsWith("https://") ? path : URL_IPFS_GATEWAY + path;
}
