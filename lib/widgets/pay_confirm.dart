import 'dart:convert';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/token_pocket.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'confirm_password.dart';

class PayConfirm extends StatelessWidget {
  final PayInfo payInfo;
  final Order order;

  PayConfirm({Key key, this.payInfo, this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseRoute<PayConfirmProvider>(
      provider: PayConfirmProvider(context, payInfo, order),
      builder: (_, model, __) {
        return Card(
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
                        Text("${model.order.productInfo.title} (${model.order.seller.nickname})")
                      ])),
                  Divider(height: 1.0, indent: 0.0, color: Colors.grey),
                  Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text(model.translate('pay_confirm.pay_mode'), style: TextStyle(color: Colors.grey[700])),
                        Row(
                          children: [
                            Text(model.translate("pay_confirm.${model.payInfo.payMode}")),
                            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])
                          ],
                        )
                      ])),
                  Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CustomButton(
                            onTap: model.onProc,
                            margin: EdgeInsets.only(left: 8, top: 8, right: 8),
                            padding: EdgeInsets.all(16),
                            color: Colors.orange,
                            text: model.translate("pay_confirm.btn_pay"),
                          )
                        ],
                      ))
                ],
              ),
            ));
      },
    );
  }
}

class PayConfirmProvider extends BaseProvider {
  PayInfo _payInfo;
  Order _order;

  PayInfo get payInfo => _payInfo;
  Order get order => _order;

  PayConfirmProvider(BuildContext context, PayInfo payInfo, Order order) : super(context) {
    this._payInfo = payInfo;
    this._order = order;
  }
  String _getChain(String symbol) {
    String chain = "bos";
    switch (symbol) {
      case "USDT":
      case "ETH":
        chain = "eth";
        break;
      case "EOS":
        chain = "eos";
        break;
      case "NULS":
        chain = "nuls";
        break;
      default:
        chain = "bos";
        break;
    }
    return chain;
  }

  String _getContract(String symbol) {
    String contract = CONTRACT_NAME;
    switch (symbol) {
      case "USDT":
        contract = ADDR_USDT_ETH_ERC20;
        break;
      case "EOS":
        contract = MAIN_NET_CONTRACT_NAME;
        break;
      default:
        contract = CONTRACT_NAME;
        break;
    }
    return contract;
  }

  onProc() async {
    switch (payInfo.payMode) {
      case 0: //合约主网支付
        await this._doMainPay();
        break;
      case 1: //tokenpocket钱包支付
        await this._doTokenPocket();
        break;
      default:
        this.showToast("pay_confirm.error_unsupported");
        break;
    }
  }

  Future<void> _doMainPay() async {
    final pwd = await showModalBottomSheet(context: context, builder: (_) => ConfirmPassword());
    if (pwd != null) {
      String contract;
      if (payInfo.symbol == MAIN_NET_ASSET_SYMBOL) {
        contract = MAIN_NET_CONTRACT_NAME;
      } else {
        contract = CONTRACT_NAME;
      }
      final um = this.getUserInfo();
      final asset = Holding.fromJson("${payInfo.amount} ${payInfo.symbol}");
      final res = await api.transfer(um.keys[1], um.user.eosid, payInfo.payAddr, asset, "p:${payInfo.orderid}", contract: contract);
      if (res.code == 0) {
        this.showToast(translate("pay_confirm.pay_success"));
      } else {
        this.showToast(res.msg);
      }
      this.pop();
    }
  }

  Future<void> _doTokenPocket() async {
    TokenPocket tp = TokenPocket();
    tp.blockchain = this._getChain(_payInfo.symbol);
    tp.contract = this._getContract(_payInfo.symbol);
    tp.to = _payInfo.payAddr;
    tp.amount = _payInfo.amount;
    tp.symbol = _payInfo.symbol;
    tp.precision = COIN_PRECISION[_payInfo.symbol];
    tp.memo = "p:${_payInfo.orderid}";
    tp.expired = (DateTime.now().add(Duration(minutes: 5)).millisecondsSinceEpoch / 1000).toString();
    tp.desc = translate("pay_confirm.confirm_title");
    String param = jsonEncode(tp);
    param = Uri.encodeComponent(param);
    String url = 'tpoutside://pull.activity?param=$param';
    bool isOk = await launch(url);
    if (isOk == false) {
      this.showToast(translate("pay_confirm.launch_tp_err"));
    } else {
      this.pop();
    }
  }
}
