import 'package:fleamarket/src/common/result_conversion.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/order.dart';
import 'package:fleamarket/src/services/api.dart';

class OrderService {

  OrderService(Api api){
    _api = api;
  }

  Api _api;

  Future<ExtResult> fetchBuyOrders(int userid, int pageNo, int pageSize) async {
    ExtResult res = await _api.fetchBuyByUser(userid, pageNo, pageSize);
    ExtResult rres = ResultConversion.excute(res, ResultTypes.OrderPage);
    ExtPage<Order> x;
    if(rres.data is ExtPage<Order>){
      x = rres.data as ExtPage<Order>;
      x.data.forEach((f) => f.buyer = null);
    }
    return rres..data = x;
  }

  Future<ExtResult> fetchSellOrders(int userid, int pageNo, int pageSize) async {
    ExtResult res = await _api.fetchSellByUser(userid, pageNo, pageSize);
    ExtResult rres = ResultConversion.excute(res, ResultTypes.OrderPage);
    ExtPage<Order> x;
    if(rres.data is ExtPage<Order>){
      x = rres.data as ExtPage<Order>;
      x.data.forEach((f) => f.seller = null);
    }
    return rres..data = x;
  }

  Future<ExtResult> fetchOrder(int orderid) async {
    ExtResult res = await _api.fetchOrder(orderid);
    return ResultConversion.excute(res, ResultTypes.Order);
  }
}