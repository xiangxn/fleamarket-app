import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/view_models/mine_buy_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/order_card_group.dart';
import 'package:flutter/material.dart';

class MineBuy extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<MineBuyViewModel>(
      model: MineBuyViewModel(context),
      builder: (_, model, __){
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(model.locale.translation('title.mine_buy')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: OrderCardGroup(refresh: model.fetchOrders),
        );
      },
    );
  }
}