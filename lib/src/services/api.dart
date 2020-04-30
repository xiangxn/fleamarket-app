import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/address.dart';
import 'package:fleamarket/src/models/district.dart';
import 'package:fleamarket/src/models/ext_locale.dart';
import 'package:fleamarket/src/models/ext_result.dart';

class Api{
  Dio _dio;
  ExtLocale _locale;

  Api(ExtLocale locale){
    print('api build function .....');
    _dio = Dio();
    _dio.options.baseUrl = BASE_URL;
    _dio.options.connectTimeout = 5000;
    _dio.options.receiveTimeout = 3000;
    _dio.options.headers['j'] = '12346';
    _dio.options.headers['platformType'] = Platform.isAndroid ? 1 : Platform.isIOS ? 2 : 3;
    _dio.options.headers['interfaceVersion'] = INTERFACE_VERSION;
    // _dio.options.headers[HttpHeaders.acceptHeader]="application/json; charset=utf-8";
    _locale = locale;
  }

  Future<ExtResult> _request({String path, Map<String, dynamic> params, String method = POST_METHOD, bool formatForm = false}) async {
    print('*********************** send request $path');
    params?.forEach((k, v) => print('$k $v'));
    print('token ${Utils.getStore(TOKEN)}');
    print('******************************************');
    _dio.options.headers['token'] = Utils.getStore(TOKEN) ?? '0';
    _dio.options.method = method;
    ExtResult result = await _dio.request(path, data: formatForm ? FormData.fromMap(params) : params).then((res){
      if(res.statusCode == 200){
        dynamic data = res.data;
        print(data.toString());
        return ExtResult(code: data['code'] ?? 0, msg: data['msg'], data: data['data']);
      }else{
        return ExtResult(code: -2, msg: _locale.translation('error.network'));
      }
    }).catchError((err){
      return ExtResult(code: -2, msg: _locale.translation('error.network'));
    });
    return result;
  }

  /// 发送短信验证码
  Future<ExtResult> sendVcode(String phone, [int codeType = 10]){
    Map<String, dynamic> params = {
      'phone': phone,
      'codeType': codeType
    };
    return _request(path: '/sendSmsCode', params: params);
  }

  /// 刷新token
  Future<ExtResult> refreshToken(int userid, String token){
    Map<String, dynamic> params = {
      'userid': userid,
      'token': token
    };
    return _request(path: '/refreshtoken', params: params);
  }

  /// 验证引荐人
  Future<ExtResult> referral(String eosid) async {
    Map<String, dynamic> params = {
      'eosid': eosid
    };
    return _request(path: '/referral', params: params);
  } 

  /// 注册  
  Future<ExtResult> register(String phone, String password, String vcode, String recommended, String ownerPubKey, String acctivePubKey) async {
    Map<String, dynamic> params = {
      'phone': phone,
      'password': password,
      'ownerpubkey': ownerPubKey,
      'actpubkey': acctivePubKey,
      'smscode': vcode,
      'referral': recommended
    };
    print('******* register ');
    params?.forEach((k, v){
      print('$k ---- $v');
    });
    return _request(path: '/register', params: params);
  }

  /// 登录
  Future<ExtResult> login(String phone, String password) async {
    Map<String, dynamic> params = {
      'phone': phone,
      'password': password
    };
    return _request(path: '/login', params: params);
  }

  /// 登出
  Future<ExtResult> logout(int userid) async {
    Map<String, dynamic> params = {
      'userid': userid
    };
    return _request(path: '/logout', params: params);
  }   

  /// 查询用户
  Future<ExtResult> fetchUser(int userid) async {
    Map<String, dynamic> params = {
      'userid': userid
    };
    return _request(path: '/getuserinfo', params: params);
  }

