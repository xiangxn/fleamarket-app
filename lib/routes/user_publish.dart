import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/custom_refresh_indicator.dart';
import 'package:bitsflea/widgets/ext_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPublishRoute extends StatelessWidget {
  Widget _buildStatus(UserPublishProvider provider, int status) {
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
    return BaseRoute<UserPublishProvider>(
      // listen: true,
      provider: UserPublishProvider(context),
      builder: (_, provider, loading) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('user_publish.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: CustomRefreshIndicator(
              onRefresh: () => provider.fetchPublish(isRefresh: true),
              onLoad: provider.load,
              child: FutureBuilder(
                future: provider.fetchPublish(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return ListView.builder(
                        // physics: ClampingScrollPhysics(),
                        itemCount: provider.productPage.data.length,
                        itemBuilder: (_, i) {
                          Product product = provider.productPage.data[i];
                          return InkWell(
                              onTap: () => provider.toEdit(product),
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
                                                    child: ExtNetworkImage('$URL_IPFS_GATEWAY${product.photos[0]}',
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
                                                    Text(provider.translate('combo_text.postage', translationParams: {"price": formatPrice2(product.postage)}),
                                                        style: style.smallFont),
                                                    Text(
                                                      provider
                                                          .translate('combo_text.favorite_count', translationParams: {"count": product.collections.toString()}),
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

class UserPublishProvider extends BaseProvider {
  UserPublishProvider(BuildContext context) : super(context) {
    _page = DataPage<Product>();
    // fetchPublish();
  }

  DataPage<Product> _page;

  DataPage<Product> get productPage => _page;

  Future<bool> fetchPublish({bool isRefresh = false}) async {
    bool flag = false;
    final user = Provider.of<UserModel>(context, listen: false).user;
    setBusy();
    if (isRefresh) {
      _page.clean();
    }
    final res = await api.fetchPublishByUser(user.userid, _page.pageNo, _page.pageSize);
    if (res.code == 0) {
      var data = convertPageList(res.data, "productByPublisher", Product());
      data.update(_page.data);
      _page = data;
      if (_page.hasMore()) {
        _page.pageNo += 1;
        flag = true;
      }
    }
    setBusy();
    return flag;
  }

  Future<bool> load() async {
    if (_page.hasMore()) {
      await fetchPublish();
    }
    return false;
  }

  toEdit(Product goods) async {
    var res = await pushNamed(ROUTE_PUBLISH, arguments: goods);
    print('编辑完成 ${res.runtimeType}');
  }
}
