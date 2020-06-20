import 'package:fleamarket/src/common/data_api.dart';
import 'package:fleamarket/src/common/result_conversion.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/order.dart';

class OrderService {

  OrderService(DataApi api){
    _api = api;
  }

  DataApi _api;

  Future<dynamic> fetchBuyOrders(int userid, int pageNo, int pageSize) async {
    final res = await _api.fetchBuyByUser(userid, pageNo, pageSize);
    ExtResult rres = ResultConversion.excute(res, ResultTypes.OrderPage);
    ExtPage<Order> x;
    if(rres.data is ExtPage<Order>){
      x = rres.data as ExtPage<Order>;
      x.data.forEach((f) => f.buyer = null);
    }
    return rres..data = x;
  }

  Future<dynamic> fetchSellOrders(int userid, int pageNo, int pageSize) async {
    final res = await _api.fetchSellByUser(userid, pageNo, pageSize);
    ExtResult rres = ResultConversion.excute(res, ResultTypes.OrderPage);
    ExtPage<Order> x;
    if(rres.data is ExtPage<Order>){
      x = rres.data as ExtPage<Order>;
      x.data.forEach((f) => f.seller = null);
    }
    return rres..data = x;
  }

  Future<dynamic> fetchOrder(int orderid) async {
    final res = await _api.fetchOrder(orderid);
    return ResultConversion.excute(res, ResultTypes.Order);
  }
}