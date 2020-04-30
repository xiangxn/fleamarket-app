import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/ext_system.dart';
import 'package:fleamarket/src/services/api.dart';
import 'package:fleamarket/src/services/account_service.dart';
import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/services/location_service.dart';
import 'package:fleamarket/src/services/order_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderSetup{
  /// 不依赖任何其他服务来执行其逻辑的服务
  static List<SingleChildWidget> independentServices = [
    // Provider(
    //   create: (_) => Api(),
    // ),
    ProxyProvider<ExtLocale, Api>(
      update: (context, locale, api) => Api(locale),
    )
  ];

  /// 对应各个模块功能的服务，依赖于先前注册的服务
  static List<SingleChildWidget> dependentServices = [
    ProxyProvider<Api, AccountService>(
      update: (context, api, accountService) => AccountService(api)
    ),
    ProxyProvider<Api, GoodsService>(
      update: (context, api, goodsService) => GoodsService(api)
    ),
    ProxyProvider<Api, LocationService>(
      lazy: false,
      update: (context, api, locationService) => LocationService(api)
    ),
    ProxyProvider<Api, OrderService>(
      update: (context, api, orderService) => OrderService(api)
    )
  ];

  ///在ui中使用的对象，如当前登陆的用户
  static List<SingleChildWidget> uiConsumableProviders = [
    // ChangeNotifierProvider<ExtSystem>(
    //   create: (_) => ExtSystem(),
    // )
    // ValueListenableProvider<ExtLocal>(
    //   create: (_) => ValueNotifier<ExtLocal>(ExtLocal()),
    // )
    // ValueListenableProvider<TestUser>(
    //   create: (context) => Provider.of<AccountService>(context, listen: false).user,
    // )
    // StreamProvider<TestUser>(
    //   create: (context) => Provider.of<AccountService>(context, listen: false).user,
    // )
  ];

  /// 整个应用所有的Provider
  static getProviders(ExtLocale locale, ExtSystem system){
    List<SingleChildWidget> providers = [];
    providers.add(ChangeNotifierProvider<ExtLocale>.value(value: locale));
    providers.add(ChangeNotifierProvider<ExtSystem>.value(value: system));
    providers.addAll([
      ...independentServices,
      ...dependentServices,
      ...uiConsumableProviders
    ]);
    return providers;
  }
}