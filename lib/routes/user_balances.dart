import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/common/funs.dart';
import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/routes/base.dart';
import 'package:bitsflea/states/base.dart';
import 'package:bitsflea/states/theme.dart';
import 'package:bitsflea/states/user.dart';
import 'package:bitsflea/widgets/confirm_password.dart';
import 'package:bitsflea/widgets/input_single_string.dart';
import 'package:bitsflea/widgets/line_button_group.dart';
import 'package:bitsflea/widgets/line_button_item.dart';
import 'package:eosdart/eosdart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserBalancesRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseRoute<UserBalancesProvider>(
      listen: true,
      provider: UserBalancesProvider(context),
      builder: (_, provider, loading) {
        final style = Provider.of<ThemeModel>(context, listen: false).theme;
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
                                  onTap: () => provider.withdraw(asset),
                                  text: asset.currency,
                                  subText: formatPrice3(asset.amount),
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

  Future<void> withdraw(Holding asset) async {
    if (asset.amount <= 0) return;
    bool withdrawable = COIN_WITHDRAWABLE.any((element) => element == asset.currency);
    if (withdrawable == false) {
      this.showToast(this.translate("user_balances.msg_no_withdraw"));
      return;
    }
    final amountInput = await showModalBottomSheet(
        context: context,
        builder: (_) => InputSingleString(
              errorMessage: this.translate("user_balances.msg_no_empty"),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              hintText: this.translate("user_balances.hint_input", translationParams: {'amount': "${asset.amount}", 'symbol': asset.currency}),
            ));
    if (amountInput != null) {
      final amount = double.tryParse(amountInput);
      if (amount == null || amount > asset.amount || amount < 0) {
        this.showToast(this.translate("user_balances.msg_input_amount"));
        return;
      } else {
        final auth = await showModalBottomSheet(context: context, builder: (_) => ConfirmPassword());
        if (auth != null) {
          showLoading();
          final um = this.getUserInfo();
          final result = await api.getWithdrawAddr(um.user.userid);
          if (result != null) {
            final data = convertList(result.data, "withdrawAddr", OtherAddr());
            final otherAddr = data.firstWhere((element) => element.coinType.split(",")[1] == asset.currency, orElse: () => null);
            if (otherAddr != null) {
              final toAsset = Holding.fromJson("$amount ${asset.currency}");
              BaseReply payResult;
              bool isIBC = COIN_CROSS_CHAIN.any((element) => element == asset.currency);
              if (isIBC) {
                payResult = await api.transfer(um.keys[1], um.user.eosid, Global.config.bosIBCContract, toAsset, "${otherAddr.addr}@eos withdraw coin",
                    contract: Global.config.bosIBCContract);
              } else {
                payResult = await api.transfer(um.keys[1], um.user.eosid, Global.config.mainContract, toAsset, "w:");
              }
              closeLoading();
              if (payResult.code == 0) {
                this.showToast(this.translate("user_balances.msg_withdraw_ok"));
                notifyListeners();
              } else {
                this.showToast(getErrorMessage(payResult.msg));
              }
              return;
            }
          }
          closeLoading();
          this.showToast(this.translate("user_balances.msg_no_bind_addr", translationParams: {'symbol': asset.currency}));
        }
      }
    }
  }
}
