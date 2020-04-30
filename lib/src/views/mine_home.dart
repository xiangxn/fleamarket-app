import 'dart:ui';
import 'package:fleamarket/src/common/style.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/view_models/mine_home_view_model.dart';
import 'package:fleamarket/src/views/base_view.dart';
import 'package:fleamarket/src/views/goods_list.dart';
import 'package:fleamarket/src/widgets/custom_button.dart';
import 'package:fleamarket/src/widgets/ext_circle_avatar.dart';
import 'package:fleamarket/src/widgets/extended_nested_scroll_view.dart';
import 'package:fleamarket/src/widgets/nested_scroll_view_inner_scroll_position_key_widget.dart';
import 'package:fleamarket/src/widgets/user_card_group.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MineHome extends StatelessWidget{
  MineHome({
    Key key,
    this.user
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return BaseView<MineHomeViewModel>(
      listen: true,
      model: MineHomeViewModel(context, user),
      builder: (_, model, loading){
        ExtLocale locale = model.locale;
        return Scaffold(
          body: model.busy ? loading :
          NestedScrollView(
            innerScrollPositionKeyBuilder: model.tabKeyBuilder,
            headerSliverBuilder: (_, flag){
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 180, // 经测试 header 和 tabbar高度为90，expandedHeight多出来的为中间内容(可隐藏)高度
                  pinned: true,
                  floating: false,
                  snap: false,
                  centerTitle: true,
                  title: Text(model.curUser.nickname),
                  backgroundColor: Style.headerBackgroundColor,
                  brightness: Brightness.light,
                  textTheme: Style.headerTextTheme,
                  iconTheme: Style.headerIconTheme,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: <Widget>[
                        Positioned.fill(
                          child: Image(
                            image: NetworkImage(model.curUser.head),
                            fit: BoxFit.cover,
                          )
                        ),
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 5, 
                              sigmaY: 5
                            ),
                            child: Container(
                              color: Colors.white.withOpacity(0.5),
                            ),
                          )
                        ),
                        Positioned(
                          top: 60,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                ExtCircleAvatar(model.curUser.head, 60, strokeWidth: 0),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(bottom: 8),
                                          child: Text(locale.translation('combo_text.user_score', ['${model.curUser.creditValue ?? 0}']),
                                            style: TextStyle(
                                              fontSize: 13
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Icon(
                                              model.curUser.isReviewer == 0 ? 
                                                FontAwesomeIcons.solidUser :
                                                FontAwesomeIcons.userTie ,
                                              color: Colors.grey[700],
                                              size: 16,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10),
                                              child: Text(
                                                model.curUser.isReviewer == 0 ? 
                                                  locale.translation('personal.user_normal') :
                                                  locale.translation('personal.user_reviewer') ,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[900]
                                                )
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                CustomButton(
                                  onTap: model.focusUser,
                                  text: locale.translation('controller.focus'),
                                )
                              ],
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    controller: model.controller,
                    unselectedLabelColor: Colors.grey[700],
                    labelColor: Colors.black,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                    tabs: model.tabs.map((t) => Tab(text: t)).toList()
                  ),
                ),
              ];
            },
            body: MediaQuery.removePadding(
              removeTop: true,
              context: context, 
              child: TabBarView(
                controller: model.controller,
                children: <Widget>[
                  NestedScrollViewInnerScrollPositionKeyWidget(
                    model.tabKeys[0],
                    GoodsList(
                      goodsPage: model.goodsPage,
                      refresh: model.fetchGoodsPage,
                    )
                  ),
                  NestedScrollViewInnerScrollPositionKeyWidget(
                    model.tabKeys[1],
                    UserCardGroup(
                      refresh: model.refreshFocus,
                    )
                  ),
                  NestedScrollViewInnerScrollPositionKeyWidget(
                    model.tabKeys[2],
                    UserCardGroup(
                      refresh: model.refreshFans,
                    )
                  ),
                ],
              )
            ),
          )
        );
      },
    );
  }
}