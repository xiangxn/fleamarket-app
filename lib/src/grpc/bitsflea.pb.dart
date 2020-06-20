///
//  Generated code. Do not modify.
//  source: bitsflea.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class BaseReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('BaseReply', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'code', $pb.PbFieldType.O3)
    ..aOS(2, 'msg')
    ..hasRequiredFields = false
  ;

  BaseReply._() : super();
  factory BaseReply() => create();
  factory BaseReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory BaseReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  BaseReply clone() => BaseReply()..mergeFromMessage(this);
  BaseReply copyWith(void Function(BaseReply) updates) => super.copyWith((message) => updates(message as BaseReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static BaseReply create() => BaseReply._();
  BaseReply createEmptyInstance() => create();
  static $pb.PbList<BaseReply> createRepeated() => $pb.PbList<BaseReply>();
  @$core.pragma('dart2js:noInline')
  static BaseReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BaseReply>(create);
  static BaseReply _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(1)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCode() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get msg => $_getSZ(1);
  @$pb.TagNumber(2)
  set msg($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasMsg() => $_has(1);
  @$pb.TagNumber(2)
  void clearMsg() => clearField(2);
}

class SearchReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SearchReply', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOM<BaseReply>(1, 'status', subBuilder: BaseReply.create)
    ..aOS(2, 'data')
    ..hasRequiredFields = false
  ;

  SearchReply._() : super();
  factory SearchReply() => create();
  factory SearchReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SearchReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SearchReply clone() => SearchReply()..mergeFromMessage(this);
  SearchReply copyWith(void Function(SearchReply) updates) => super.copyWith((message) => updates(message as SearchReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SearchReply create() => SearchReply._();
  SearchReply createEmptyInstance() => create();
  static $pb.PbList<SearchReply> createRepeated() => $pb.PbList<SearchReply>();
  @$core.pragma('dart2js:noInline')
  static SearchReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchReply>(create);
  static SearchReply _defaultInstance;

  @$pb.TagNumber(1)
  BaseReply get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(BaseReply v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  BaseReply ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get data => $_getSZ(1);
  @$pb.TagNumber(2)
  set data($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
}

class TokenReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TokenReply', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOM<BaseReply>(1, 'status', subBuilder: BaseReply.create)
    ..aOS(2, 'token')
    ..hasRequiredFields = false
  ;

  TokenReply._() : super();
  factory TokenReply() => create();
  factory TokenReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TokenReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TokenReply clone() => TokenReply()..mergeFromMessage(this);
  TokenReply copyWith(void Function(TokenReply) updates) => super.copyWith((message) => updates(message as TokenReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TokenReply create() => TokenReply._();
  TokenReply createEmptyInstance() => create();
  static $pb.PbList<TokenReply> createRepeated() => $pb.PbList<TokenReply>();
  @$core.pragma('dart2js:noInline')
  static TokenReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TokenReply>(create);
  static TokenReply _defaultInstance;

  @$pb.TagNumber(1)
  BaseReply get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(BaseReply v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  BaseReply ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);
}

class FileRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.List<$core.int>>(1, 'file', $pb.PbFieldType.OY)
    ..aOS(2, 'name')
    ..hasRequiredFields = false
  ;

  FileRequest._() : super();
  factory FileRequest() => create();
  factory FileRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FileRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FileRequest clone() => FileRequest()..mergeFromMessage(this);
  FileRequest copyWith(void Function(FileRequest) updates) => super.copyWith((message) => updates(message as FileRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FileRequest create() => FileRequest._();
  FileRequest createEmptyInstance() => create();
  static $pb.PbList<FileRequest> createRepeated() => $pb.PbList<FileRequest>();
  @$core.pragma('dart2js:noInline')
  static FileRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FileRequest>(create);
  static FileRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get file => $_getN(0);
  @$pb.TagNumber(1)
  set file($core.List<$core.int> v) { $_setBytes(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasFile() => $_has(0);
  @$pb.TagNumber(1)
  void clearFile() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);
}

class EosidRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EosidRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'eosid')
    ..hasRequiredFields = false
  ;

  EosidRequest._() : super();
  factory EosidRequest() => create();
  factory EosidRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EosidRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  EosidRequest clone() => EosidRequest()..mergeFromMessage(this);
  EosidRequest copyWith(void Function(EosidRequest) updates) => super.copyWith((message) => updates(message as EosidRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EosidRequest create() => EosidRequest._();
  EosidRequest createEmptyInstance() => create();
  static $pb.PbList<EosidRequest> createRepeated() => $pb.PbList<EosidRequest>();
  @$core.pragma('dart2js:noInline')
  static EosidRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EosidRequest>(create);
  static EosidRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eosid => $_getSZ(0);
  @$pb.TagNumber(1)
  set eosid($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasEosid() => $_has(0);
  @$pb.TagNumber(1)
  void clearEosid() => clearField(1);
}

class User extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('User', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'userid', $pb.PbFieldType.O3)
    ..aOS(2, 'eosid')
    ..aOS(3, 'phone')
    ..a<$core.int>(4, 'status', $pb.PbFieldType.O3)
    ..aOS(5, 'nickname')
    ..aOS(6, 'head')
    ..a<$core.int>(7, 'creditValue', $pb.PbFieldType.O3, protoName: 'creditValue')
    ..aOS(8, 'referrer')
    ..aOS(9, 'lastActiveTime', protoName: 'lastActiveTime')
    ..a<$core.int>(10, 'postsTotal', $pb.PbFieldType.O3, protoName: 'postsTotal')
    ..a<$core.int>(11, 'sellTotal', $pb.PbFieldType.O3, protoName: 'sellTotal')
    ..a<$core.int>(12, 'buyTotal', $pb.PbFieldType.O3, protoName: 'buyTotal')
    ..a<$core.int>(13, 'referralTotal', $pb.PbFieldType.O3, protoName: 'referralTotal')
    ..aOS(14, 'point')
    ..a<$core.int>(15, 'isReviewer', $pb.PbFieldType.O3, protoName: 'isReviewer')
    ..a<$core.int>(16, 'followTotal', $pb.PbFieldType.O3, protoName: 'followTotal')
    ..a<$core.int>(17, 'favoriteTotal', $pb.PbFieldType.O3, protoName: 'favoriteTotal')
    ..a<$core.int>(18, 'fansTotal', $pb.PbFieldType.O3, protoName: 'fansTotal')
    ..hasRequiredFields = false
  ;

  User._() : super();
  factory User() => create();
  factory User.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory User.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  User clone() => User()..mergeFromMessage(this);
  User copyWith(void Function(User) updates) => super.copyWith((message) => updates(message as User));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static User create() => User._();
  User createEmptyInstance() => create();
  static $pb.PbList<User> createRepeated() => $pb.PbList<User>();
  @$core.pragma('dart2js:noInline')
  static User getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<User>(create);
  static User _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get userid => $_getIZ(0);
  @$pb.TagNumber(1)
  set userid($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserid() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get eosid => $_getSZ(1);
  @$pb.TagNumber(2)
  set eosid($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasEosid() => $_has(1);
  @$pb.TagNumber(2)
  void clearEosid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get phone => $_getSZ(2);
  @$pb.TagNumber(3)
  set phone($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasPhone() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhone() => clearField(3);

  @$pb.TagNumber(4)
  $core.int get status => $_getIZ(3);
  @$pb.TagNumber(4)
  set status($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasStatus() => $_has(3);
  @$pb.TagNumber(4)
  void clearStatus() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get nickname => $_getSZ(4);
  @$pb.TagNumber(5)
  set nickname($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasNickname() => $_has(4);
  @$pb.TagNumber(5)
  void clearNickname() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get head => $_getSZ(5);
  @$pb.TagNumber(6)
  set head($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasHead() => $_has(5);
  @$pb.TagNumber(6)
  void clearHead() => clearField(6);

  @$pb.TagNumber(7)
  $core.int get creditValue => $_getIZ(6);
  @$pb.TagNumber(7)
  set creditValue($core.int v) { $_setSignedInt32(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasCreditValue() => $_has(6);
  @$pb.TagNumber(7)
  void clearCreditValue() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get referrer => $_getSZ(7);
  @$pb.TagNumber(8)
  set referrer($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasReferrer() => $_has(7);
  @$pb.TagNumber(8)
  void clearReferrer() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get lastActiveTime => $_getSZ(8);
  @$pb.TagNumber(9)
  set lastActiveTime($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLastActiveTime() => $_has(8);
  @$pb.TagNumber(9)
  void clearLastActiveTime() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get postsTotal => $_getIZ(9);
  @$pb.TagNumber(10)
  set postsTotal($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasPostsTotal() => $_has(9);
  @$pb.TagNumber(10)
  void clearPostsTotal() => clearField(10);

  @$pb.TagNumber(11)
  $core.int get sellTotal => $_getIZ(10);
  @$pb.TagNumber(11)
  set sellTotal($core.int v) { $_setSignedInt32(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasSellTotal() => $_has(10);
  @$pb.TagNumber(11)
  void clearSellTotal() => clearField(11);

  @$pb.TagNumber(12)
  $core.int get buyTotal => $_getIZ(11);
  @$pb.TagNumber(12)
  set buyTotal($core.int v) { $_setSignedInt32(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasBuyTotal() => $_has(11);
  @$pb.TagNumber(12)
  void clearBuyTotal() => clearField(12);

  @$pb.TagNumber(13)
  $core.int get referralTotal => $_getIZ(12);
  @$pb.TagNumber(13)
  set referralTotal($core.int v) { $_setSignedInt32(12, v); }
  @$pb.TagNumber(13)
  $core.bool hasReferralTotal() => $_has(12);
  @$pb.TagNumber(13)
  void clearReferralTotal() => clearField(13);

  @$pb.TagNumber(14)
  $core.String get point => $_getSZ(13);
  @$pb.TagNumber(14)
  set point($core.String v) { $_setString(13, v); }
  @$pb.TagNumber(14)
  $core.bool hasPoint() => $_has(13);
  @$pb.TagNumber(14)
  void clearPoint() => clearField(14);

  @$pb.TagNumber(15)
  $core.int get isReviewer => $_getIZ(14);
  @$pb.TagNumber(15)
  set isReviewer($core.int v) { $_setSignedInt32(14, v); }
  @$pb.TagNumber(15)
  $core.bool hasIsReviewer() => $_has(14);
  @$pb.TagNumber(15)
  void clearIsReviewer() => clearField(15);

  @$pb.TagNumber(16)
  $core.int get followTotal => $_getIZ(15);
  @$pb.TagNumber(16)
  set followTotal($core.int v) { $_setSignedInt32(15, v); }
  @$pb.TagNumber(16)
  $core.bool hasFollowTotal() => $_has(15);
  @$pb.TagNumber(16)
  void clearFollowTotal() => clearField(16);

  @$pb.TagNumber(17)
  $core.int get favoriteTotal => $_getIZ(16);
  @$pb.TagNumber(17)
  set favoriteTotal($core.int v) { $_setSignedInt32(16, v); }
  @$pb.TagNumber(17)
  $core.bool hasFavoriteTotal() => $_has(16);
  @$pb.TagNumber(17)
  void clearFavoriteTotal() => clearField(17);

  @$pb.TagNumber(18)
  $core.int get fansTotal => $_getIZ(17);
  @$pb.TagNumber(18)
  set fansTotal($core.int v) { $_setSignedInt32(17, v); }
  @$pb.TagNumber(18)
  $core.bool hasFansTotal() => $_has(17);
  @$pb.TagNumber(18)
  void clearFansTotal() => clearField(18);
}

class RegisterRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RegisterRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'phone')
    ..aOS(2, 'nickname')
    ..aOS(3, 'ownerpubkey')
    ..aOS(4, 'actpubkey')
    ..aOS(5, 'smscode')
    ..aOS(6, 'referral')
    ..aOS(7, 'authkey')
    ..aOS(8, 'phoneEncrypt', protoName: 'phoneEncrypt')
    ..hasRequiredFields = false
  ;

  RegisterRequest._() : super();
  factory RegisterRequest() => create();
  factory RegisterRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RegisterRequest clone() => RegisterRequest()..mergeFromMessage(this);
  RegisterRequest copyWith(void Function(RegisterRequest) updates) => super.copyWith((message) => updates(message as RegisterRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegisterRequest create() => RegisterRequest._();
  RegisterRequest createEmptyInstance() => create();
  static $pb.PbList<RegisterRequest> createRepeated() => $pb.PbList<RegisterRequest>();
  @$core.pragma('dart2js:noInline')
  static RegisterRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterRequest>(create);
  static RegisterRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phone => $_getSZ(0);
  @$pb.TagNumber(1)
  set phone($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhone() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhone() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get nickname => $_getSZ(1);
  @$pb.TagNumber(2)
  set nickname($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasNickname() => $_has(1);
  @$pb.TagNumber(2)
  void clearNickname() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get ownerpubkey => $_getSZ(2);
  @$pb.TagNumber(3)
  set ownerpubkey($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasOwnerpubkey() => $_has(2);
  @$pb.TagNumber(3)
  void clearOwnerpubkey() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get actpubkey => $_getSZ(3);
  @$pb.TagNumber(4)
  set actpubkey($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasActpubkey() => $_has(3);
  @$pb.TagNumber(4)
  void clearActpubkey() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get smscode => $_getSZ(4);
  @$pb.TagNumber(5)
  set smscode($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSmscode() => $_has(4);
  @$pb.TagNumber(5)
  void clearSmscode() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get referral => $_getSZ(5);
  @$pb.TagNumber(6)
  set referral($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasReferral() => $_has(5);
  @$pb.TagNumber(6)
  void clearReferral() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get authkey => $_getSZ(6);
  @$pb.TagNumber(7)
  set authkey($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAuthkey() => $_has(6);
  @$pb.TagNumber(7)
  void clearAuthkey() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get phoneEncrypt => $_getSZ(7);
  @$pb.TagNumber(8)
  set phoneEncrypt($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasPhoneEncrypt() => $_has(7);
  @$pb.TagNumber(8)
  void clearPhoneEncrypt() => clearField(8);
}

class RegisterReply extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RegisterReply', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOM<BaseReply>(1, 'status', subBuilder: BaseReply.create)
    ..aOM<User>(2, 'data', subBuilder: User.create)
    ..hasRequiredFields = false
  ;

  RegisterReply._() : super();
  factory RegisterReply() => create();
  factory RegisterReply.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RegisterReply.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RegisterReply clone() => RegisterReply()..mergeFromMessage(this);
  RegisterReply copyWith(void Function(RegisterReply) updates) => super.copyWith((message) => updates(message as RegisterReply));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RegisterReply create() => RegisterReply._();
  RegisterReply createEmptyInstance() => create();
  static $pb.PbList<RegisterReply> createRepeated() => $pb.PbList<RegisterReply>();
  @$core.pragma('dart2js:noInline')
  static RegisterReply getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RegisterReply>(create);
  static RegisterReply _defaultInstance;

  @$pb.TagNumber(1)
  BaseReply get status => $_getN(0);
  @$pb.TagNumber(1)
  set status(BaseReply v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
  @$pb.TagNumber(1)
  BaseReply ensureStatus() => $_ensure(0);

  @$pb.TagNumber(2)
  User get data => $_getN(1);
  @$pb.TagNumber(2)
  set data(User v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasData() => $_has(1);
  @$pb.TagNumber(2)
  void clearData() => clearField(2);
  @$pb.TagNumber(2)
  User ensureData() => $_ensure(1);
}

class SmsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SmsRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'phone')
    ..a<$core.int>(2, 'codeType', $pb.PbFieldType.O3, protoName: 'codeType')
    ..hasRequiredFields = false
  ;

  SmsRequest._() : super();
  factory SmsRequest() => create();
  factory SmsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SmsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SmsRequest clone() => SmsRequest()..mergeFromMessage(this);
  SmsRequest copyWith(void Function(SmsRequest) updates) => super.copyWith((message) => updates(message as SmsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SmsRequest create() => SmsRequest._();
  SmsRequest createEmptyInstance() => create();
  static $pb.PbList<SmsRequest> createRepeated() => $pb.PbList<SmsRequest>();
  @$core.pragma('dart2js:noInline')
  static SmsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SmsRequest>(create);
  static SmsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phone => $_getSZ(0);
  @$pb.TagNumber(1)
  set phone($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhone() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhone() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get codeType => $_getIZ(1);
  @$pb.TagNumber(2)
  set codeType($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCodeType() => $_has(1);
  @$pb.TagNumber(2)
  void clearCodeType() => clearField(2);
}

class RefreshTokenRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('RefreshTokenRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'phone')
    ..aOS(2, 'token')
    ..a<$core.int>(3, 'time', $pb.PbFieldType.O3)
    ..aOS(4, 'sign')
    ..hasRequiredFields = false
  ;

  RefreshTokenRequest._() : super();
  factory RefreshTokenRequest() => create();
  factory RefreshTokenRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RefreshTokenRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  RefreshTokenRequest clone() => RefreshTokenRequest()..mergeFromMessage(this);
  RefreshTokenRequest copyWith(void Function(RefreshTokenRequest) updates) => super.copyWith((message) => updates(message as RefreshTokenRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RefreshTokenRequest create() => RefreshTokenRequest._();
  RefreshTokenRequest createEmptyInstance() => create();
  static $pb.PbList<RefreshTokenRequest> createRepeated() => $pb.PbList<RefreshTokenRequest>();
  @$core.pragma('dart2js:noInline')
  static RefreshTokenRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RefreshTokenRequest>(create);
  static RefreshTokenRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phone => $_getSZ(0);
  @$pb.TagNumber(1)
  set phone($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhone() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhone() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get token => $_getSZ(1);
  @$pb.TagNumber(2)
  set token($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasToken() => $_has(1);
  @$pb.TagNumber(2)
  void clearToken() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get time => $_getIZ(2);
  @$pb.TagNumber(3)
  set time($core.int v) { $_setSignedInt32(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearTime() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sign => $_getSZ(3);
  @$pb.TagNumber(4)
  set sign($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSign() => $_has(3);
  @$pb.TagNumber(4)
  void clearSign() => clearField(4);
}

class SearchRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SearchRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'query')
    ..hasRequiredFields = false
  ;

  SearchRequest._() : super();
  factory SearchRequest() => create();
  factory SearchRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SearchRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SearchRequest clone() => SearchRequest()..mergeFromMessage(this);
  SearchRequest copyWith(void Function(SearchRequest) updates) => super.copyWith((message) => updates(message as SearchRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SearchRequest create() => SearchRequest._();
  SearchRequest createEmptyInstance() => create();
  static $pb.PbList<SearchRequest> createRepeated() => $pb.PbList<SearchRequest>();
  @$core.pragma('dart2js:noInline')
  static SearchRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SearchRequest>(create);
  static SearchRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get query => $_getSZ(0);
  @$pb.TagNumber(1)
  set query($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasQuery() => $_has(0);
  @$pb.TagNumber(1)
  void clearQuery() => clearField(1);
}

class TransactionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('TransactionRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..aOS(1, 'trx')
    ..a<$core.int>(2, 'sign', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  TransactionRequest._() : super();
  factory TransactionRequest() => create();
  factory TransactionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory TransactionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  TransactionRequest clone() => TransactionRequest()..mergeFromMessage(this);
  TransactionRequest copyWith(void Function(TransactionRequest) updates) => super.copyWith((message) => updates(message as TransactionRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static TransactionRequest create() => TransactionRequest._();
  TransactionRequest createEmptyInstance() => create();
  static $pb.PbList<TransactionRequest> createRepeated() => $pb.PbList<TransactionRequest>();
  @$core.pragma('dart2js:noInline')
  static TransactionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TransactionRequest>(create);
  static TransactionRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get trx => $_getSZ(0);
  @$pb.TagNumber(1)
  set trx($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrx() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrx() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get sign => $_getIZ(1);
  @$pb.TagNumber(2)
  set sign($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSign() => $_has(1);
  @$pb.TagNumber(2)
  void clearSign() => clearField(2);
}

class FollowRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FollowRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'user', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'follower', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  FollowRequest._() : super();
  factory FollowRequest() => create();
  factory FollowRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FollowRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FollowRequest clone() => FollowRequest()..mergeFromMessage(this);
  FollowRequest copyWith(void Function(FollowRequest) updates) => super.copyWith((message) => updates(message as FollowRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FollowRequest create() => FollowRequest._();
  FollowRequest createEmptyInstance() => create();
  static $pb.PbList<FollowRequest> createRepeated() => $pb.PbList<FollowRequest>();
  @$core.pragma('dart2js:noInline')
  static FollowRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FollowRequest>(create);
  static FollowRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get user => $_getIZ(0);
  @$pb.TagNumber(1)
  set user($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get follower => $_getIZ(1);
  @$pb.TagNumber(2)
  set follower($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasFollower() => $_has(1);
  @$pb.TagNumber(2)
  void clearFollower() => clearField(2);
}

class FavoriteRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FavoriteRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'user', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'product', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  FavoriteRequest._() : super();
  factory FavoriteRequest() => create();
  factory FavoriteRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FavoriteRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FavoriteRequest clone() => FavoriteRequest()..mergeFromMessage(this);
  FavoriteRequest copyWith(void Function(FavoriteRequest) updates) => super.copyWith((message) => updates(message as FavoriteRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FavoriteRequest create() => FavoriteRequest._();
  FavoriteRequest createEmptyInstance() => create();
  static $pb.PbList<FavoriteRequest> createRepeated() => $pb.PbList<FavoriteRequest>();
  @$core.pragma('dart2js:noInline')
  static FavoriteRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FavoriteRequest>(create);
  static FavoriteRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get user => $_getIZ(0);
  @$pb.TagNumber(1)
  set user($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get product => $_getIZ(1);
  @$pb.TagNumber(2)
  set product($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasProduct() => $_has(1);
  @$pb.TagNumber(2)
  void clearProduct() => clearField(2);
}

class AddressRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddressRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'rid', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'userid', $pb.PbFieldType.O3)
    ..aOS(3, 'province')
    ..aOS(4, 'city')
    ..aOS(5, 'district')
    ..aOS(6, 'phone')
    ..aOS(7, 'name')
    ..aOS(8, 'address')
    ..aOS(9, 'postcode')
    ..a<$core.int>(10, 'default', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  AddressRequest._() : super();
  factory AddressRequest() => create();
  factory AddressRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddressRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AddressRequest clone() => AddressRequest()..mergeFromMessage(this);
  AddressRequest copyWith(void Function(AddressRequest) updates) => super.copyWith((message) => updates(message as AddressRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddressRequest create() => AddressRequest._();
  AddressRequest createEmptyInstance() => create();
  static $pb.PbList<AddressRequest> createRepeated() => $pb.PbList<AddressRequest>();
  @$core.pragma('dart2js:noInline')
  static AddressRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddressRequest>(create);
  static AddressRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get rid => $_getIZ(0);
  @$pb.TagNumber(1)
  set rid($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRid() => $_has(0);
  @$pb.TagNumber(1)
  void clearRid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get userid => $_getIZ(1);
  @$pb.TagNumber(2)
  set userid($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUserid() => $_has(1);
  @$pb.TagNumber(2)
  void clearUserid() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get province => $_getSZ(2);
  @$pb.TagNumber(3)
  set province($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasProvince() => $_has(2);
  @$pb.TagNumber(3)
  void clearProvince() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get city => $_getSZ(3);
  @$pb.TagNumber(4)
  set city($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCity() => $_has(3);
  @$pb.TagNumber(4)
  void clearCity() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get district => $_getSZ(4);
  @$pb.TagNumber(5)
  set district($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasDistrict() => $_has(4);
  @$pb.TagNumber(5)
  void clearDistrict() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get phone => $_getSZ(5);
  @$pb.TagNumber(6)
  set phone($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasPhone() => $_has(5);
  @$pb.TagNumber(6)
  void clearPhone() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get name => $_getSZ(6);
  @$pb.TagNumber(7)
  set name($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasName() => $_has(6);
  @$pb.TagNumber(7)
  void clearName() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get address => $_getSZ(7);
  @$pb.TagNumber(8)
  set address($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasAddress() => $_has(7);
  @$pb.TagNumber(8)
  void clearAddress() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get postcode => $_getSZ(8);
  @$pb.TagNumber(9)
  set postcode($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasPostcode() => $_has(8);
  @$pb.TagNumber(9)
  void clearPostcode() => clearField(9);

  @$pb.TagNumber(10)
  $core.int get default_10 => $_getIZ(9);
  @$pb.TagNumber(10)
  set default_10($core.int v) { $_setSignedInt32(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDefault_10() => $_has(9);
  @$pb.TagNumber(10)
  void clearDefault_10() => clearField(10);
}

class SetDefaultAddrRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SetDefaultAddrRequest', package: const $pb.PackageName('bitsflea'), createEmptyInstance: create)
    ..a<$core.int>(1, 'userid', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'rid', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  SetDefaultAddrRequest._() : super();
  factory SetDefaultAddrRequest() => create();
  factory SetDefaultAddrRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory SetDefaultAddrRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  SetDefaultAddrRequest clone() => SetDefaultAddrRequest()..mergeFromMessage(this);
  SetDefaultAddrRequest copyWith(void Function(SetDefaultAddrRequest) updates) => super.copyWith((message) => updates(message as SetDefaultAddrRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static SetDefaultAddrRequest create() => SetDefaultAddrRequest._();
  SetDefaultAddrRequest createEmptyInstance() => create();
  static $pb.PbList<SetDefaultAddrRequest> createRepeated() => $pb.PbList<SetDefaultAddrRequest>();
  @$core.pragma('dart2js:noInline')
  static SetDefaultAddrRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<SetDefaultAddrRequest>(create);
  static SetDefaultAddrRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get userid => $_getIZ(0);
  @$pb.TagNumber(1)
  set userid($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserid() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserid() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get rid => $_getIZ(1);
  @$pb.TagNumber(2)
  set rid($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRid() => $_has(1);
  @$pb.TagNumber(2)
  void clearRid() => clearField(2);
}

