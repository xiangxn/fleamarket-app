import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class MinePublishViewModel extends BaseViewModel {
  MinePublishViewModel(BuildContext context) : super(context) {
    _goodsService = Provider.of(context, listen: false);
    _page = ExtPage<Goods>();
    fetchPublish();
  }

  GoodsService _goodsService;
  ExtPage<Goods> _page;

  ExtPage<Goods> get page => _page;

  Future<void> fetchPublish({bool isRefresh = false}) async {
    super.setBusy();
    if (isRefresh) {
      _page.clean();
    }
    var process = _goodsService.fetchPublish(userId, _page.pageNo, _page.pageSize);
    final res = await super.processing(process, showLoading: false);
    if (res.code == 0) {
      var data = Utils.convertPageList<Goods>(res.data, new Goods(), "productByPublisher");
      _page = data.update(_page.data);
      print('---- ${_page.data.length}');
    }
    super.setBusy();
    notifyListeners();
  }

  toEdit(Goods goods) async {
    var res = await super.pushNamed(PUBLISH_ROUTE, arguments: goods);
    print('编辑完成 ${res.runtimeType}');
  }
}
