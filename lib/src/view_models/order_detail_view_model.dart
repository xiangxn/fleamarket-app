import 'package:fleamarket/src/models/order.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class OrderDetailViewModel extends BaseViewModel{
  OrderDetailViewModel(BuildContext context, Order order) : super(context){
    _order = order;
  }

  Order _order;

  Order get order => _order;
}