import 'package:fleamarket/src/models/ext_result.dart';
import 'package:grpc/grpc.dart';
import '../grpc/bitsflea.pb.dart';
import '../grpc/bitsflea.pbgrpc.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'dart:convert';
import 'profile.dart';
import 'utils.dart';

class DataApi {
  BitsFleaClient _client;
  EOSPrivateKey _authKey; // = EOSPrivateKey.fromString('5JTjhoW4cbBDcHkfDVE6C3DwHqgU4yccqTAxrV7xc7JMDwa1xja');
  DateTime _lastTokenTime = DateTime.now();
  String _phone = "0";

  Future<bool> init() async {
    final _channel = ClientChannel(
      GRPC_HOST,
      port: 50000,
      options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    _client = BitsFleaClient(_channel);
    return true;
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

  Future<String> getToken([bool force = false]) async {
    String token = Utils.getStore(TOKEN) ?? "0";
    final diff = DateTime.now().difference(_lastTokenTime);
    if (force == false && diff.inHours < 2 && token != "0") {
      return token;
    }
    final request = RefreshTokenRequest();
    request.phone = _phone;
    request.token = token;
    request.time = ((new DateTime.now().millisecondsSinceEpoch) / 1000).floor();
    request.sign = _authKey.signString(request.phone + request.token + request.time.toString()).toString();
    //print(request.sign);
    final res = await _client.refreshToken(request);
    if (res.status.code == 0) {
      token = res.token;
      _lastTokenTime = DateTime.now();
      await Utils.setStore(TOKEN, token);
    }
    //print(res);
    return token;
  }

  Future<dynamic> getUserByPhone(String phone) async {
    final token = await getToken();
    final query = "{ users(phone:\"" +
        phone +
        "\") { edges{ node { userid,eosid,phone,status,nickname,head,creditValue,referrer,lastActiveTime,postsTotal,sellTotal,buyTotal," +
        "referralTotal,point,isReviewer,favoriteTotal,collectionTotal,fansTotal,authKey } } } }";
    final res = await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    //print(res);
    if (res.status.code == 0 && res.data.length > 0) {
      final data = json.decode(res.data);
      final e = data['users']['edges'];
      if (e.length > 0) return e[0]['node'];
    }
    return null;
  }

  Future<dynamic> getUserByEosid(String eosid) async {
    final token = await getToken();
    final query = "{ users(eosid:\"" +
        eosid +
        "\") { edges{ node { userid,eosid,phone,status,nickname,head,creditValue,referrer,lastActiveTime,postsTotal,sellTotal,buyTotal," +
        "referralTotal,point,isReviewer,favoriteTotal,collectionTotal,fansTotal,authKey } } } }";
    final res = await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    //print(res);
    if (res.status.code == 0 && res.data.length > 0) {
      final data = json.decode(res.data);
      final e = data['users']['edges'];
      if (e.length > 0) return e[0]['node'];
    }
    return null;
  }

  Future<dynamic> getUserByUserid(int uid) async {
    final token = await getToken();
    final query = "{ users(userid:" +
        uid.toString() +
        ") { edges{ node { userid,eosid,phone,status,nickname,head,creditValue,referrer,lastActiveTime,postsTotal,sellTotal,buyTotal," +
        "referralTotal,point,isReviewer,favoriteTotal,collectionTotal,fansTotal,authKey } } } }";
    final res = await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    //print(res);
    if (res.status.code == 0 && res.data.length > 0) {
      final data = json.decode(res.data);
      final e = data['users']['edges'];
      if (e.length > 0) return e[0]['node'];
    }
    return null;
  }

  Future<RegisterReply> register(String phone, String ownerPubKey, String activePubKey,
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
    return await _client.register(request);
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
    final token = await getToken();
    var request = FollowRequest();
    request.user = user;
    request.follower = follower;
    final res = await _client.follow(request, options: CallOptions(metadata: {'token': token}));
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

  Future<dynamic> getFollowByFollower(int userid, int pageNo, int pageSize) async {
    final token = await getToken();
    var query = "{followByFollower(userid:" +
        userid.toString() +
        ", pageNo:" +
        pageNo.toString() +
        ", pageSize:" +
        pageSize.toString() +
        ")" +
        " {user{userid,eosid,status,nickname,head}}}";
    final res = await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    //print(res);
    if (res.status.code == 0 && res.data.length > 0) {
      final data = json.decode(res.data);
      final e = data['followByFollower'];
      if (e.length > 0) return e;
    }
    return null;
  }

  Future<dynamic> getFollowByUser(int userid, int pageNo, int pageSize) async {
    final token = await getToken();
    var query = "{followByUser(userid:" +
        userid.toString() +
        ", pageNo:" +
        pageNo.toString() +
        ", pageSize:" +
        pageSize.toString() +
        ")" +
        " {follower{userid,eosid,status,nickname,head}}}";
    final res = await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    //print(res);
    if (res.status.code == 0) {
      final data = json.decode(res.data);
      final e = data['followByUser'];
      if (e.length > 0) return e;
    }
    return null;
  }

  Future<dynamic> getRecAddrByUser(int userid) async {
    final token = await getToken();
    var query = "{recAddrByUser(userid:" + userid.toString() + "){rid,province,city,district,phone,name,address,postcode,default}}";
    final res = await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    //print(res);
    if (res.status.code == 0) {
      final data = json.decode(res.data);
      final e = data['recAddrByUser'];
      if (e.length > 0) return e;
    }
    return null;
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

  Future<dynamic> fetchCategorier() async {}

  Future<dynamic> fetchGoodsList(int userid, int categoryId, int pageNo, int pageSize) async {}

  Future<dynamic> fetchGoodsInfo(int productId, int userid) async {}

  Future<bool> favorite(int userid, int productId) async {
    return true;
  }

  Future<bool> unFavorite(int userid, int productId) async {
    return true;
  }

  Future<dynamic> fetchFavoriteByUser(int userid, int pageNo, int pageSize) async {}

  Future<dynamic> fetchPublishByUser(int userid, int pageNo, int pageSize) async {}

  Future<dynamic> fetchDistricts() async {}

  Future<dynamic> fetchBuyByUser(int userid, int pageNo, int pageSize) async {}

  Future<dynamic> fetchSellByUser(int userid, int pageNo, int pageSize) async {}

  Future<dynamic> fetchOrder(int orderid) async {}
}
