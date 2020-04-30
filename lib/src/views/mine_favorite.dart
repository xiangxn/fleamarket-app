import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/mine_favorite_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/views/goods_list.dart';
import 'package:flutter/material.dart';

class MineFavorite extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BaseView<MineFavoriteViewModel>(
      listen: true,
      model: MineFavoriteViewModel(context),
      builder: (_, model, loading){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('title.mine_favorite')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: model.busy ? loading :
          GoodsList(
            goodsPage: model.page,
            refresh: model.fetchFavorite,
          )
        );
      },
    );
  }
}