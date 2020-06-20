import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoodsListViewModel extends BaseViewModel {
  /*
   * 思路是将父级的Page对象传到展示用的view里，然后view自己处理本页的列表项，对于单个列表元素实现不干扰其他同级的刷新.
   * 但是新建model对象会始终保留最初创建的一个（经测试其实是使用了同一个key），如果key不改变，新构建的viewModel对象
   * 初始化完成后，widget树还是会延用原来的viewModel对象，但是原viewModel对象的部分数据又被清空了，导致无法加载出正常数据.
   * 尝试改变key，但这让列表加载更多的时候，返回到顶部，因为这时的view已经完全全新
   * 目前调整方式为，列表的viewmodel不保存list数据，由外部静态维护，收藏的时候仅维护当前商品对象，这样也能实现仅刷新有变动的元素
   */

  GoodsListViewModel(BuildContext context) : super(context) {
    _goodsService = Provider.of<GoodsService>(context, listen: false);
  }

  GoodsService _goodsService;

  favorite(List<Goods> goodsList, int i) async {
    if (accountService.user == null) {
      super.pushNamed(LOGIN_ROUTE);
    } else {
      if (!super.busy) {
        super.setBusy();
        var process;
        int diff = 0;
        Goods goods = goodsList[i].clone();
        bool isCollection = goods.hasCollection(accountService.user['userid']);
        if (isCollection) {
          process = _goodsService.unfavorite(userId, goods.productId);
          diff = -1;
        } else {
          process = _goodsService.favorite(userId, goods.productId);
          diff = 1;
        }
        ExtResult res = await super.processing(process, showLoading: false, showToast: false);
        if (res.code == 0) {
          goods.collectionFlag = isCollection ? 0 : 1;
          goods.collections += isCollection ? -1 : 1;
          goodsList[i] = goods;
          goods.faceUserId = userId;
          this.currentUser['favoriteTotal'] += diff;
          notifyListeners();
        }
        super.setBusy();
      }
    }
  }

  toDetail(List<Goods> goodsList, int i) async {
    var goods = await super.pushNamed(DETAIL_ROUTE, arguments: goodsList[i]);
    if (goods != null && goods is Goods) {
      goodsList[i] = goods;
      notifyListeners();
    }
    print('router return goods $goods');
  }
}
