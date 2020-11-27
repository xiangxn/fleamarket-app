import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/address_select_card.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/ext_network_image.dart';
import 'package:bitsflea/widgets/pay_confirm.dart';
import 'package:bitsflea/widgets/price_text.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateOrderRoute extends StatelessWidget {
  CreateOrderRoute({Key key, this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return BaseRoute<CreateOrderProvider>(
      listen: true,
      provider: CreateOrderProvider(context, product),
      builder: (_, model, loading) {
        final style = Provider.of<ThemeModel>(context, listen: false).theme;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(model.translate('order.create_order')),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
          ),
          body: Stack(fit: StackFit.expand, children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 80,
                          height: 80,
                          child: ExtNetworkImage(getIPFSUrl(product.photos[0]), imageBuilder: (_, imageProvider) {
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
                                  child: Text(product.title),
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          PriceText(label: model.translate('product_detail.price'), price: product.price),
                                          PriceText(label: model.translate('product_detail.postage'), price: product.postage)
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                  future: model.initAddress(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done)
                      return AddressSelectCard(
                        onTap: model.selectAddress,
                        address: model.address,
                        noDataHints: model.translate('message.address_no_data'),
                      );
                    return loading;
                  },
                )
              ],
            ),
            Positioned(
              left: 0,
              bottom: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    PriceText(
                        label: model.translate('order_detail.total_price'), price: addPrice(product.price, product.postage), fontSize: 14, priceBold: true),
                    CustomButton(
                      onTap: model.submit,
                      text: model.translate('controller.confirm_buy'),
                    )
                  ],
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}

class CreateOrderProvider extends BaseProvider {
  CreateOrderProvider(BuildContext context, Product product) : super(context) {
    _product = product;
  }

  Product _product;
  ReceiptAddress _address;

  ReceiptAddress get address => _address;

  initAddress() async {
    if (isLocalRefresh) {
      isLocalRefresh = false;
      return;
    }
    final user = this.getUser();
    var process = api.getDefaultAddr(user.userid);
    final res = await processing(process, loading: false);
    if (res.code == 0) {
      _address = convertEdge(res.data, "receiptaddresses", ReceiptAddress());
    }
  }

  submit() async {
    if (_product.category.cid != 7 && _address == null) {
      this.showToast(translate('message.order_no_address'));
    } else {
      // String password = await showModalBottomSheet(context: context, builder: (_) => ConfirmPassword());
      showLoading();
      //************创建订单***************
      final um = this.getUserInfo();
      final price = Holding.fromJson(_product.price);
      final postage = Holding.fromJson(_product.postage);
      final user = Provider.of<UserModel>(context, listen: false).user;
      //获取主网余额
      // print("获取余额...");
      final balance = await api.getUserBalance(user.eosid, price.currency);
      // print("获取余额完成...");
      final total = price.amount + postage.amount;
      bool mainPay = balance.amount >= total;
      //生成支付信息
      PayInfo payInfo = PayInfo();
      payInfo.payMode = mainPay ? 0 : 1;
      final res = await api.createPayInfo(um.user.userid, _product.productId, total, price.currency, mainPay);
      // print("创建支付信息...");
      if (res.code == 0) {
        res.data.unpackInto(payInfo);
      } else {
        closeLoading();
        showToast(this.translate("order.create_pay_info_err"));
        return;
      }
      final cRes = await api.placeorder(um.keys[1], um.user.userid, um.user.eosid, _product.productId, payInfo.orderid, _address == null ? 0 : _address.rid);
      // print("执行下单...");
      if (cRes.code != 0) {
        closeLoading();
        showToast(this.translate("order.create_order_err"));
        return;
      }
      closeLoading();
      Global.console("pay info: { $payInfo }");
      //打开支付UI
      Order order = Order();
      order.orderid = payInfo.orderid;
      order.productInfo = _product;
      order.seller = _product.seller;
      // Widget screen = PayConfirm(payInfo: payInfo, order: order);
      // final result = await this.showDialog(screen);
      final isPay = await showModalBottomSheet<bool>(
          context: context,
          builder: (_) => PayConfirm(
                payInfo: payInfo,
                order: order,
              ));
      // print("isPay: $isPay");
      this.pop(isPay);
    }
  }

  selectAddress() async {
    final address = await this.pushNamed(ROUTE_USER_ADDRESS, arguments: true);
    if (address != null) {
      _address = address;
      isLocalRefresh = true;
      notifyListeners();
    }
  }
}
