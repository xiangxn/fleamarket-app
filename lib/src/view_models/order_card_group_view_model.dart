import 'package:fleamarket/src/common/type_defs.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/order.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';

class OrderCardGroupViewModel extends BaseViewModel{
  OrderCardGroupViewModel(BuildContext context, RefreshPageCallback refresh) : super(context){
    _refresh = refresh;
    _page = ExtPage<Order>();
    refreshOrders();
  }

  ExtPage<Order> _page;
  RefreshPageCallback _refresh;

  ExtPage<Order> get page => _page;

  Future<void> refreshOrders({bool isRefresh = false}) async {
    super.setBusy();
    if(isRefresh){
      _page.clean();
    }
    var process = _refresh(pageNo: _page.pageNo, pageSize: _page.pageSize);
    ExtResult res = await super.processing(process, showLoading: false);
    if(res.code == 0){
      _page = res.data..update(_page.data);
    }
    super.setBusy();
    notifyListeners();
  }

  void updateOrder({Order obj}){

  }

  toDetail(Order order){

  }
}