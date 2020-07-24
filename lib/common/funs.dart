import 'dart:convert';

import 'package:bitsflea/grpc/google/protobuf/any.pb.dart';
import 'package:bitsflea/grpc/google/protobuf/wrappers.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:protobuf/protobuf.dart';



List<dynamic> convertEdgeList(Any data, String key) {
    var val = StringValue();
    data.unpackInto(val);
    final json = jsonDecode(val.value);
    return (json[key]['edges'] as List<dynamic>);
  }

  DataPage<T> convertPageList<T extends GeneratedMessage>(Any data, T type, String key) {
    var val = StringValue();
    data.unpackInto(val);
    final json = jsonDecode(val.value);
    // print("convertPageList$json");
    return DataPage<T>.fromJson(json[key], type);
  }