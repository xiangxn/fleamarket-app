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
    const {'1': 'isReviewer', '3': 15, '4': 1, '5': 8, '10': 'isReviewer'},
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

const Category$json = const {
  '1': 'Category',
  '2': const [
    const {'1': 'cid', '3': 1, '4': 1, '5': 5, '10': 'cid'},
    const {'1': 'view', '3': 2, '4': 1, '5': 9, '10': 'view'},
    const {'1': 'parent', '3': 3, '4': 1, '5': 5, '10': 'parent'},
  ],
};

const Product$json = const {
  '1': 'Product',
  '2': const [
    const {'1': 'productId', '3': 1, '4': 1, '5': 13, '10': 'productId'},
    const {
      '1': 'category',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.Category',
      '10': 'category'
    },
    const {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'status', '3': 4, '4': 1, '5': 13, '10': 'status'},
    const {'1': 'isNew', '3': 5, '4': 1, '5': 8, '10': 'isNew'},
    const {'1': 'isReturns', '3': 6, '4': 1, '5': 8, '10': 'isReturns'},
    const {'1': 'transMethod', '3': 7, '4': 1, '5': 13, '10': 'transMethod'},
    const {'1': 'postage', '3': 8, '4': 1, '5': 9, '10': 'postage'},
    const {'1': 'position', '3': 9, '4': 1, '5': 9, '10': 'position'},
    const {'1': 'releaseTime', '3': 10, '4': 1, '5': 9, '10': 'releaseTime'},
    const {'1': 'description', '3': 11, '4': 1, '5': 9, '10': 'description'},
    const {'1': 'photos', '3': 12, '4': 3, '5': 9, '10': 'photos'},
    const {'1': 'collections', '3': 13, '4': 1, '5': 13, '10': 'collections'},
    const {'1': 'price', '3': 14, '4': 1, '5': 9, '10': 'price'},
    const {'1': 'saleMethod', '3': 15, '4': 1, '5': 13, '10': 'saleMethod'},
    const {
      '1': 'seller',
      '3': 16,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.User',
      '10': 'seller'
    },
    const {'1': 'stockCount', '3': 17, '4': 1, '5': 13, '10': 'stockCount'},
    const {'1': 'isRetail', '3': 18, '4': 1, '5': 8, '10': 'isRetail'},
  ],
};

