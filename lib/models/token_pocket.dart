class TokenPocket {
  String protocol = "TokenPocket";
  String version = "1.1.6";
  String dappName = "希奇";
  String dappIcon = "http://www.bitsflea.com/logo512.jpg";
  String action = "transfer";
  String actionId = "";
  String blockchain = "bos";
  String from = "";
  String to = "";
  double amount = 0;
  String contract = "";
  String symbol = "BOS";
  int precision = 4;
  String memo;
  String desc;
  String expired;
  String callbackSchema = "bitsflea://";

  TokenPocket();

  TokenPocket.fromJson(Map json) {
    this.protocol = json['protocol'];
    this.version = json['version'];
    this.dappName = json['dappName'];
    this.dappIcon = json['dappIcon'];
    this.action = json['action'];
    this.actionId = json['actionId'];
    this.blockchain = json['blockchain'];
    this.from = json['from'];
    this.to = json['to'];
    this.amount = json['amount'];
    this.contract = json['contract'];
    this.symbol = json['symbol'];
    this.precision = json['precision'];
    this.memo = json['memo'];
    this.desc = json['desc'];
    this.expired = json['expired'];
    this.callbackSchema = json['callbackSchema'];
  }

  Map toJson() {
    return {
      "protocol": this.protocol,
      "version": this.version,
      "dappName": this.dappName,
      "dappIcon": this.dappIcon,
      "action": this.action,
      "actionId": this.actionId,
      "blockchain": this.blockchain,
      "from": this.from,
      "to": this.to,
      "amount": this.amount,
      "contract": this.contract,
      "symbol": this.symbol,
      "precision": this.precision,
      "memo": this.memo,
      "desc": this.desc,
      "expired": this.expired,
      "callbackSchema": this.callbackSchema
    };
  }
}
