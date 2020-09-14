import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserBalancesRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseRoute<UserBalancesProvider>(
      provider: UserBalancesProvider(context),
      builder: (_, provider, loading) {
        final style = Provider.of<ThemeModel>(context).theme;
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(provider.translate('user_balances.title')),
              backgroundColor: style.headerBackgroundColor,
              brightness: Brightness.light,
              textTheme: style.headerTextTheme,
              iconTheme: style.headerIconTheme,
            ),
            body: FutureBuilder(
                future: provider.getUserBalances(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return LineButtonGroup(
                        children: provider.assets
                            .map((asset) => LineButtonItem(
                                  text: formatPrice3(asset.amount),
                                  subText: asset.currency,
                                ))
                            .toList());
                  }
                  return loading;
                }));
      },
    );
  }
}

class UserBalancesProvider extends BaseProvider {
  UserBalancesProvider(BuildContext context) : super(context);

  List<Holding> _assets = [];
  List<Holding> get assets => _assets;

  Future<void> getUserBalances() async {
    final user = Provider.of<UserModel>(context, listen: false).user;
    if (user != null) {
      _assets = await api.getUserBalances(user.eosid);
    }
  }
}
