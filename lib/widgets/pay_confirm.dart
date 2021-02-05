import 'dart:convert';
import 'dart:io';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/token_pocket.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:convert/convert.dart';

import 'confirm_password.dart';

class PayConfirm extends StatelessWidget {
  final PayInfo payInfo;
  final Order order;

  PayConfirm({Key key, this.payInfo, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseRoute<PayConfirmProvider>(
      listen: true,
      provider: PayConfirmProvider(context, payInfo, order),
      builder: (_, model, __) {
        return PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: model.pageController,
          children: [
            Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 50),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          children: [
                            Text(
                              "${formatPrice3(payInfo.amount)}",
                              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.orange),
                            ),
                            Text(
                              "${payInfo.symbol}",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(model.translate('pay_confirm.order_info'), style: TextStyle(color: Colors.grey[700])),
                            Expanded(
                                child: Text(
                              "${model.order.productInfo.title}",
                              overflow: TextOverflow.ellipsis,
                            )),
                            Text("(${model.order.seller.nickname})")
                          ])),
                      Divider(height: 1.0, indent: 0.0, color: Colors.grey),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: InkWell(
                          onTap: () => model.changePage(1),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(model.translate('pay_confirm.pay_mode'), style: TextStyle(color: Colors.grey[700])),
                            Row(
                              children: [Text(model.selectedPayMode), Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])],
                            )
                          ]),
                        ),
                      ),
                      Offstage(
                        offstage: !(model.isManual),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(children: [
                            InkWell(
                                onTap: () => model.onCopyPayAddr(),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(model.translate("pay_confirm.label_pay_addr"), style: TextStyle(color: Colors.grey[700])),
                                    Expanded(
                                      child: Text(model.getManualPayAddr(), overflow: TextOverflow.ellipsis, maxLines: 1),
                                    ),
                                    Icon(Icons.copy, size: 16)
                                  ]),
                                )),
                            InkWell(
                              onTap: () => model.onCopyPayMemo(),
                              child: Padding(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text(model.translate("pay_confirm.label_pay_memo"), style: TextStyle(color: Colors.grey[700])),
                                  Expanded(
                                    child: Text(model.getManualPayMemo(), overflow: TextOverflow.ellipsis, maxLines: 1),
                                  ),
                                  Icon(Icons.copy, size: 16)
                                ]),
                              ),
                            ),
                          ]),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              CustomButton(
                                onTap: model.onProc,
                                margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                                padding: EdgeInsets.all(16),
                                color: Colors.orange,
                                text: model.isManual ? model.translate("pay_confirm.btn_pay_ok") : model.translate("pay_confirm.btn_pay"),
                              )
                            ],
                          ))
                    ],
                  ),
                )),
            Card(
              elevation: 0,
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 50),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: Text(
                        model.translate("pay_confirm.label_select_pay"),
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: model.availablePayModes.length,
                        separatorBuilder: (ctx, index) {
                          return Divider(height: 1.0, indent: 0.0, color: Colors.grey);
                        },
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: EdgeInsets.all(16),
                            child: InkWell(
                                onTap: () => model.onSelected(model.availablePayModes[index]),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [Text(model.availablePayModes[index]), Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])],
                                )),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class PayConfirmProvider extends BaseProvider {
  PayInfo _payInfo;
  Order _order;
  int pageIndex = 0;
  PageController _pageController;
  List<String> _availablePayModes = [];
  String selectedPayMode;

  PayInfo get payInfo => _payInfo;
  Order get order => _order;
  PageController get pageController => _pageController;
  List<String> get availablePayModes => _availablePayModes;

  PayConfirmProvider(BuildContext context, PayInfo payInfo, Order order) : super(context) {
    this._payInfo = payInfo;
    this._order = order;
    _pageController = PageController();
    _initAvailablePayModes();
    selectedPayMode = availablePayModes[0];
  }

  ///
  /// 是否手工支付
  ///
  bool get isManual => selectedPayMode == this.translate("pay_confirm.2");

  bool get isBalance => selectedPayMode == this.translate("pay_confirm.0");

  void onCopyPayAddr() {
    Clipboard.setData(ClipboardData(text: this.getManualPayAddr()));
    this.showToast(translate('pay_confirm.msg_already_copy_addr'));
  }

  void onCopyPayMemo() {
    Clipboard.setData(ClipboardData(text: this.getManualPayMemo()));
    this.showToast(translate('pay_confirm.msg_already_copy_memo'));
  }

  void _initAvailablePayModes() {
    if (payInfo.balance >= payInfo.amount) {
      _availablePayModes.add(this.translate("pay_confirm.0"));
    }
    switch (payInfo.chain) {
      case "nuls":
        _availablePayModes.add("Nabox");
        _availablePayModes.add("HebeWallet");
        break;
      case "eos":
      case "heco":
      case "bsc":
      case "bos":
        _availablePayModes.add("TokenPocket");
        break;
      default:
        break;
    }
    _availablePayModes.add(this.translate("pay_confirm.2"));
  }

  String getManualPayAddr() {
    if (this._isIBCTransfer(payInfo.chain)) {
      return Global.config.bosIBCContract;
    }
    return payInfo.payAddr;
  }

  String getManualPayMemo() {
    // print(payInfo);
    if (this._isIBCTransfer(payInfo.chain)) {
      return "${payInfo.payAddr}@bos p:${payInfo.orderid}";
    } else {
      switch (payInfo.chain) {
        case "eth":
        case "heco":
        case "bsc":
          return "0x" + hex.encode(utf8.encode("p:${payInfo.orderid}"));
        default:
          return "p:${payInfo.orderid}";
      }
    }
  }

  Future<void> onSelected(String payMode) async {
    selectedPayMode = payMode;
    payInfo.payMode = this.isBalance ? 0 : 1;
    final balance = payInfo.amount;
    showLoading();
    final res =
        await api.createPayInfo(payInfo.userId.toInt(), payInfo.productId, payInfo.amount, payInfo.symbol, payInfo.payMode == 0, orderId: payInfo.orderid);
    closeLoading();
    if (res.code == 0) {
      res.data.unpackInto(payInfo);
      payInfo.balance = balance;
    } else {
      this.showToast(this.translate("order.create_pay_info_err"));
      return;
    }
    Global.console("payInfo: $payInfo");
    pageController.animateToPage(0, duration: new Duration(milliseconds: 300), curve: Curves.decelerate);
    notifyListeners();
  }

  void changePage(int newIndex) {
    pageController.animateToPage(newIndex, duration: new Duration(milliseconds: 300), curve: Curves.decelerate);
  }

  String _getContract(String symbol) {
    String contract = Global.config.mainContract;
    switch (symbol) {
      case "USDT":
        contract = Global.config.bosIBCContract;
        break;
      case "EOS":
        contract = Global.config.eosTokenContract;
        break;
      default:
        contract = Global.config.mainContract;
        break;
    }
    if (symbol == Global.config.mainAssetSymbol) contract = Global.config.mainTokenContract;
    return contract;
  }

  onProc() async {
    if (this.selectedPayMode == this.translate("pay_confirm.0")) {
      //合约主网支付
      await this._doMainPay();
    } else if (this.selectedPayMode == this.translate("pay_confirm.2")) {
      //手工支付,直接关闭
      this.showToast(this.translate("pay_confirm.msg_already_pay")).then((value) => this.pop(false));
    } else {
      //钱包支付
      await this._walletPay();
    }
  }

  Future<void> _walletPay() async {
    switch (payInfo.chain) {
      case "nuls":
        if (this.selectedPayMode == "Nabox") {
          await _doNabox();
        } else {
          await _doHebeWallet();
        }
        break;
      case "eos":
      case "heco":
      case "bsc":
        await _doTokenPocket();
        break;
      default:
        break;
    }
  }

  Future<void> _doMainPay() async {
    final pwd = await showModalBottomSheet(context: context, builder: (_) => ConfirmPassword());
    // Widget screen = ConfirmPassword();
    // final pwd = await this.showDialog(screen);
    if (pwd != null) {
      String contract;
      if (payInfo.symbol == Global.config.mainAssetSymbol) {
        //eosio.token
        contract = Global.config.mainTokenContract;
      } else if (COIN_CROSS_CHAIN.any((element) => element == payInfo.symbol)) {
        //bosibc.io
        contract = Global.config.bosIBCContract;
      } else {
        //bitsfleamain
        contract = Global.config.mainContract;
      }
      final um = this.getUserInfo();
      final asset = Holding.fromJson("${payInfo.amount} ${payInfo.symbol}");
      showLoading();
      final res = await api.transfer(um.keys[1], um.user.eosid, payInfo.payAddr, asset, "p:${payInfo.orderid}", contract: contract);
      closeLoading();
      if (res.code == 0) {
        this.showToast(translate("pay_confirm.pay_success")).then((value) => this.pop(true));
      } else {
        await this.showToast(getErrorMessage(res.msg));
        this.pop(false);
      }
    }
  }

  Future<void> _doHebeWallet() async {
    //hebewallet://?model={"addr":"nuls地址","sum":"数量","type":"Nuls","msg":"消息"}
    String model = '{"addr":"${_payInfo.payAddr}","sum":"${_payInfo.amount}","type":"${_payInfo.symbol}","msg":"p:${_payInfo.orderid}"}';
    model = Uri.encodeComponent(model);
    String url = "hebewallet://?model=$model";
    Global.console("url: $url");
    bool isOk = false;
    try {
      isOk = await launch(url);
    } on Exception catch (e) {
      Global.console(e);
      isOk = false;
    }
    if (isOk == false) {
      this.showToast(translate("pay_confirm.launch_tp_err", translationParams: {'wallet': this.selectedPayMode}));
    } else {
      if (Platform.isAndroid) {
        this.pop(false);
      } else {
        this.showToast(this.translate("pay_confirm.msg_already_pay")).then((value) => this.pop(false));
      }
    }
  }

  Future<void> _doNabox() async {
    //nabox://nuls.nabox/pay?remark="+“备注”+"&amount="+ “金		额”+"&toAddress="+ “入账地址”
    String remark = "p:${_payInfo.orderid}";
    remark = Uri.encodeComponent(remark);
    final url = "nabox://nuls.nabox/pay?remark=$remark&amount=${_payInfo.amount}&symbol=${_payInfo.symbol}&toAddress=${_payInfo.payAddr}";
    Global.console("url: $url");
    bool isOk = false;
    try {
      isOk = await launch(url);
    } on Exception catch (e) {
      Global.console(e);
      isOk = false;
    }
    if (isOk == false) {
      this.showToast(translate("pay_confirm.launch_tp_err", translationParams: {'wallet': this.selectedPayMode}));
    } else {
      if (Platform.isAndroid) {
        this.pop(false);
      } else {
        this.showToast(this.translate("pay_confirm.msg_already_pay")).then((value) => this.pop(false));
      }
    }
  }

  bool _isIBCTransfer(String chain) {
    bool flag = false;
    switch (chain) {
      case "eos":
        flag = true;
        break;
      default:
        break;
    }
    return flag;
  }

  Future<void> _doTokenPocket() async {
    TokenPocket tp = TokenPocket();
    tp.blockchain = _payInfo.chain;
    tp.contract = this._getContract(_payInfo.symbol);
    if (this._isIBCTransfer(_payInfo.chain)) {
      tp.to = Global.config.bosIBCContract;
      // tp.memo = "${_payInfo.payAddr}@bos p:${_payInfo.orderid}";
    } else {
      tp.to = _payInfo.payAddr;
      // tp.memo = "p:${_payInfo.orderid}";
    }
    tp.memo = getManualPayMemo();
    tp.amount = _payInfo.amount;
    tp.symbol = _payInfo.symbol;
    tp.precision = Global.coins[_payInfo.symbol].precision;
    tp.expired = (DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch / 1000).toString();
    tp.desc = translate("pay_confirm.confirm_title");
    String param = jsonEncode(tp);
    Global.console(param);
    param = Uri.encodeComponent(param);
    String url = 'tpoutside://pull.activity?param=$param';
    bool isOk = await launch(url);
    if (isOk == false) {
      this.showToast(translate("pay_confirm.launch_tp_err", translationParams: {'wallet': this.selectedPayMode}));
    } else {
      this.showToast(this.translate("pay_confirm.msg_already_pay")).then((value) => this.pop(false));
    }
  }
}
