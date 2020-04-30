import 'dart:async';

import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/services/account_service.dart';
import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class MineHomeViewModel extends BaseViewModel implements TickerProvider{
  MineHomeViewModel(BuildContext context, User user) : super(context){
    _accountService = Provider.of<AccountService>(context, listen: false);
    _goodsService = Provider.of<GoodsService>(context, listen: false);
    _tabs = [
      super.locale.translation('title.other_publish'),
      super.locale.translation('title.other_focus'),
      super.locale.translation('title.other_fans')
    ];
    _controller = TabController(length: _tabs.length, vsync: this);
    // _controller.addListener((){
    //   for (int i = 0; i < tabKeys.length; i++) {
    //     GlobalKey<PrimaryScrollContainerState> key = tabKeys[i];
    //     if (key.currentState != null) {
    //       key.currentState.onPageChange(_controller.index == i);//控制是否当前显示
    //     }
    //   }
    // });
    init(isInit: true, user: user);

  }

  AccountService _accountService;
  GoodsService _goodsService;
  User _user;
  List<String> _tabs;
  TabController _controller ;
  ExtPage<Goods> _goodsPage ;
  ExtPage<User> _focusPage ;
  ExtPage<User> _fansPage ;

  User get curUser => _user;
  List<String> get tabs => _tabs;
  TabController get controller => _controller;
  ExtPage<Goods> get goodsPage => _goodsPage;
  ExtPage<User> get focusPage => _focusPage;
  ExtPage<User> get fansPage => _fansPage;

  List<Key> tabKeys = [
    Key('ExtTab0'),
    Key('ExtTab1'),
    Key('ExtTab2')
  ];

  Key tabKeyBuilder(){
    return Key('ExtTab${_controller.index}');
  }

  Future<void> fetchUser({bool notify = true}) async {
    var process =  _accountService.fetchUser(_user.userid);
    ExtResult res = await super.processing(process, showLoading: false);
    if(res.code == 0){
      _user = res.data;
      if(notify){
        notifyListeners();
      }
    }
    return ;
  }

  fetchGoodsPage({ExtPage<Goods> page, bool isRefresh = false, bool notify = true}) async {
    _goodsPage ??= ExtPage<Goods>();
    if(isRefresh){
      _goodsPage.clean();
    }
    var process = _goodsService.fetchPublish(_user.userid, _goodsPage.pageNo, _goodsPage.pageSize);
    ExtResult res = await super.processing(process, showLoading: false);
    if(res.code == 0){
      _goodsPage = res.data..update(_goodsPage.data);
      if(notify){
        notifyListeners();
      }
    }
  }

  fetchFocus({bool notify = true}) async {
    _focusPage ??= ExtPage<User>();
    var process = refreshFocus(pageNo: _focusPage.pageNo, pageSize: _focusPage.pageSize);
    ExtResult res = await super.processing(process, showLoading: false);
    if(res.code == 0){
      _focusPage = res.data..update(_focusPage.data);
      if(notify){
        notifyListeners();
      }
    }
  }

  fetchFans({bool notify = true}) async {
    _fansPage ??= ExtPage<User>();
    var process = refreshFans(pageNo: _fansPage.pageNo, pageSize: _fansPage.pageSize);
    ExtResult res = await super.processing(process, showLoading: false);
    if(res.code == 0){
      _fansPage = res.data..update(_fansPage.data);
      if(notify){
        notifyListeners();
      }
    }
  }

  Future<ExtResult> refreshFocus({int pageNo, int pageSize}) {
    return _accountService.fetchFocus(_user.userid, pageNo, pageSize);
  }

  Future<ExtResult> refreshFans({int pageNo, int pageSize}) {
    return _accountService.fetchFans(_user.userid, pageNo, pageSize);
  }

  init({bool isInit = false, User user}) async {
    super.setBusy();
    if(isInit){
      _user = user;
      // _user ??= User();
      // _user.userid = userid;
    }
    await fetchUser(notify: false);
    await fetchGoodsPage(notify: false);
    // await fetchFocus(notify: false);
    // await fetchFans(notify: false);
    super.setBusy();
    notifyListeners();
  }

  focusUser(){

  }

  @override
  Ticker createTicker(onTick) {
    return Ticker(onTick);
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

}