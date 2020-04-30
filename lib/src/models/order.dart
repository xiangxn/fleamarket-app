import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/models/order_return.dart';
import 'package:fleamarket/src/models/user.dart';

class Order {
  int orderid;       // 订单号
  Goods product;    // 商品
  User seller;          // 卖方
  User buyer;           // 买方
  int status;           // 状态
  String price;         // 订单金额
  String shipNum;       // 快递单号
  DateTime createTime;  // 创建时间
  DateTime payTime;     // 支付时间
  DateTime payOutTime;  // 支付超时时间
  DateTime shipTime;    // 邮寄时间
  DateTime shipOutTime; // 邮寄超时时间
  DateTime receiptTime; // 确认收货时间
  DateTime reciptOutTime; // 确认收货超时时间
  OrderReturn returnInfo; // 退货信息

  Order.fromJson(Map<String, dynamic> json){
    this.orderid = int.parse(json['orderid']);
    this.product = Goods.fromJson(json['product']);
    this.seller = json['seller'] == null ? null : User.fromJson(json['seller']);
    this.buyer = json['buyer'] == null ? null : User.fromJson(json['buyer']);
    this.status = json['status'];
    this.price = json['price'];
    this.shipNum = json['shipNum'];
    this.createTime = Utils.formatDateTime(json['createTime']);
    this.payTime = Utils.formatDateTime(json['payTime']);
    this.payOutTime = Utils.formatDateTime(json['payOutTime']);
    this.shipTime = Utils.formatDateTime(json['shipTime']);
    this.shipOutTime = Utils.formatDateTime(json['shipOutTime']);
    this.receiptTime = Utils.formatDateTime(json['receiptTime']);
    this.reciptOutTime = Utils.formatDateTime(json['reciptOutTime']);
    this.returnInfo = json['returnInfo'] == null ? null : OrderReturn.fromJson(json['returnInfo']);
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = Map<String, dynamic>();
    json['orderid'] = this.orderid;
    json['product'] = this.product.toJson();
    json['seller'] = this.seller.toJson();
    json['buyer'] = this.buyer.toJson();
    json['status'] = this.status;
    json['price'] = this.price;
    json['shipNum'] = this.shipNum;
    json['createTime'] = this.createTime?.toIso8601String() ?? '';
    json['payTime'] = this.payTime?.toIso8601String() ?? '';
    json['payOutTime'] = this.payOutTime?.toIso8601String() ?? '';
    json['shipTime'] = this.shipTime?.toIso8601String() ?? '';
    json['shipOutTime'] = this.shipOutTime?.toIso8601String() ?? '';
    json['receiptTime'] = this.receiptTime?.toIso8601String() ?? '';
    json['reciptOutTime'] = this.reciptOutTime?.toIso8601String() ?? '';
    json['returnInfo'] = this.returnInfo.toJson();
    return json;
  }

  clone(){
    return Order.fromJson(this.toJson());
  }

  User masterUser(int userid){
    return this.isSell(userid) ? this.buyer : this.seller;
  }

  /// 订单是否为卖单
  bool isSell(int userid){
    if(this.buyer == null || this.seller == null){
      return this.buyer != null && this.seller == null;
    }else{
      return this.buyer?.userid != userid && this.seller?.userid == userid;
    }
  }
}