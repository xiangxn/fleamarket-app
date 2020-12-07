import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class UserEditWithdrawAddrRoute extends StatelessWidget {
  UserEditWithdrawAddrRoute({Key key, @required this.coin}) : super(key: key);
  final OtherAddr coin;

  String _getHint(UserEditWithdrawAddrProvider provider) {
    if (coin.coinType.split(",")[1] == "USDT") {
      return provider.translate('user_withdraw_addr.hint2');
    }
    return provider.translate('user_withdraw_addr.hint');
  }

  @override
  Widget build(BuildContext context) {
    return BaseRoute<UserEditWithdrawAddrProvider>(
      provider: UserEditWithdrawAddrProvider(context, coin),
      builder: (_, provider, __) {
        final style = Provider.of<ThemeModel>(context, listen: false).theme;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(provider.translate('user_withdraw_addr.edit_title')),
            backgroundColor: style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: style.headerTextTheme,
            iconTheme: style.headerIconTheme,
            actions: <Widget>[
              FlatButton(
                onPressed: provider.submit,
                child: Text(provider.translate('controller.complete')),
              )
            ],
          ),
          body: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        TextField(
                          autofocus: true,
                          enableSuggestions: false,
                          controller: provider.controller,
                          autocorrect: false,
                          maxLines: 8,
                          decoration: InputDecoration(
                              isDense: true, hintText: _getHint(provider), contentPadding: EdgeInsets.symmetric(vertical: 0), border: InputBorder.none),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: InkWell(
                              onTap: provider.paste,
                              child: Text(
                                provider.translate('controller.paste'),
                                style: TextStyle(color: Colors.green),
                              )),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(color: style.backgroundColor),
                  )
                ],
              )),
        );
      },
    );
  }
}

class UserEditWithdrawAddrProvider extends BaseProvider {
  OtherAddr _coin;
  UserEditWithdrawAddrProvider(BuildContext context, OtherAddr coin) : super(context) {
    _coin = coin;
    _controller.text = coin?.addr ?? '';
  }

  TextEditingController _controller = TextEditingController();
  TextEditingController get controller => _controller;

  paste() async {
    ClipboardData data = await Clipboard.getData('text/plain');
    _controller.text += data.text;
  }

  submit() async {
    final um = Provider.of<UserModel>(context, listen: false);
    _coin.addr = _controller.text;
    if (_coin.addr == null || _coin.addr.isEmpty) {
      this.showToast(translate("user_withdraw_addr.msg_not_empty"));
      return;
    }
    showLoading();
    final res = await api.setCoinAddr(um.keys[1], um.user.eosid, um.user.userid, _coin);
    closeLoading();
    if (res) {
      pop(_coin);
    } else {
      showToast(translate("user_withdraw_addr.set_error"));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }
}
