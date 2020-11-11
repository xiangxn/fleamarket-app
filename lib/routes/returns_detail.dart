import 'dart:convert';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/input_single_string.dart';
import 'package:flutter/material.dart';

class ReturnsDetailRoute extends StatelessWidget {
  final Order order;
  ReturnsDetailRoute({Key key, this.order}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BaseWidget2<ReturnsDetailProvider, ProReturn>(
      model: ReturnsDetailProvider(context, this.order),
      getSmallModel: (model) => model.returnInfo,
      builder: (ctx, provider, model, loading) {
        final style = provider.getStyle();
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(provider.translate('returns_detail.title')),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
          ),
          body: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Text(provider.translate('combo_text.order_no', translationParams: {'oid': order.orderid})),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Text(provider.translate('combo_text.product_title', translationParams: {'title': order.productInfo.title})),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Text(provider.translate('returns_detail.reasons', translationParams: {'reasons': model?.reasons ?? ""})),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      color: Colors.white,
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[Text(provider.translate('returns_detail.status')), buildReturnStatus(provider, model)],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 8),
                        color: Colors.white,
                        padding: EdgeInsets.all(16),
                        child: Row(children: [
                          Text(provider.translate('order_detail.address')),
                          FutureBuilder(
                              future: provider.getToAddr(model?.toAddr),
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
                                  return Text(provider.translate("order_detail.none"));
                                }
                                return loading;
                              })
                        ])),
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
                                        child: buildShipNumber(model?.shipNum, snapshot.data),
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
                                Row(children: [
                                  Text(provider.translate("order_detail.logistics_info")),
                                  Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text("${model?.shipNum}"),
                                  )
                                ]),
                                Column(mainAxisSize: MainAxisSize.min, children: [loading]),
                              ]);
                            })),
                  ],
                ),
              ),
              Positioned(
                  left: 0,
                  bottom: 6,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildBtn(provider),
                    ],
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBtn(ReturnsDetailProvider provider) {
    String key = "300";
    if (provider.returnInfo != null) {
      final user = provider.getUser();
      if (user.userid == provider.returnInfo.order.buyer.userid) {
        key = "300";
      } else {
        key = "400";
      }
    }
    return Offstage(
        offstage: provider.isShowBtn(),
        child: CustomButton(
          onTap: () => provider.doProc(),
          margin: EdgeInsets.only(left: 8, top: 8, right: 8),
          padding: EdgeInsets.all(16),
          color: Colors.orange,
          text: provider.translate("order_detail.$key"),
        ));
  }
}

class ReturnsDetailProvider extends BaseProvider {
  ReturnsDetailProvider(BuildContext context, Order order) : super(context) {
    this._order = order;
    initProReturn();
  }

  Order _order;

  ProReturn _returnInfo;

  ProReturn get returnInfo => _returnInfo;

  String get logisticsKey => "logistics${_order.orderid}_return";

  Future<void> initProReturn() async {
    final res = await this.api.getReturns(_order.oid);
    if (res.code == 0) {
      _returnInfo = convertObj(res.data, "returnsByOrder", ProReturn());
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

  Future<dynamic> getLogistics() async {
    if (_returnInfo == null || _returnInfo.shipNum == null || _returnInfo.shipNum.isEmpty) return null;
    Map data;
    final cache = Global.getCache(logisticsKey);
    if (cache == null || cache.isEmpty) {
      final user = this.getUser();
      final res = await api.getLogisticsInfo(user.userid, _returnInfo.shipNum);
      if (res.code != 0) {
        return null;
      } else {
        data = jsonDecode(res.msg);
        if (data['status'] == "0") {
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

  Future<void> doProc() async {
    switch (_returnInfo.status) {
      case ReturnStatus.pendingShipment:
        await reShipment();
        break;
      case ReturnStatus.pendingReceipt:
        await reConReceipt();
        break;
      default:
        break;
    }
  }

  Future<void> reShipment() async {
    final um = this.getUserInfo();
    String number = await showModalBottomSheet(context: context, builder: (_) => InputSingleString());
    if (number != null && number.isNotEmpty) {
      showLoading();
      final res = await api.reShipment(um.keys[1], um.user.userid, um.user.eosid, _order.orderid, number);
      closeLoading();
      if (res.code == 0) {
        this.showToast(this.translate("message.successful_operation"));
        _returnInfo.status = ReturnStatus.pendingReceipt;
        _returnInfo.shipNum = number;
        notifyListeners();
      } else {
        this.showToast(getErrorMessage(res.msg));
      }
    }
  }

  Future<void> reConReceipt() async {
    final um = this.getUserInfo();
    showLoading();
    final res = await api.reConReceipt(um.keys[1], um.user.userid, um.user.eosid, _order.orderid);
    closeLoading();
    if (res.code == 0) {
      this.showToast(this.translate("message.successful_operation"));
      _returnInfo.status = ReturnStatus.completed;
      notifyListeners();
    } else {
      this.showToast(getErrorMessage(res.msg));
    }
  }

  bool isShowBtn() {
    if (_returnInfo != null) {
      final user = this.getUser();
      if (user.userid == _order.buyer.userid) {
        return !(_returnInfo.status == ReturnStatus.pendingShipment);
      } else if (user.userid == _order.seller.userid) {
        return !(_returnInfo.status == ReturnStatus.pendingReceipt);
      }
    }
    return true;
  }
}
