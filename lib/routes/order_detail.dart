import 'dart:convert';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/ext_network_image.dart';
import 'package:bitsflea/widgets/input_shipment_number.dart';
import 'package:bitsflea/widgets/pay_confirm.dart';
import 'package:bitsflea/widgets/price_text.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:url_launcher/url_launcher.dart';

class OrderDetailRoute extends StatelessWidget {
  OrderDetailRoute({Key key, this.order}) : super(key: key);

  final Order order;

  @override
  Widget build(BuildContext context) {
    return BaseRoute<OrderDetailProvider>(
        listen: true,
        provider: OrderDetailProvider(context, order),
        builder: (_, provider, loading) {
          final curUser = Provider.of<UserModel>(context).user;
          final style = Provider.of<ThemeModel>(context, listen: false).theme;
          bool isSell = provider.order.seller.userid == curUser.userid;
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(onPressed: () => provider.pop(provider.order)),
              centerTitle: true,
              title: Text(provider.translate('order_detail.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(provider.translate('combo_text.order_no', translationParams: {"oid": provider.order.orderid})),
                                  buildOrderStatus(provider, provider.order)
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 6),
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
                                      style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                                  IconButton(icon: Icon(Icons.phone_forwarded, color: style.primarySwatch), iconSize: 20, onPressed: () => provider.onPhone())
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
                        child: Row(
                          children: [
                            Text(provider.translate('order_detail.address')),
                            FutureBuilder(
                              future: provider.getToAddr(provider.order.toAddr),
                              builder: (ctx, snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.data != null) {
                                    String addr =
                                        "${snapshot.data.province}${snapshot.data.city}${snapshot.data.district} ${snapshot.data.address}(${snapshot.data.postcode})";
                                    String name = "${snapshot.data.name} ${snapshot.data.phone}";
                                    return Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Column(
                                          children: [Text(addr), Text(name)],
                                        ));
                                  }
                                  return Text("");
                                }
                                return loading;
                              },
                            )
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(top: 8),
                          color: Colors.white,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(provider.translate("order_detail.logistics_info")),
                                  Padding(padding: EdgeInsets.only(left: 10), child: Text("${provider.order.shipNum}"))
                                ],
                              ),
                              FutureBuilder<dynamic>(
                                  future: provider.getLogistics(),
                                  builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: _buildLogistics(provider, snapshot.data == null ? null : snapshot.data['data']),
                                      );
                                    }
                                    return loading;
                                  })
                            ],
                          )),
                    ],
                  ),
                ),
                Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Offstage(
                            offstage: provider.isExpired(),
                            child: CustomButton(
                              onTap: provider.onProc,
                              margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                              padding: EdgeInsets.all(16),
                              color: Colors.orange,
                              text: _buildButtonText(provider, provider.order.status),
                            )),
                        Offstage(
                            offstage: provider.isShowGoodsBtn(),
                            child: CustomButton(
                              onTap: provider.onProc,
                              margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                              padding: EdgeInsets.all(16),
                              color: Colors.orange,
                              text: _buildButtonText(provider, provider.order.status),
                            )),
                        Offstage(
                            offstage: !(provider.order.status == OrderStatus.pendingPayment || provider.order.status == OrderStatus.cancelled),
                            child: CustomButton(
                              onTap: provider.onCancel,
                              color: Colors.red,
                              margin: EdgeInsets.all(8),
                              padding: EdgeInsets.all(16),
                              text: provider.translate("order_detail.cancel"),
                            )),
                      ],
                    ))
              ],
            ),
          );
        });
  }

  _buildButtonText(OrderDetailProvider provider, int status) {
    switch (status) {
      case OrderStatus.pendingPayment:
      case OrderStatus.pendingShipment:
      case OrderStatus.pendingReceipt:
        return provider.translate("order_detail.$status");
      default:
        return "";
    }
  }

  _buildLogistics(OrderDetailProvider provider, List<dynamic> data) {
    List<Widget> logisticsList = new List<Widget>();
    if (data != null && data.length > 0) {
      int i = 1;
      for (int n = 0; n < data.length; ++n, ++i)
        logisticsList
            .add(i == data.length ? _buildLogisticsItem(provider.context, data[n], i, true) : _buildLogisticsItem(provider.context, data[n], i, false));
    } else {
      logisticsList.add(Center(child: Text(provider.translate("order_detail.not_logistics"))));
    }
    return logisticsList;
  }

  Widget _buildLogisticsItem(BuildContext context, Map value, int i, bool flag) {
    double height = 1;
    if (flag) height = 0;
    return i == 1
        ? Container(
            // width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 0.0, left: 0.0, bottom: 0.0), //容器外填充
            padding: EdgeInsets.only(top: 15.0, bottom: 0, left: 0, right: 0), //容器内填充
            child: Card(
              margin: EdgeInsets.only(left: 0.0, right: 0),
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 90,
                        child: Text(
                          "${value['time']}",
                          style: TextStyle(fontSize: 15.0, height: 1.28, color: Color(0xFF999999)),
                          maxLines: 2,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 26.0, left: 6.5, right: 6.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.adjust,
                              size: 12,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 1,
                              height: 28,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        // width: MediaQuery.of(context).size.width - 165,
                        child: Text(
                          "${value['context']}",
                          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, height: 1.28),
                          maxLines: 3,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  //垂直分割线
                  Padding(
                    //左边添加像素补白
                    padding: const EdgeInsets.only(left: 91.5),
                    child: SizedBox(
                      width: 1,
                      height: height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container(
            // width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 0.0, left: 0.0, bottom: 0.0), //容器外填充
            padding: EdgeInsets.only(top: 0, bottom: 0), //容器内填充
            child: Card(
              margin: EdgeInsets.only(left: 0.0, right: 0),
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 90,
                        child: Text(
                          "${value['time']}",
                          style: TextStyle(fontSize: 15.0, height: 1.28, color: Color(0xFF999999)),
                          maxLines: 2,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Padding(
                        padding: height == 0 ? EdgeInsets.only(bottom: 32, left: 10.0, right: 10.5) : EdgeInsets.only(bottom: 0, left: 10.0, right: 10.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 1,
                              height: 32,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                              ),
                            ),
                            Icon(
                              Icons.adjust,
                              size: 5,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: 1,
                              height: height == 0 ? 0 : 32,
                              child: DecoratedBox(
                                decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        // width: MediaQuery.of(context).size.width - 50,
                        child: Text(
                          "${value['context']}",
                          style: TextStyle(fontSize: 15.0, height: 1.28, color: Color(0xFF999999)),
                          maxLines: 3,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ],
                  ),
                  //垂直分割线
                  Padding(
                    //左边添加像素补白
                    padding: const EdgeInsets.only(left: 91.5),
                    child: SizedBox(
                      width: 1,
                      height: height,
                      child: DecoratedBox(
                        decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class OrderDetailProvider extends BaseProvider {
  OrderDetailProvider(BuildContext context, Order order) : super(context) {
    _order = order;
  }

  Order _order;

  Order get order => _order;

  String get logisticsKey => "logistics${_order.orderid}";

  Future<void> onCancel() async {
    final um = this.getUserInfo();
    showLoading();
    final res = await api.cancelOrder(um.keys[1], um.user.userid, um.user.eosid, _order.orderid);
    closeLoading();
    if (res.code == 0) {
      _order.status = OrderStatus.cancelled;
      this.pop(_order);
    } else {
      this.showToast(getErrorMessage(res.msg));
    }
  }

  onPhone() async {
    final user = this.getUser();
    if (user == null) return;
    showLoading();
    final res = await api.getUserPhone(user.userid, _order.seller.userid);
    closeLoading();
    if (res.code == 0) {
      await launch("tel:${res.msg}");
    }
  }

  Future<dynamic> getLogistics() async {
    if (_order.shipNum == null || _order.shipNum.isEmpty) return null;
    Map data;
    final cache = Global.getCache(logisticsKey);
    if (cache == null || cache.isEmpty) {
      final user = this.getUser();
      final res = await api.getLogisticsInfo(user.userid, _order.shipNum);
      if (res.code != 0) {
        return null;
      } else {
        data = jsonDecode(res.msg);
        if (_order.status == OrderStatus.completed) {
          Global.setCache(logisticsKey, res.msg);
        } else {
          Global.setCache(logisticsKey, res.msg, dt: DateTime.now());
        }
      }
    } else {
      data = jsonDecode(cache);
    }
    return data['showapi_res_body'];
  }

  bool isExpired() {
    if (_order.status == OrderStatus.pendingPayment) {
      DateTime now = DateTime.now();
      DateTime expired = DateTime.parse("${order.payOutTime}Z");
      expired = expired.add(Duration(hours: now.timeZoneOffset.inHours));
      return now.isAfter(expired);
    }
    return true;
  }

  bool isShowGoodsBtn() {
    bool flag = true;
    switch (_order.status) {
      case OrderStatus.pendingShipment:
        flag = !isSeller();
        break;
      case OrderStatus.pendingReceipt:
        flag = !isBuyer();
        break;
      default:
        flag = true;
        break;
    }
    return flag;
  }

  bool isSeller() {
    final user = this.getUser();
    return _order.seller.userid == user.userid;
  }

  bool isBuyer() {
    final user = this.getUser();
    return _order.buyer.userid == user.userid;
  }

  Future<void> onProc() async {
    switch (_order.status) {
      case OrderStatus.pendingPayment:
        await _pay();
        break;
      case OrderStatus.pendingShipment:
        await _shipment();
        break;
      case OrderStatus.pendingReceipt:
        await _receipt();
        break;
    }
  }

  Future<void> _receipt() async {
    final confirm = await this.confirm(translate("order_detail.confirm_prompt"));
    if (confirm) {
      final um = this.getUserInfo();
      showLoading();
      final res = await api.confirmReceipt(um.keys[1], um.user.userid, um.user.eosid, _order.orderid);
      closeLoading();
      if (res.code == 0) {
        this.showToast(this.translate("message.successful_operation"));
        _order = _order.clone();
        _order.status = OrderStatus.completed;
        notifyListeners();
      } else {
        this.showToast(getErrorMessage(res.msg));
      }
    }
  }

  Future<void> _shipment() async {
    final um = this.getUserInfo();
    String number = await showModalBottomSheet(context: context, builder: (_) => InputShipmentNumber());
    if (number != null && number.isNotEmpty) {
      showLoading();
      final res = await api.shipment(um.keys[1], um.user.userid, um.user.eosid, _order.orderid, number);
      closeLoading();
      if (res.code == 0) {
        this.showToast(this.translate("message.successful_operation"));
        _order.status = OrderStatus.pendingReceipt;
        notifyListeners();
      } else {
        this.showToast(getErrorMessage(res.msg));
      }
    }
  }

  Future<void> _pay() async {
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
    final isPay = await showModalBottomSheet(
        context: context,
        builder: (_) => PayConfirm(
              payInfo: payInfo,
              order: _order,
            ));
    print("isPay: $isPay");
    if (isPay) {
      _order.status = OrderStatus.pendingShipment;
      notifyListeners();
    }
  }

  Future<ReceiptAddress> getToAddr(int toAddr) async {
    final res = await api.getReceiptAddress(toAddr);
    if (res.code == 0) {
      ReceiptAddress ra = convertEdge(res.data, "receiptaddresses", ReceiptAddress());
      return ra;
    }
    return null;
  }
}
