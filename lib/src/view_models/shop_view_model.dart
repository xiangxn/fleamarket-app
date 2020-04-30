import 'package:fleamarket/src/models/category.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

class ShopViewModel extends BaseViewModel implements TickerProvider{
  GoodsService _goodsService ;
  List<Category> _categories ;
  List<ExtPage<Goods>> _list = [];
  TabController _tabController;
  
  List<Category> get categories => _categories;
  TabController get tabController => _tabController;

  ShopViewModel(BuildContext context) : super(context){
    _goodsService = Provider.of(context, listen: false);
    // _types = _goodsService.types;
    fetchCategorier();
    // fetchGoodsInfo();
    // fetchGoodsList(null);
  }

  fetchCategorier() async {
    print('fetch categories');
    var process = _goodsService.fetchCategories();
    ExtResult res = await super.processing(process, showLoading: false);
    if(res.code == 0 && res.data != null && res.data.length > 0){
      _categories = res.data;
      _list = List<ExtPage<Goods>>.generate(_categories.length, (i) => ExtPage<Goods>());
      _tabController = TabController(length: _categories.length, vsync: this);
      await Future.wait(_list.map((p) => fetchGoodsList(page: p, isRefresh: true, notify: false)));
      notifyListeners();
    }else if(res.code == -2){
      print('网络错误');
      /// 网络错误情况重试
      await Future.delayed(Duration(seconds: 6));
      fetchCategorier();
      print('重试');
    }
  }

  // fetchGoodsInfo(int productId) async {
  //   print('获取goods ');
  //   await Future.delayed(Duration(seconds: 3));
  //   var process = _goodsService.fetchGoodsInfo(productId, super.user?.userid ?? 0);
  //   ExtResult res = await super.processing(process);
  //   print('res.code ${res.code}');
  //   print('res.data ${res.data.owner.nickname}');
  // }

  fetchGoodsList({ExtPage<Goods> page, bool isRefresh = false, bool notify = true}) async {
    int inx = _list.indexOf(page);
    Category category = _categories[inx];
    if(isRefresh){
      page.clean();
    }else{
      page.incres();
    }
    var process = _goodsService.fetchGoodsList(super.user?.userid ?? 0, category.id, page.pageNo, page.pageSize);
    ExtResult res = await super.processing(process, showLoading: false, showToast: false);
    if(res.code == 0){
      res.data?.data?.forEach((g) => g.faceUserId = super.user?.userid ?? 0);
      res.data?.data?.forEach((g){
        print('goods face user id ${g.faceUserId}');
      });
      res.data.update(page.data);
      _list[inx] = res.data;
      if(notify){
        notifyListeners();
      }
    }
  }

  ExtPage getGoodsList(Category category){
    int inx = _categories.indexOf(category);
    return _list[inx];
  }

  // Goods findGoods(Category category, int i){
  //   int inx = _categories.indexOf(category);
  //   return _list[inx].data[i];
  // }

  // favorite(Goods goods) async {
  //   if(!super.busy){
  //     super.setBusy();
  //     Goods tmp = goods.clone();
  //     var process ;
  //     if(tmp.hasCollection()){
  //       process = _goodsService.unfavorite(super.user?.userid ?? 0, tmp.productId);
  //     }else{
  //       process = _goodsService.favorite(super.user?.userid ?? 0, tmp.productId);
  //     }
  //     ExtResult res = await super.processing(process, showLoading: false, showToast: false);
  //     if(res.code == 0){
  //       tmp.collectionFlag = tmp.hasCollection() ? 0 : 1;
  //       tmp.collections += tmp.hasCollection() ? 1 : -1;
  //       _list.forEach((list) {
  //         int inx = list.data.indexWhere((g) => g.id == goods.id);
  //         if(inx >= 0){
  //           list.data[inx] = tmp;
  //         }
  //       });
  //       notifyListeners();
  //     }
  //     super.setBusy();
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    _tabController?.dispose();
  }

  @override
  Ticker createTicker(onTick) {
    return Ticker(onTick);
  }
}