import 'package:fleamarket/src/common/data_api.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/grpc/bitsflea.pb.dart';
import 'package:fleamarket/src/models/category.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';

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

  Future<bool> favorite(int userid, int productId) async {
    return await _api.favorite(userid, productId);
  }

  Future<bool> unfavorite(int userid, int productId) async {
    return await _api.unFavorite(userid, productId);
  }

  Future<BaseReply> fetchFavorite(int userid, int pageNo, int pageSize) async {
    final res = await _api.fetchFavoriteByUser(userid, pageNo, pageSize);
    return res;
  }

  Future<BaseReply> fetchPublish(int userid, int pageNo, int pageSize) async {
    final res = await _api.fetchPublishByUser(userid, pageNo, pageSize);
    return res;
  }

  Future<bool> publishProduct(EOSPrivateKey actKey, String eosid, int userId, Map product, List<AssetEntity> photos) async {
    if (photos != null) {
      var futures = List<Future<BaseReply>>();
      for (int i = 0; i < photos.length; i++) {
        var data = await photos[i].originBytes;
        futures.add(_api.uploadFile(data));
      }
      try {
        final resList = await Future.wait(futures);
        print("uploadFiles: $resList");
        if (resList.length > 0) {
          resList.forEach((f) {
            if (f.code == 0) (product['photos'] as List).add(f.msg);
          });
        }
      } catch (e) {
        return false;
      }
    }
    print("product: $product");
    return await _api.publishProduct(actKey, eosid, userId, product);
  }
}
