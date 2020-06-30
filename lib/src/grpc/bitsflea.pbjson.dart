///
//  Generated code. Do not modify.
//  source: bitsflea.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const BaseReply$json = const {
  '1': 'BaseReply',
  '2': const [
    const {'1': 'code', '3': 1, '4': 1, '5': 5, '10': 'code'},
    const {'1': 'msg', '3': 2, '4': 1, '5': 9, '10': 'msg'},
    const {
      '1': 'data',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.google.protobuf.Any',
      '10': 'data'
    },
  ],
};

const FileRequest$json = const {
  '1': 'FileRequest',
  '2': const [
    const {'1': 'file', '3': 1, '4': 1, '5': 12, '10': 'file'},
    const {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
  ],
};

const EosidRequest$json = const {
  '1': 'EosidRequest',
  '2': const [
    const {'1': 'eosid', '3': 1, '4': 1, '5': 9, '10': 'eosid'},
  ],
};

const User$json = const {
  '1': 'User',
  '2': const [
    const {'1': 'userid', '3': 1, '4': 1, '5': 5, '10': 'userid'},
    const {'1': 'eosid', '3': 2, '4': 1, '5': 9, '10': 'eosid'},
    const {'1': 'phone', '3': 3, '4': 1, '5': 9, '10': 'phone'},
    const {'1': 'status', '3': 4, '4': 1, '5': 5, '10': 'status'},
    const {'1': 'nickname', '3': 5, '4': 1, '5': 9, '10': 'nickname'},
    const {'1': 'head', '3': 6, '4': 1, '5': 9, '10': 'head'},
    const {'1': 'creditValue', '3': 7, '4': 1, '5': 5, '10': 'creditValue'},
    const {'1': 'referrer', '3': 8, '4': 1, '5': 9, '10': 'referrer'},
    const {
      '1': 'lastActiveTime',
      '3': 9,
      '4': 1,
      '5': 9,
      '10': 'lastActiveTime'
    },
    const {'1': 'postsTotal', '3': 10, '4': 1, '5': 5, '10': 'postsTotal'},
    const {'1': 'sellTotal', '3': 11, '4': 1, '5': 5, '10': 'sellTotal'},
    const {'1': 'buyTotal', '3': 12, '4': 1, '5': 5, '10': 'buyTotal'},
    const {
      '1': 'referralTotal',
      '3': 13,
      '4': 1,
      '5': 5,
      '10': 'referralTotal'
    },
    const {'1': 'point', '3': 14, '4': 1, '5': 9, '10': 'point'},
    const {'1': 'isReviewer', '3': 15, '4': 1, '5': 5, '10': 'isReviewer'},
    const {'1': 'followTotal', '3': 16, '4': 1, '5': 5, '10': 'followTotal'},
    const {
      '1': 'favoriteTotal',
      '3': 17,
      '4': 1,
      '5': 5,
      '10': 'favoriteTotal'
    },
    const {'1': 'fansTotal', '3': 18, '4': 1, '5': 5, '10': 'fansTotal'},
    const {'1': 'authKey', '3': 19, '4': 1, '5': 9, '10': 'authKey'},
  ],
};

const RegisterRequest$json = const {
  '1': 'RegisterRequest',
  '2': const [
    const {'1': 'phone', '3': 1, '4': 1, '5': 9, '10': 'phone'},
    const {'1': 'nickname', '3': 2, '4': 1, '5': 9, '10': 'nickname'},
    const {'1': 'ownerpubkey', '3': 3, '4': 1, '5': 9, '10': 'ownerpubkey'},
    const {'1': 'actpubkey', '3': 4, '4': 1, '5': 9, '10': 'actpubkey'},
    const {'1': 'smscode', '3': 5, '4': 1, '5': 9, '10': 'smscode'},
    const {'1': 'referral', '3': 6, '4': 1, '5': 9, '10': 'referral'},
    const {'1': 'authkey', '3': 7, '4': 1, '5': 9, '10': 'authkey'},
    const {'1': 'phoneEncrypt', '3': 8, '4': 1, '5': 9, '10': 'phoneEncrypt'},
  ],
};

const SmsRequest$json = const {
  '1': 'SmsRequest',
  '2': const [
    const {'1': 'phone', '3': 1, '4': 1, '5': 9, '10': 'phone'},
    const {'1': 'codeType', '3': 2, '4': 1, '5': 5, '10': 'codeType'},
  ],
};

const RefreshTokenRequest$json = const {
  '1': 'RefreshTokenRequest',
  '2': const [
    const {'1': 'phone', '3': 1, '4': 1, '5': 9, '10': 'phone'},
    const {'1': 'token', '3': 2, '4': 1, '5': 9, '10': 'token'},
    const {'1': 'time', '3': 3, '4': 1, '5': 5, '10': 'time'},
    const {'1': 'sign', '3': 4, '4': 1, '5': 9, '10': 'sign'},
  ],
};

const SearchRequest$json = const {
  '1': 'SearchRequest',
  '2': const [
    const {'1': 'query', '3': 1, '4': 1, '5': 9, '10': 'query'},
  ],
};

const TransactionRequest$json = const {
  '1': 'TransactionRequest',
  '2': const [
    const {'1': 'trx', '3': 1, '4': 1, '5': 9, '10': 'trx'},
    const {'1': 'sign', '3': 2, '4': 1, '5': 5, '10': 'sign'},
  ],
};

const FollowRequest$json = const {
  '1': 'FollowRequest',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 5, '10': 'user'},
    const {'1': 'follower', '3': 2, '4': 1, '5': 5, '10': 'follower'},
  ],
};

const FavoriteRequest$json = const {
  '1': 'FavoriteRequest',
  '2': const [
    const {'1': 'user', '3': 1, '4': 1, '5': 5, '10': 'user'},
    const {'1': 'product', '3': 2, '4': 1, '5': 5, '10': 'product'},
  ],
};

const AddressRequest$json = const {
  '1': 'AddressRequest',
  '2': const [
    const {'1': 'rid', '3': 1, '4': 1, '5': 5, '10': 'rid'},
    const {'1': 'userid', '3': 2, '4': 1, '5': 5, '10': 'userid'},
    const {'1': 'province', '3': 3, '4': 1, '5': 9, '10': 'province'},
    const {'1': 'city', '3': 4, '4': 1, '5': 9, '10': 'city'},
    const {'1': 'district', '3': 5, '4': 1, '5': 9, '10': 'district'},
    const {'1': 'phone', '3': 6, '4': 1, '5': 9, '10': 'phone'},
    const {'1': 'name', '3': 7, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'address', '3': 8, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'postcode', '3': 9, '4': 1, '5': 9, '10': 'postcode'},
    const {'1': 'default', '3': 10, '4': 1, '5': 5, '10': 'default'},
  ],
};

const SetDefaultAddrRequest$json = const {
  '1': 'SetDefaultAddrRequest',
  '2': const [
    const {'1': 'userid', '3': 1, '4': 1, '5': 5, '10': 'userid'},
    const {'1': 'rid', '3': 2, '4': 1, '5': 5, '10': 'rid'},
  ],
};
