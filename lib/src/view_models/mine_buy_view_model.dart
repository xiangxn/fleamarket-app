import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/services/order_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MineBuyViewModel extends BaseViewModel{
  MineBuyViewModel(BuildContext context) : super(context){
    _orderService = Provider.of(context, listen: false);
  }

  OrderService _orderService;

  Future<ExtResult> fetchOrders({int pageNo, int pageSize}){
    return _orderService.fetchBuyOrders(userId, pageNo, pageSize);
  }

}