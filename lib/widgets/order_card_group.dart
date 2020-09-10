import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/type.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'custom_refresh_indicator.dart';
import 'order_card.dart';

class OrderCardGroup extends StatelessWidget {
  OrderCardGroup({Key key, this.refresh}) : super(key: key);

  final RefreshPageCallback refresh;

  @override
  Widget build(BuildContext context) {
    return BaseRoute<OrderCardGroupProvider>(
      provider: OrderCardGroupProvider(context, refresh),
      builder: (_, provider, loading) {
        return CustomRefreshIndicator(
            onRefresh: () => provider.refreshOrders(isRefresh: true),
            onLoad: provider.page.hasMore() ? provider.refreshOrders : null,
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: FutureBuilder(
                    future: provider.refreshOrders(),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            itemCount: provider.page.data.length,
                            itemBuilder: (_, i) => Selector<OrderCardGroupProvider, Order>(
                                  selector: (_, __) => provider.page.data[i],
                                  builder: (_, order, __) {
                                    return OrderCard(
                                      key: randomKey(),
                                      order: order,
                                      updateOrder: provider.updateOrder,
                                    );
                                  },
                                ));
                      }
                      return loading;
                    })));
      },
    );
  }
}

class OrderCardGroupProvider extends BaseProvider {
  OrderCardGroupProvider(BuildContext context, RefreshPageCallback refresh) : super(context) {
    _refresh = refresh;
    _page = DataPage<Order>();
  }

  DataPage<Order> _page;
  RefreshPageCallback _refresh;

  DataPage<Order> get page => _page;

  Future<void> refreshOrders({bool isRefresh = false}) async {
    setBusy();
    if (isRefresh) {
      _page.clean();
    }
    var data = await _refresh(pageNo: _page.pageNo, pageSize: _page.pageSize);
    data.update(_page.data);
    _page = data;
    if (_page.hasMore()) {
      _page.pageNo += 1;
    }
    setBusy();
  }

  void updateOrder({Order obj}) {}
}