const Auction$json = const {
  '1': 'Auction',
  '2': const [
    const {'1': 'aid', '3': 1, '4': 1, '5': 4, '10': 'aid'},
    const {
      '1': 'product',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.Product',
      '10': 'product'
    },
    const {'1': 'security', '3': 3, '4': 1, '5': 9, '10': 'security'},
    const {'1': 'markup', '3': 4, '4': 1, '5': 9, '10': 'markup'},
    const {'1': 'currentPrice', '3': 5, '4': 1, '5': 9, '10': 'currentPrice'},
    const {'1': 'auctionTimes', '3': 6, '4': 1, '5': 13, '10': 'auctionTimes'},
    const {
      '1': 'lastPriceUser',
      '3': 7,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.User',
      '10': 'lastPriceUser'
    },
    const {'1': 'startTime', '3': 8, '4': 1, '5': 9, '10': 'startTime'},
    const {'1': 'endTime', '3': 9, '4': 1, '5': 9, '10': 'endTime'},
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
    const {'1': 'isDefault', '3': 10, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

const SetDefaultAddrRequest$json = const {
  '1': 'SetDefaultAddrRequest',
  '2': const [
    const {'1': 'userid', '3': 1, '4': 1, '5': 5, '10': 'userid'},
    const {'1': 'rid', '3': 2, '4': 1, '5': 5, '10': 'rid'},
  ],
};

const Reviewer$json = const {
  '1': 'Reviewer',
  '2': const [
    const {'1': 'rid', '3': 1, '4': 1, '5': 4, '10': 'rid'},
    const {
      '1': 'user',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.User',
      '10': 'user'
    },
    const {'1': 'eosid', '3': 3, '4': 1, '5': 9, '10': 'eosid'},
    const {'1': 'votedCount', '3': 4, '4': 1, '5': 5, '10': 'votedCount'},
    const {'1': 'createTime', '3': 5, '4': 1, '5': 9, '10': 'createTime'},
    const {
      '1': 'lastActiveTime',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'lastActiveTime'
    },
    const {'1': 'voterApprove', '3': 7, '4': 3, '5': 4, '10': 'voterApprove'},
    const {'1': 'voterAgainst', '3': 8, '4': 3, '5': 4, '10': 'voterAgainst'},
  ],
};

const ProductAudit$json = const {
  '1': 'ProductAudit',
  '2': const [
    const {'1': 'paid', '3': 1, '4': 1, '5': 4, '10': 'paid'},
    const {
      '1': 'product',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.Product',
      '10': 'product'
    },
    const {
      '1': 'reviewer',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.User',
      '10': 'reviewer'
    },
    const {'1': 'isDelisted', '3': 4, '4': 1, '5': 8, '10': 'isDelisted'},
    const {'1': 'reviewDetails', '3': 5, '4': 1, '5': 9, '10': 'reviewDetails'},
    const {'1': 'reviewTime', '3': 6, '4': 1, '5': 9, '10': 'reviewTime'},
  ],
};

const Order$json = const {
  '1': 'Order',
  '2': const [
    const {'1': 'oid', '3': 1, '4': 1, '5': 4, '10': 'oid'},
    const {'1': 'orderid', '3': 2, '4': 1, '5': 9, '10': 'orderid'},
    const {
      '1': 'productInfo',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.Product',
      '10': 'productInfo'
    },
    const {
      '1': 'seller',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.User',
      '10': 'seller'
    },
    const {
      '1': 'buyer',
      '3': 5,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.User',
      '10': 'buyer'
    },
    const {'1': 'status', '3': 6, '4': 1, '5': 13, '10': 'status'},
    const {'1': 'price', '3': 7, '4': 1, '5': 9, '10': 'price'},
    const {'1': 'postage', '3': 8, '4': 1, '5': 9, '10': 'postage'},
    const {'1': 'payAddr', '3': 9, '4': 1, '5': 9, '10': 'payAddr'},
    const {'1': 'shipNum', '3': 10, '4': 1, '5': 9, '10': 'shipNum'},
    const {'1': 'createTime', '3': 11, '4': 1, '5': 9, '10': 'createTime'},
    const {'1': 'payTime', '3': 12, '4': 1, '5': 9, '10': 'payTime'},
    const {'1': 'payOutTime', '3': 13, '4': 1, '5': 9, '10': 'payOutTime'},
    const {'1': 'shipTime', '3': 14, '4': 1, '5': 9, '10': 'shipTime'},
    const {'1': 'shipOutTime', '3': 15, '4': 1, '5': 9, '10': 'shipOutTime'},
    const {'1': 'receiptTime', '3': 16, '4': 1, '5': 9, '10': 'receiptTime'},
    const {
      '1': 'receiptOutTime',
      '3': 17,
      '4': 1,
      '5': 9,
      '10': 'receiptOutTime'
    },
    const {'1': 'endTime', '3': 18, '4': 1, '5': 9, '10': 'endTime'},
    const {'1': 'delayedCount', '3': 19, '4': 1, '5': 13, '10': 'delayedCount'},
    const {'1': 'toAddr', '3': 20, '4': 1, '5': 13, '10': 'toAddr'},
  ],
};

const ProReturn$json = const {
  '1': 'ProReturn',
  '2': const [
    const {'1': 'prid', '3': 1, '4': 1, '5': 13, '10': 'prid'},
    const {
      '1': 'order',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.Order',
      '10': 'order'
    },
    const {
      '1': 'product',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.bitsflea.Product',
      '10': 'product'
    },
    const {'1': 'orderPrice', '3': 4, '4': 1, '5': 9, '10': 'orderPrice'},
    const {'1': 'status', '3': 5, '4': 1, '5': 13, '10': 'status'},
    const {'1': 'reasons', '3': 6, '4': 1, '5': 9, '10': 'reasons'},
    const {'1': 'createTime', '3': 7, '4': 1, '5': 9, '10': 'createTime'},
    const {'1': 'shipNum', '3': 8, '4': 1, '5': 9, '10': 'shipNum'},
    const {'1': 'shipTime', '3': 9, '4': 1, '5': 9, '10': 'shipTime'},
    const {'1': 'shipOutTime', '3': 10, '4': 1, '5': 9, '10': 'shipOutTime'},
    const {'1': 'receiptTime', '3': 11, '4': 1, '5': 9, '10': 'receiptTime'},
    const {
      '1': 'receiptOutTime',
      '3': 12,
      '4': 1,
      '5': 9,
      '10': 'receiptOutTime'
    },
    const {'1': 'endTime', '3': 13, '4': 1, '5': 9, '10': 'endTime'},
    const {'1': 'delayedCount', '3': 14, '4': 1, '5': 13, '10': 'delayedCount'},
    const {'1': 'toAddr', '3': 15, '4': 1, '5': 13, '10': 'toAddr'},
  ],
};

const Arbitration$json = const {
  '1': 'Arbitration',
  '2': const [
    const {'1': 'aid', '3': 1, '4': 1, '5': 13, '10': 'aid'},
    const {'1': 'plaintiff', '3': 2, '4': 1, '5': 4, '10': 'plaintiff'},
    const {'1': 'product', '3': 3, '4': 1, '5': 13, '10': 'product'},
    const {'1': 'order', '3': 4, '4': 1, '5': 9, '10': 'order'},
    const {'1': 'type', '3': 5, '4': 1, '5': 13, '10': 'type'},
    const {'1': 'status', '3': 6, '4': 1, '5': 13, '10': 'status'},
    const {'1': 'title', '3': 7, '4': 1, '5': 9, '10': 'title'},
    const {'1': 'resume', '3': 8, '4': 1, '5': 9, '10': 'resume'},
    const {'1': 'detailed', '3': 9, '4': 1, '5': 9, '10': 'detailed'},
    const {'1': 'createTime', '3': 10, '4': 1, '5': 9, '10': 'createTime'},
    const {'1': 'defendant', '3': 11, '4': 1, '5': 4, '10': 'defendant'},
    const {'1': 'proofContent', '3': 12, '4': 1, '5': 9, '10': 'proofContent'},
    const {
      '1': 'arbitrationResults',
      '3': 13,
      '4': 1,
      '5': 9,
      '10': 'arbitrationResults'
    },
    const {'1': 'winner', '3': 14, '4': 1, '5': 4, '10': 'winner'},
    const {'1': 'startTime', '3': 15, '4': 1, '5': 9, '10': 'startTime'},
    const {'1': 'endTime', '3': 16, '4': 1, '5': 9, '10': 'endTime'},
    const {'1': 'reviewers', '3': 17, '4': 3, '5': 4, '10': 'reviewers'},
  ],
};

const OtherAddr$json = const {
  '1': 'OtherAddr',
  '2': const [
    const {'1': 'oaid', '3': 1, '4': 1, '5': 13, '10': 'oaid'},
    const {'1': 'user', '3': 2, '4': 1, '5': 4, '10': 'user'},
    const {'1': 'coinType', '3': 3, '4': 1, '5': 9, '10': 'coinType'},
    const {'1': 'addr', '3': 4, '4': 1, '5': 9, '10': 'addr'},
  ],
};

const ReceiptAddress$json = const {
  '1': 'ReceiptAddress',
  '2': const [
    const {'1': 'rid', '3': 1, '4': 1, '5': 13, '10': 'rid'},
    const {'1': 'userid', '3': 2, '4': 1, '5': 4, '10': 'userid'},
    const {'1': 'province', '3': 3, '4': 1, '5': 9, '10': 'province'},
    const {'1': 'city', '3': 4, '4': 1, '5': 9, '10': 'city'},
    const {'1': 'district', '3': 5, '4': 1, '5': 9, '10': 'district'},
    const {'1': 'phone', '3': 6, '4': 1, '5': 9, '10': 'phone'},
    const {'1': 'name', '3': 7, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'address', '3': 8, '4': 1, '5': 9, '10': 'address'},
    const {'1': 'postcode', '3': 9, '4': 1, '5': 9, '10': 'postcode'},
    const {'1': 'isDefault', '3': 10, '4': 1, '5': 8, '10': 'isDefault'},
  ],
};

const PayInfo$json = const {
  '1': 'PayInfo',
  '2': const [
    const {'1': 'orderid', '3': 1, '4': 1, '5': 9, '10': 'orderid'},
    const {'1': 'amount', '3': 2, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'symbol', '3': 3, '4': 1, '5': 9, '10': 'symbol'},
    const {'1': 'payAddr', '3': 4, '4': 1, '5': 9, '10': 'payAddr'},
    const {'1': 'userId', '3': 5, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'productId', '3': 6, '4': 1, '5': 13, '10': 'productId'},
    const {'1': 'payMode', '3': 7, '4': 1, '5': 13, '10': 'payMode'},
  ],
};

const PayInfoRequest$json = const {
  '1': 'PayInfoRequest',
  '2': const [
    const {'1': 'userId', '3': 1, '4': 1, '5': 4, '10': 'userId'},
    const {'1': 'productId', '3': 2, '4': 1, '5': 13, '10': 'productId'},
    const {'1': 'amount', '3': 3, '4': 1, '5': 1, '10': 'amount'},
    const {'1': 'symbol', '3': 4, '4': 1, '5': 9, '10': 'symbol'},
    const {'1': 'mainPay', '3': 5, '4': 1, '5': 8, '10': 'mainPay'},
  ],
};

const LogisticsRequest$json = const {
  '1': 'LogisticsRequest',
  '2': const [
    const {'1': 'com', '3': 1, '4': 1, '5': 9, '10': 'com'},
    const {'1': 'number', '3': 2, '4': 1, '5': 9, '10': 'number'},
    const {'1': 'userId', '3': 3, '4': 1, '5': 4, '10': 'userId'},
  ],
};

const GetPhoneRequest$json = const {
  '1': 'GetPhoneRequest',
  '2': const [
    const {'1': 'fromUserId', '3': 1, '4': 1, '5': 13, '10': 'fromUserId'},
    const {'1': 'toUserId', '3': 2, '4': 1, '5': 13, '10': 'toUserId'},
  ],
};
