import 'package:bitsflea/routes/home.dart';
import 'package:bitsflea/routes/login.dart';
import 'package:bitsflea/routes/product_detail.dart';
import 'package:bitsflea/routes/user_fans.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'common/chinese_cupertino.dart';
import 'common/constant.dart';
import 'common/global.dart';
import 'routes/order_detail.dart';
import 'routes/publish.dart';
import 'routes/search.dart';
import 'routes/user_buys.dart';
import 'routes/user_edit.dart';
import 'routes/user_favorite.dart';
import 'routes/user_follow.dart';
import 'routes/user_home.dart';
import 'routes/user_publish.dart';
import 'routes/user_sells.dart';
import 'states/locale.dart';
import 'states/theme.dart';
import 'states/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((value) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  final _flutterI18nDelegate =
      FlutterI18nDelegate(translationLoader: FileTranslationLoader(fallbackFile: "zh", basePath: "assets/locales", useCountryCode: false));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: <SingleChildWidget>[
          ChangeNotifierProvider<ThemeModel>.value(value: ThemeModel()),
          ChangeNotifierProvider<UserModel>.value(value: UserModel()),
          ChangeNotifierProvider<LocaleModel>.value(value: LocaleModel()),
        ],
        child: Consumer2<ThemeModel, LocaleModel>(builder: (BuildContext context, themeModel, localeModel, Widget child) {
          return MaterialApp(
            theme: ThemeData(
                primarySwatch: themeModel.theme.primarySwatch,
                splashColor: themeModel.theme.splashColor,
                highlightColor: themeModel.theme.highlightColor,
                dividerColor: themeModel.theme.dividerColor,
                scaffoldBackgroundColor: themeModel.theme.scaffoldBackgroundColor,
                backgroundColor: themeModel.theme.backgroundColor),
            onGenerateTitle: (context) {
              return FlutterI18n.translate(context, "title");
            },
            // home: HomeRoute(),
            // locale: localeModel.getLocale(),
            //我们只支持美国英语和中文简体
            supportedLocales: [
              const Locale('zh', 'CN'), // 中文简体
              const Locale('en', 'US'), // 美国英语
              //其它Locales
            ],
            localizationsDelegates: [
              // 本地化的代理类
              _flutterI18nDelegate,
              ChineseCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            localeResolutionCallback: (Locale _locale, Iterable<Locale> supportedLocales) {
              if (localeModel.getLocale() != null) {
                //如果已经选定语言，则不跟随系统
                return localeModel.getLocale();
              } else {
                Locale locale;
                //APP语言跟随系统语言，如果系统语言不是中文简体或美国英语，
                //则默认使用中文简体
                if (supportedLocales.contains(_locale)) {
                  locale = _locale;
                } else {
                  locale = Locale('zh', 'CN');
                }
                return locale;
              }
            },
            initialRoute: ROUTE_HOME,
            // 注册命名路由表
            routes: <String, WidgetBuilder>{
              ROUTE_HOME: (context) => HomeRoute(),
              ROUTE_SEARCH: (context) => SearchRoute(),
              ROUTE_LOGIN: (context) => LoginRoute(),
              ROUTE_USER_EDIT: (context) => UserEditRoute(),
              ROUTE_USER_FAVORITE: (context) => UserFavoriteRoute(),
              ROUTE_USER_FOLLOW: (context) => UserFollowRoute(),
              ROUTE_USER_FANS: (context) => UserFansRoute(),
              ROUTE_USER_PUBLISH: (context) => UserPublishRoute(),
              ROUTE_USER_BUY: (context) => UserBuysRoute(),
              ROUTE_USER_SELL: (context) => UserSellsRoute()
            },
            onGenerateRoute: (RouteSettings settings) {
              return CupertinoPageRoute(
                settings: settings,
                builder: (context) {
                  switch (settings.name) {
                    case ROUTE_DETAIL:
                      return ProductDetailRoute(product: settings.arguments);
                    case ROUTE_PUBLISH:
                      return PublishRoute(product: settings.arguments);
                    case ROUTE_USER_HOME:
                      return UserHomeRoute(user: settings.arguments);
                    case ROUTE_ORDER_DETAIL:
                      return OrderDetailRoute(order: settings.arguments);
                    default:
                      return Scaffold(
                        appBar: AppBar(),
                        body: Center(
                          child: Text('unknown route ${settings.name}'),
                        ),
                      );
                  }
                },
              );
            },
          );
        }));
  }
}
