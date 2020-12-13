import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
// import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_refresh_indicator.dart';
import 'package:bitsflea/widgets/ext_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductReviewListRoute extends StatelessWidget {
  Widget _buildStatus(ProductReviewListProvider provider, int status) {
    // status = Random.secure().nextInt(4);
    Color color = Colors.black;

    if (status == 0) {
      color = Colors.red;
    } else if (status == 100) {
      color = Colors.green;
    } else if (status == 200) {
      color = Colors.orange;
    } else if (status == 300) {
      color = Colors.grey;
    } else if (status == 400) {
      color = Colors.red;
    }
    return Text(provider.translate('product_type.$status'), style: TextStyle(color: color));
  }

  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    return BaseRoute<ProductReviewListProvider>(
      // listen: true,
      provider: ProductReviewListProvider(context),
      builder: (_, provider, loading) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('product_review.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: CustomRefreshIndicator(
              onRefresh: () => provider.fetchProducts(isRefresh: true),
              onLoad: () => provider.load(),
              hasMore: () => provider.productPage.hasMore(),
              child: FutureBuilder(
                future: provider.fetchProducts(isRefresh: true),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        // physics: ClampingScrollPhysics(),
                        itemCount: provider.productPage.data?.length ?? 0,
                        itemBuilder: (_, i) {
                          return Selector<ProductReviewListProvider, Product>(
                            selector: (ctx, provider) => provider.productPage.data[i],
                            builder: (ctx, product, _) {
                              return InkWell(
                                  onTap: () => provider.toEdit(i, product),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 4),
                                    child: Card(
                                        elevation: 0,
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(right: 10),
                                                      child: SizedBox(
                                                        width: 70,
                                                        height: 70,
                                                        child: ExtNetworkImage(getIPFSUrl(product.photos[0]),
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4))),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                            child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: <Widget>[
                                                        Text(product.title, overflow: TextOverflow.ellipsis, maxLines: 1),
                                                        Text(provider.translate('combo_text.price', translationParams: {"price": formatPrice2(product.price)}),
                                                            style: style.smallFont),
                                                        Text(
                                                            provider
                                                                .translate('combo_text.postage', translationParams: {"price": formatPrice2(product.postage)}),
                                                            style: style.smallFont),
                                                        Text(
                                                          provider.translate('combo_text.favorite_count',
                                                              translationParams: {"count": product.collections.toString()}),
                                                          style: style.smallFont,
                                                        )
                                                      ],
                                                    )))
                                                  ],
                                                ),
                                              ),
                                              _buildStatus(provider, product.status)
                                            ],
                                          ),
                                        )),
                                  ));
                            },
                          );
                        });
                  }
                  return loading;
                },
              ),
            ));
      },
    );
  }
}

class ProductReviewListProvider extends BaseProvider {
  ProductReviewListProvider(BuildContext context) : super(context) {
    _page = DataPage<Product>();
    // fetchPublish();
  }

  DataPage<Product> _page;

  DataPage<Product> get productPage => _page;

  Future<bool> fetchProducts({bool isRefresh = false}) async {
    final user = Provider.of<UserModel>(context, listen: false).user;
    bool flag = false;
    setBusy();
    if (isRefresh) {
      _page.pageNo = 1;
      _page.clean();
    }
    final res = await api.fetchProductByStatus(0, user.userid, _page.pageNo, _page.pageSize);
    if (res.code == 0) {
      var data = convertPageList(res.data, "productByStatus", Product());
      if (data.data.length > 0) {
        data.update(_page.data);
        _page = data;
        if (_page.hasMore()) {
          _page.pageNo += 1;
          flag = true;
        }
      }
    }
    setBusy();
    // notifyListeners();
    return flag;
  }

  Future<bool> load() async {
    bool flag = _page.hasMore();
    if (flag) {
      await fetchProducts();
    }
    return flag;
  }

  toEdit(int index, Product goods) async {
    var res = await pushNamed(ROUTE_PRODUCT_REVIEW_DETAIL, arguments: goods);
    if (res != null) {
      _page.data[index] = res;
      notifyListeners();
    }
  }
}
