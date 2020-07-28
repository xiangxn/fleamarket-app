import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/data_api.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_button.dart';
import 'package:bitsflea/widgets/ext_circle_avatar.dart';
import 'package:bitsflea/widgets/ext_network_image.dart';
import 'package:bitsflea/widgets/price_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

import '../states/base.dart';

class ProductDetailRoute extends StatelessWidget {
  ProductDetailRoute({Key key, @required this.product}) : super(key: key);

  final Product product;

  Widget _buildImg(ProductDetailProvider provider, int inx) {
    String img = provider.product.photos[inx];
    Widget imgWidget = ExtNetworkImage('$URL_IPFS_GATEWAY$img', borderRadius: BorderRadius.circular(4));
    // Widget child = inx == 0 ? Hero(tag: 'productImg${product.photos[0].hashCode}${product.productId}${product.category.cid}', child: imgWidget) : imgWidget;
    // return Card(margin: EdgeInsets.only(left: 10, bottom: 10, right: 10), child: child);
    return Card(margin: EdgeInsets.only(left: 10, bottom: 10, right: 10), child: imgWidget);
  }

  Widget _buildBottomButton(String text, int type, bool active, Function onTap) {
    IconData icon;
    switch (type) {
      case 1:
        icon = active ? Icons.favorite : Icons.favorite_border;
        break;
      case 2:
        icon = active ? Icons.star : Icons.star_border;
        break;
      default:
        icon = Icons.chat_bubble_outline;
    }
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 20),
        child: Column(
          children: <Widget>[
            Icon(
              icon,
              color: active ? Colors.green : Colors.grey[600],
            ),
            Text(
              text,
              style: TextStyle(
                color: active ? Colors.green : Colors.grey[600],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build detail ....');
    return BaseRoute<ProductDetailProvider>(
      listen: true,
      provider: ProductDetailProvider(context, product),
      builder: (_, provider, __) {
        return FutureBuilder<bool>(
          initialData: false,
          future: provider.fetchProductInfo(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            final style = Provider.of<ThemeModel>(context).theme;
            if (snapshot.connectionState == ConnectionState.done && snapshot.data) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(FlutterI18n.translate(context, "product_detail.title")),
                  backgroundColor: style.headerBackgroundColor,
                  brightness: Brightness.light,
                  textTheme: style.headerTextTheme,
                  iconTheme: style.headerIconTheme,
                ),
                body: GestureDetector(
                    onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            physics: ClampingScrollPhysics(),
                            child: Column(
                              children: <Widget>[
                                Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      children: <Widget>[
                                        ExtCircleAvatar(
                                          provider.product.seller.head,
                                          36,
                                          strokeWidth: 0,
                                        ),
                                        SizedBox(width: 8),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(provider.product.seller.nickname, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                            Text(
                                                FlutterI18n.translate(context, 'product_detail.location', translationParams: {
                                                  "location": provider.product.position ?? '',
                                                  "time": provider.product.releaseTime.split("T")[0]
                                                }),
                                                style: TextStyle(fontSize: 12, color: Colors.grey))
                                          ],
                                        )
                                      ],
                                    )),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  alignment: Alignment.centerLeft,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      PriceText(label: FlutterI18n.translate(context, 'product_detail.price'), price: provider.product.price, priceBold: true),
                                      PriceText(
                                          label: FlutterI18n.translate(context, 'product_detail.postage'), price: provider.product.postage, priceBold: true),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(provider.product.title,
                                            style: TextStyle(
                                              fontSize: 18,
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          provider.product.description ?? '',
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    primary: false,
                                    itemCount: provider.product.photos.length,
                                    itemBuilder: (context, inx) => _buildImg(provider, inx),
                                  ),
                                ),
                                // ListTile(
                                //   dense: true,
                                //   title: Text('全部留言'),
                                // ),
                                // ListView.separated(
                                //   shrinkWrap: true,
                                //   primary: false,
                                //   itemCount: model.messages.length,
                                //   separatorBuilder: (_, i) => Divider(color: Colors.grey[300], height: 2,),
                                //   itemBuilder: (_, i) => ListTile(
                                //     leading: ExtCircleAvatar(
                                //       model.user.head,
                                //       40,
                                //       strokeWidth: 0,
                                //     ),
                                //     title: Row(
                                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                //       children: <Widget>[
                                //         Text(model.user.nickname,
                                //           style: TextStyle(
                                //             fontSize: 14
                                //           ),
                                //         ),
                                //         Text('1900-01-01 23:59:59',
                                //           style: TextStyle(
                                //             color: Colors.grey[600],
                                //             fontSize: 12
                                //           ),
                                //         )
                                //       ],
                                //     ),
                                //     subtitle: Text(model.messages[i]),
                                //   )
                                // )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: style.shadowBottom,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: <Widget>[
                              _buildBottomButton(FlutterI18n.translate(context, 'product_detail.favorite'), 1, provider.hasFavorite(), provider.favorite),
                              _buildBottomButton(FlutterI18n.translate(context, 'product_detail.follow'), 2, provider.hasFollow(), provider.follow),
                              // _buildBottomButton('留言', 0, false, (){}),
                              Spacer(),
                              CustomButton(
                                text: FlutterI18n.translate(context, 'product_detail.buy'),
                                height: 40,
                                onTap: provider.createOrder,
                              )
                            ],
                          ),
                        )
                      ],
                    )),
              );
            } else {
              return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text(FlutterI18n.translate(context, "product_detail.title")),
                    backgroundColor: style.headerBackgroundColor,
                    brightness: Brightness.light,
                    textTheme: style.headerTextTheme,
                    iconTheme: style.headerIconTheme,
                  ),
                  body: Center(child: CircularProgressIndicator()));
            }
          },
        );
      },
    );
  }
}

