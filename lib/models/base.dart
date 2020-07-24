import 'package:protobuf/protobuf.dart';

abstract class BaseModel extends GeneratedMessage {
  fromJson(Map<String, dynamic> json);
}
