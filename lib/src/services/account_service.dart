import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/grpc/bitsflea.pb.dart';
import 'package:fleamarket/src/grpc/google/protobuf/wrappers.pb.dart';
import '../common/data_api.dart';

class AccountService {
  DataApi _api;
  User _user;
  bool _lock = true;
  EOSPrivateKey _ownerKey;
  EOSPrivateKey _activeKey;
  EOSPrivateKey _authKey;

  User get user => _user;
  bool get locked => _lock;
  EOSPrivateKey get ownerKey => _ownerKey;
  EOSPrivateKey get activeKey => _activeKey;
  EOSPrivateKey get authKey => _authKey;

  AccountService(DataApi api) {
    _api = api;
  }

  User _userFromMap(dynamic map) {
    var user = User();
    user.userid = map['userid'];
    user.eosid = map['eosid'];
    user.phone = map['phone'];
    user.status = map['status'];
    user.nickname = map['nickname'];
    user.head = map['head'];
    user.creditValue = map['creditValue'];
    user.referrer = map['referrer'];
    user.lastActiveTime = map['lastActiveTime'];
    user.postsTotal = map['postsTotal'];
    user.sellTotal = map['sellTotal'];
    user.buyTotal = map['buyTotal'];
    user.referralTotal = map['referralTotal'];
    user.point = map['point'];
    user.isReviewer = map['isReviewer'];
    user.followTotal = map['followTotal'];
    user.favoriteTotal = map['favoriteTotal'];
    user.fansTotal = map['fansTotal'];
    user.authKey = map['authKey'];
    if (user.head != null && user.head != "")
      user.head = URL_IPFS_GATEWAY + user.head;
    else
      user.head = DEFAULT_HEAD;
    return user;
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
        _user = _userFromMap(data);
        _lock = false;
        _ownerKey = keys[0];
        _activeKey = keys[1];
        _authKey = keys[2];
        return true;
      }
    }
    return false;
  }

  Future<bool> refreshUser() async {
    if (_user == null) return false;
    final result = await _api.getUserByUserid(_user.userid);
    if (result.code == 0) {
      var str = StringValue();
      result.data.unpackInto(str);
      dynamic data = jsonDecode(str.value)['users']['edges'];
      if (data.length > 0) {
        _user = data[0]['node'];
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
      _user = user;
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

  Future<bool> setProfile({Uint8List head, String nickname}) async {
    //print("user: $user");
    if (head == null && nickname == null) return true;
    String headHash;
    String nn;
    if (head != null) {
      final result = await _api.uploadFile(head);
      if (result.code == 0) {
        headHash = result.msg;
      }
    }
    if (nickname != null && nickname.length > 0) {
      nn = nickname;
    }
    //print("head:$headHash, nickname:$nn");
    final result = await _api.setProfile(activeKey, user.eosid, head: headHash, nickname: nn);
    if (result) {
      if (headHash != null) _user.head = URL_IPFS_GATEWAY + headHash;
      if (nickname != null) _user.nickname = nickname;
    }
    return result;
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
