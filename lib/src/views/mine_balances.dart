import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/mine_balances_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/line_button_group.dart';
import 'package:fleamarket/src/widgets/line_button_item.dart';
import 'package:flutter/material.dart';

class MineBalances extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<MineBalancesViewModel>(
      model: MineBalancesViewModel(context),
      builder: (_, model, __){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('title.mine_balances')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: LineButtonGroup(
            children: model.assets.map((asset) => LineButtonItem(
              text: asset.split(' ')[1],
              subText: asset.split(' ')[0],
            )).toList()
          ),
        );
      },
    );
  }
}