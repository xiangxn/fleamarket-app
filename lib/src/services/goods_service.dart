import 'dart:convert';

import 'package:fleamarket/src/common/data_api.dart';
import 'package:fleamarket/src/common/result_conversion.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/grpc/bitsflea.pb.dart';
import 'package:fleamarket/src/grpc/google/protobuf/wrappers.pb.dart';
import 'package:fleamarket/src/models/category.dart';
import 'package:fleamarket/src/models/ext_result.dart';

class GoodsService {
  DataApi _api;

  List<Category> _categories = [];
  List<dynamic> _symbols;

  List<Category> get categories => _categories;
  List<dynamic> get symbols => _symbols;

  GoodsService(DataApi api) {
    _api = api;
    _symbols = [
      {'key': 'BOS', 'value': 'BOS'},
      {'key': 'EOS', 'value': 'EOS'},
      {'key': 'BTS', 'value': 'BTS'},
      {'key': 'BTC', 'value': 'BTC'},
    ];
    print('goods service init ');
  }

  Future<BaseReply> fetchCategories() async {
    BaseReply res = await _api.fetchCategorier();
    if (res.code == 0) {
      final data = Utils.convertEdgeList(res.data, "categories");
      _categories = data.map((c) => Category.fromJson(c['node'])).toList();
    }
    return res;
  }

  Future<BaseReply> fetchGoodsList(int userid, int categoryId, int pageNo, int pageSize) async {
    return await _api.fetchGoodsList(categoryId, pageNo, pageSize);
  }

  Future<BaseReply> fetchGoodsInfo(int productId, int userid) async {
    return await _api.fetchGoodsInfo(productId, userid: userid);
  }

  Future<bool> favorite(int userid, int productId) {
    return _api.favorite(userid, productId);
  }

  Future<bool> unfavorite(int userid, int productId) {
    return _api.unFavorite(userid, productId);
  }

  Future<dynamic> fetchFavorite(int userid, int pageNo, int pageSize) async {
    final res = await _api.fetchFavoriteByUser(userid, pageNo, pageSize);
    return res;
  }

  Future<ExtResult> fetchPublish(int userid, int pageNo, int pageSize) async {
    final res = await _api.fetchPublishByUser(userid, pageNo, pageSize);
    return res;
  }
}
