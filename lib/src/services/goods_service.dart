import 'package:fleamarket/src/common/result_conversion.dart';
import 'package:fleamarket/src/models/category.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/services/api.dart';

class GoodsService{
  Api _api;

  List<Category> _categories = [];
  List<dynamic> _symbols ;

  List<Category> get categories => _categories;
  List<dynamic> get symbols => _symbols;

  GoodsService(Api api){
    _api = api;
    _symbols = [
      {'key': 'BOS', 'value': 'BOS' },
      {'key': 'EOS', 'value': 'EOS' },
      {'key': 'BTS', 'value': 'BTS' },
      {'key': 'BTC', 'value': 'BTC' },
    ];
    print('goods service init ');
  }

  Future<ExtResult> fetchCategories() async {
    ExtResult res = await _api.fetchCategorier();
    if(res.code == 0){
      res.data = (res.data as List<dynamic>).map((c) => Category.fromJson(c)).toList();
      _categories = res.data;
    }
    return res;
  }

  Future<ExtResult> fetchGoodsList(int userid, int categoryId, int pageNo, int pageSize) async {
    ExtResult res = await _api.fetchGoodsList(userid, categoryId, pageNo, pageSize);
    return ResultConversion.excute(res, ResultTypes.GoodsPage);
  }

  Future<ExtResult> fetchGoodsInfo(int productId, int userid) async {
    ExtResult res = await _api.fetchGoodsInfo(productId, userid);
    return ResultConversion.excute(res, ResultTypes.Goods);
  }

  Future<ExtResult> favorite(int userid, int productId){
    return _api.favorite(userid, productId);
  }

  Future<ExtResult> unfavorite(int userid, int productId){
    return _api.unfavorite(userid, productId);
  }

  Future<ExtResult> fetchFavorite(int userid, int pageNo, int pageSize) async {
    ExtResult res = await _api.fetchCollectionByUser(userid, pageNo, pageSize);
    return ResultConversion.excute(res, ResultTypes.GoodsPage);
  }

  Future<ExtResult> fetchPublish(int userid, int pageNo, int pageSize) async {
    ExtResult res = await _api.fetchPublishByUser(userid, pageNo, pageSize);
    return ResultConversion.excute(res, ResultTypes.GoodsPage);
  }

}