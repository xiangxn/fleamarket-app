import 'package:fleamarket/src/models/base_model.dart';

class User extends BaseModel {
  User();

  String token;
  int userid;
  String eosid;
  String phone; //手机号
  int status; //状态 0 正常 1 锁定
  String nickname; //昵称
  String head; //头像
  int creditValue; //信用值
  String referrer; //我的邀请人eosid
  String lastActiveTime; //最后激活时间
  int postsTotal; //上传总数
  int sellTotal; //卖出总数
  int buyTotal; //购买总数
  int referralTotal; //引荐总数
  int favoriteTotal; //关注总数
  int collectionTotal; //收藏总数
  int fansTotal; //粉丝数
  String point; //平台资产总数
  int isReviewer; //评审员标示 0 评审员 1 普通用户
  int vote; //（临）票数

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    userid = json['userid'];
    eosid = json['eosid'];
    phone = json['phone'];
    status = json['status'];
    nickname = json['nickname'];
    head = json['head'];
    creditValue = json['creditValue'];
    referrer = json['referrer'];
    lastActiveTime = json['lastActiveTime'];
    postsTotal = json['postsTotal'];
    sellTotal = json['sellTotal'];
    buyTotal = json['buyTotal'];
    referralTotal = json['referralTotal'];
    favoriteTotal = json['favoriteTotal'];
    collectionTotal = json['collectionTotal'];
    fansTotal = json['fansTotal'];
    point = json['point'];
    isReviewer = json['isReviewer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['userid'] = this.userid;
    data['eosid'] = this.eosid;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['nickname'] = this.nickname;
    data['head'] = this.head;
    data['creditValue'] = this.creditValue;
    data['referrer'] = this.referrer;
    data['lastActiveTime'] = this.lastActiveTime;
    data['postsTotal'] = this.postsTotal;
    data['sellTotal'] = this.sellTotal;
    data['buyTotal'] = this.buyTotal;
    data['referralTotal'] = this.referralTotal;
    data['favoriteTotal'] = this.favoriteTotal;
    data['collectionTotal'] = this.collectionTotal;
    data['fansTotal'] = this.fansTotal;
    data['point'] = this.point;
    data['isReviewer'] = this.isReviewer;
    return data;
  }

  clone() {
    return User.fromJson(this.toJson());
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return User.fromJson(json);
  }
}
