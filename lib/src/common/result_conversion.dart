import 'package:fleamarket/src/models/address.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/models/order.dart';
import 'package:fleamarket/src/models/user.dart';

enum ResultTypes{
  User,
  UserPage,
  Goods,
  GoodsPage,
  Order,
  OrderPage,
  AddressList
}

class ResultConversion {
  static ExtResult excute(ExtResult res, ResultTypes type){
    if(res.code == 0){
      switch (type) {
        case ResultTypes.User:
          res.data = User.fromJson(res.data);
          break;
        case ResultTypes.UserPage:
          res.data  = ExtPage<User>.fromJson(res.data, (json) => User.fromJson(json));
          break;
        case ResultTypes.Goods:
          res.data = Goods.fromJson(res.data);     
          break;
        case ResultTypes.GoodsPage:
          res.data = ExtPage<Goods>.fromJson(res.data, (json) => Goods.fromJson(json));     
          break;
        case ResultTypes.Order:
          res.data = Order.fromJson(res.data);
          break;
        case ResultTypes.OrderPage:
          res.data = ExtPage<Order>.fromJson(res.data, (json) => Order.fromJson(json));     
          break;
        case ResultTypes.AddressList:
          if(res.data == null){
            res.data = List<Address>();
          }else{
            res.data = (res.data as List<dynamic>).map<Address>((json) => Address.fromJson(json)).toList();
          }
          break;
        default:
      }
    }
    return res;
  }
}