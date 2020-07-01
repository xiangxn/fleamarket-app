import 'dart:convert';

import 'package:fleamarket/src/models/base_model.dart';

class Category extends BaseModel {
  int id;
  String view;
  int parent;

  Category() {
    // this.id = Random.secure().nextInt(10);
    // this.view = 'view $id';
    // this.parent = 0;
  }

  Category.fromJson(Map<String, dynamic> json) {
    this.id = json['cid'];
    this.view = json['view'];
    this.parent = json['parent'];
  }

  Category clone() {
    String encode = jsonEncode(this);
    return Category.fromJson(jsonDecode(encode));
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cid'] = this.id;
    data['view'] = this.view;
    data['parent'] = this.parent;
    return data;
  }

  @override
  Category fromJson(Map<String, dynamic> json) {
    return Category.fromJson(json);
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
