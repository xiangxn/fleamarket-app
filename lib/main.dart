import 'dart:async';
import 'package:amap_location/amap_location.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
// import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/provider_setup.dart';
import 'package:fleamarket/src/common/router.dart';
import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/ext_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'dart:js';
void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  ExtLocale locale = ExtLocale();
  ExtSystem system = ExtSystem();
  runZoned(
    () {
      Future.wait(<Future>[
        Utils.initSharedPreferences(),
        locale.setLocale(),
        system.init(),
        // AmapCore.init("4c3c5b2c6a9a03a5d08e02225fdf3fd9"),
        AMapLocationClient.setApiKey("4c3c5b2c6a9a03a5d08e02225fdf3fd9")
      ]).then((_){
        runApp(App(locale: locale, system: system,));
        // 强制横屏
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown
        ]);
        // if (Platform.isAndroid) {
          // 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
          SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: Color(0xFF000000),
            systemNavigationBarDividerColor: null,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );
          SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
          // 设置statusBar 使用黑色主题（白底黑字）
          // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
        // }


        // test
        EOSPrivateKey privateKey = EOSPrivateKey.fromRandom();
      });
    },
    zoneSpecification: ZoneSpecification(print: (Zone self, ZoneDelegate parent, Zone zone, String line){
      parent.print(zone, "输出: $line");
    }),
    onError: Utils.reports
  );
}

class App extends StatelessWidget{

  final ExtLocale locale;
  final ExtSystem system;
  App({
    Key key,
    @required this.locale,
    @required this.system
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('************************************************ app build ************************************************');
    return MultiProvider(
      providers: ProviderSetup.getProviders(locale, system),
      child: Consumer<ExtLocale>(
        builder: (_, locale, __){
          print('************************************************ app consumer build ************************************************');
          return MaterialApp(
            title: 'Flemarket-app',
            color: Colors.green,
            theme: ThemeData(
              primarySwatch: Colors.green,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              dividerColor: Colors.transparent,
              scaffoldBackgroundColor: Style.backgroundColor,
              backgroundColor: Style.backgroundColor
            ),
            onGenerateRoute: Router.generatorRoute,
            initialRoute: HOME_ROUTE,
          );
        },
      )
    );
  }
}