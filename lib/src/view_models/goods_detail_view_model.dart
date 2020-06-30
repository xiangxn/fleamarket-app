import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoodsDetailViewModel extends BaseViewModel{
  GoodsDetailViewModel(BuildContext context, Goods goods) : super(context){
    _goodsService = Provider.of<GoodsService>(context, listen: false);
    _goods = goods;
    /// 因为实现了addScopedWillPopCallback，所以详情页面无法滑动返回
    /// 实现回退监听主要目的是页面返回时，更新列表上的对象，如果用户在详情里点了收藏，那么列表也应该展示最新的数据，而不用去拉取服务
    /// 与获取路由方式相同，以这样的方式添加pop监听，会导致回退的时候view重新build，所以采用在view里嵌套WillPopScope来实现
    // _route = ModalRoute.of(context);
    // _route.addScopedWillPopCallback(onBack);
    fetchGoodsInfo();
    checkFocus();
  }

  GoodsService _goodsService;
  Goods _goods;
  bool _hasFocus;

  Goods get goods => _goods;
  bool get hasFocus => _hasFocus;

  favorite() async {
    if(!super.busy){
      super.setBusy();
      var process ;
      if(_goods.hasCollection(userId)){
        process = _goodsService.unfavorite(userId, _goods.productId);
      }else{
        process = _goodsService.favorite(userId, _goods.productId);
      }
      ExtResult res = await super.processing(process, showLoading: false, showToast: false);
      if(res.code == 0){
        _goods.collectionFlag = _goods.hasCollection(userId) ? 0 : 1;
        _goods.collections += _goods.hasCollection(userId) ? 1 : -1;
        notifyListeners();
      }
      super.setBusy();
    }
  }

  focus() async {
    if(!super.busy){
      super.setBusy();
      var process ;
      if(_hasFocus){
        process = accountService.unFollow(userId, _goods.seller.userid);
      }else{
        process = accountService.follow(userId, _goods.seller.userid);
      }
      ExtResult res = await super.processing(process, showLoading: false, showToast: false);
      if(res.code == 0){
        _hasFocus = !_hasFocus;
        notifyListeners();
      }
      super.setBusy();
    }
  }

  fetchGoodsInfo() async {
    var process = _goodsService.fetchGoodsInfo(_goods.productId, userId);
    ExtResult res = await super.processing(process, showLoading: false);
    if(res.code == 0){
      _goods = _goods.merge(res.data);
      notifyListeners();
    }
  }

  checkFocus(){
    //TODO: 从服务端验证是否已关注
    _hasFocus = false;
  }

  Future<bool> onBack(){
    super.pop(_goods);
    return Future.value(false);
  }

  toPreOrder(){
    super.pushNamed(PRE_ORDER_ROUTE, arguments: _goods);
  }

  @override
  void dispose() {
    super.dispose();
  }

}