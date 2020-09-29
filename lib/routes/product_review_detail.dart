import 'package:bitsflea/common/constant.dart';
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
import 'package:provider/provider.dart';

import '../states/base.dart';

class ProductReviewDetailRoute extends StatelessWidget {
  ProductReviewDetailRoute({Key key, @required this.product}) : super(key: key);

  final Product product;

  Widget _buildImg(ProductReviewDetailProvider provider, int inx) {
    String img = provider.product.photos[inx];
    Widget imgWidget = ExtNetworkImage('$URL_IPFS_GATEWAY$img', borderRadius: BorderRadius.circular(4));
    // Widget child = inx == 0 ? Hero(tag: 'productImg${product.photos[0].hashCode}${product.productId}${product.category.cid}', child: imgWidget) : imgWidget;
    // return Card(margin: EdgeInsets.only(left: 10, bottom: 10, right: 10), child: child);
    return Card(margin: EdgeInsets.only(left: 10, bottom: 10, right: 10), child: imgWidget);
  }

  @override
  Widget build(BuildContext context) {
    print('build review detail ....');
    return BaseRoute<ProductReviewDetailProvider>(
      listen: true,
      provider: ProductReviewDetailProvider(context, product),
      builder: (_, provider, __) {
        return FutureBuilder<bool>(
          initialData: false,
          future: provider.fetchProductInfo(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            final style = Provider.of<ThemeModel>(context, listen: false).theme;
            if (snapshot.connectionState == ConnectionState.done && snapshot.data) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(provider.translate("product_review.title")),
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
                                                provider.translate('product_detail.location', translationParams: {
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
                                      PriceText(label: provider.translate('product_detail.price'), price: provider.product.price, priceBold: true),
                                      PriceText(label: provider.translate('product_detail.postage'), price: provider.product.postage, priceBold: true),
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
                              ],
                            ),
                          ),
                        ),
                        Container(
                            decoration: style.shadowBottom,
                            padding: EdgeInsets.all(10),
                            child: Selector<ProductReviewDetailProvider, User>(
                                selector: (ctx, provider) => Provider.of<UserModel>(ctx).user,
                                shouldRebuild: (pre, next) => true,
                                builder: (ctx, user, widget) {
                                  print("shadow bottom build***************");
                                  return Row(
                                    children: <Widget>[
                                      CustomButton(
                                        text: provider.translate('product_review.pulloff'),
                                        height: 40,
                                        color: Colors.orange,
                                        onTap: provider.pullOff,
                                      ),
                                      Spacer(),
                                      CustomButton(
                                        text: provider.translate('product_review.puton'),
                                        height: 40,
                                        onTap: provider.putOn,
                                      )
                                    ],
                                  );
                                }))
                      ],
                    )),
              );
            } else {
              return Scaffold(
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text(provider.translate("product_detail.title")),
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

class ProductReviewDetailProvider extends BaseProvider {
  Product _product;
  ProductReviewDetailProvider(BuildContext context, Product product) : super(context) {
    _product = product;
  }

  Product get product => _product;

  Future<bool> fetchProductInfo() async {
    var process = api.fetchProductInfo(_product.productId);
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

  putOn() async {
    if (_product.status != 0) {
      showToast(this.translate("product_review.put_error"));
      return;
    }
    final um = Provider.of<UserModel>(context, listen: false);
    showLoading();
    final res = await api.putReview(um.keys[1], um.user.userid, um.user.eosid, product.productId, false);
    closeLoading();
    if (res.code == 0) {
      _product.status = 100;
      pop(_product);
    } else {
      showToast(getErrorMessage(res.msg));
    }
  }

  pullOff() async {
    if (_product.status != 0) {
      showToast(this.translate("product_review.put_error"));
      return;
    }
    final txt = await Navigator.push(context, PopRoute(child: InputDialog()));
    if (txt.runtimeType != String) return;
    if (txt == null || txt.isEmpty || txt.length < 1) {
      showToast(this.translate("product_review.memo_hint"));
      return;
    }
    final um = Provider.of<UserModel>(context, listen: false);
    showLoading();
    final res = await api.putReview(um.keys[1], um.user.userid, um.user.eosid, product.productId, true, memo: txt);
    closeLoading();
    if (res.code == 0) {
      _product.status = 300;
      pop(_product);
    } else {
      showToast(getErrorMessage(res.msg));
    }
  }
}

class InputDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    return BaseRoute<InputDialogProvider>(
      provider: InputDialogProvider(context),
      builder: (ctx, provider, widget) {
        return Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                    child: new GestureDetector(
                        child: new Container(
                          color: Colors.black54,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        })),
                Container(
                    color: style.scaffoldBackgroundColor,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: TextField(
                            autofocus: true,
                            maxLines: 6,
                            maxLength: 500,
                            maxLengthEnforced: false,
                            textInputAction: TextInputAction.done,
                            controller: provider.memoController,
                            decoration: InputDecoration(
                                hintText: provider.translate('product_review.memo_hint'),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(8),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(style: BorderStyle.none))),
                          ),
                        ),
                        CustomButton(
                          width: double.infinity,
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(16),
                          onTap: provider.submit,
                          text: provider.translate('controller.ok'),
                        )
                      ],
                    ))
              ],
            ));
      },
    );
  }
}

class InputDialogProvider extends BaseProvider {
  TextEditingController _memoController = TextEditingController();

  InputDialogProvider(BuildContext context) : super(context);

  TextEditingController get memoController => _memoController;

  submit() async {
    pop(_memoController.text);
  }
}

class PopRoute<T> extends PopupRoute {
  final Duration _duration = Duration(milliseconds: 300);
  Widget child;

  PopRoute({@required this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

class BottomInputDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: new Column(
        children: <Widget>[
          Expanded(
              child: new GestureDetector(
            child: new Container(
              color: Colors.black54,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          )),
          new Container(
              height: 50,
              color: Colors.white,
              child: TextField(
                autofocus: true,
                maxLines: 100,
              ))
        ],
      ),
    );
  }
}
