import 'package:bitsflea/common/ext_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseProvider extends ChangeNotifier {
  final BuildContext context;
  bool _busy = false;

  BaseProvider(this.context);

  bool get busy => _busy;

  showLoading([String msg]) {
    ExtDialog.loading(context, msg);
  }

  closeLoading() {
    ExtDialog.close(context);
  }

  showToast(String msg) {
    ExtDialog.toast(context, msg);
  }

  Future showDialog(Widget screen) {
    return Navigator.of(context).push(CupertinoPageRoute(builder: (_) => screen, fullscreenDialog: true));
  }

  alert(String msg, {String title, Function callback}) {
    ExtDialog.alert(context, msg, title).then((val) => callback(val) ?? null);
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
}