class ProductDetailProvider extends BaseProvider {
  Product _product;
  DataApi _api;
  ProductDetailProvider(BuildContext context, Product product) : super(context) {
    _api = DataApi();
    _product = product;
  }

  Product get product => _product;

  bool hasFavorite([UserModel um]) {
    if (um == null) um = Provider.of<UserModel>(context, listen: false);
    return um.hasFavorites(_product?.productId);
  }

  bool hasFollow([UserModel um]) {
    if (um == null) um = Provider.of<UserModel>(context, listen: false);
    return um.hasFollow(_product.seller.userid);
  }

  favorite() async {
    _product.collections += 1;
    if (checkLogin() && !busy) {
      final um = Provider.of<UserModel>(context, listen: false);
      setBusy();
      var process;
      bool isf = false;
      if (hasFavorite(um)) {
        process = _api.unFavorite(um.user.userid, _product.productId);
      } else {
        process = _api.favorite(um.user.userid, _product.productId);
        isf = true;
      }
      showLoading();
      final res = await process;
      closeLoading();
      if (res.code == 0) {
        if (isf) {
          um.addFavorite(_product.productId);
          _product.collections += 1;
        } else {
          um.removeFavorite(_product.productId);
          _product.collections -= 1;
        }
        notifyListeners();
      }
      setBusy();
    }
  }

  follow() async {
    if (checkLogin() && !busy) {
      final user = Provider.of<UserModel>(context, listen: false).user;
      setBusy();
      var process;
      if (hasFollow()) {
        process = _api.unFollow(user.userid, _product.seller.userid);
      } else {
        process = _api.follow(user.userid, _product.seller.userid);
      }
      final res = await processing(process, loading: false, toast: false);
      if (res.code == 0) {
        notifyListeners();
      }
      setBusy();
    }
  }

  Future<bool> fetchProductInfo() async {
    var process = _api.fetchProductInfo(_product.productId);
    final res = await processing(process, loading: false);
    if (res.code == 0) {
      var product = convertEdge<Product>(res.data, "products", Product());
      if (product != null) {
        _product = product;
      }
      // notifyListeners();
      return true;
    }
    return false;
  }

  createOrder() {
    pushNamed(ROUTE_CREATE_ORDER, arguments: _product);
  }

  // Future<bool> onBack() {
  //   pop(_product);
  //   return Future.value(false);
  // }
}
