import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/type_defs.dart';
import 'package:fleamarket/src/models/order.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class OrderCardViewModel extends BaseViewModel{
  OrderCardViewModel(BuildContext context, Order order, UpdateObjectCallback<Order> updateOrder) : super(context){
    _order = order;
    _updateOrder = updateOrder;
  }

  Order _order;
  UpdateObjectCallback<Order> _updateOrder;

  Order get order => _order;

  toOrderDetail(){
    super.pushNamed(ORDER_DETAIL_ROUTE, arguments: _order);
  }

}