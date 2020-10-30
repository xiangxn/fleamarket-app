import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/type.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/price_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ext_circle_avatar.dart';
import 'ext_network_image.dart';

class OrderCard extends StatelessWidget {
  OrderCard({Key key, this.order, this.updateOrder}) : super(key: key);

  final Order order;
  final UpdateObjectCallback<Order> updateOrder;

  @override
  Widget build(BuildContext context) {
    return BaseRoute<OrderCardProvider>(
      provider: OrderCardProvider(context, order, updateOrder),
      builder: (_, provider, __) {
        User curUser = Provider.of<UserModel>(context).user;
        bool isSell = provider.order.seller.userid == curUser.userid;
        return InkWell(
          onTap: provider.toOrderDetail,
          child: Card(
            elevation: 0,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(provider.translate('combo_text.order_no', translationParams: {"oid": provider.order.orderid.toString()})),
                        buildOrderStatus(provider, provider.order)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: ExtCircleAvatar(isSell ? provider.order.buyer.head : provider.order.seller.head, 30, strokeWidth: 0),
                        ),
                        Text(
                          provider.translate('combo_text.${isSell ? 'buyer' : 'seller'}',
                              translationParams: {"name": isSell ? provider.order.buyer.nickname : provider.order.seller.nickname}),
                          style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ExtNetworkImage(getIPFSUrl(provider.order.productInfo.photos[0]), imageBuilder: (_, imageProvider) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 16),
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                child: Text(provider.order.productInfo.title),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: PriceText(
                                  label: provider.translate('order.price'),
                                  priceBold: true,
                                  price: addPrice(provider.order.price, provider.order.postage),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class OrderCardProvider extends BaseProvider {
  OrderCardProvider(BuildContext context, Order order, UpdateObjectCallback<Order> updateOrder) : super(context) {
    _order = order;
    _updateOrder = updateOrder;
  }

  Order _order;
  UpdateObjectCallback<Order> _updateOrder;

  Order get order => _order;

  toOrderDetail() async {
    final o = await pushNamed(ROUTE_ORDER_DETAIL, arguments: _order);
    if (_updateOrder != null) {
      _updateOrder(obj: o);
    }
  }
}
