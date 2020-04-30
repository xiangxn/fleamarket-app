import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/view_models/mine_focus_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/user_card_group.dart';
import 'package:flutter/material.dart';

class MineFocus extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<MineFocusViewModel>(
      model: MineFocusViewModel(context),
      builder: (_, model, loading){
        print("...............");
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(model.locale.translation('title.mine_focus')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: UserCardGroup(
            refresh: model.fetchFocus
          )
        );
      },
    );
  }
}