  /// 根据用户查询关注列表
  Future<ExtResult> fetchFavoritesByUser(int userid, int pageNo, int pageSize) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'pageNo': pageNo,
      'pageSize': pageSize
    };
    return _request(path: '/getfavorites', params: params);
  }

  /// 根据用户获取收藏列表
  Future<ExtResult> fetchCollectionByUser(int userid, int pageNo, int pageSize) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'pageNo': pageNo,
      'pageSize': pageSize
    };
    return _request(path: '/getcolls', params: params);
  }

  /// 获取用户粉丝列表
  Future<ExtResult> fetchFansByUser(int userid, int pageNo, int pageSize) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'pageNo': pageNo,
      'pageSize': pageSize
    };
    return _request(path: '/getfavoritesdlist', params: params);
  }

  /// 关注
  Future<ExtResult> focus(int userid, int followedUserid) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'followedUserid': followedUserid
    };
    return _request(path: '/favorite', params: params);
  }

  /// 取消关注
  Future<ExtResult> unfocus(int userid, int followedUserid) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'followedUserid': followedUserid
    };
    return _request(path: '/unfavorite', params: params);
  }

  /// 收藏
  Future<ExtResult> favorite(int userid, int productId) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'productId': productId
    };
    return _request(path: '/collection', params: params);
  }

  /// 取消收藏
  Future<ExtResult> unfavorite(int userid, int productId) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'productId': productId
    };
    return _request(path: '/uncollection', params: params);
  }

  /// 获取商品分类列表
  Future<ExtResult> fetchCategorier() async {
    return _request(path: '/getcategory', method: GET_METHOD);
  }

  /// 根据商品分类获获取商品列表
  Future<ExtResult> fetchGoodsList(int userid, int categoryId, int pageNo, int pageSize) async {
    Map<String, int> params = {
      'userid': userid,
      'categoryId': categoryId,
      'pageNo': pageNo,
      'pageSize': pageSize
    };
    return _request(path: '/getproductlist', params: params);
  }

  /// 获取用户发布的商品列表
  Future<ExtResult> fetchPublishByUser(int userid, int pageNo, int pageSize) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'pageNo': pageNo,
      'pageSize': pageSize
    };
    return _request(path: '/getownerproductlist', params: params);
  }

  /// 获取用户购买的商品列表
  Future<ExtResult> fetchBuyByUser(int userid, int pageNo, int pageSize) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'pageNo': pageNo,
      'pageSize': pageSize
    };
    return _request(path: '/getbuyorderlist', params: params);
  }

  /// 获取用户卖出的商品列表
  Future<ExtResult> fetchSellByUser(int userid, int pageNo, int pageSize) async {
    Map<String, dynamic> params = {
      'userid': userid,
      'pageNo': pageNo,
      'pageSize': pageSize
    };
    return _request(path: '/getsellorderlist', params: params);
  }
  
  /// 获取订单信息
  Future<ExtResult> fetchOrder(int orderid) async {
    Map<String, dynamic> params = {
      'orderid': orderid
    };
    return _request(path: '/getorder', params: params);
  }

  /// 获取商品信息
  Future<ExtResult> fetchGoodsInfo(int productId, int userid) async {
    Map<String, dynamic> params = {
      'productId': productId,
      'userid': userid
    };
    return _request(path: '/getproductinfo', params: params);
  }

  /// 获取用户收货地址
  Future<ExtResult> fetchAddressByUser(int userid){
    Map<String, dynamic> params = {
      'userid': userid
    };
    return _request(path: '/getaddress', params: params);
  }

  /// 添加用户收货地址
  Future<ExtResult> addAddress(Address address, {int def = 0}){
    return _request(path: '/address', params: address.toJson());
  }

  /// 更新用户收货地址
  Future<ExtResult> updAddress(Address address, {int def = 0}){
    return _request(path: '/updateaddress', params: address.toJson());
  }

  /// 删除用户收货地址
  Future<ExtResult> delAddress(int id, int userid){
    Map<String, dynamic> params = {
      'id': id,
      'userid': userid
    };
    return _request(path: '/deladdress', params: params);
  }

  /// 设置默认收货地址
  Future<ExtResult> setAddressDefault(int id, int userid){
    Map<String, dynamic> params = {
      'id': id,
      'userid': userid
    };
    return _request(path: '/setdefault', params: params);
  }

  Future<District> fetchDistricts() async {
    var res = await Dio().get('https://restapi.amap.com/v3/config/district', queryParameters: {
      'keywords': '100000',
      'subdistrict': '3',
      'key': '92f35a6155436fa0179a80b27adec436'
    });
    if(res.statusCode == 200 && res.data['status'] == '1' && res.data['districts'][0] != null){
      District district = District.fromJson(res.data['districts'][0]);
      district.lastUpdate = DateTime.now();
      return district;
    }
    return null;
  }

  
}