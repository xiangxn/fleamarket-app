import 'package:fleamarket/src/common/utils.dart';

class OrderReturn{
  String reasons;
  int status;
  String shipNum;
  DateTime shipTime;
  DateTime createTime;
  DateTime shipOutTime;

  OrderReturn.fromJson(Map<String, dynamic> json){
    this.reasons = json['reasons'];
    this.status = json['status'];
    this.createTime = Utils.formatDateTime(json['createTime']);
    this.shipNum = json['shipNum'];
    this.shipTime = Utils.formatDateTime(json['shipTime']);
    this.shipOutTime = Utils.formatDateTime(json['shipOutTime']);
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = Map<String, dynamic>();
    json['reasons'] = this.reasons;
    json['status'] = this.status;
    json['createTime'] = this.createTime?.toIso8601String() ?? '';
    json['shipNum'] = this.shipNum;
    json['shipTime'] = this.shipTime?.toIso8601String() ?? '';
    json['shipOutTime'] = this.shipOutTime?.toIso8601String() ?? '';
    return json;
  }
}