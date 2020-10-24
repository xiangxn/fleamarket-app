import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class PayConfirm extends StatelessWidget {
  final bool mainPay;
  final PayInfo payInfo;
  final Order order;

  PayConfirm({Key key, this.mainPay, this.payInfo, this.order}) : super(key: key);

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
                          children: [Text(model.translate("pay_confirm.${mainPay ? 0 : 1}")), Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])],
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

  onProc() async {}
}
