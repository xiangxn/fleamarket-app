//data
const CONTRACT_NAME = "bitsfleatest";
const GRPC_HOST = 'api.bitsflea.com';
//const String GRPC_HOST = '127.0.0.1';
const URL_EOS_API = 'https://api-bostest.blockzone.net';
//const String URL_EOS_API = 'http://127.0.0.1:8888';
const URL_IPFS_GATEWAY = "http://source.bitsflea.com:10001/ipfs/";
const DEFAULT_HEAD = 'http://source.bitsflea.com:10001/ipfs/QmbfSqvZJRTs4PcskkfhZDMXG4nxviQWN28sFAQdVfCV9W';

//主网配置
const MAIN_NET_CONTRACT_NAME = "eosio.token";
const MAIN_NET_ASSET_SYMBOL = "BOS";

/// 短信重发延时
const int TIMER_RESET = 60;
const KEY_AMAP = "92e8c56420d01d5e106deaad56e0505f";

const KEY_NAME_OWNER = 'owner';
const KEY_NAME_ACTIVE = 'active';
const KEY_NAME_AUTH = 'auth';
const TAG_SHOW_CNY = false;

//ROUTE
const ROUTE_HOME = "/";
const ROUTE_LOGIN = "login";
const ROUTE_PUBLISH = "publish";
const ROUTE_SEARCH = "search";
const ROUTE_DETAIL = 'detail';
const ROUTE_CREATE_ORDER = "createOrder";
const ROUTE_USER_EDIT = "userEdit";
const ROUTE_USER_HOME = 'userHome';
const ROUTE_USER_FAVORITE = 'userFavorite';
const ROUTE_USER_FOLLOW = 'userFollow';
const ROUTE_USER_FANS = 'mineFans';
const ROUTE_USER_PUBLISH = 'minePublish';
const ROUTE_USER_BUY = 'mineBuy';
const ROUTE_USER_SELL = 'mineSell';
const ROUTE_USER_INVITED = 'mineInvited';
const ROUTE_USER_BALANCES = 'mineBalances';
const ROUTE_USER_KEYS = 'mineKeys';
const ROUTE_USER_ADDRESS = 'mineAddress';
const ROUTE_EDIT_ADDRESS = 'editAddress';
const ROUTE_USER_WITHDRAWADDR = 'mineWithdrawal';
const ROUTE_EDIT_WITHDRAWADDR = 'editWithdrawal';
const ROUTE_GOVERN = "govern";
const ROUTE_REVIEWER_LIST = 'reviewerList';
const ROUTE_PRODUCT_REVIEW_LIST = 'productReviewList';
const ROUTE_PRODUCT_REVIEW_DETAIL = 'productReviewDetail';
const ROUTE_APPLY_REVIEWER = 'applyReviewer';
const ROUTE_AUDIT_GOODS = 'auditGoods';
const ROUTE_ORDER_DETAIL = 'orderDetail';
const ROUTE_LOGISTICS = 'logistics';
const ROUTE_ABOUT = 'about';
const ROUTE_SETTING = "setting";

//Store
const STORE_SEARCH_HISTORY = "searchHistory";
const STORE_FAVORITES = "favorites";
const STORE_FOLLOWS = "follows";
const STORE_VCODE_TIMER = 'vcodeTimer';

//其他
// const Map COIN_PRECISION = {"BOS": 4, "ETH": 8, "FMP": 4, "EOS": 4, "BTS": 5, "CNY": 4, "NULS": 8, "USDT": 8};
const Map COIN_PRECISION = {"FMP": 4, "BOS": 4, "EOS": 4, "NULS": 8, "USDT": 8};
const CITY_LV = 'city';
const CACHE_DISTRICT = 'cacheDisrict';
const COUNTRY_LV = 'country';
const DISTRICT_LV = 'district';

class ProductStatus {
  ///发布
  static const publish = 0;

  ///正常
  static const normal = 100;

  ///完成交易
  static const completed = 200;

  ///下架
  static const delisted = 300;

  ///锁定
  static const locked = 400;
}

class OrderStatus {
  ///待支付
  static const pendingPayment = 0;

  ///待确认
  static const pendingConfirm = 100;

  ///已取消
  static const cancelled = 200;

  ///待发货
  static const pendingShipment = 300;

  ///待收货
  static const pendingReceipt = 400;

  ///待结算 (这个状态用于平台结算)
  static const pendingSettle = 500;

  ///已完成
  static const completed = 600;

  ///仲裁中
  static const arbitration = 700;

  ///退货中
  static const returning = 800;
}
