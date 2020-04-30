import 'dart:math';

import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/view_models/mine_publish_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/widgets/custom_refresh_indicator.dart';
import 'package:fleamarket/src/widgets/ext_network_image.dart';
import 'package:flutter/material.dart';

class MinePublish extends StatelessWidget{

  Widget _buildStatus(ExtLocale locale, int status){
    status = Random.secure().nextInt(4);
    Color color = Colors.black;
    
    if(status == 0){
      color = Colors.green;
    }else if(status == 1){
      color = Colors.orange;
    }else if(status == 2){
      color = Colors.red;
    }else if(status == 3){
      color = Colors.grey;
    }
    return Text(locale.translation('goods_type.$status'), 
      style: TextStyle(color: color)
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<MinePublishViewModel>(
      listen: true,
      model: MinePublishViewModel(context),
      builder: (_, model, loading){
        ExtLocale locale = model.locale;
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(locale.translation('title.mine_publish')),
            backgroundColor: Style.headerBackgroundColor,
            brightness: Brightness.light,
            textTheme: Style.headerTextTheme,
            iconTheme: Style.headerIconTheme,
          ),
          body: model.busy ? loading : CustomRefreshIndicator(
            onRefresh: () => model.fetchPublish(isRefresh: true),
            onLoad: model.page.hasMore() ? model.fetchPublish : null,
            child: ListView.builder(
              physics: ClampingScrollPhysics(),
              itemCount: model.page.data.length,
              itemBuilder: (_, i){
                Goods goods = model.page.data[i];
                return InkWell(
                  onTap:() => model.toEdit(goods),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: SizedBox(
                                      width: 70,
                                      height: 70,
                                      child: ExtNetworkImage(goods.img, 
                                        imageBuilder: (_, imageProvider){
                                          return ClipRRect(
                                            borderRadius: BorderRadius.circular(4),
                                            child: Image(
                                              image: imageProvider,
                                              width: 70,
                                              height: 70,
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        }
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(goods.title),
                                      Text(locale.translation('combo_text.price', [goods.price]), style: Style.smallFont),
                                      Text(locale.translation('combo_text.postage', [goods.postage ?? '0.0000 BOS']), style: Style.smallFont),
                                      Text(locale.translation('combo_text.favorite_count', [(goods.collections ?? 0).toString()]), 
                                        style: Style.smallFont,
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            _buildStatus(locale, goods.status)
                          ],
                        ),
                      )
                    ),
                  )
                );
              }
            ), 
          ),
        );
      },
    );
  }
}