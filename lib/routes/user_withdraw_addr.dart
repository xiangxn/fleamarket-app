import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserWithdrawAddrRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseRoute<UserWithdrawAddrProvider>(
      // listen: true,
      provider: UserWithdrawAddrProvider(context),
      builder: (_, provider, loading) {
        final style = Provider.of<ThemeModel>(context).theme;
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('user_withdraw_addr.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: FutureBuilder(
              future: provider.getCoins(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return LineButtonGroup(
                      children: provider.list.keys.map((key) {
                    return Selector<UserWithdrawAddrProvider, OtherAddr>(
                      selector: (_, __) => provider.list[key],
                      builder: (_, oa, __) {
                        return LineButtonItem(
                          text: key.split(",")[1],
                          subText: provider.list[key]?.addr,
                          onTap: () {
                            OtherAddr oa = provider.list[key]?.clone() ?? OtherAddr();
                            oa.coinType = key;
                            provider.toEdit(oa);
                          },
                        );
                      },
                    );
                  }).toList());
                }
                return loading;
              },
            ));
      },
    );
  }
}

class UserWithdrawAddrProvider extends BaseProvider {
  UserWithdrawAddrProvider(BuildContext context) : super(context);

  Map<String, OtherAddr> _list = {};
  Map<String, OtherAddr> get list => _list;

  toEdit(OtherAddr coin) async {
    final res = await pushNamed(ROUTE_EDIT_WITHDRAWADDR, arguments: coin);
    if (res != null) {
      OtherAddr c = (res as OtherAddr);
      _list[c.coinType] = c;
      notifyListeners();
    }
  }

  Future<void> getCoins() async {
    final user = Provider.of<UserModel>(context, listen: false).user;
    final coins = await api.getCoins();
    coins.forEach((e) {
      // String sym = e["sym"].toString().split(",")[1];
      if (e["sym"] == "4,CNY" && TAG_SHOW_CNY == false) return;
      if (e["is_out"] == 1) {
        _list[e["sym"]] = null;
      }
    });
    final res = await api.getCoinAddrs(user.userid);
    if (res.code == 0) {
      var data = convertList(res.data, "withdrawAddr", OtherAddr());
      data.forEach((e) {
        if (_list.containsKey(e.coinType)) _list[e.coinType] = e.clone();
      });
    }
  }
}
