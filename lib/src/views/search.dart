import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/view_models/search_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:flutter/material.dart';
import 'package:fleamarket/src/widgets/search_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'goods_list.dart';

class Search extends StatelessWidget{

  Widget _buildChild(SearchViewModel model, Widget loading){
    if(model.firstShow || model.hasFocus || model.search.isEmpty){
      return _history(model);
    }else{
      return _goodsList(model, loading);
    }
  }

  Widget _history(SearchViewModel model){
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(model.locale.translation('search.history')),
          trailing: IconButton(
            icon: Icon(FontAwesomeIcons.trashAlt, size: 18),
            onPressed: model.clearHistory,
          ),
        ),
        Expanded(
          child: ListView.separated(
            physics: ClampingScrollPhysics(),
            separatorBuilder: (_, i) => Divider(color:Colors.grey[300], indent: 16, endIndent: 16),
            itemCount: model.history.length,
            itemBuilder: (_, i){
              return ListTile(
                dense: true,
                title: Text(
                  model.history[i],
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15
                  ),
                ),
                onTap: () => model.onSearchSubmit(model.history[i]),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _goodsList(SearchViewModel model, Widget loading){
    if(model.busy){
      return loading;
    }else if(model.goodsPage.data.isEmpty){
      return Center(
        child: Text(model.locale.translation('search.no_data')),
      );
    }else{
      return GoodsList(goodsPage: model.goodsPage, refresh: model.fetchGoodsList);
    }
  }

  Widget build(BuildContext context){
    return BaseView<SearchViewModel>(
      listen: true,
      model: SearchViewModel(context),
      builder: (_, model, loading){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            titleSpacing: 2,
            title: SearchWidget(
              isBtn: false,
              onFocus: model.onSearchFocus,
              onSubmit: model.onSearchSubmit,
              controller: model.controller,
            ),
            backgroundColor: Style.backgroundColor,
            elevation: 0,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
            automaticallyImplyLeading: false,
            actions: <Widget>[
              SizedBox(
                width: 60,
                child: FlatButton(
                  onPressed: model.onBack,
                  child: Text(locale.translation('search.cancel')),
                ),
              )
            ],
          ),
          body: GestureDetector(
            onTap: model.unfocus,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 150),
              child: _buildChild(model, loading),
              transitionBuilder: (Widget child, Animation<double> animation){
                return FadeTransition(
                  opacity: animation, 
                  child: child
                );
              },
            ),
          )
        );
      }
    );
  }
}