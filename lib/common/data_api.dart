import 'dart:convert';
import 'dart:typed_data';

import 'package:bitsflea/common/global.dart';
import 'package:bitsflea/models/district.dart';
import 'package:dio/dio.dart';
import 'package:grpc/grpc.dart';
import '../grpc/bitsflea.pb.dart';
import '../grpc/bitsflea.pbgrpc.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'constant.dart';
import '../grpc/google/protobuf/wrappers.pb.dart';
import 'package:eosdart/eosdart.dart';
import 'package:eosdart/src/serialize.dart' as ser;

class DataApi {
  static BitsFleaClient _client;
  EOSPrivateKey _authKey; // = EOSPrivateKey.fromString('5JTjhoW4cbBDcHkfDVE6C3DwHqgU4yccqTAxrV7xc7JMDwa1xja');
  DateTime _lastTokenTime = DateTime.now();
  String _phone;

  static void init() {
    final _channel = ClientChannel(
      GRPC_HOST,
      port: 50000,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _client = BitsFleaClient(_channel);
  }

  void setKey(EOSPrivateKey authKey) {
    _authKey = authKey;
  }

  void delKey() {
    _authKey = null;
  }

  void setPhone(String phone) {
    _phone = phone;
  }

  void cleanInfo() {
    _authKey = null;
    _phone = null;
  }

  EOSPrivateKey get authKey {
    return _authKey ?? Global.profile.keys[2];
  }

  String get phone {
    return _phone ?? Global.profile.user.phone;
  }

  Future<String> getToken([bool force = false]) async {
    String token = Global.profile.token ?? "0";
    String tStr = Global.profile.tokenTime;
    _lastTokenTime = tStr == null ? DateTime.now() : DateTime.parse(tStr);
    final diff = DateTime.now().difference(_lastTokenTime);
    if (force == false && diff.inHours < 2 && token != "0") {
      print("token 0:" + token);
      return token;
    }
    final request = RefreshTokenRequest();
    request.phone = phone;
    request.token = token;
    request.time = ((new DateTime.now().millisecondsSinceEpoch) / 1000).floor();
    request.sign = authKey.signString(request.phone + request.token + request.time.toString()).toString();
    final res = await _client.refreshToken(request);
    // print("token_request:$request");
    // print("token_result:$res");
    if (res.code == 0) {
      var st = StringValue();
      res.data.unpackInto(st);
      token = st.value;
      _lastTokenTime = DateTime.now();
      Global.profile.setToken(token, _lastTokenTime.toString());
      Global.saveProfile();
    }
    //print(res);
    print("token 1:" + token);
    return token;
  }

  Future<BaseReply> getUserByPhone(String phone) async {
    final query = "{ users(phone:\"" +
        phone +
        "\") { edges{ node { userid,eosid,phone,status,nickname,head,creditValue,referrer,lastActiveTime,postsTotal,sellTotal,buyTotal," +
        "referralTotal,point,isReviewer,favoriteTotal,followTotal,fansTotal,authKey } } } }";
    return await _search(query);
    //print(res);
    // if (res.status.code == 0 && res.data.length > 0) {
    //   final data = json.decode(res.data);
    //   final e = data['users']['edges'];
    //   if (e.length > 0) return e[0]['node'];
    // }
    // return null;
  }

  Future<BaseReply> getUserByEosid(String eosid) async {
    final query = "{ users(eosid:\"" +
        eosid +
        "\") { edges{ node { userid,eosid,phone,status,nickname,head,creditValue,referrer,lastActiveTime,postsTotal,sellTotal,buyTotal," +
        "referralTotal,point,isReviewer,favoriteTotal,followTotal,fansTotal,authKey } } } }";
    return await _search(query);
  }

  Future<BaseReply> getUserByUserid(int uid) async {
    final query = "{ users(userid:" +
        uid.toString() +
        ") { edges{ node { userid,eosid,phone,status,nickname,head,creditValue,referrer,lastActiveTime,postsTotal,sellTotal,buyTotal," +
        "referralTotal,point,isReviewer,favoriteTotal,followTotal,fansTotal,authKey } } } }";
    return await _search(query);
  }

  Future<BaseReply> register(String phone, String ownerPubKey, String activePubKey,
      {String nickname, String smsCode, String referral, String authKey, String phoneEncrypt}) async {
    //final token = await getToken();
    var request = RegisterRequest();
    request.phone = phone;
    request.ownerpubkey = ownerPubKey;
    request.actpubkey = activePubKey;
    if (nickname != null) request.nickname = nickname;
    if (smsCode != null) request.smscode = smsCode;
    if (referral != null) request.referral = referral;
    if (authKey != null) request.authkey = authKey;
    if (phoneEncrypt != null) request.phoneEncrypt = phoneEncrypt;
    //final res = await _client.register(request, options: CallOptions(metadata: {'token': token}));
    try {
      return await _client.register(request);
    } on GrpcError catch (e) {
      var reply = BaseReply();
      reply.code = e.code;
      reply.msg = e.message;
      return reply;
    }
  }

  Future<bool> sendSmsCode(String phone, [int codeType = 10]) async {
    //final token = await getToken();
    var request = SmsRequest();
    request.phone = phone;
    request.codeType = codeType;
    //final res = await _client.sendSmsCode(request, options: CallOptions(metadata: {'token': token}));
    final res = await _client.sendSmsCode(request);
    if (res.code == 0) return true;
    return false;
  }

  Future<bool> follow(int user, int follower) async {
    // print("user: $user; follower: $follower");
    if (user == follower) return false;
    final token = await getToken();
    var request = FollowRequest();
    request.user = user;
    request.follower = follower;
    final res = await _client.follow(request, options: CallOptions(metadata: {'token': token}));
    // print("res: $res");
    if (res.code == 0) return true;
    return false;
  }

  Future<bool> unFollow(int user, int follower) async {
    final token = await getToken();
    var request = FollowRequest();
    request.user = user;
    request.follower = follower;
    final res = await _client.unFollow(request, options: CallOptions(metadata: {'token': token}));
    if (res.code == 0) return true;
    return false;
  }

  Future<BaseReply> getFollowByUser(int userid, int pageNo, int pageSize) async {
    var query = "{followByUser(userid:" +
        userid.toString() +
        ", pageNo:" +
        pageNo.toString() +
        ", pageSize:" +
        pageSize.toString() +
        ")" +
        " {pageNo,pageSize,totalCount,list{follower{userid,eosid,status,nickname,head,fansTotal,creditValue,isReviewer}}}}";
    return await _search(query);
  }

  Future<BaseReply> getFollowByFollower(int userid, int pageNo, int pageSize) async {
    var query = "{followByFollower(userid:" +
        userid.toString() +
        ", pageNo:" +
        pageNo.toString() +
        ", pageSize:" +
        pageSize.toString() +
        ")" +
        " {pageNo,pageSize,totalCount,list{user{userid,eosid,status,nickname,head,fansTotal,creditValue,isReviewer}}}}";
    return await _search(query);
  }

  Future<BaseReply> getRecAddrByUser(int userid) async {
    var query = "{recAddrByUser(userid:" + userid.toString() + "){rid,province,city,district,phone,name,address,postcode,default}}";
    return await _search(query);
  }

  Future<bool> setDefaultAddr(int id, int userid) async {
    final token = await getToken();
    var request = SetDefaultAddrRequest();
    request.rid = id;
    request.userid = userid;
    final res = await _client.setDefaultAddr(request, options: CallOptions(metadata: {'token': token}));
    return res.code == 0;
  }

  Future<bool> addRecAddr(AddressRequest addr) async {
    final token = await getToken();
    final res = await _client.address(addr, options: CallOptions(metadata: {'token': token}));
    return res.code == 0;
  }

  Future<bool> updateRecAddr(AddressRequest addr) async {
    final token = await getToken();
    final res = await _client.updateAddress(addr, options: CallOptions(metadata: {'token': token}));
    return res.code == 0;
  }

  Future<bool> delRecAddr(AddressRequest addr) async {
    final token = await getToken();
    final res = await _client.delAddress(addr, options: CallOptions(metadata: {'token': token}));
    return res.code == 0;
  }

  Future<bool> setProfile(EOSPrivateKey actKey, String eosid, {String head, String nickname}) async {
    final token = await getToken();
    TransactionRequest tr = TransactionRequest();
    tr.sign = 0;
    EOSClient client = EOSClient(URL_EOS_API, "v1", privateKeys: [actKey.toString()]);
    List<Authorization> auth = [
      Authorization()
        ..actor = eosid
        ..permission = 'active'
    ];
    Map data = {'eosid': eosid};
    data['head'] = head;
    data['nickname'] = nickname;
    //print("head-data:$data");
    List<Action> actions = [
      Action()
        ..account = CONTRACT_NAME
        ..name = 'setprofile'
        ..authorization = auth
        ..data = data
    ];
    Transaction transaction = Transaction()..actions = actions;
    final serTrxArgs = await client.pushTransaction(transaction, broadcast: false);
    //print("serTrxArgs:$serTrxArgs");
    final trx = {
      'signatures': serTrxArgs.signatures,
      'compression': 0,
      'packed_context_free_data': '',
      'packed_trx': ser.arrayToHex(serTrxArgs.serializedTransaction),
    };
    tr.sign = 0;
    tr.trx = jsonEncode(trx);
    //print("trx:$tr");
    try {
      final result = await _client.transaction(tr, options: CallOptions(metadata: {'token': token}));
      //print("result:$result");
      return result.code == 0;
    } on GrpcError catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<BaseReply> uploadFile(Uint8List file) async {
    final token = await getToken();
    FileRequest request = FileRequest();
    request.file = file;
    request.name = "head.jpg";
    return _client.upload(request, options: CallOptions(metadata: {'token': token}));
  }

  Future<BaseReply> _search(String query) async {
    //final token = await getToken();
    try {
      //return await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
      return await _client.search(SearchRequest()..query = query);
    } on GrpcError catch (e) {
      var reply = BaseReply();
      reply.code = e.code;
      reply.msg = e.message;
      return reply;
    }
  }

  Future<BaseReply> fetchCategories() async {
    String query = "{ categories { edges{ node { cid, view, parent} } } }";
    return await _search(query);
  }

  Future<BaseReply> fetchProductList(int categoryId, int pageNo, int pageSize, {int userid = 0}) async {
    String query = "{productByCid(categoryId:$categoryId,pageNo:$pageNo,pageSize:$pageSize)";
    if (userid > 0) query = "{productByCid(userid:$userid,categoryId:$categoryId,pageNo:$pageNo,pageSize:$pageSize)";
    query += "{pageNo,pageSize,totalCount,list{productId,title,price,collections,seller{userid,head,nickname},photos}}}";
    return await _search(query);
  }

  Future<BaseReply> getProductsByPublisher(int userid, int pageNo, int pageSize) async {
    String query = "{productByPublisher(userid:$userid,pageNo:$pageNo,pageSize:$pageSize)";
    query += "{pageNo,pageSize,totalCount,list{productId,title,price,collections,seller{userid,head,nickname},photos}}}";
    return await _search(query);
  }

  Future<BaseReply> searchProductByTitle(String title, int pageNo, int pageSize, {int userid = 0}) async {
    String query = "{productByTitle(title:\"$title\",pageNo:$pageNo,pageSize:$pageSize)";
    if (userid > 0) query = "{productByTitle(userid:$userid,title:\"$title\",pageNo:$pageNo,pageSize:$pageSize)";
    query += "{pageNo,pageSize,totalCount,list{productId,title,price,collections,seller{userid,head,nickname},photos}}}";
    return await _search(query);
  }

  Future<BaseReply> fetchProductInfo(int productId) async {
    String query = "{products(productId:$productId){edges{node{";
    query +=
        "productId,title,status,isNew,isReturns,transMethod,postage,position,releaseTime,description,photos,collections,price,saleMethod,stockCount,isRetail,";
    query += "category{cid,view},";
    query += "seller{userid,head,nickname,eosid}";
    query += "}}}}";
    return await _search(query);
  }

  Future<bool> favorite(int userid, int productId) async {
    final token = await getToken();
    FavoriteRequest request = FavoriteRequest();
    request.user = userid;
    request.product = productId;
    try {
      final result = await _client.favorite(request, options: CallOptions(metadata: {'token': token}));
      return result.code == 0;
    } on GrpcError catch (e) {
      print("favorite error: ${e.message}");
      return false;
    }
  }

  Future<bool> unFavorite(int userid, int productId) async {
    final token = await getToken();
    FavoriteRequest request = FavoriteRequest();
    request.user = userid;
    request.product = productId;
    try {
      final result = await _client.unFavorite(request, options: CallOptions(metadata: {'token': token}));
      return result.code == 0;
    } on GrpcError catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<BaseReply> fetchFavoriteByUser(int userid, int pageNo, int pageSize) async {
    String query = "{favoriteByUser(userid:$userid, pageNo:$pageNo, pageSize:$pageSize)";
    query += "{pageNo,pageSize,totalCount,list{";
    query += "product{productId,title,price,collections,seller{head,nickname},photos}";
    query += "}}}";
    return await _search(query);
  }

  Future<BaseReply> getFavoriteIdsByUser(int userid, int pageNo, int pageSize) async {
    String query = "{favoriteByUser(userid:$userid, pageNo:$pageNo, pageSize:$pageSize)";
    query += "{pageNo,pageSize,totalCount,list{";
    query += "product{productId}";
    query += "}}}";
    // print("query: $query");
    return await _search(query);
  }

  Future<BaseReply> fetchPublishByUser(int userid, int pageNo, int pageSize) async {
    String query = "{productByPublisher(userid:$userid, pageNo:$pageNo, pageSize:$pageSize)";
    query += "{pageNo,pageSize,totalCount,list{";
    query += "productId,title,price,collections,seller{head,nickname},photos";
    query += "}}}";
    return await _search(query);
  }

  Future<District> fetchDistricts() async {
    var res = await Dio().get('https://restapi.amap.com/v3/config/district',
        queryParameters: {'keywords': '100000', 'subdistrict': '3', 'key': '92f35a6155436fa0179a80b27adec436'});
    if (res.statusCode == 200 && res.data['status'] == '1' && res.data['districts'][0] != null) {
      District district = District.fromJson(res.data['districts'][0]);
      district.lastUpdate = DateTime.now();
      return district;
    }
    return null;
  }

  Future<dynamic> fetchBuyByUser(int userid, int pageNo, int pageSize) async {}

  Future<dynamic> fetchSellByUser(int userid, int pageNo, int pageSize) async {}

  Future<dynamic> fetchOrder(int orderid) async {}

  Future<bool> publishProduct(EOSPrivateKey actKey, String eosid, int userId, Map product, [Map productAuction]) async {
    final token = await getToken();
    TransactionRequest tr = TransactionRequest();
    tr.sign = 1;
    EOSClient client = EOSClient(URL_EOS_API, "v1", privateKeys: [actKey.toString()]);
    List<Authorization> auth = [
      Authorization()
        ..actor = CONTRACT_NAME
        ..permission = 'active',
      Authorization()
        ..actor = eosid
        ..permission = 'active'
    ];
    Map data = {'uid': userId};
    data['product'] = product;
    data['pa'] = productAuction;
    print("action-data:$data");
    List<Action> actions = [
      Action()
        ..account = CONTRACT_NAME
        ..name = 'publish'
        ..authorization = auth
        ..data = data
    ];
    Transaction transaction = Transaction()..actions = actions;
    //final serTrxArgs = await client.pushTransaction(transaction, broadcast: false);
    final serTrxArgs = await client.createTransaction(transaction);
    print("serTrxArgs:$serTrxArgs");
    final trx = {
      'signatures': serTrxArgs.signatures,
      'compression': 0,
      'packed_context_free_data': '',
      'packed_trx': ser.arrayToHex(serTrxArgs.serializedTransaction),
    };
    tr.trx = jsonEncode(trx);
    print("trx:$tr");
    try {
      final result = await _client.transaction(tr, options: CallOptions(metadata: {'token': token}));
      print("result:$result");
      return result.code == 0;
    } on GrpcError catch (e) {
      print(e.message);
      return false;
    }
  }
}
