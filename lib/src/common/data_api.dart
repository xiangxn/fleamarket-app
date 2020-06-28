import 'dart:convert';
import 'dart:typed_data';

import 'package:grpc/grpc.dart';
import '../grpc/bitsflea.pb.dart';
import '../grpc/bitsflea.pbgrpc.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'profile.dart';
import 'utils.dart';
import '../grpc/google/protobuf/wrappers.pb.dart';
import 'package:eosdart/eosdart.dart';
import 'package:eosdart/src/serialize.dart' as ser;

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
      print("token:" + token);
      return token;
    }
    final request = RefreshTokenRequest();
    request.phone = _phone;
    request.token = token;
    request.time = ((new DateTime.now().millisecondsSinceEpoch) / 1000).floor();
    request.sign = _authKey.signString(request.phone + request.token + request.time.toString()).toString();
    final res = await _client.refreshToken(request);
    print("token_result:$res");
    if (res.code == 0) {
      var st = StringValue();
      res.data.unpackInto(st);
      token = st.value;
      _lastTokenTime = DateTime.now();
      await Utils.setStore(TOKEN, token);
    }
    //print(res);
    print("token:" + token);
    return token;
  }

  Future<BaseReply> getUserByPhone(String phone) async {
    final token = await getToken();
    final query = "{ users(phone:\"" +
        phone +
        "\") { edges{ node { userid,eosid,phone,status,nickname,head,creditValue,referrer,lastActiveTime,postsTotal,sellTotal,buyTotal," +
        "referralTotal,point,isReviewer,favoriteTotal,followTotal,fansTotal,authKey } } } }";
    try {
      return await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    } on GrpcError catch (e) {
      var reply = BaseReply();
      reply.code = e.code;
      reply.msg = e.message;
      return reply;
    }
    //print(res);
    // if (res.status.code == 0 && res.data.length > 0) {
    //   final data = json.decode(res.data);
    //   final e = data['users']['edges'];
    //   if (e.length > 0) return e[0]['node'];
    // }
    // return null;
  }

  Future<BaseReply> getUserByEosid(String eosid) async {
    final token = await getToken();
    final query = "{ users(eosid:\"" +
        eosid +
        "\") { edges{ node { userid,eosid,phone,status,nickname,head,creditValue,referrer,lastActiveTime,postsTotal,sellTotal,buyTotal," +
        "referralTotal,point,isReviewer,favoriteTotal,followTotal,fansTotal,authKey } } } }";
    try {
      return await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    } on GrpcError catch (e) {
      var reply = BaseReply();
      reply.code = e.code;
      reply.msg = e.message;
      return reply;
    }
  }

  Future<BaseReply> getUserByUserid(int uid) async {
    final token = await getToken();

    final query = "{ users(userid:" +
        uid.toString() +
        ") { edges{ node { userid,eosid,phone,status,nickname,head,creditValue,referrer,lastActiveTime,postsTotal,sellTotal,buyTotal," +
        "referralTotal,point,isReviewer,favoriteTotal,followTotal,fansTotal,authKey } } } }";
    try {
      return await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    } on GrpcError catch (e) {
      var reply = BaseReply();
      reply.code = e.code;
      reply.msg = e.message;
      return reply;
    }
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

  Future<BaseReply> getFollowByFollower(int userid, int pageNo, int pageSize) async {
    final token = await getToken();
    var query = "{followByFollower(userid:" +
        userid.toString() +
        ", pageNo:" +
        pageNo.toString() +
        ", pageSize:" +
        pageSize.toString() +
        ")" +
        " {user{userid,eosid,status,nickname,head}}}";
    try {
      return await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    } on GrpcError catch (e) {
      var reply = BaseReply();
      reply.code = e.code;
      reply.msg = e.message;
      return reply;
    }
  }

  Future<BaseReply> getFollowByUser(int userid, int pageNo, int pageSize) async {
    final token = await getToken();
    var query = "{followByUser(userid:" +
        userid.toString() +
        ", pageNo:" +
        pageNo.toString() +
        ", pageSize:" +
        pageSize.toString() +
        ")" +
        " {follower{userid,eosid,status,nickname,head}}}";
    try {
      return await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    } on GrpcError catch (e) {
      var reply = BaseReply();
      reply.code = e.code;
      reply.msg = e.message;
      return reply;
    }
  }

  Future<BaseReply> getRecAddrByUser(int userid) async {
    final token = await getToken();
    var query = "{recAddrByUser(userid:" + userid.toString() + "){rid,province,city,district,phone,name,address,postcode,default}}";
    try {
      return await _client.search(SearchRequest()..query = query, options: CallOptions(metadata: {'token': token}));
    } on GrpcError catch (e) {
      var reply = BaseReply();
      reply.code = e.code;
      reply.msg = e.message;
      return reply;
    }
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
