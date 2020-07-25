import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/data_api.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_refresh_indicator.dart';
import 'package:bitsflea/widgets/ext_circle_avatar.dart';
import 'package:bitsflea/widgets/ext_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class ProductList extends StatefulWidget {
  ProductList({
    Key key,
    @required this.productPage,
    this.refresh,
    this.controller,
    this.category,
  }) : super(key: key);

  final DataPage<Product> productPage;
  final Function({DataPage<Product> page, bool isRefresh}) refresh;
  final ScrollController controller;
  final int category;

  @override
  State<StatefulWidget> createState() => _ProductList();
}

class _ProductList extends State<ProductList> with AutomaticKeepAliveClientMixin {
  Future<void> onRefresh() async {
    if (widget.refresh != null) {
      return widget.refresh(page: widget.productPage, isRefresh: true);
    }
  }

  Future<void> onLoad() async {
    if (widget.refresh != null) {
      return widget.refresh(page: widget.productPage, isRefresh: false);
    }
  }

  Icon _buildFavoriteIcon(Product product) {
    var um = Provider.of<UserModel>(context, listen: false);
    bool isFavorite = um.hasFavorites(product.productId);
    return Icon(
      isFavorite ? Icons.favorite : Icons.favorite_border,
      size: 14,
      color: isFavorite ? Colors.green : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    DataPage productPage = widget.productPage;
    return BaseRoute<ProductListProvider>(
        provider: ProductListProvider(context),
        builder: (_, provider, __) {
          return CustomRefreshIndicator(
            onRefresh: onRefresh,
            onLoad: productPage.hasMore() ? onLoad : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: StaggeredGridView.countBuilder(
                controller: widget.controller,
                // physics: ClampingScrollPhysics(),
                itemCount: productPage.data.length,
                staggeredTileBuilder: (inx) => StaggeredTile.fit(2),
                crossAxisCount: 4,
                mainAxisSpacing: 6, // 垂直间距
                crossAxisSpacing: 6, // 水平间距
                itemBuilder: (context, i) {
                  return Selector<ProductListProvider, Product>(
                    selector: (_, __) => productPage.data[i],
                    builder: (_, product, __) {
                      return Card(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                          Hero(
                            tag: 'productImg${product.photos[0].hashCode}${product.productId}${widget.category}',
                            child: ExtNetworkImage(
                              '$URL_IPFS_GATEWAY${product.photos[0]}',
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                              onTap: () => provider.toDetail(productPage.data, i),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child:
                                Text(product.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(product.price.split(' ')[1], style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
                                Text(product.price.split(' ')[0],
                                    style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                              ExtCircleAvatar(product.seller.head, 20, strokeWidth: 0),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 6, right: 2),
                                  child: Text(product.seller.nickname,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                                ),
                              ),
                              InkWell(
                                child: Row(
                                  children: <Widget>[
                                    Text(product.collections.toString(), style: TextStyle(fontSize: 12)),
                                    SizedBox(width: 4),
                                    _buildFavoriteIcon(product)
                                  ],
                                ),
                                onTap: () => provider.favorite(productPage.data, i),
                              )
                            ]),
                          ),
                        ]),
                      );
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

class ProductListProvider extends BaseProvider {
  DataApi _api;
  ProductListProvider(BuildContext context) : super(context) {
    _api = DataApi();
  }

  toDetail(List<Product> data, int i) async {
    var product = await pushNamed(ROUTE_DETAIL, arguments: data[i]);
    if (product != null && product is Product) {
      data[i] = product;
      notifyListeners();
    }
    // print('router return product: $product');
  }

  favorite(List<Product> data, int i) async {
    if (checkLogin() && !busy) {
      final um = Provider.of<UserModel>(context, listen: false);
      setBusy();
      var process;
      bool isf = false;
      if (um.hasFavorites(data[i].productId)) {
        process = _api.unFavorite(um.user.userid, data[i].productId);
      } else {
        process = _api.favorite(um.user.userid, data[i].productId);
        isf = true;
      }
      // showLoading();
      final res = await process;
      // closeLoading();
      if (res.code == 0) {
        if (isf) {
          um.addFavorite(data[i].productId);
          data[i].collections += 1;
        } else {
          um.removeFavorite(data[i].productId);
          data[i].collections -= 1;
        }
        notifyListeners();
      }
      setBusy();
    }
  }
}
