import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/type.dart';
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
    this.onGetData,
    this.controller,
    this.category,
  }) : super(key: key);

  final DataPage<Product> productPage;
  final ScrollController controller;
  final int category;
  final GetDataCallback onGetData;

  @override
  State<StatefulWidget> createState() => _ProductList();
}

class _ProductList extends State<ProductList> {
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
    print("product_list build ******** ");
    return BaseWidget2<ProductListProvider, DataPage<Product>>(
      model: ProductListProvider(context, widget.productPage, onGetData: widget.onGetData),
      getSmallModel: (provider) => provider.productPage,
      builder: (ctx, provider, page, child) {
        return CustomRefreshIndicator(
          onRefresh: () => provider.onRefresh(categoryid: widget.category, isRefresh: true),
          onLoad: () => provider.onLoad(widget.category),
          hasMore: () => provider.productPage.hasMore(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: StaggeredGridView.countBuilder(
              controller: widget.controller,
              itemCount: provider.productPage.data?.length ?? 0,
              staggeredTileBuilder: (inx) => StaggeredTile.fit(2),
              crossAxisCount: 4,
              mainAxisSpacing: 6, // 垂直间距
              crossAxisSpacing: 6, // 水平间距
              itemBuilder: (context, i) {
                final product = page.data[i];
                return Card(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    ExtNetworkImage(
                      '$URL_IPFS_GATEWAY${product.photos[0]}',
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
                      onTap: () => provider.toDetail(i),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(product.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 2),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(product.price.split(' ')[1], style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
                          Text(formatPrice(product.price.split(' ')[0]),
                              style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis, maxLines: 1),
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
                          //onTap: () => provider.favorite(productPage.data, i),
                          onTap: () => provider.favorite(i),
                        )
                      ]),
                    ),
                  ]),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ProductListProvider extends BaseProvider {
  DataPage<Product> _productPage;
  GetDataCallback _onGetData;

  ProductListProvider(BuildContext context, DataPage<Product> productPage, {GetDataCallback onGetData}) : super(context) {
    _productPage = productPage ?? DataPage<Product>();
    _onGetData = onGetData ?? this._fetchProductList;
  }

  DataPage<Product> get productPage => _productPage;
  GetDataCallback get onGetData => _onGetData;

  @override
  void dispose() {
    _onGetData = null;
    super.dispose();
  }

  toDetail(int index) {
    pushNamed(ROUTE_DETAIL, arguments: _productPage.data[index]);
    // var product = await pushNamed(ROUTE_DETAIL, arguments: data[i]);
    // if (product != null && product is Product) {
    //   print("data[i].collections:${data[i].collections}");
    //   data[i] = product;
    //   notifyListeners();
    // }
    // print('router return product: $product');
  }

  favorite(int index) async {
    Product data = _productPage.data[index].clone();
    if (checkLogin() && !busy) {
      final um = this.getUserInfo();
      setBusy();
      var process;
      bool isf = false;
      if (um.hasFavorites(data.productId)) {
        process = api.unFavorite(um.user.userid, data.productId);
      } else {
        process = api.favorite(um.user.userid, data.productId);
        isf = true;
      }
      // showLoading();
      final res = await process;
      // closeLoading();
      if (res) {
        if (isf) {
          um.addFavorite(data.productId);
          data.collections += 1;
        } else {
          um.removeFavorite(data.productId);
          data.collections -= 1;
        }
        _productPage.data[index] = data;
        notifyListeners();
      }
      setBusy();
    }
  }

  Future<DataPage<Product>> _fetchProductList({int categoryid, DataPage<Product> page}) async {
    final res = await api.fetchProductList(categoryid, page.pageNo, page.pageSize);
    if (res.code == 0) {
      var data = convertPageList<Product>(res.data, "productByCid", Product());
      data.update(page.data);
      return data;
    }
    return page;
  }

  Future<bool> onRefresh({int categoryid = 0, bool isRefresh = false, bool notify = true}) async {
    bool flag = false;
    if (isRefresh) {
      _productPage.pageNo = 1;
      _productPage.clean();
    }
    setBusy();
    _productPage = await this.onGetData(categoryid: categoryid, page: _productPage);
    if (_productPage.hasMore()) {
      _productPage.pageNo += 1;
      flag = true;
    }
    setBusy();
    if (notify) {
      notifyListeners();
    }
    return flag;
  }

  Future<bool> onLoad(int categoryid) async {
    int hc = 0;
    if (productPage.hasMore()) {
      hc = productPage.hashCode;
      await this.onRefresh(categoryid: categoryid);
      return hc != productPage.hashCode;
    }
    return false;
  }
}
