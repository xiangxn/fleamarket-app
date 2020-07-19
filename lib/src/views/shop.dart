import 'package:fleamarket/src/models/category.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/view_models/shop_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/views/goods_list.dart';
import 'package:fleamarket/src/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Shop extends StatelessWidget{

  final ShopViewModel model;

  Shop({
    Key key,
    @required this.model
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BaseView<ShopViewModel>(
      listen: false,
      model: model,
      builder: (_, model, child){
        return Selector<ShopViewModel, List<Category>>(
          selector: (_, provider) => provider.categories,
          builder: (_, categories, __){
            if(categories != null && categories.length > 0){
              return Column(
                children: <Widget>[
                  TabBar(
                    controller: model.tabController,
                    isScrollable: true,
                    indicatorColor: Colors.grey[700],
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorPadding: EdgeInsets.only(bottom: 10.0),
                    labelPadding: EdgeInsets.symmetric(horizontal: 10),
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: TextStyle(
                      fontSize: 14,
                    ),
                    labelColor: Colors.black,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    tabs: categories.map((c) => Tab(text: c.view)).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 8),
                    child: SearchWidget(isBtn: true),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: model.tabController,
                      children: categories.map((category) {
                        return Selector<ShopViewModel, ExtPage>(
                          selector: (_, provider) => provider.getGoodsList(category),
                          builder: (_, page, __){
                            return GoodsList(goodsPage: page, refresh: model.fetchGoodsList, category: category.id,);
                            // return WaterfallContainer(page: page, category: category, model: model);
                          },
                        );
                      }).toList(),
                    ),  
                  ),
                ]
              );
            }else{
              return child;
            }
          },
        );
      },
    );
  }
}