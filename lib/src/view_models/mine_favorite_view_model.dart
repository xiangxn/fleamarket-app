import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MineFavoriteViewModel extends BaseViewModel {
  MineFavoriteViewModel(BuildContext context) : super(context) {
    _goodsService = Provider.of<GoodsService>(context, listen: false);
    _page = ExtPage<Goods>();
    fetchFavorite();
  }

  GoodsService _goodsService;
  ExtPage<Goods> _page;

  ExtPage<Goods> get page => _page;

  fetchFavorite({ExtPage<Goods> page, bool isRefresh = false}) async {
    if (isRefresh) {
      _page.clean();
    }
    super.setBusy();
    var process = _goodsService.fetchFavorite(userId, _page.pageNo, _page.pageSize);
    final res = await super.processing(process, showLoading: false);
    if (res.code == 0) {
      var data = Utils.convertPageList<Goods>(res.data, new Goods(), "favoriteByUser");
      data.update(_page.data);
      _page = data;
    }
    super.setBusy();
    notifyListeners();
  }
}
