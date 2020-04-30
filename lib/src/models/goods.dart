import 'package:fleamarket/src/models/user.dart';

class Goods{
  int id;
  int productId;
  String title;
  String img;
  List<String> imgs;
  int collections;
  String price;
  int saleMethod;
  int collectionFlag;
  int category;
  int status; // （临）定义状态 0 正常， 1 待审核， 2 审核拒绝， 3 下架
  int isNew;
  int isReturns;
  String postage;
  String position;
  DateTime releaseTime;
  String desc;
  User seller;
  // 基于哪个user查询的，用于商品列表查询之后，登录用户注销之后再次登录，判断是否是上次登录之前的结果
  // 初始化会在获取列表的时候把当前用户id赋值进去
  // 收藏的时候会把当前用户id赋值进去
  int faceUserId;

  Goods();

  Goods.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.productId = json['productId'];
    this.title = json['title'];
    this.img = json['img'];
    this.imgs = (json['imgs'] as List<dynamic>)?.map<String>((f) => f as String)?.toList() ?? [];
    this.collections = json['collections'];
    this.price = json['price'];
    this.saleMethod = json['saleMethod'];
    this.collectionFlag = json['collectionFlag'];
    this.category = json['category'];
    this.status = json['status'];
    this.isNew = json['isNew'];
    this.isReturns = json['isReturns'];
    this.postage = json['postage'];
    this.position = json['position'];
    this.releaseTime = DateTime.parse(json['releaseTime'] ?? '1900-01-01 00:00:00.000');
    this.desc = json['desc'];
    this.seller = json['seller'] == null ? null : User.fromJson(json['seller']);
    this.faceUserId = json['faceUserId'] ?? 0;
  }

  toJson(){
    Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['title'] = this.title;
    data['img'] = this.img;
    data['imgs'] = this.imgs;
    data['collections'] = this.collections;
    data['price'] = this.price;
    data['saleMethod'] = this.saleMethod;
    data['collectionFlag'] = this.collectionFlag;
    data['category'] = this.category;
    data['status'] = this.status;
    data['isNew'] = this.isNew;
    data['isReturns'] = this.isReturns;
    data['postage'] = this.postage;
    data['position'] = this.position;
    data['releaseTime'] = this.releaseTime.toIso8601String();
    data['desc'] = this.desc;
    data['seller'] = this.seller.toJson();
    data['faceUserId'] = this.faceUserId;
    return data;
  }

  Goods clone(){
    return Goods.fromJson(this.toJson());
  }

  bool hasCollection(int userid){
    return userid == this.faceUserId && this.collectionFlag == 1;
  }

  Goods merge(Goods goods){
    this.img = goods.imgs[0];
    return this;
  }

  String get symbol => price == null ? null : price.split(' ')[1];

  double get priceAmount => price == null ? 0 : double.parse(price.split(' ')[0]);

  double get postageAmount => postage == null ? 0 : double.parse(postage.split(' ')[0]);

  double get totalAmount => priceAmount + postageAmount;

  String get total => '$totalAmount $symbol';


}