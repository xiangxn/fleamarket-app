import 'dart:convert';

import 'package:bitsflea/grpc/google/protobuf/any.pb.dart';
import 'package:bitsflea/grpc/google/protobuf/wrappers.pb.dart';
import 'package:bitsflea/models/data_page.dart';
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

DataPage<T> convertPageList<T extends GeneratedMessage>(Any data, String key, T type) {
  var val = StringValue();
  data.unpackInto(val);
  final json = jsonDecode(val.value);
  // print("convertPageList$json");
  return DataPage<T>.fromJson(json[key], type);
}

List<EOSPrivateKey> generateKeys(String phone, String password) {
  EOSPrivateKey ownerKey = EOSPrivateKey.fromSeed('$phone $password owner');
  EOSPrivateKey activeKey = EOSPrivateKey.fromSeed('$phone $password active');
  EOSPrivateKey authKey = EOSPrivateKey.fromSeed('$phone $password auth');
  return [ownerKey, activeKey, authKey];
}
