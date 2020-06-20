import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/ext_page.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/goods.dart';
import 'package:fleamarket/src/services/goods_service.dart';
import 'package:fleamarket/src/view_models/base_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchViewModel extends BaseViewModel{
  SearchViewModel(BuildContext context) : super(context){
    _goodsService = Provider.of<GoodsService>(context);
    _history = Utils.prefs.getStringList(SEARCH_HISTORY) ?? [];
    _goodsPage = ExtPage<Goods>();
    _controller = TextEditingController();
  }

  GoodsService _goodsService;
  List<String> _history;
  ExtPage<Goods> _goodsPage;
  bool _hasFocus = false;
  bool _firstShow = true;
  TextEditingController _controller;

  ExtPage<Goods> get goodsPage => _goodsPage;
  List<String> get history => _history;
  bool get hasFocus => _hasFocus;
  bool get firstShow => _firstShow;
  String get search => _controller.text;
  TextEditingController get controller => _controller;


  onSearchFocus(bool hasFocus){
    switchFirst();
    _hasFocus = hasFocus;
    notifyListeners();
  }

  onSearchSubmit(String val) async {
    switchFirst();
    unfocus();
    _controller.text = val ?? '';
    if(search.isNotEmpty){
      if(!_history.contains(search)){
        _history.insert(0, search);
        Utils.setStore(SEARCH_HISTORY, _history);
      }
      super.setBusy();
      notifyListeners();
      await fetchGoodsList(notify: false);
      super.setBusy();
    }
    notifyListeners();
  }

  switchFirst(){
    if(_firstShow){
      _firstShow = false;
    }
  }

  onBack(){
    if(_hasFocus){
      _controller.text = '';
      unfocus();
    }else{
      super.pop();
    }
  }

  unfocus(){
    FocusScope.of(context).requestFocus(FocusNode());
  }

  clearHistory(){
    if(_history.isNotEmpty){
      _history.clear();
      Utils.clearStore(SEARCH_HISTORY);
      notifyListeners();
    }
  }

  fetchGoodsList({ExtPage<Goods> page, bool isRefresh = true, bool notify = true}) async {
    if(isRefresh){
      _goodsPage.clean();
    }else{
      _goodsPage.incres();
    }
    // TODO: 根据搜索条件查询商品列表
    var process = _goodsService.fetchGoodsList(userId, 0, _goodsPage.pageNo, _goodsPage.pageSize);
    ExtResult res = await super.processing(process, showLoading: false);
    if(res.code == 0){
      res.data.update(_goodsPage.data);
      _goodsPage = res.data;
      if(notify){
        notifyListeners();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
