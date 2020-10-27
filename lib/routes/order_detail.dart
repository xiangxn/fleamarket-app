import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/ext_network_image.dart';
import 'package:bitsflea/widgets/pay_confirm.dart';
import 'package:bitsflea/widgets/price_text.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;

class OrderDetailRoute extends StatelessWidget {
  OrderDetailRoute({Key key, this.order}) : super(key: key);

  final Order order;

  Widget _buildStatus(OrderDetailProvider provider, int status) {
    Color color = Colors.black;
    return Text(provider.translate('order_type.$status'), style: TextStyle(color: color, fontSize: 13));
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<OrderDetailProvider>(
        provider: OrderDetailProvider(context, order),
        builder: (_, provider, loading) {
          final curUser = Provider.of<UserModel>(context).user;
          final style = Provider.of<ThemeModel>(context, listen: false).theme;
          bool isSell = provider.order.seller.userid == curUser.userid;
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('order_detail.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: Stack(
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(provider.translate('combo_text.order_no', translationParams: {"oid": provider.order.orderid})),
                                _buildStatus(provider, provider.order.status)
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                // Padding(
                                //   padding: EdgeInsets.only(right: 16),
                                //   child: ExtCircleAvatar(curUser?.head, 30, strokeWidth: 0),
                                // ),
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
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                PriceText(label: provider.translate('order.price'), price: provider.order.productInfo.price),
                                                PriceText(label: provider.translate('order.postage'), price: provider.order.productInfo.postage),
                                              ],
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                PriceText(
                                    label: provider.translate('order_detail.total_price'),
                                    priceBold: true,
                                    price: addPrice(provider.order.price, provider.order.postage))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Text(provider.translate('order_detail.address')),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Text(provider.translate("order_detail.logistics_info")),
                    ),
                  ],
                ),
                Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        CustomButton(
                          onTap: provider.onProc,
                          margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                          padding: EdgeInsets.all(16),
                          color: Colors.orange,
                          text: _buildButtonText(provider, provider.order.status),
                        ),
                        CustomButton(
                          onTap: provider.onCancel,
                          color: Colors.red,
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          text: provider.translate("order_detail.cancel"),
                        )
                      ],
                    ))
              ],
            ),
          );
        });
  }

  _buildButtonText(OrderDetailProvider provider, int status) {
    switch (status) {
      case 0:
      case 300:
      case 400:
        return provider.translate("order_detail.$status");
      default:
        return "";
    }
  }
}

class OrderDetailProvider extends BaseProvider {
  OrderDetailProvider(BuildContext context, Order order) : super(context) {
    _order = order;
  }

  Order _order;

  Order get order => _order;

  Future<void> onCancel() async {
    //TODO
  }

  Future<void> onProc() async {
    final um = this.getUserInfo();
    final price = Holding.fromJson(_order.price);
    final postage = Holding.fromJson(_order.postage);
    showLoading();
    final balance = await api.getUserBalance(um.user.eosid, price.currency);
    final total = price.amount + postage.amount;
    final mainPay = balance.amount >= total;
    PayInfo payInfo = PayInfo();
    payInfo.payMode = mainPay ? 0 : 1;
    payInfo.orderid = _order.orderid;
    payInfo.amount = total;
    payInfo.symbol = price.currency;
    payInfo.payAddr = (_order.payAddr == null || _order.payAddr == "") ? CONTRACT_NAME : _order.payAddr;
    payInfo.userId = $fixnum.Int64.parseInt(um.user.userid.toString());
    payInfo.productId = _order.productInfo.productId;
    //打开支付UI
    // Widget screen = PayConfirm(mainPay: mainPay, payInfo: payInfo);
    // final result = await this.showDialog(screen);
    closeLoading();
    await showModalBottomSheet(
        context: context,
        builder: (_) => PayConfirm(
              payInfo: payInfo,
              order: _order,
            ));
  }
}
