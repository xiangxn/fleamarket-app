import 'dart:async';

import 'package:eosdart_ecc/eosdart_ecc.dart';
import 'package:fleamarket/src/common/profile.dart';
import 'package:fleamarket/src/common/result_conversion.dart';
import 'package:fleamarket/src/common/utils.dart';
import 'package:fleamarket/src/models/address.dart';
import 'package:fleamarket/src/models/ext_result.dart';
import 'package:fleamarket/src/models/user.dart';
import 'package:fleamarket/src/services/api.dart';

class AccountService{
  Api _api;
  User _user ;

  get user => _user;

  AccountService(Api api){
    _api = api;

    var user = Utils.getStore(USER, true);
    if(user != null){
      _user = User.fromJson(user);
    }
  }

  Future<ExtResult> login(String phone, String password) async{
    List<EOSPrivateKey> keys = Utils.generateKeys(phone, password);
    Utils.saveKeys(keys);
    ExtResult res = await _api.login(phone, password);
    return ResultConversion.excute(res, ResultTypes.User);
  }

  Future<ExtResult> register(String phone, String password, String vcode, String recommended) async {
    List<EOSPrivateKey> keys = Utils.generateKeys(phone, password);
    Utils.saveKeys(keys);
    ExtResult res = await _api.register(phone, password, vcode, recommended, keys[0].toEOSPublicKey().toString(), keys[1].toEOSPublicKey().toString());
    return ResultConversion.excute(res, ResultTypes.User);
  }

  Future<ExtResult> validateReferral(String eosid){
    return _api.referral(eosid);
  }

  Future<ExtResult> sendVcode(String phone){
    return _api.sendVcode(phone);
  }

  Future<ExtResult> fetchUser(int id) async {
    ExtResult res = await _api.fetchUser(id);
    return ResultConversion.excute(res, ResultTypes.User);
  }

  Future<ExtResult> focus(int userid, int followedUserid) {
    return _api.focus(userid, followedUserid);
  }

  Future<ExtResult> unfocus(int userid, int followedUserid){
    return _api.unfocus(userid, followedUserid);
  }

  refreshToken(int id, String token) async {
    ExtResult res = await _api.refreshToken(id, token);
    if(res.code == 0){
      updateToken(res.data['token']);
    }
  }

  updateToken(String token){
    Utils.setStore(TOKEN, token);
    Utils.setStore(TOKEN_TIMER, DateTime.now().toIso8601String());
  }

  logout(int id){
    _api.logout(id);
    _user = null;
    Utils.clearStore(USER);
    Utils.clearStore(TOKEN);
    Utils.clearStore(TOKEN_TIMER);
  }

  bool updateUser(User user){
    if(user == null){
      return false;
    }else{
      _user = user;
      Utils.setStore(USER, _user);
      if(_user.token != null){
        updateToken(_user.token);
      }else{
        refreshToken(_user.userid, Utils.getStore(TOKEN) ?? '0');
      }
      return true;
    }
  }

  Future<ExtResult> fetchFocus(int userid, int pageNo, int pageSize) async {
    ExtResult res = await _api.fetchFavoritesByUser(userid ?? 0, pageNo, pageSize);
    return ResultConversion.excute(res, ResultTypes.UserPage);
  }

  Future<ExtResult> fetchFans(int userid, int pageNo, int pageSize) async {
    ExtResult res = await _api.fetchFansByUser(userid ?? 0, pageNo, pageSize);
    return ResultConversion.excute(res, ResultTypes.UserPage);
  }

  Future<ExtResult> fetchAddressByUser(int userid) async {
    ExtResult res = await _api.fetchAddressByUser(userid);
    return ResultConversion.excute(res, ResultTypes.AddressList);
  }

  Future<ExtResult> setAddressDefault(int id, int userid) async {
    ExtResult res = await _api.setAddressDefault(id, userid);
    return ResultConversion.excute(res, ResultTypes.AddressList);
  }

  Future<ExtResult> addAddress(Address address, {int def = 0}) async {
    ExtResult res = await _api.addAddress(address);
    return ResultConversion.excute(res, ResultTypes.AddressList);
  }

  Future<ExtResult> updAddress(Address address, {int def = 0}) async {
    ExtResult res = await _api.updAddress(address);
    return ResultConversion.excute(res, ResultTypes.AddressList);
  }

  Future<ExtResult> delAddress(int id, int userid) async {
    ExtResult res = await _api.delAddress(id, userid);
    return ResultConversion.excute(res, ResultTypes.AddressList);
  }

}