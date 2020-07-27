import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/data_api.dart';
import 'package:bitsflea/common/ext_dialog.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/states/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

class BaseProvider extends ChangeNotifier {
  final BuildContext context;
  bool _busy = false;
  DataApi _api;

  BaseProvider(this.context) {
    _api = DataApi();
  }

  bool get busy => _busy;
  DataApi get api => _api;

  showLoading([String msg]) {
    ExtDialog.loading(context, msg);
  }

  closeLoading() {
    ExtDialog.close(context, true);
  }

  showToast(String msg) {
    ExtDialog.toast(context, msg);
  }

  Future showDialog(Widget screen) {
    return Navigator.of(context).push(CupertinoPageRoute(builder: (_) => screen, fullscreenDialog: true));
  }

  alert(String msg, {String title, Function callback}) {
    ExtDialog.alert(context, msg, title).then((val) => callback ?? null);
  }

  confirm(String msg, {String title, Function callback}) {
    ExtDialog.confirm(context, msg, title).then((val) => callback(val) ?? null);
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
    if (res.code == 0) {
    } else {
      if (toast) showToast(msg);
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
