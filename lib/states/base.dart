import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/data_api.dart';
import 'package:bitsflea/common/ext_dialog.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/common/style.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';

class BaseProvider extends ChangeNotifier {
  final BuildContext context;
  bool _busy = false;
  DataApi _api;
  bool isLocalRefresh = false;

  BaseProvider(this.context) {
    _api = DataApi();
  }

  //********************用户状态数据**************/
  User getUser({bool listen = false}) {
    return Provider.of<UserModel>(context, listen: listen).user;
  }

  UserModel getUserInfo({bool listen = false}) {
    return Provider.of<UserModel>(context, listen: listen);
  }

  Style getStyle({bool listen = false}) {
    return Provider.of<ThemeModel>(context, listen: listen).theme;
  }

  EOSPrivateKey getUserKey(int index, {bool listen = false}) {
    final um = this.getUserInfo(listen: listen);
    if (um.keys.length == 3) return um.keys[index];
    return null;
  }
  //********************用户状态数据 结束**************/

  bool get busy => _busy;
  DataApi get api => _api;

  showLoading([String msg]) {
    ExtDialog.loading(context, msg);
  }

  closeLoading() {
    ExtDialog.close(context, true);
  }

  Future<bool> showToast(String msg) {
    return ExtDialog.toast(context, msg);
  }

  Future showDialog(Widget screen) {
    return Navigator.of(context).push(CupertinoPageRoute(builder: (_) => screen, fullscreenDialog: true));
  }

  alert(String msg, {String title, Function callback}) {
    ExtDialog.alert(context, msg, title).then((val) => callback == null ? val : callback());
  }

  confirm(String msg, {String title, Function callback}) {
    return ExtDialog.confirm(context, msg, title).then((val) => callback == null ? val : callback(val));
  }

  Future<T> pushNamed<T>(String routeName, {Object arguments}) {
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  pop<T>([T result]) {
    Navigator.of(context).pop(result);
  }

  Future<T> pushAndRepalceUntil<T>(String pushRoute, String untilRoute, {dynamic result, dynamic arguments}) {
    NavigatorState nav = Navigator.of(context);
    nav.popUntil(ModalRoute.withName(untilRoute));
    return nav.pushReplacementNamed(pushRoute, result: result, arguments: arguments);
  }

  setBusy() {
    _busy = !_busy;
  }

  Future<BaseReply> processing(Future<BaseReply> process, {bool loading = true, bool toast = true, String msg}) async {
    if (loading) showLoading(msg);
    var res = await process;
    if (loading) closeLoading();
    if (res.code != 0) {
      Global.console(res.msg);
      if (toast) showToast(res.msg);
    }
    return res;
  }

  bool checkLogin() {
    final user = Provider.of<UserModel>(context, listen: false).user;
    if (user == null) {
      pushNamed(ROUTE_LOGIN);
      return false;
    }
    return true;
  }

  String translate(String key, {String fallbackKey, Map<String, String> translationParams}) {
    return FlutterI18n.translate(context, key, fallbackKey: fallbackKey, translationParams: translationParams);
  }
}
