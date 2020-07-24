import 'package:bitsflea/common/constant.dart';
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
    @required this.goodsPage,
    this.refresh,
    this.controller,
    this.category,
  }) : super(key: key);

  final DataPage<Product> goodsPage;
  final Function({DataPage<Product> page, bool isRefresh}) refresh;
  final ScrollController controller;
  final int category;

  @override
  State<StatefulWidget> createState() => _ProductList();
}

class _ProductList extends State<ProductList> with AutomaticKeepAliveClientMixin {
  Future<void> onRefresh() async {
    if (widget.refresh != null) {
      return widget.refresh(page: widget.goodsPage, isRefresh: true);
    }
  }

  Future<void> onLoad() async {
    if (widget.refresh != null) {
      return widget.refresh(page: widget.goodsPage, isRefresh: false);
    }
  }

  Icon _buildFavoriteIcon(Product goods) {
    // bool isFavorite = goods.hasCollection(user?.userid ?? 0);  //TODO
    var userModel = Provider.of<UserModel>(context, listen: false);
    bool isFavorite = false;
    return Icon(
      isFavorite ? Icons.favorite : Icons.favorite_border,
      size: 14,
      color: isFavorite ? Colors.green : Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    DataPage goodsPage = widget.goodsPage;
    return BaseRoute<ProductListProvider>(
        provider: ProductListProvider(context),
        builder: (_, model, __) {
          return CustomRefreshIndicator(
            onRefresh: onRefresh,
            onLoad: goodsPage.hasMore() ? onLoad : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6),
              child: StaggeredGridView.countBuilder(
                controller: widget.controller,
                // physics: ClampingScrollPhysics(),
                itemCount: goodsPage.data.length,
                staggeredTileBuilder: (inx) => StaggeredTile.fit(2),
                crossAxisCount: 4,
                mainAxisSpacing: 6, // 垂直间距
                crossAxisSpacing: 6, // 水平间距
                itemBuilder: (context, i) {
                  return Selector<ProductListProvider, Product>(
                    selector: (_, __) => goodsPage.data[i],
                    builder: (_, goods, __) {
                      return Card(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                          Hero(
                            tag: 'goodsImg${goods.photos[0].hashCode}${goods.productId}${widget.category}',
                            child: ExtNetworkImage(
                              '$URL_IPFS_GATEWAY${goods.photos[0]}',
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                              onTap: () => model.toDetail(goodsPage.data, i),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Text(goods.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(goods.price.split(' ')[1], style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
                                Text(goods.price.split(' ')[0],
                                    style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                              ExtCircleAvatar(goods.seller.head, 20, strokeWidth: 0),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 6, right: 2),
                                  child: Text(goods.seller.nickname,
                                      textAlign: TextAlign.left,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12, color: Colors.grey[800])),
                                ),
                              ),
                              InkWell(
                                child: Row(
                                  children: <Widget>[
                                    Text(goods.collections.toString(), style: TextStyle(fontSize: 12)),
                                    SizedBox(width: 4),
                                    _buildFavoriteIcon(goods)
                                  ],
                                ),
                                onTap: () => model.favorite(goodsPage.data, i),
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
  ProductListProvider(BuildContext context) : super(context);

  toDetail(List<Product> data, int i) async {
    var product = await super.pushNamed(ROUTE_DETAIL, arguments: data[i]);
    if (product != null && product is Product) {
      data[i] = product;
      notifyListeners();
    }
    print('router return goods $product');
  }

  favorite(List<Product> data, int i) async {
    var userModel = Provider.of<UserModel>(context);
    if (userModel.user == null) {
      pushNamed(ROUTE_LOGIN);
    }else {
      // TODO
    }
  }
}
