import 'dart:async';
import 'package:bitsflea/states/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:provider/provider.dart';

/// example:
///
/// ExtDialog.toast(context, 'toast message');
///
/// ExtDialog.alert(context, 'alert message).then((res){
///   on press ok return true
/// })
///
/// ExtDialog.confirm(context, 'confirm message').then((res){
///   on press ok return true
///   on press cancel return false
/// })
class ExtDialog {
  static TextStyle get _titleStyle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.grey[700],
      );

  static TextStyle get _msgStyle => TextStyle(fontSize: 15, color: Colors.grey[700]);

  static bool isShow = false;

  static Future<bool> _baseDialog(
      {@required BuildContext context,
      @required Widget content,
      double width = 350,
      bool barrierDismissible = true,
      bool autoDismissible = false,
      WidgetBuilder builder,
      Color bgColor}) async {
    bool res;
    if (!isShow) {
      isShow = true;
      res = await showGeneralDialog(
          context: context,
          barrierDismissible: autoDismissible ? false : barrierDismissible,
          barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
          barrierColor: Colors.black26,
          transitionDuration: const Duration(milliseconds: 150),
          transitionBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
            return ScaleTransition(
              scale: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondrayAnimation) {
            final Widget pageChild = Builder(builder: (BuildContext context) {
              if (autoDismissible) {
                Future.delayed(Duration(milliseconds: 2000), () => close(context));
              }
              return UnconstrainedBox(
                  constrainedAxis: Axis.vertical,
                  child: SizedBox(
                    width: width,
                    child: Dialog(
                      backgroundColor: bgColor ?? Colors.white,
                      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: content,
                      ),
                    ),
                  ));
            });
            return SafeArea(child: Builder(builder: (BuildContext context) {
              return pageChild;
            }));
          });
    }
    isShow = false;
    return res ?? false;
  }

  static Future<dynamic> _dialog(BuildContext context, String msg, String title, [int btnCount = 1]) {
    return _baseDialog(
        context: context,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title ?? FlutterI18n.translate(context, "dialog.title"), style: _titleStyle),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                msg,
                style: _msgStyle,
              ),
            ),
            Row(
                mainAxisAlignment: btnCount == 1 ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: List.generate(btnCount, (inx) => inx).map((i) {
                  bool isFirst = i == 0;
                  return FlatButton(
                    onPressed: () => Navigator.of(context).pop(isFirst),
                    child: Text(isFirst ? FlutterI18n.translate(context, "dialog.ok") : FlutterI18n.translate(context, "dialog.cancel"),
                        style: TextStyle(color: isFirst ? Colors.green : Colors.grey[800])),
                  );
                }).toList())
          ],
        ));
  }

  static Future<dynamic> alert(BuildContext context, String msg, [String title]) {
    return _dialog(context, msg, title);
  }

  static Future<dynamic> confirm(BuildContext context, String msg, [String title]) {
    return _dialog(context, msg, title, 2);
  }

  static void toast(BuildContext context, String msg) {
    final style = Provider.of<ThemeModel>(context, listen: false).theme;
    _baseDialog(
        context: context,
        autoDismissible: true,
        bgColor: style.primarySwatch,
        content: Text(msg, textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white)));
  }

  static void loading(BuildContext context, [String loadMsg]) {
    _baseDialog(
        context: context,
        barrierDismissible: false,
        width: 240,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            Padding(
              padding: const EdgeInsets.only(top: 26.0),
              child: Text(
                loadMsg ?? FlutterI18n.translate(context, "dialog.loading"),
                style: _msgStyle,
              ),
            )
          ],
        ));
  }

  static void close(BuildContext context, [dynamic param]) {
    isShow = false;
    Navigator.of(context).pop(param);
  }
}
