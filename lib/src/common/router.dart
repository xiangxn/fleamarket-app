import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/views/about.dart';
import 'package:fleamarket/src/views/audit_goods.dart';
import 'package:fleamarket/src/views/detail.dart';
import 'package:fleamarket/src/views/edit_address.dart';
import 'package:fleamarket/src/views/edit_withdrawal.dart';
import 'package:fleamarket/src/views/home.dart';
import 'package:fleamarket/src/views/login.dart';
import 'package:fleamarket/src/views/logistics.dart';
import 'package:fleamarket/src/views/mine_address.dart';
import 'package:fleamarket/src/views/mine_balances.dart';
import 'package:fleamarket/src/views/mine_buy.dart';
import 'package:fleamarket/src/views/mine_fans.dart';
import 'package:fleamarket/src/views/mine_favorite.dart';
import 'package:fleamarket/src/views/mine_focus.dart';
import 'package:fleamarket/src/views/mine_home.dart';
import 'package:fleamarket/src/views/mine_invite.dart';
import 'package:fleamarket/src/views/mine_keys.dart';
import 'package:fleamarket/src/views/mine_publish.dart';
import 'package:fleamarket/src/views/mine_sell.dart';
import 'package:fleamarket/src/views/mine_vote.dart';
import 'package:fleamarket/src/views/mine_withdrawal.dart';
import 'package:fleamarket/src/views/order_detail.dart';
import 'package:fleamarket/src/views/pre_order.dart';
import 'package:fleamarket/src/views/publish.dart';
import 'package:fleamarket/src/views/search.dart';
import 'package:fleamarket/src/views/try_reviewer.dart';
import 'package:fleamarket/src/views/user_edit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Router{
  static Route<dynamic> generatorRoute(RouteSettings settings){
    print('进入路由 ${settings.name}');
    print('路由参数 ${settings.arguments}');
    return CupertinoPageRoute(
      settings: settings,
      builder: (context){
        switch (settings.name){
          case HOME_ROUTE:
            return Home();
          case SEARCH_ROUTE:
            return Search();
          case PUBLISH_ROUTE:
            return Publish(goods: settings.arguments);
          case DETAIL_ROUTE:
            return Detail(goods: settings.arguments);
          case LOGIN_ROUTE:
            return Login();
          case MINE_HOME_ROUTE:
            return MineHome(user: settings.arguments);
          case USER_EDIT_ROUTE:
            return UserEdit();
          case MINE_FAVORITE_ROUTE:
            return MineFavorite();
          case MINE_FOCUS_ROUTE:
            return MineFocus();
          case MINE_FANS_ROUTE:
            return MineFans();
          case MINE_PUBLISH_ROUTE:
            return MinePublish();
          case MINE_BUY_ROUTE:
            return MineBuy();
          case MINE_SELL_ROUTE:
            return MineSell();
          case MINE_INVITE_ROUTE:
            return MineInvite();
          case MINE_BALANCES_ROUTE:
            return MineBalances();
          case MINE_KEYS_ROUTE:
            return MineKeys();
          case MINE_ADDRESS_ROUTE:
            return MineAddress();
          case EDIT_ADDRESS_ROUTE:
            return EditAddress(address: settings.arguments);
          case MINE_WITHDRAWAL_ROUTE:
            return MineWithdrawal();
          case EDIT_WITHDRAWAL_ROUTE:
            return EditWithdrawal(withdrawal: settings.arguments);
          case MINE_VOTE_ROUTE:
            return MineVote();
          case TRY_REVIEWER_ROUTE:
            return TryReviewer();
          case AUDIT_GOODS_ROUTE:
            return AuditGoods();
          case PRE_ORDER_ROUTE:
            return PreOrder(goods: settings.arguments);
          case ORDER_DETAIL_ROUTE:
            return OrderDetail(order: settings.arguments);
          case LOGISTICS_ROUTE:
            return Logistics();
          case ABOUT_ROUTE:
            return About();
          default:
            return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: Text('unknown route ${settings.name}'),
              ),
            );
        }
      }
    );
  }  
}