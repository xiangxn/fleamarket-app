import 'dart:convert';
import 'dart:math';

class Category {
  int id;
  String view;
  int parent;

  Category(){
    // this.id = Random.secure().nextInt(10);
    // this.view = 'view $id';
    // this.parent = 0;
  }

  Category.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.view = json['view'];
    this.parent = json['parent'];
  }

  Category clone(){
    String encode = jsonEncode(this);
    return Category.fromJson(jsonDecode(encode));
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['view'] = this.view;
    data['parent'] = this.parent;
    return data;
  }
}