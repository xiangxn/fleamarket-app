import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'product_list.dart';

class UserFavoriteRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("UserFavoriteRoute build*************");
    return BaseRoute<UserFavoriteProvider>(
      listen: true,
      provider: UserFavoriteProvider(context),
      builder: (_, provider, loading) {
        final style = Provider.of<ThemeModel>(context).theme;
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('user_favorite.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: Container(
                margin: EdgeInsets.only(bottom: 10, top: 10),
                child: FutureBuilder(
                    future: provider.fetchFavorite(page: DataPage<Product>()),
                    builder: (ctx, AsyncSnapshot<DataPage<Product>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done)
                        return ProductList(productPage: snapshot.data, onGetData: provider.fetchFavorite);
                      else
                        return loading;
                    })));
      },
    );
  }
}

class UserFavoriteProvider extends BaseProvider {
  UserFavoriteProvider(BuildContext context) : super(context);

  Future<DataPage<Product>> fetchFavorite({DataPage<Product> page, int categoryid}) async {
    final user = Provider.of<UserModel>(context, listen: false).user;
    var res = await api.fetchFavoriteByUser(user.userid, page.pageNo, page.pageSize);
    if (res.code == 0) {
      var data = convertPageList<Product>(res.data, "favoriteByUser", new Product(), key2: "product");
      data.update(page.data);
      // print("data: $data");
      return data;
    }
    return page;
  }
}
