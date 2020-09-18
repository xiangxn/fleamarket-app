import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/order_card_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSellsRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    return BaseRoute<UserSellsProvider>(
      provider: UserSellsProvider(context),
      builder: (_, provider, __){
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(provider.translate('user_sells.title')),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
          ),
          body: OrderCardGroup(refresh: provider.fetchOrders),
        );
      }
    );
  }
}

class UserSellsProvider extends BaseProvider{
  UserSellsProvider(BuildContext context) : super(context);

  Future<DataPage<Order>> fetchOrders({int pageNo, int pageSize, String key="orderBySeller", String key2}) async {
    final user = Provider.of<UserModel>(context, listen: false).user;
    final res = await api.fetchBuysByUser(user.userid, pageNo, pageSize);
    if (res.code == 0) {
      var data = convertPageList(res.data, key, Order());
      return data;
    }
    return DataPage<Order>();
  }

}