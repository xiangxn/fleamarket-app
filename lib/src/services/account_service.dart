import 'dart:async';
import 'dart:convert';

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/grpc/bitsflea.pb.dart';
import 'package:fleamarket/src/grpc/google/protobuf/wrappers.pb.dart';
import '../common/data_api.dart';

class AccountService {
  DataApi _api;
  dynamic _user;
  bool _lock = true;
  EOSPrivateKey _ownerKey;
  EOSPrivateKey _activeKey;
  EOSPrivateKey _authKey;

  get user => _user;
  get locked => _lock;
  get ownerKey => _ownerKey;
  get activeKey => _activeKey;
  get authKey => _authKey;

  AccountService(DataApi api) {
    _api = api;
  }

  Future<bool> login(String phone, String password) async {
    final keys = Utils.generateKeys(phone, password);
    _api.setKey(keys[2]);
    _api.setPhone(phone);
    //print("${keys[0].toEOSPublicKey().toString()}_${keys[1].toEOSPublicKey().toString()}_${keys[2].toEOSPublicKey().toString()}");
    final result = await _api.getUserByPhone(phone);
    if (result.code == 0) {
      final str = StringValue();
      result.data.unpackInto(str);
      dynamic data = jsonDecode(str.value)['users']['edges'];
      if (data.length > 0) {
        data = data[0]['node'];
      }
      //print("data============:$data");
      if (keys[2].toEOSPublicKey().toString() == data['authKey'].toString()) {
        _user = data;
        _lock = false;
        _ownerKey = keys[0];
        _activeKey = keys[1];
        _authKey = keys[2];
        return true;
      }
    }
    return false;
  }

  Future<BaseReply> register(String phone, String password, String smsCode, String referral) async {
    List<EOSPrivateKey> keys = Utils.generateKeys(phone, password);
    final res = await _api.register(phone, keys[0].toEOSPublicKey().toString(), keys[1].toEOSPublicKey().toString(),
        smsCode: smsCode, referral: referral, authKey: keys[2].toEOSPublicKey().toString());
    if (res.code == 0) {
      // Utils.setStore(KEY_OWNER, Utils.encrypt(password, keys[0].toString()));
      // Utils.setStore(KEY_ACTIVE, Utils.encrypt(password, keys[1].toString()));
      // Utils.setStore(KEY_AUTH, Utils.encrypt(password, keys[2].toString()));
      _lock = false;
      _ownerKey = keys[0];
      _activeKey = keys[1];
      _authKey = keys[2];
      _api.setKey(_authKey);
      _api.setPhone(phone);
      var user = User();
      res.data.unpackInto(user);
      _user = user.toProto3Json();
      //print("user:$user");
      //_user = await _api.getUserByUserid(user.userid);
      //return BaseReply();
    }
    return res;
  }

  Future<bool> validateReferral(String eosid) async {
    final res = await _api.getUserByEosid(eosid);
    print("res:$res");
    return res != null;
  }

  Future<bool> sendVcode(String phone) {
    return _api.sendSmsCode(phone);
  }

  Future<dynamic> fetchUser(int id) async {
    final res = await _api.getUserByUserid(id);
    return res;
  }

  Future<bool> follow(int userid, int follower) async {
    return await _api.follow(userid, follower);
  }

  Future<bool> unFollow(int userid, int follower) async {
    return await _api.unFollow(userid, follower);
  }

  updateToken(String token) {
    Utils.setStore(TOKEN, token);
    Utils.setStore(TOKEN_TIMER, DateTime.now().toIso8601String());
  }

  Future<bool> setProfile({String head, String nickname}) async {
    return await _api.setProfile(activeKey, user['eosid'], head: head, nickname: nickname);
  }

  logout(int id) {
    _user = null;
    _ownerKey = null;
    _activeKey = null;
    _authKey = null;
    _lock = true;
    _api.delKey();
  }

  Future<dynamic> fetchFocus(int userid, int pageNo, int pageSize) async {
    return await _api.getFollowByFollower(userid ?? 0, pageNo, pageSize);
  }

  Future<dynamic> fetchFans(int userid, int pageNo, int pageSize) async {
    return await _api.getFollowByUser(userid ?? 0, pageNo, pageSize);
  }

  Future<dynamic> fetchAddressByUser(int userid) async {
    return await _api.getRecAddrByUser(userid);
  }

  Future<bool> setAddressDefault(int id, int userid) async {
    return await _api.setDefaultAddr(id, userid);
  }

  Future<bool> addAddress(AddressRequest address) async {
    return await _api.addRecAddr(address);
  }

  Future<bool> updAddress(AddressRequest address) async {
    return await _api.updateRecAddr(address);
  }

  Future<bool> delAddress(int id, int userid) async {
    AddressRequest addr = AddressRequest();
    addr.rid = id;
    addr.userid = userid;
    return await _api.delRecAddr(addr);
  }
}
