///
//  Generated code. Do not modify.
//  source: bitsflea.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/any.pb.dart' as $1;

class BaseReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('BaseReply',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'code', $pb.PbFieldType.O3)
    ..aOS(2, 'msg')
    ..aOM<$1.Any>(3, 'data', subBuilder: $1.Any.create)
    ..hasRequiredFields = false;

  BaseReply._() : super();
  factory BaseReply() => create();
  factory BaseReply.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory BaseReply.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  BaseReply clone() => BaseReply()..mergeFromMessage(this);
  BaseReply copyWith(void Function(BaseReply) updates) =>
      super.copyWith((message) => updates(message as BaseReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BaseReply create() => BaseReply._();
  BaseReply createEmptyInstance() => create();
  static $pb.PbList<BaseReply> createRepeated() => $pb.PbList<BaseReply>();
  @$core.pragma('dart2js:noInline')
  static BaseReply getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BaseReply>(create);
  static BaseReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get msg => $_getSZ(1);
  @$pb.TagNumber(2)
  set msg($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsg() => clearField(2);

  @$pb.TagNumber(3)
  $1.Any get data => $_getN(2);
  @$pb.TagNumber(3)
  set data($1.Any v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasData() => $_has(2);
  @$pb.TagNumber(3)
  void clearData() => clearField(3);
  @$pb.TagNumber(3)
  $1.Any ensureData() => $_ensure(2);
}

class FileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'file', $pb.PbFieldType.OY)
    ..aOS(2, 'name')
    ..hasRequiredFields = false;

  FileRequest._() : super();
  factory FileRequest() => create();
  factory FileRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory FileRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  FileRequest clone() => FileRequest()..mergeFromMessage(this);
  FileRequest copyWith(void Function(FileRequest) updates) =>
      super.copyWith((message) => updates(message as FileRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileRequest create() => FileRequest._();
  FileRequest createEmptyInstance() => create();
  static $pb.PbList<FileRequest> createRepeated() => $pb.PbList<FileRequest>();
  @$core.pragma('dart2js:noInline')
  static FileRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileRequest>(create);
  static FileRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get file => $_getN(0);
  @$pb.TagNumber(1)
  set file($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasFile() => $_has(0);
  @$pb.TagNumber(1)
  void clearFile() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class EosidRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EosidRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'eosid')
    ..hasRequiredFields = false;

  EosidRequest._() : super();
  factory EosidRequest() => create();
  factory EosidRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory EosidRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  EosidRequest clone() => EosidRequest()..mergeFromMessage(this);
  EosidRequest copyWith(void Function(EosidRequest) updates) =>
      super.copyWith((message) => updates(message as EosidRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EosidRequest create() => EosidRequest._();
  EosidRequest createEmptyInstance() => create();
  static $pb.PbList<EosidRequest> createRepeated() =>
      $pb.PbList<EosidRequest>();
  @$core.pragma('dart2js:noInline')
  static EosidRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<EosidRequest>(create);
  static EosidRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eosid => $_getSZ(0);
  @$pb.TagNumber(1)
  set eosid($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasEosid() => $_has(0);
  @$pb.TagNumber(1)
  void clearEosid() => clearField(1);
}

class User extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('User',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'userid', $pb.PbFieldType.O3)
    ..aOS(2, 'eosid')
    ..aOS(3, 'phone')
    ..a<$core.int>(4, 'status', $pb.PbFieldType.O3)
    ..aOS(5, 'nickname')
    ..aOS(6, 'head')
    ..a<$core.int>(7, 'creditValue', $pb.PbFieldType.O3,
        protoName: 'creditValue')
    ..aOS(8, 'referrer')
    ..aOS(9, 'lastActiveTime', protoName: 'lastActiveTime')
    ..a<$core.int>(10, 'postsTotal', $pb.PbFieldType.O3,
        protoName: 'postsTotal')
    ..a<$core.int>(11, 'sellTotal', $pb.PbFieldType.O3, protoName: 'sellTotal')
    ..a<$core.int>(12, 'buyTotal', $pb.PbFieldType.O3, protoName: 'buyTotal')
    ..a<$core.int>(13, 'referralTotal', $pb.PbFieldType.O3,
        protoName: 'referralTotal')
    ..aOS(14, 'point')
    ..aOB(15, 'isReviewer', protoName: 'isReviewer')
    ..a<$core.int>(16, 'followTotal', $pb.PbFieldType.O3,
        protoName: 'followTotal')
    ..a<$core.int>(17, 'favoriteTotal', $pb.PbFieldType.O3,
        protoName: 'favoriteTotal')
    ..a<$core.int>(18, 'fansTotal', $pb.PbFieldType.O3, protoName: 'fansTotal')
    ..aOS(19, 'authKey', protoName: 'authKey')
    ..hasRequiredFields = false;

  User._() : super();
  factory User() => create();
  factory User.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  User clone() => User()..mergeFromMessage(this);
  User copyWith(void Function(User) updates) =>
      super.copyWith((message) => updates(message as User));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get userid => $_getIZ(0);
  @$pb.TagNumber(1)
  set userid($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get eosid => $_getSZ(1);
  @$pb.TagNumber(2)
  set eosid($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasEosid() => $_has(1);
  @$pb.TagNumber(2)
  void clearEosid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get phone => $_getSZ(2);
  @$pb.TagNumber(3)
  set phone($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPhone() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhone() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get status => $_getIZ(3);
  @$pb.TagNumber(4)
  set status($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get nickname => $_getSZ(4);
  @$pb.TagNumber(5)
  set nickname($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasNickname() => $_has(4);
  @$pb.TagNumber(5)
  void clearNickname() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get head => $_getSZ(5);
  @$pb.TagNumber(6)
  set head($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasHead() => $_has(5);
  @$pb.TagNumber(6)
  void clearHead() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get creditValue => $_getIZ(6);
  @$pb.TagNumber(7)
  set creditValue($core.int v) {
    $_setSignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasCreditValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreditValue() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get referrer => $_getSZ(7);
  @$pb.TagNumber(8)
  set referrer($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasReferrer() => $_has(7);
  @$pb.TagNumber(8)
  void clearReferrer() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get lastActiveTime => $_getSZ(8);
  @$pb.TagNumber(9)
  set lastActiveTime($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasLastActiveTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastActiveTime() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get postsTotal => $_getIZ(9);
  @$pb.TagNumber(10)
  set postsTotal($core.int v) {
    $_setSignedInt32(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasPostsTotal() => $_has(9);
  @$pb.TagNumber(10)
  void clearPostsTotal() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get sellTotal => $_getIZ(10);
  @$pb.TagNumber(11)
  set sellTotal($core.int v) {
    $_setSignedInt32(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasSellTotal() => $_has(10);
  @$pb.TagNumber(11)
  void clearSellTotal() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get buyTotal => $_getIZ(11);
  @$pb.TagNumber(12)
  set buyTotal($core.int v) {
    $_setSignedInt32(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasBuyTotal() => $_has(11);
  @$pb.TagNumber(12)
  void clearBuyTotal() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get referralTotal => $_getIZ(12);
  @$pb.TagNumber(13)
  set referralTotal($core.int v) {
    $_setSignedInt32(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasReferralTotal() => $_has(12);
  @$pb.TagNumber(13)
  void clearReferralTotal() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get point => $_getSZ(13);
  @$pb.TagNumber(14)
  set point($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasPoint() => $_has(13);
  @$pb.TagNumber(14)
  void clearPoint() => clearField(14);

  @$pb.TagNumber(15)
  $core.bool get isReviewer => $_getBF(14);
  @$pb.TagNumber(15)
  set isReviewer($core.bool v) {
    $_setBool(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasIsReviewer() => $_has(14);
  @$pb.TagNumber(15)
  void clearIsReviewer() => clearField(15);

  @$pb.TagNumber(16)
  $core.int get followTotal => $_getIZ(15);
  @$pb.TagNumber(16)
  set followTotal($core.int v) {
    $_setSignedInt32(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasFollowTotal() => $_has(15);
  @$pb.TagNumber(16)
  void clearFollowTotal() => clearField(16);

  @$pb.TagNumber(17)
  $core.int get favoriteTotal => $_getIZ(16);
  @$pb.TagNumber(17)
  set favoriteTotal($core.int v) {
    $_setSignedInt32(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasFavoriteTotal() => $_has(16);
  @$pb.TagNumber(17)
  void clearFavoriteTotal() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get fansTotal => $_getIZ(17);
  @$pb.TagNumber(18)
  set fansTotal($core.int v) {
    $_setSignedInt32(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasFansTotal() => $_has(17);
  @$pb.TagNumber(18)
  void clearFansTotal() => clearField(18);

  @$pb.TagNumber(19)
  $core.String get authKey => $_getSZ(18);
  @$pb.TagNumber(19)
  set authKey($core.String v) {
    $_setString(18, v);
  }

  @$pb.TagNumber(19)
  $core.bool hasAuthKey() => $_has(18);
  @$pb.TagNumber(19)
  void clearAuthKey() => clearField(19);
}

class RegisterRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RegisterRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'phone')
    ..aOS(2, 'nickname')
    ..aOS(3, 'ownerpubkey')
    ..aOS(4, 'actpubkey')
    ..aOS(5, 'smscode')
    ..aOS(6, 'referral')
    ..aOS(7, 'authkey')
    ..aOS(8, 'phoneEncrypt', protoName: 'phoneEncrypt')
    ..hasRequiredFields = false;

  RegisterRequest._() : super();
  factory RegisterRequest() => create();
  factory RegisterRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RegisterRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  RegisterRequest clone() => RegisterRequest()..mergeFromMessage(this);
  RegisterRequest copyWith(void Function(RegisterRequest) updates) =>
      super.copyWith((message) => updates(message as RegisterRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegisterRequest create() => RegisterRequest._();
  RegisterRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterRequest> createRepeated() =>
      $pb.PbList<RegisterRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RegisterRequest>(create);
  static RegisterRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phone => $_getSZ(0);
  @$pb.TagNumber(1)
  set phone($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPhone() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhone() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get nickname => $_getSZ(1);
  @$pb.TagNumber(2)
  set nickname($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasNickname() => $_has(1);
  @$pb.TagNumber(2)
  void clearNickname() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerpubkey => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerpubkey($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasOwnerpubkey() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerpubkey() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get actpubkey => $_getSZ(3);
  @$pb.TagNumber(4)
  set actpubkey($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasActpubkey() => $_has(3);
  @$pb.TagNumber(4)
  void clearActpubkey() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get smscode => $_getSZ(4);
  @$pb.TagNumber(5)
  set smscode($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasSmscode() => $_has(4);
  @$pb.TagNumber(5)
  void clearSmscode() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get referral => $_getSZ(5);
  @$pb.TagNumber(6)
  set referral($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasReferral() => $_has(5);
  @$pb.TagNumber(6)
  void clearReferral() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get authkey => $_getSZ(6);
  @$pb.TagNumber(7)
  set authkey($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasAuthkey() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthkey() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get phoneEncrypt => $_getSZ(7);
  @$pb.TagNumber(8)
  set phoneEncrypt($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPhoneEncrypt() => $_has(7);
  @$pb.TagNumber(8)
  void clearPhoneEncrypt() => clearField(8);
}

class SmsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SmsRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'phone')
    ..a<$core.int>(2, 'codeType', $pb.PbFieldType.O3, protoName: 'codeType')
    ..hasRequiredFields = false;

  SmsRequest._() : super();
  factory SmsRequest() => create();
  factory SmsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SmsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SmsRequest clone() => SmsRequest()..mergeFromMessage(this);
  SmsRequest copyWith(void Function(SmsRequest) updates) =>
      super.copyWith((message) => updates(message as SmsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SmsRequest create() => SmsRequest._();
  SmsRequest createEmptyInstance() => create();
  static $pb.PbList<SmsRequest> createRepeated() => $pb.PbList<SmsRequest>();
  @$core.pragma('dart2js:noInline')
  static SmsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SmsRequest>(create);
  static SmsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phone => $_getSZ(0);
  @$pb.TagNumber(1)
  set phone($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPhone() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhone() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get codeType => $_getIZ(1);
  @$pb.TagNumber(2)
  set codeType($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCodeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearCodeType() => clearField(2);
}

class RefreshTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RefreshTokenRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'phone')
    ..aOS(2, 'token')
    ..a<$core.int>(3, 'time', $pb.PbFieldType.O3)
    ..aOS(4, 'sign')
    ..hasRequiredFields = false;

  RefreshTokenRequest._() : super();
  factory RefreshTokenRequest() => create();
  factory RefreshTokenRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RefreshTokenRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  RefreshTokenRequest clone() => RefreshTokenRequest()..mergeFromMessage(this);
  RefreshTokenRequest copyWith(void Function(RefreshTokenRequest) updates) =>
      super.copyWith((message) => updates(message as RefreshTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RefreshTokenRequest create() => RefreshTokenRequest._();
  RefreshTokenRequest createEmptyInstance() => create();
  static $pb.PbList<RefreshTokenRequest> createRepeated() =>
      $pb.PbList<RefreshTokenRequest>();
  @$core.pragma('dart2js:noInline')
  static RefreshTokenRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RefreshTokenRequest>(create);
  static RefreshTokenRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phone => $_getSZ(0);
  @$pb.TagNumber(1)
  set phone($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPhone() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhone() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get time => $_getIZ(2);
  @$pb.TagNumber(3)
  set time($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sign => $_getSZ(3);
  @$pb.TagNumber(4)
  set sign($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSign() => $_has(3);
  @$pb.TagNumber(4)
  void clearSign() => clearField(4);
}

class Category extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Category',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'cid', $pb.PbFieldType.O3)
    ..aOS(2, 'view')
    ..a<$core.int>(3, 'parent', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  Category._() : super();
  factory Category() => create();
  factory Category.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Category.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Category clone() => Category()..mergeFromMessage(this);
  Category copyWith(void Function(Category) updates) =>
      super.copyWith((message) => updates(message as Category));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Category create() => Category._();
  Category createEmptyInstance() => create();
  static $pb.PbList<Category> createRepeated() => $pb.PbList<Category>();
  @$core.pragma('dart2js:noInline')
  static Category getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Category>(create);
  static Category _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get cid => $_getIZ(0);
  @$pb.TagNumber(1)
  set cid($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCid() => $_has(0);
  @$pb.TagNumber(1)
  void clearCid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get view => $_getSZ(1);
  @$pb.TagNumber(2)
  set view($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasView() => $_has(1);
  @$pb.TagNumber(2)
  void clearView() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get parent => $_getIZ(2);
  @$pb.TagNumber(3)
  set parent($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasParent() => $_has(2);
  @$pb.TagNumber(3)
  void clearParent() => clearField(3);
}

class Product extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Product',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'productId', $pb.PbFieldType.OU3, protoName: 'productId')
    ..aOM<Category>(2, 'category', subBuilder: Category.create)
    ..aOS(3, 'title')
    ..a<$core.int>(4, 'status', $pb.PbFieldType.OU3)
    ..aOB(5, 'isNew', protoName: 'isNew')
    ..aOB(6, 'isReturns', protoName: 'isReturns')
    ..a<$core.int>(7, 'transMethod', $pb.PbFieldType.OU3,
        protoName: 'transMethod')
    ..aOS(8, 'postage')
    ..aOS(9, 'position')
    ..aOS(10, 'releaseTime', protoName: 'releaseTime')
    ..aOS(11, 'description')
    ..pPS(12, 'photos')
    ..a<$core.int>(13, 'collections', $pb.PbFieldType.OU3)
    ..aOS(14, 'price')
    ..a<$core.int>(15, 'saleMethod', $pb.PbFieldType.OU3,
        protoName: 'saleMethod')
    ..aOM<User>(16, 'seller', subBuilder: User.create)
    ..a<$core.int>(17, 'stockCount', $pb.PbFieldType.OU3,
        protoName: 'stockCount')
    ..aOB(18, 'isRetail', protoName: 'isRetail')
    ..hasRequiredFields = false;

  Product._() : super();
  factory Product() => create();
  factory Product.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Product.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Product clone() => Product()..mergeFromMessage(this);
  Product copyWith(void Function(Product) updates) =>
      super.copyWith((message) => updates(message as Product));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Product create() => Product._();
  Product createEmptyInstance() => create();
  static $pb.PbList<Product> createRepeated() => $pb.PbList<Product>();
  @$core.pragma('dart2js:noInline')
  static Product getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Product>(create);
  static Product _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get productId => $_getIZ(0);
  @$pb.TagNumber(1)
  set productId($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasProductId() => $_has(0);
  @$pb.TagNumber(1)
  void clearProductId() => clearField(1);

  @$pb.TagNumber(2)
  Category get category => $_getN(1);
  @$pb.TagNumber(2)
  set category(Category v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$pb.TagNumber(2)
  void clearCategory() => clearField(2);
  @$pb.TagNumber(2)
  Category ensureCategory() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get status => $_getIZ(3);
  @$pb.TagNumber(4)
  set status($core.int v) {
    $_setUnsignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get isNew => $_getBF(4);
  @$pb.TagNumber(5)
  set isNew($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasIsNew() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsNew() => clearField(5);

  @$pb.TagNumber(6)
  $core.bool get isReturns => $_getBF(5);
  @$pb.TagNumber(6)
  set isReturns($core.bool v) {
    $_setBool(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasIsReturns() => $_has(5);
  @$pb.TagNumber(6)
  void clearIsReturns() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get transMethod => $_getIZ(6);
  @$pb.TagNumber(7)
  set transMethod($core.int v) {
    $_setUnsignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasTransMethod() => $_has(6);
  @$pb.TagNumber(7)
  void clearTransMethod() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get postage => $_getSZ(7);
  @$pb.TagNumber(8)
  set postage($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPostage() => $_has(7);
  @$pb.TagNumber(8)
  void clearPostage() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get position => $_getSZ(8);
  @$pb.TagNumber(9)
  set position($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPosition() => $_has(8);
  @$pb.TagNumber(9)
  void clearPosition() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get releaseTime => $_getSZ(9);
  @$pb.TagNumber(10)
  set releaseTime($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasReleaseTime() => $_has(9);
  @$pb.TagNumber(10)
  void clearReleaseTime() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get description => $_getSZ(10);
  @$pb.TagNumber(11)
  set description($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasDescription() => $_has(10);
  @$pb.TagNumber(11)
  void clearDescription() => clearField(11);

  @$pb.TagNumber(12)
  $core.List<$core.String> get photos => $_getList(11);

  @$pb.TagNumber(13)
  $core.int get collections => $_getIZ(12);
  @$pb.TagNumber(13)
  set collections($core.int v) {
    $_setUnsignedInt32(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasCollections() => $_has(12);
  @$pb.TagNumber(13)
  void clearCollections() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get price => $_getSZ(13);
  @$pb.TagNumber(14)
  set price($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasPrice() => $_has(13);
  @$pb.TagNumber(14)
  void clearPrice() => clearField(14);

  @$pb.TagNumber(15)
  $core.int get saleMethod => $_getIZ(14);
  @$pb.TagNumber(15)
  set saleMethod($core.int v) {
    $_setUnsignedInt32(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasSaleMethod() => $_has(14);
  @$pb.TagNumber(15)
  void clearSaleMethod() => clearField(15);

  @$pb.TagNumber(16)
  User get seller => $_getN(15);
  @$pb.TagNumber(16)
  set seller(User v) {
    setField(16, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasSeller() => $_has(15);
  @$pb.TagNumber(16)
  void clearSeller() => clearField(16);
  @$pb.TagNumber(16)
  User ensureSeller() => $_ensure(15);

  @$pb.TagNumber(17)
  $core.int get stockCount => $_getIZ(16);
  @$pb.TagNumber(17)
  set stockCount($core.int v) {
    $_setUnsignedInt32(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasStockCount() => $_has(16);
  @$pb.TagNumber(17)
  void clearStockCount() => clearField(17);

  @$pb.TagNumber(18)
  $core.bool get isRetail => $_getBF(17);
  @$pb.TagNumber(18)
  set isRetail($core.bool v) {
    $_setBool(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasIsRetail() => $_has(17);
  @$pb.TagNumber(18)
  void clearIsRetail() => clearField(18);
}

class Auction extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Auction',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'aid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Product>(2, 'product', subBuilder: Product.create)
    ..aOS(3, 'security')
    ..aOS(4, 'markup')
    ..aOS(5, 'currentPrice', protoName: 'currentPrice')
    ..a<$core.int>(6, 'auctionTimes', $pb.PbFieldType.OU3,
        protoName: 'auctionTimes')
    ..aOM<User>(7, 'lastPriceUser',
        protoName: 'lastPriceUser', subBuilder: User.create)
    ..aOS(8, 'startTime', protoName: 'startTime')
    ..aOS(9, 'endTime', protoName: 'endTime')
    ..hasRequiredFields = false;

  Auction._() : super();
  factory Auction() => create();
  factory Auction.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Auction.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Auction clone() => Auction()..mergeFromMessage(this);
  Auction copyWith(void Function(Auction) updates) =>
      super.copyWith((message) => updates(message as Auction));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Auction create() => Auction._();
  Auction createEmptyInstance() => create();
  static $pb.PbList<Auction> createRepeated() => $pb.PbList<Auction>();
  @$core.pragma('dart2js:noInline')
  static Auction getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Auction>(create);
  static Auction _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get aid => $_getI64(0);
  @$pb.TagNumber(1)
  set aid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => clearField(1);

  @$pb.TagNumber(2)
  Product get product => $_getN(1);
  @$pb.TagNumber(2)
  set product(Product v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProduct() => $_has(1);
  @$pb.TagNumber(2)
  void clearProduct() => clearField(2);
  @$pb.TagNumber(2)
  Product ensureProduct() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get security => $_getSZ(2);
  @$pb.TagNumber(3)
  set security($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSecurity() => $_has(2);
  @$pb.TagNumber(3)
  void clearSecurity() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get markup => $_getSZ(3);
  @$pb.TagNumber(4)
  set markup($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMarkup() => $_has(3);
  @$pb.TagNumber(4)
  void clearMarkup() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get currentPrice => $_getSZ(4);
  @$pb.TagNumber(5)
  set currentPrice($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCurrentPrice() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentPrice() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get auctionTimes => $_getIZ(5);
  @$pb.TagNumber(6)
  set auctionTimes($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasAuctionTimes() => $_has(5);
  @$pb.TagNumber(6)
  void clearAuctionTimes() => clearField(6);

  @$pb.TagNumber(7)
  User get lastPriceUser => $_getN(6);
  @$pb.TagNumber(7)
  set lastPriceUser(User v) {
    setField(7, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasLastPriceUser() => $_has(6);
  @$pb.TagNumber(7)
  void clearLastPriceUser() => clearField(7);
  @$pb.TagNumber(7)
  User ensureLastPriceUser() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.String get startTime => $_getSZ(7);
  @$pb.TagNumber(8)
  set startTime($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasStartTime() => $_has(7);
  @$pb.TagNumber(8)
  void clearStartTime() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get endTime => $_getSZ(8);
  @$pb.TagNumber(9)
  set endTime($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasEndTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearEndTime() => clearField(9);
}

class SearchRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SearchRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'query')
    ..hasRequiredFields = false;

  SearchRequest._() : super();
  factory SearchRequest() => create();
  factory SearchRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SearchRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SearchRequest clone() => SearchRequest()..mergeFromMessage(this);
  SearchRequest copyWith(void Function(SearchRequest) updates) =>
      super.copyWith((message) => updates(message as SearchRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SearchRequest create() => SearchRequest._();
  SearchRequest createEmptyInstance() => create();
  static $pb.PbList<SearchRequest> createRepeated() =>
      $pb.PbList<SearchRequest>();
  @$core.pragma('dart2js:noInline')
  static SearchRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SearchRequest>(create);
  static SearchRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);
}

class TransactionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TransactionRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'trx')
    ..a<$core.int>(2, 'sign', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  TransactionRequest._() : super();
  factory TransactionRequest() => create();
  factory TransactionRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory TransactionRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  TransactionRequest clone() => TransactionRequest()..mergeFromMessage(this);
  TransactionRequest copyWith(void Function(TransactionRequest) updates) =>
      super.copyWith((message) => updates(message as TransactionRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TransactionRequest create() => TransactionRequest._();
  TransactionRequest createEmptyInstance() => create();
  static $pb.PbList<TransactionRequest> createRepeated() =>
      $pb.PbList<TransactionRequest>();
  @$core.pragma('dart2js:noInline')
  static TransactionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TransactionRequest>(create);
  static TransactionRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trx => $_getSZ(0);
  @$pb.TagNumber(1)
  set trx($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTrx() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrx() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get sign => $_getIZ(1);
  @$pb.TagNumber(2)
  set sign($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasSign() => $_has(1);
  @$pb.TagNumber(2)
  void clearSign() => clearField(2);
}

class FollowRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FollowRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'user', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'follower', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  FollowRequest._() : super();
  factory FollowRequest() => create();
  factory FollowRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory FollowRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  FollowRequest clone() => FollowRequest()..mergeFromMessage(this);
  FollowRequest copyWith(void Function(FollowRequest) updates) =>
      super.copyWith((message) => updates(message as FollowRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FollowRequest create() => FollowRequest._();
  FollowRequest createEmptyInstance() => create();
  static $pb.PbList<FollowRequest> createRepeated() =>
      $pb.PbList<FollowRequest>();
  @$core.pragma('dart2js:noInline')
  static FollowRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FollowRequest>(create);
  static FollowRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get user => $_getIZ(0);
  @$pb.TagNumber(1)
  set user($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get follower => $_getIZ(1);
  @$pb.TagNumber(2)
  set follower($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasFollower() => $_has(1);
  @$pb.TagNumber(2)
  void clearFollower() => clearField(2);
}

class FavoriteRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FavoriteRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'user', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'product', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  FavoriteRequest._() : super();
  factory FavoriteRequest() => create();
  factory FavoriteRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory FavoriteRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  FavoriteRequest clone() => FavoriteRequest()..mergeFromMessage(this);
  FavoriteRequest copyWith(void Function(FavoriteRequest) updates) =>
      super.copyWith((message) => updates(message as FavoriteRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FavoriteRequest create() => FavoriteRequest._();
  FavoriteRequest createEmptyInstance() => create();
  static $pb.PbList<FavoriteRequest> createRepeated() =>
      $pb.PbList<FavoriteRequest>();
  @$core.pragma('dart2js:noInline')
  static FavoriteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavoriteRequest>(create);
  static FavoriteRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get user => $_getIZ(0);
  @$pb.TagNumber(1)
  set user($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get product => $_getIZ(1);
  @$pb.TagNumber(2)
  set product($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProduct() => $_has(1);
  @$pb.TagNumber(2)
  void clearProduct() => clearField(2);
}

class AddressRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddressRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'rid', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'userid', $pb.PbFieldType.O3)
    ..aOS(3, 'province')
    ..aOS(4, 'city')
    ..aOS(5, 'district')
    ..aOS(6, 'phone')
    ..aOS(7, 'name')
    ..aOS(8, 'address')
    ..aOS(9, 'postcode')
    ..aOB(10, 'isDefault', protoName: 'isDefault')
    ..hasRequiredFields = false;

  AddressRequest._() : super();
  factory AddressRequest() => create();
  factory AddressRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory AddressRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  AddressRequest clone() => AddressRequest()..mergeFromMessage(this);
  AddressRequest copyWith(void Function(AddressRequest) updates) =>
      super.copyWith((message) => updates(message as AddressRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddressRequest create() => AddressRequest._();
  AddressRequest createEmptyInstance() => create();
  static $pb.PbList<AddressRequest> createRepeated() =>
      $pb.PbList<AddressRequest>();
  @$core.pragma('dart2js:noInline')
  static AddressRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddressRequest>(create);
  static AddressRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get rid => $_getIZ(0);
  @$pb.TagNumber(1)
  set rid($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get userid => $_getIZ(1);
  @$pb.TagNumber(2)
  set userid($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUserid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get province => $_getSZ(2);
  @$pb.TagNumber(3)
  set province($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasProvince() => $_has(2);
  @$pb.TagNumber(3)
  void clearProvince() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get city => $_getSZ(3);
  @$pb.TagNumber(4)
  set city($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCity() => $_has(3);
  @$pb.TagNumber(4)
  void clearCity() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get district => $_getSZ(4);
  @$pb.TagNumber(5)
  set district($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDistrict() => $_has(4);
  @$pb.TagNumber(5)
  void clearDistrict() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get phone => $_getSZ(5);
  @$pb.TagNumber(6)
  set phone($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPhone() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhone() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get name => $_getSZ(6);
  @$pb.TagNumber(7)
  set name($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasName() => $_has(6);
  @$pb.TagNumber(7)
  void clearName() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get address => $_getSZ(7);
  @$pb.TagNumber(8)
  set address($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasAddress() => $_has(7);
  @$pb.TagNumber(8)
  void clearAddress() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get postcode => $_getSZ(8);
  @$pb.TagNumber(9)
  set postcode($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPostcode() => $_has(8);
  @$pb.TagNumber(9)
  void clearPostcode() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isDefault => $_getBF(9);
  @$pb.TagNumber(10)
  set isDefault($core.bool v) {
    $_setBool(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasIsDefault() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsDefault() => clearField(10);
}

class SetDefaultAddrRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SetDefaultAddrRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'userid', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'rid', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  SetDefaultAddrRequest._() : super();
  factory SetDefaultAddrRequest() => create();
  factory SetDefaultAddrRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SetDefaultAddrRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  SetDefaultAddrRequest clone() =>
      SetDefaultAddrRequest()..mergeFromMessage(this);
  SetDefaultAddrRequest copyWith(
          void Function(SetDefaultAddrRequest) updates) =>
      super.copyWith((message) => updates(message as SetDefaultAddrRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SetDefaultAddrRequest create() => SetDefaultAddrRequest._();
  SetDefaultAddrRequest createEmptyInstance() => create();
  static $pb.PbList<SetDefaultAddrRequest> createRepeated() =>
      $pb.PbList<SetDefaultAddrRequest>();
  @$core.pragma('dart2js:noInline')
  static SetDefaultAddrRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SetDefaultAddrRequest>(create);
  static SetDefaultAddrRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get userid => $_getIZ(0);
  @$pb.TagNumber(1)
  set userid($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get rid => $_getIZ(1);
  @$pb.TagNumber(2)
  set rid($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRid() => $_has(1);
  @$pb.TagNumber(2)
  void clearRid() => clearField(2);
}

class Reviewer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Reviewer',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'rid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<User>(2, 'user', subBuilder: User.create)
    ..aOS(3, 'eosid')
    ..a<$core.int>(4, 'votedCount', $pb.PbFieldType.O3, protoName: 'votedCount')
    ..aOS(5, 'createTime', protoName: 'createTime')
    ..aOS(6, 'lastActiveTime', protoName: 'lastActiveTime')
    ..p<$fixnum.Int64>(7, 'voterApprove', $pb.PbFieldType.PU6,
        protoName: 'voterApprove')
    ..p<$fixnum.Int64>(8, 'voterAgainst', $pb.PbFieldType.PU6,
        protoName: 'voterAgainst')
    ..hasRequiredFields = false;

  Reviewer._() : super();
  factory Reviewer() => create();
  factory Reviewer.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Reviewer.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Reviewer clone() => Reviewer()..mergeFromMessage(this);
  Reviewer copyWith(void Function(Reviewer) updates) =>
      super.copyWith((message) => updates(message as Reviewer));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Reviewer create() => Reviewer._();
  Reviewer createEmptyInstance() => create();
  static $pb.PbList<Reviewer> createRepeated() => $pb.PbList<Reviewer>();
  @$core.pragma('dart2js:noInline')
  static Reviewer getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Reviewer>(create);
  static Reviewer _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get rid => $_getI64(0);
  @$pb.TagNumber(1)
  set rid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRid() => clearField(1);

  @$pb.TagNumber(2)
  User get user => $_getN(1);
  @$pb.TagNumber(2)
  set user(User v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => clearField(2);
  @$pb.TagNumber(2)
  User ensureUser() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get eosid => $_getSZ(2);
  @$pb.TagNumber(3)
  set eosid($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasEosid() => $_has(2);
  @$pb.TagNumber(3)
  void clearEosid() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get votedCount => $_getIZ(3);
  @$pb.TagNumber(4)
  set votedCount($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasVotedCount() => $_has(3);
  @$pb.TagNumber(4)
  void clearVotedCount() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get createTime => $_getSZ(4);
  @$pb.TagNumber(5)
  set createTime($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCreateTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreateTime() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get lastActiveTime => $_getSZ(5);
  @$pb.TagNumber(6)
  set lastActiveTime($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasLastActiveTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearLastActiveTime() => clearField(6);

  @$pb.TagNumber(7)
  $core.List<$fixnum.Int64> get voterApprove => $_getList(6);

  @$pb.TagNumber(8)
  $core.List<$fixnum.Int64> get voterAgainst => $_getList(7);
}

class ProductAudit extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ProductAudit',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'paid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<Product>(2, 'product', subBuilder: Product.create)
    ..aOM<User>(3, 'reviewer', subBuilder: User.create)
    ..aOB(4, 'isDelisted', protoName: 'isDelisted')
    ..aOS(5, 'reviewDetails', protoName: 'reviewDetails')
    ..aOS(6, 'reviewTime', protoName: 'reviewTime')
    ..hasRequiredFields = false;

  ProductAudit._() : super();
  factory ProductAudit() => create();
  factory ProductAudit.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ProductAudit.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ProductAudit clone() => ProductAudit()..mergeFromMessage(this);
  ProductAudit copyWith(void Function(ProductAudit) updates) =>
      super.copyWith((message) => updates(message as ProductAudit));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProductAudit create() => ProductAudit._();
  ProductAudit createEmptyInstance() => create();
  static $pb.PbList<ProductAudit> createRepeated() =>
      $pb.PbList<ProductAudit>();
  @$core.pragma('dart2js:noInline')
  static ProductAudit getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProductAudit>(create);
  static ProductAudit _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get paid => $_getI64(0);
  @$pb.TagNumber(1)
  set paid($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPaid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaid() => clearField(1);

  @$pb.TagNumber(2)
  Product get product => $_getN(1);
  @$pb.TagNumber(2)
  set product(Product v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProduct() => $_has(1);
  @$pb.TagNumber(2)
  void clearProduct() => clearField(2);
  @$pb.TagNumber(2)
  Product ensureProduct() => $_ensure(1);

  @$pb.TagNumber(3)
  User get reviewer => $_getN(2);
  @$pb.TagNumber(3)
  set reviewer(User v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasReviewer() => $_has(2);
  @$pb.TagNumber(3)
  void clearReviewer() => clearField(3);
  @$pb.TagNumber(3)
  User ensureReviewer() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get isDelisted => $_getBF(3);
  @$pb.TagNumber(4)
  set isDelisted($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasIsDelisted() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsDelisted() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get reviewDetails => $_getSZ(4);
  @$pb.TagNumber(5)
  set reviewDetails($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasReviewDetails() => $_has(4);
  @$pb.TagNumber(5)
  void clearReviewDetails() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get reviewTime => $_getSZ(5);
  @$pb.TagNumber(6)
  set reviewTime($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasReviewTime() => $_has(5);
  @$pb.TagNumber(6)
  void clearReviewTime() => clearField(6);
}

class Order extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Order',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'orderid')
    ..aOM<Product>(2, 'productInfo',
        protoName: 'productInfo', subBuilder: Product.create)
    ..aOM<User>(3, 'seller', subBuilder: User.create)
    ..aOM<User>(4, 'buyer', subBuilder: User.create)
    ..a<$core.int>(5, 'status', $pb.PbFieldType.OU3)
    ..aOS(6, 'price')
    ..aOS(7, 'postage')
    ..aOS(8, 'payAddr', protoName: 'payAddr')
    ..aOS(9, 'shipNum', protoName: 'shipNum')
    ..aOS(10, 'createTime', protoName: 'createTime')
    ..aOS(11, 'payTime', protoName: 'payTime')
    ..aOS(12, 'payOutTime', protoName: 'payOutTime')
    ..aOS(13, 'shipTime', protoName: 'shipTime')
    ..aOS(14, 'shipOutTime', protoName: 'shipOutTime')
    ..aOS(15, 'receiptTime', protoName: 'receiptTime')
    ..aOS(16, 'receiptOutTime', protoName: 'receiptOutTime')
    ..aOS(17, 'endTime', protoName: 'endTime')
    ..a<$core.int>(18, 'delayedCount', $pb.PbFieldType.OU3,
        protoName: 'delayedCount')
    ..hasRequiredFields = false;

  Order._() : super();
  factory Order() => create();
  factory Order.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Order.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Order clone() => Order()..mergeFromMessage(this);
  Order copyWith(void Function(Order) updates) =>
      super.copyWith((message) => updates(message as Order));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Order create() => Order._();
  Order createEmptyInstance() => create();
  static $pb.PbList<Order> createRepeated() => $pb.PbList<Order>();
  @$core.pragma('dart2js:noInline')
  static Order getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Order>(create);
  static Order _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderid => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderid($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOrderid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderid() => clearField(1);

  @$pb.TagNumber(2)
  Product get productInfo => $_getN(1);
  @$pb.TagNumber(2)
  set productInfo(Product v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProductInfo() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductInfo() => clearField(2);
  @$pb.TagNumber(2)
  Product ensureProductInfo() => $_ensure(1);

  @$pb.TagNumber(3)
  User get seller => $_getN(2);
  @$pb.TagNumber(3)
  set seller(User v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSeller() => $_has(2);
  @$pb.TagNumber(3)
  void clearSeller() => clearField(3);
  @$pb.TagNumber(3)
  User ensureSeller() => $_ensure(2);

  @$pb.TagNumber(4)
  User get buyer => $_getN(3);
  @$pb.TagNumber(4)
  set buyer(User v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasBuyer() => $_has(3);
  @$pb.TagNumber(4)
  void clearBuyer() => clearField(4);
  @$pb.TagNumber(4)
  User ensureBuyer() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.int get status => $_getIZ(4);
  @$pb.TagNumber(5)
  set status($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get price => $_getSZ(5);
  @$pb.TagNumber(6)
  set price($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPrice() => $_has(5);
  @$pb.TagNumber(6)
  void clearPrice() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get postage => $_getSZ(6);
  @$pb.TagNumber(7)
  set postage($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPostage() => $_has(6);
  @$pb.TagNumber(7)
  void clearPostage() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get payAddr => $_getSZ(7);
  @$pb.TagNumber(8)
  set payAddr($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasPayAddr() => $_has(7);
  @$pb.TagNumber(8)
  void clearPayAddr() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get shipNum => $_getSZ(8);
  @$pb.TagNumber(9)
  set shipNum($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasShipNum() => $_has(8);
  @$pb.TagNumber(9)
  void clearShipNum() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get createTime => $_getSZ(9);
  @$pb.TagNumber(10)
  set createTime($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasCreateTime() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreateTime() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get payTime => $_getSZ(10);
  @$pb.TagNumber(11)
  set payTime($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasPayTime() => $_has(10);
  @$pb.TagNumber(11)
  void clearPayTime() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get payOutTime => $_getSZ(11);
  @$pb.TagNumber(12)
  set payOutTime($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasPayOutTime() => $_has(11);
  @$pb.TagNumber(12)
  void clearPayOutTime() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get shipTime => $_getSZ(12);
  @$pb.TagNumber(13)
  set shipTime($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasShipTime() => $_has(12);
  @$pb.TagNumber(13)
  void clearShipTime() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get shipOutTime => $_getSZ(13);
  @$pb.TagNumber(14)
  set shipOutTime($core.String v) {
    $_setString(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasShipOutTime() => $_has(13);
  @$pb.TagNumber(14)
  void clearShipOutTime() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get receiptTime => $_getSZ(14);
  @$pb.TagNumber(15)
  set receiptTime($core.String v) {
    $_setString(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasReceiptTime() => $_has(14);
  @$pb.TagNumber(15)
  void clearReceiptTime() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get receiptOutTime => $_getSZ(15);
  @$pb.TagNumber(16)
  set receiptOutTime($core.String v) {
    $_setString(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasReceiptOutTime() => $_has(15);
  @$pb.TagNumber(16)
  void clearReceiptOutTime() => clearField(16);

  @$pb.TagNumber(17)
  $core.String get endTime => $_getSZ(16);
  @$pb.TagNumber(17)
  set endTime($core.String v) {
    $_setString(16, v);
  }

  @$pb.TagNumber(17)
  $core.bool hasEndTime() => $_has(16);
  @$pb.TagNumber(17)
  void clearEndTime() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get delayedCount => $_getIZ(17);
  @$pb.TagNumber(18)
  set delayedCount($core.int v) {
    $_setUnsignedInt32(17, v);
  }

  @$pb.TagNumber(18)
  $core.bool hasDelayedCount() => $_has(17);
  @$pb.TagNumber(18)
  void clearDelayedCount() => clearField(18);
}

class ProReturn extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ProReturn',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'prid', $pb.PbFieldType.OU3)
    ..aOS(2, 'order')
    ..a<$core.int>(3, 'product', $pb.PbFieldType.OU3)
    ..aOS(4, 'orderPrice', protoName: 'orderPrice')
    ..a<$core.int>(5, 'status', $pb.PbFieldType.OU3)
    ..aOS(6, 'reasons')
    ..aOS(7, 'createTime', protoName: 'createTime')
    ..aOS(8, 'shipNum', protoName: 'shipNum')
    ..aOS(9, 'shipTime', protoName: 'shipTime')
    ..aOS(10, 'shipOutTime', protoName: 'shipOutTime')
    ..aOS(11, 'receiptTime', protoName: 'receiptTime')
    ..aOS(12, 'receiptOutTime', protoName: 'receiptOutTime')
    ..aOS(13, 'endTime', protoName: 'endTime')
    ..a<$core.int>(14, 'delayedCount', $pb.PbFieldType.OU3,
        protoName: 'delayedCount')
    ..hasRequiredFields = false;

  ProReturn._() : super();
  factory ProReturn() => create();
  factory ProReturn.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ProReturn.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ProReturn clone() => ProReturn()..mergeFromMessage(this);
  ProReturn copyWith(void Function(ProReturn) updates) =>
      super.copyWith((message) => updates(message as ProReturn));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ProReturn create() => ProReturn._();
  ProReturn createEmptyInstance() => create();
  static $pb.PbList<ProReturn> createRepeated() => $pb.PbList<ProReturn>();
  @$core.pragma('dart2js:noInline')
  static ProReturn getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProReturn>(create);
  static ProReturn _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get prid => $_getIZ(0);
  @$pb.TagNumber(1)
  set prid($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPrid() => $_has(0);
  @$pb.TagNumber(1)
  void clearPrid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get order => $_getSZ(1);
  @$pb.TagNumber(2)
  set order($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasOrder() => $_has(1);
  @$pb.TagNumber(2)
  void clearOrder() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get product => $_getIZ(2);
  @$pb.TagNumber(3)
  set product($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasProduct() => $_has(2);
  @$pb.TagNumber(3)
  void clearProduct() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get orderPrice => $_getSZ(3);
  @$pb.TagNumber(4)
  set orderPrice($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasOrderPrice() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrderPrice() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get status => $_getIZ(4);
  @$pb.TagNumber(5)
  set status($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(5)
  void clearStatus() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get reasons => $_getSZ(5);
  @$pb.TagNumber(6)
  set reasons($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasReasons() => $_has(5);
  @$pb.TagNumber(6)
  void clearReasons() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get createTime => $_getSZ(6);
  @$pb.TagNumber(7)
  set createTime($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasCreateTime() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreateTime() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get shipNum => $_getSZ(7);
  @$pb.TagNumber(8)
  set shipNum($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasShipNum() => $_has(7);
  @$pb.TagNumber(8)
  void clearShipNum() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get shipTime => $_getSZ(8);
  @$pb.TagNumber(9)
  set shipTime($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasShipTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearShipTime() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get shipOutTime => $_getSZ(9);
  @$pb.TagNumber(10)
  set shipOutTime($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasShipOutTime() => $_has(9);
  @$pb.TagNumber(10)
  void clearShipOutTime() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get receiptTime => $_getSZ(10);
  @$pb.TagNumber(11)
  set receiptTime($core.String v) {
    $_setString(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasReceiptTime() => $_has(10);
  @$pb.TagNumber(11)
  void clearReceiptTime() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get receiptOutTime => $_getSZ(11);
  @$pb.TagNumber(12)
  set receiptOutTime($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasReceiptOutTime() => $_has(11);
  @$pb.TagNumber(12)
  void clearReceiptOutTime() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get endTime => $_getSZ(12);
  @$pb.TagNumber(13)
  set endTime($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasEndTime() => $_has(12);
  @$pb.TagNumber(13)
  void clearEndTime() => clearField(13);

  @$pb.TagNumber(14)
  $core.int get delayedCount => $_getIZ(13);
  @$pb.TagNumber(14)
  set delayedCount($core.int v) {
    $_setUnsignedInt32(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasDelayedCount() => $_has(13);
  @$pb.TagNumber(14)
  void clearDelayedCount() => clearField(14);
}

class Arbitration extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Arbitration',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'aid', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(2, 'plaintiff', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(3, 'product', $pb.PbFieldType.OU3)
    ..aOS(4, 'order')
    ..a<$core.int>(5, 'type', $pb.PbFieldType.OU3)
    ..a<$core.int>(6, 'status', $pb.PbFieldType.OU3)
    ..aOS(7, 'title')
    ..aOS(8, 'resume')
    ..aOS(9, 'detailed')
    ..aOS(10, 'createTime', protoName: 'createTime')
    ..a<$fixnum.Int64>(11, 'defendant', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(12, 'proofContent', protoName: 'proofContent')
    ..aOS(13, 'arbitrationResults', protoName: 'arbitrationResults')
    ..a<$fixnum.Int64>(14, 'winner', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(15, 'startTime', protoName: 'startTime')
    ..aOS(16, 'endTime', protoName: 'endTime')
    ..p<$fixnum.Int64>(17, 'reviewers', $pb.PbFieldType.PU6)
    ..hasRequiredFields = false;

  Arbitration._() : super();
  factory Arbitration() => create();
  factory Arbitration.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Arbitration.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Arbitration clone() => Arbitration()..mergeFromMessage(this);
  Arbitration copyWith(void Function(Arbitration) updates) =>
      super.copyWith((message) => updates(message as Arbitration));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Arbitration create() => Arbitration._();
  Arbitration createEmptyInstance() => create();
  static $pb.PbList<Arbitration> createRepeated() => $pb.PbList<Arbitration>();
  @$core.pragma('dart2js:noInline')
  static Arbitration getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Arbitration>(create);
  static Arbitration _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get aid => $_getIZ(0);
  @$pb.TagNumber(1)
  set aid($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAid() => $_has(0);
  @$pb.TagNumber(1)
  void clearAid() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get plaintiff => $_getI64(1);
  @$pb.TagNumber(2)
  set plaintiff($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPlaintiff() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlaintiff() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get product => $_getIZ(2);
  @$pb.TagNumber(3)
  set product($core.int v) {
    $_setUnsignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasProduct() => $_has(2);
  @$pb.TagNumber(3)
  void clearProduct() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get order => $_getSZ(3);
  @$pb.TagNumber(4)
  set order($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasOrder() => $_has(3);
  @$pb.TagNumber(4)
  void clearOrder() => clearField(4);

  @$pb.TagNumber(5)
  $core.int get type => $_getIZ(4);
  @$pb.TagNumber(5)
  set type($core.int v) {
    $_setUnsignedInt32(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasType() => $_has(4);
  @$pb.TagNumber(5)
  void clearType() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get status => $_getIZ(5);
  @$pb.TagNumber(6)
  set status($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(5);
  @$pb.TagNumber(6)
  void clearStatus() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get title => $_getSZ(6);
  @$pb.TagNumber(7)
  set title($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasTitle() => $_has(6);
  @$pb.TagNumber(7)
  void clearTitle() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get resume => $_getSZ(7);
  @$pb.TagNumber(8)
  set resume($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasResume() => $_has(7);
  @$pb.TagNumber(8)
  void clearResume() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get detailed => $_getSZ(8);
  @$pb.TagNumber(9)
  set detailed($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasDetailed() => $_has(8);
  @$pb.TagNumber(9)
  void clearDetailed() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get createTime => $_getSZ(9);
  @$pb.TagNumber(10)
  set createTime($core.String v) {
    $_setString(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasCreateTime() => $_has(9);
  @$pb.TagNumber(10)
  void clearCreateTime() => clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get defendant => $_getI64(10);
  @$pb.TagNumber(11)
  set defendant($fixnum.Int64 v) {
    $_setInt64(10, v);
  }

  @$pb.TagNumber(11)
  $core.bool hasDefendant() => $_has(10);
  @$pb.TagNumber(11)
  void clearDefendant() => clearField(11);

  @$pb.TagNumber(12)
  $core.String get proofContent => $_getSZ(11);
  @$pb.TagNumber(12)
  set proofContent($core.String v) {
    $_setString(11, v);
  }

  @$pb.TagNumber(12)
  $core.bool hasProofContent() => $_has(11);
  @$pb.TagNumber(12)
  void clearProofContent() => clearField(12);

  @$pb.TagNumber(13)
  $core.String get arbitrationResults => $_getSZ(12);
  @$pb.TagNumber(13)
  set arbitrationResults($core.String v) {
    $_setString(12, v);
  }

  @$pb.TagNumber(13)
  $core.bool hasArbitrationResults() => $_has(12);
  @$pb.TagNumber(13)
  void clearArbitrationResults() => clearField(13);

  @$pb.TagNumber(14)
  $fixnum.Int64 get winner => $_getI64(13);
  @$pb.TagNumber(14)
  set winner($fixnum.Int64 v) {
    $_setInt64(13, v);
  }

  @$pb.TagNumber(14)
  $core.bool hasWinner() => $_has(13);
  @$pb.TagNumber(14)
  void clearWinner() => clearField(14);

  @$pb.TagNumber(15)
  $core.String get startTime => $_getSZ(14);
  @$pb.TagNumber(15)
  set startTime($core.String v) {
    $_setString(14, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasStartTime() => $_has(14);
  @$pb.TagNumber(15)
  void clearStartTime() => clearField(15);

  @$pb.TagNumber(16)
  $core.String get endTime => $_getSZ(15);
  @$pb.TagNumber(16)
  set endTime($core.String v) {
    $_setString(15, v);
  }

  @$pb.TagNumber(16)
  $core.bool hasEndTime() => $_has(15);
  @$pb.TagNumber(16)
  void clearEndTime() => clearField(16);

  @$pb.TagNumber(17)
  $core.List<$fixnum.Int64> get reviewers => $_getList(16);
}

class OtherAddr extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OtherAddr',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'oaid', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(2, 'user', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, 'coinType', protoName: 'coinType')
    ..aOS(4, 'addr')
    ..hasRequiredFields = false;

  OtherAddr._() : super();
  factory OtherAddr() => create();
  factory OtherAddr.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory OtherAddr.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  OtherAddr clone() => OtherAddr()..mergeFromMessage(this);
  OtherAddr copyWith(void Function(OtherAddr) updates) =>
      super.copyWith((message) => updates(message as OtherAddr));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OtherAddr create() => OtherAddr._();
  OtherAddr createEmptyInstance() => create();
  static $pb.PbList<OtherAddr> createRepeated() => $pb.PbList<OtherAddr>();
  @$core.pragma('dart2js:noInline')
  static OtherAddr getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OtherAddr>(create);
  static OtherAddr _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get oaid => $_getIZ(0);
  @$pb.TagNumber(1)
  set oaid($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOaid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOaid() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get user => $_getI64(1);
  @$pb.TagNumber(2)
  set user($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get coinType => $_getSZ(2);
  @$pb.TagNumber(3)
  set coinType($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCoinType() => $_has(2);
  @$pb.TagNumber(3)
  void clearCoinType() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get addr => $_getSZ(3);
  @$pb.TagNumber(4)
  set addr($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasAddr() => $_has(3);
  @$pb.TagNumber(4)
  void clearAddr() => clearField(4);
}

class ReceiptAddress extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ReceiptAddress',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'rid', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(2, 'userid', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(3, 'province')
    ..aOS(4, 'city')
    ..aOS(5, 'district')
    ..aOS(6, 'phone')
    ..aOS(7, 'name')
    ..aOS(8, 'address')
    ..aOS(9, 'postcode')
    ..aOB(10, 'isDefault', protoName: 'isDefault')
    ..hasRequiredFields = false;

  ReceiptAddress._() : super();
  factory ReceiptAddress() => create();
  factory ReceiptAddress.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory ReceiptAddress.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  ReceiptAddress clone() => ReceiptAddress()..mergeFromMessage(this);
  ReceiptAddress copyWith(void Function(ReceiptAddress) updates) =>
      super.copyWith((message) => updates(message as ReceiptAddress));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ReceiptAddress create() => ReceiptAddress._();
  ReceiptAddress createEmptyInstance() => create();
  static $pb.PbList<ReceiptAddress> createRepeated() =>
      $pb.PbList<ReceiptAddress>();
  @$core.pragma('dart2js:noInline')
  static ReceiptAddress getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ReceiptAddress>(create);
  static ReceiptAddress _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get rid => $_getIZ(0);
  @$pb.TagNumber(1)
  set rid($core.int v) {
    $_setUnsignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRid() => clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get userid => $_getI64(1);
  @$pb.TagNumber(2)
  set userid($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasUserid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get province => $_getSZ(2);
  @$pb.TagNumber(3)
  set province($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasProvince() => $_has(2);
  @$pb.TagNumber(3)
  void clearProvince() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get city => $_getSZ(3);
  @$pb.TagNumber(4)
  set city($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCity() => $_has(3);
  @$pb.TagNumber(4)
  void clearCity() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get district => $_getSZ(4);
  @$pb.TagNumber(5)
  set district($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasDistrict() => $_has(4);
  @$pb.TagNumber(5)
  void clearDistrict() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get phone => $_getSZ(5);
  @$pb.TagNumber(6)
  set phone($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasPhone() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhone() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get name => $_getSZ(6);
  @$pb.TagNumber(7)
  set name($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasName() => $_has(6);
  @$pb.TagNumber(7)
  void clearName() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get address => $_getSZ(7);
  @$pb.TagNumber(8)
  set address($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasAddress() => $_has(7);
  @$pb.TagNumber(8)
  void clearAddress() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get postcode => $_getSZ(8);
  @$pb.TagNumber(9)
  set postcode($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasPostcode() => $_has(8);
  @$pb.TagNumber(9)
  void clearPostcode() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get isDefault => $_getBF(9);
  @$pb.TagNumber(10)
  set isDefault($core.bool v) {
    $_setBool(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasIsDefault() => $_has(9);
  @$pb.TagNumber(10)
  void clearIsDefault() => clearField(10);
}

class PayInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PayInfo',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'orderid')
    ..a<$core.double>(2, 'amount', $pb.PbFieldType.OD)
    ..aOS(3, 'symbol')
    ..aOS(4, 'payAddr', protoName: 'payAddr')
    ..a<$fixnum.Int64>(5, 'userId', $pb.PbFieldType.OU6,
        protoName: 'userId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(6, 'productId', $pb.PbFieldType.OU3, protoName: 'productId')
    ..a<$core.int>(7, 'payMode', $pb.PbFieldType.OU3, protoName: 'payMode')
    ..hasRequiredFields = false;

  PayInfo._() : super();
  factory PayInfo() => create();
  factory PayInfo.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PayInfo.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PayInfo clone() => PayInfo()..mergeFromMessage(this);
  PayInfo copyWith(void Function(PayInfo) updates) =>
      super.copyWith((message) => updates(message as PayInfo));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PayInfo create() => PayInfo._();
  PayInfo createEmptyInstance() => create();
  static $pb.PbList<PayInfo> createRepeated() => $pb.PbList<PayInfo>();
  @$core.pragma('dart2js:noInline')
  static PayInfo getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PayInfo>(create);
  static PayInfo _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get orderid => $_getSZ(0);
  @$pb.TagNumber(1)
  set orderid($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOrderid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrderid() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get amount => $_getN(1);
  @$pb.TagNumber(2)
  set amount($core.double v) {
    $_setDouble(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasAmount() => $_has(1);
  @$pb.TagNumber(2)
  void clearAmount() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get symbol => $_getSZ(2);
  @$pb.TagNumber(3)
  set symbol($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSymbol() => $_has(2);
  @$pb.TagNumber(3)
  void clearSymbol() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get payAddr => $_getSZ(3);
  @$pb.TagNumber(4)
  set payAddr($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasPayAddr() => $_has(3);
  @$pb.TagNumber(4)
  void clearPayAddr() => clearField(4);

  @$pb.TagNumber(5)
  $fixnum.Int64 get userId => $_getI64(4);
  @$pb.TagNumber(5)
  set userId($fixnum.Int64 v) {
    $_setInt64(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasUserId() => $_has(4);
  @$pb.TagNumber(5)
  void clearUserId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get productId => $_getIZ(5);
  @$pb.TagNumber(6)
  set productId($core.int v) {
    $_setUnsignedInt32(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasProductId() => $_has(5);
  @$pb.TagNumber(6)
  void clearProductId() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get payMode => $_getIZ(6);
  @$pb.TagNumber(7)
  set payMode($core.int v) {
    $_setUnsignedInt32(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasPayMode() => $_has(6);
  @$pb.TagNumber(7)
  void clearPayMode() => clearField(7);
}

class PayInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PayInfoRequest',
      package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, 'userId', $pb.PbFieldType.OU6,
        protoName: 'userId', defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(2, 'productId', $pb.PbFieldType.OU3, protoName: 'productId')
    ..a<$core.double>(3, 'amount', $pb.PbFieldType.OD)
    ..aOS(4, 'symbol')
    ..aOB(5, 'mainPay', protoName: 'mainPay')
    ..hasRequiredFields = false;

  PayInfoRequest._() : super();
  factory PayInfoRequest() => create();
  factory PayInfoRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PayInfoRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  PayInfoRequest clone() => PayInfoRequest()..mergeFromMessage(this);
  PayInfoRequest copyWith(void Function(PayInfoRequest) updates) =>
      super.copyWith((message) => updates(message as PayInfoRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PayInfoRequest create() => PayInfoRequest._();
  PayInfoRequest createEmptyInstance() => create();
  static $pb.PbList<PayInfoRequest> createRepeated() =>
      $pb.PbList<PayInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static PayInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PayInfoRequest>(create);
  static PayInfoRequest _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get userId => $_getI64(0);
  @$pb.TagNumber(1)
  set userId($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get productId => $_getIZ(1);
  @$pb.TagNumber(2)
  set productId($core.int v) {
    $_setUnsignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProductId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProductId() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get amount => $_getN(2);
  @$pb.TagNumber(3)
  set amount($core.double v) {
    $_setDouble(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasAmount() => $_has(2);
  @$pb.TagNumber(3)
  void clearAmount() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get symbol => $_getSZ(3);
  @$pb.TagNumber(4)
  set symbol($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSymbol() => $_has(3);
  @$pb.TagNumber(4)
  void clearSymbol() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get mainPay => $_getBF(4);
  @$pb.TagNumber(5)
  set mainPay($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasMainPay() => $_has(4);
  @$pb.TagNumber(5)
  void clearMainPay() => clearField(5);
}
