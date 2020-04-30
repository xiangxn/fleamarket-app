import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/view_models/mine_invite_view_model.dart';
import 'package:fleamarket/src/widgets/user_card_group.dart';
import 'package:flutter/material.dart';

import 'base_view.dart';

class MineInvite extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<MineInviteViewModel>(
      model: MineInviteViewModel(context),
      builder: (_, model, loading){
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(model.locale.translation('title.mine_invite')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: UserCardGroup(
            refresh: model.fetchInvite
          )
        );
      },
    );
  }

}