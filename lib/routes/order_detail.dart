import 'dart:convert';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/ext_network_image.dart';
import 'package:bitsflea/widgets/input_single_string.dart';
import 'package:bitsflea/widgets/pay_confirm.dart';
import 'package:bitsflea/widgets/price_text.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          final curUser = provider.getUser();
          final style = provider.getStyle();
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
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Offstage(
                                    offstage: provider.isShowReturn(),
                                    child: GestureDetector(
                                        onTap: () => provider.onReturn(),
                                        child: Text(
                                            provider.order.status == OrderStatus.returning
                                                ? provider.translate("order_detail.btn_return_show")
                                                : provider.translate("order_detail.btn_return"),
                                            style: TextStyle(color: Colors.red, decoration: TextDecoration.underline))),
                                  ),
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
                                    return Expanded(
                                        child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              children: [Text(addr, maxLines: 3), Text(name)],
                                            )));
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
                          child: FutureBuilder<dynamic>(
                              future: provider.getLogistics(),
                              builder: (BuildContext ctx, AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.connectionState == ConnectionState.done) {
                                  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Row(
                                      children: [
                                        Text(provider.translate("order_detail.logistics_info")),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: GestureDetector(
                                              onTap: () => provider.copyLogistics(), child: buildShipNumber(provider.order.shipNum, snapshot.data)),
                                        )
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: buildLogistics(provider, snapshot.data == null ? null : snapshot.data['list']),
                                    ),
                                  ]);
                                }
                                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Row(
                                    children: [
                                      Text(provider.translate("order_detail.logistics_info")),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: GestureDetector(onTap: () => provider.copyLogistics(), child: Text("${provider.order.shipNum}")))
                                    ],
                                  ),
                                  Column(mainAxisSize: MainAxisSize.min, children: [loading]),
                                ]);
                              })),
                    ],
                  ),
                ),
                Positioned(
                    left: 0,
                    bottom: 10,
                    right: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Offstage(
                            offstage: provider.isShowPayBtn,
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
                            offstage: provider.isShowCancelBtn,
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
}

class OrderDetailProvider extends BaseProvider {
  OrderDetailProvider(BuildContext context, Order order) : super(context) {
    _order = order;
  }

  Order _order;

  Order get order => _order;

  String get logisticsKey => "logistics${_order.orderid}";

  bool get isShowCancelBtn {
    if (isSeller()) return true;
    return !(order.status == OrderStatus.pendingPayment);
  }

  bool get isShowPayBtn {
    if (isExpired()) return true;
    if (order.status == OrderStatus.pendingPayment) {
      return isSeller();
    }
    return false;
  }

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
    // showLoading();
    final res = await api.getUserPhone(user.userid, _order.seller.userid);
    // closeLoading();
    if (res.code == 0) {
      await launch("tel:${res.msg}");
    } else {
      this.showToast(getErrorMessage(res.msg));
    }
  }

  copyLogistics() {
    if (_order.shipNum != null && _order.shipNum.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _order.shipNum));
      showToast(translate('order_detail.copy_ok'));
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
        if (data['status'] == "0") {
          // if (_order.status == OrderStatus.completed) {
          if (data['result']['issign'] == "1") {
            Global.setCache(logisticsKey, res.msg);
          } else {
            Global.setCache(logisticsKey, res.msg, dt: DateTime.now());
          }
        }
      }
    } else {
      data = jsonDecode(cache);
    }
    return data['result'];
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
    bool confirm = true;
    if (_order.productInfo.isReturns) {
      confirm = await this.confirm(translate("order_detail.confirm_prompt"));
    }
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
    String number = await showModalBottomSheet(context: context, builder: (_) => InputSingleString(canEmpty: true));
    if (number != null) {
      if (number.isNotEmpty || _order.productInfo.category.cid == 7) {
        showLoading();
        final res = await api.shipment(um.keys[1], um.user.userid, um.user.eosid, _order.orderid, number);
        closeLoading();
        if (res.code == 0) {
          this.showToast(this.translate("message.successful_operation"));
          _order.status = OrderStatus.pendingReceipt;
          _order.shipNum = number;
          notifyListeners();
        } else {
          this.showToast(getErrorMessage(res.msg));
        }
      }
    }
  }

  Future<void> _pay() async {
    final um = this.getUserInfo();
    final price = Holding.fromJson(_order.price);
    final postage = Holding.fromJson(_order.postage);
    showLoading();
    // 获取主网余额
    final balance = await api.getUserBalance(um.user.eosid, price.currency);
    final total = price.amount + postage.amount;
    final mainPay = balance.amount >= total;
    PayInfo payInfo = PayInfo();
    payInfo.payMode = mainPay ? 0 : 1;
    payInfo.orderid = _order.orderid;
    payInfo.amount = total;
    payInfo.symbol = price.currency;
    payInfo.payAddr = (_order.payAddr == null || _order.payAddr.isEmpty) ? CONTRACT_NAME : _order.payAddr;
    payInfo.userId = $fixnum.Int64.parseInt(um.user.userid.toString());
    payInfo.productId = _order.productInfo.productId;
    payInfo.balance = balance.amount;
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
    // print("isPay: $isPay");
    if (isPay != null && isPay) {
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

  Future<void> onReturn() async {
    if (order.status == OrderStatus.returning) {
      pushNamed(ROUTE_RETURNS_DETAIL, arguments: order);
      return;
    }
    final resAddr = await api.getRecAddrByUser(order.seller.userid);
    int toAddr = 0;
    if (resAddr.code == 0) {
      final addrs = convertList(resAddr.data, "recAddrByUser", ReceiptAddress());
      if (addrs.length > 0) {
        toAddr = addrs.singleWhere((element) => element.isDefault)?.rid ?? 0;
        if (toAddr == 0) {
          toAddr = addrs[0].rid;
        }
      }
    }
    if (toAddr == 0) {
      this.alert(this.translate("order_detail.msg_return"), callback: () async {
        await _applyReturns(toAddr);
      });
    } else {
      await _applyReturns(toAddr);
    }
  }

  Future<void> _applyReturns(int toAddr) async {
    String reasons = await showModalBottomSheet(
        context: context,
        builder: (_) => InputSingleString(
            maxLines: 4, hintText: this.translate("order_detail.hint_reasons"), errorMessage: this.translate("order_detail.msg_reasons_err")));
    if (reasons == null || reasons.isEmpty) return;
    showLoading();
    final um = this.getUserInfo();
    final res = await api.applyReturns(um.keys[1], um.user.userid, um.user.eosid, order.orderid, reasons, toAddr);
    closeLoading();
    if (res.code == 0) {
      this.showToast(this.translate("order_detail.msg_apply_returns_ok"));
      _order.status = OrderStatus.returning;
      notifyListeners();
    } else {
      this.showToast(getErrorMessage(res.msg));
    }
  }

  bool isShowReturn() {
    final user = this.getUser();
    if (user.userid == order.seller.userid) {
      if (order.status == OrderStatus.returning) return false;
      return true;
    }

    if (order.productInfo.isReturns) {
      return !(order.status == OrderStatus.pendingReceipt || order.status == OrderStatus.returning);
    }
    return true;
  }
}
