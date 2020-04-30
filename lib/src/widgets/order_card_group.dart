import 'package:fleamarket/src/common/type_defs.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/order.dart';
import 'package:fleamarket/src/view_models/order_card_group_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'custom_refresh_indicator.dart';
import 'order_card.dart';

class OrderCardGroup extends StatelessWidget{
  OrderCardGroup({
    Key key,
    this.refresh
  }) : super(key: key);

  final RefreshPageCallback refresh;

  @override
  Widget build(BuildContext context) {
    return BaseView<OrderCardGroupViewModel>(
      model: OrderCardGroupViewModel(context, refresh),
      builder: (_, model, loading){
        return Selector<OrderCardGroupViewModel, ExtPage<Order>>(
          selector: (_, __) => model.page,
          builder: (_, page, __){
            return model.busy ? loading : CustomRefreshIndicator(
              onRefresh: () => model.refreshOrders(isRefresh: true),
              onLoad: model.page.hasMore() ? model.refreshOrders : null,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  itemCount: model.page.data.length,
                  itemBuilder: (_, i) => Selector<OrderCardGroupViewModel, Order>(
                    selector: (_, __) => model.page.data[i],
                    builder: (_, order, __){
                      return Selector<OrderCardGroupViewModel, Order>(
                        selector: (_, __) => page.data[i],
                        builder: (_, order, __){
                          return OrderCard(
                            key: Utils.randomKey(),
                            order: order,
                            updateOrder: model.updateOrder,
                          ); 
                        },
                      );
                    },
                  )
                ),
              )
            );
          },
        );
      },
    );
  }

}