import 'dart:convert';
import 'dart:math';

import 'package:bitsflea/common/constant.dart';
import 'package:bitsflea/grpc/bitsflea.pb.dart';
import 'package:bitsflea/grpc/google/protobuf/any.pb.dart';
import 'package:bitsflea/grpc/google/protobuf/wrappers.pb.dart';
import 'package:bitsflea/models/data_page.dart';
import 'package:bitsflea/states/base.dart';
import 'package:flutter/material.dart';
import 'package:protobuf/protobuf.dart';
import 'package:eosdart_ecc/eosdart_ecc.dart';

List<T> convertEdgeList<T extends GeneratedMessage>(Any data, String key, T type) {
  var val = StringValue();
  data.unpackInto(val);
  final json = jsonDecode(val.value);
  List<T> list = [];
  (json[key]['edges'] as List<dynamic>).forEach((e) {
    var obj = type.createEmptyInstance();
    obj.mergeFromProto3Json(e['node']);
    list.add(obj);
  });
  return list;
}

T convertEdge<T extends GeneratedMessage>(Any data, String key, T typeObj) {
  var val = StringValue();
  data.unpackInto(val);
  final json = jsonDecode(val.value);
  final list = (json[key]['edges'] as List<dynamic>);
  if (list.length > 0) {
    typeObj.mergeFromProto3Json(list[0]['node']);
    return typeObj;
  }
  return null;
}

T convertObj<T extends GeneratedMessage>(Any data, String key, T typeObj) {
  var val = StringValue();
  data.unpackInto(val);
  if (val.value == null || val.value == "null" || val.value.isEmpty) return null;
  final json = jsonDecode(val.value);
  typeObj.mergeFromProto3Json(json[key]);
  return typeObj;
}

DataPage<T> convertPageList<T extends GeneratedMessage>(Any data, String key, T type, {String key2}) {
  var val = StringValue();
  data.unpackInto(val);
  final json = jsonDecode(val.value);
  // print("convertPageList$json");
  return DataPage<T>.fromJson(json[key], type, key2: key2);
}

List<T> convertList<T extends GeneratedMessage>(Any data, String key, T type) {
  var val = StringValue();
  data.unpackInto(val);
  final json = jsonDecode(val.value);
  List<T> list = [];
  (json[key] as List).forEach((e) {
    var obj = type.createEmptyInstance();
    obj.mergeFromProto3Json(e);
    list.add(obj);
  });
  return list;
}

List<EOSPrivateKey> generateKeys(String phone, String password) {
  EOSPrivateKey ownerKey = EOSPrivateKey.fromSeed('$phone $password owner');
  EOSPrivateKey activeKey = EOSPrivateKey.fromSeed('$phone $password active');
  EOSPrivateKey authKey = EOSPrivateKey.fromSeed('$phone $password auth');
  return [ownerKey, activeKey, authKey];
}

Future<bool> validateKey(String phone, String password, EOSPrivateKey auth) async {
  EOSPrivateKey authKey = EOSPrivateKey.fromSeed('$phone $password auth');
  return authKey.toEOSPublicKey().toString() == auth.toEOSPublicKey().toString();
}

formatPrice(String price) {
  double p = double.tryParse(price) ?? 0;
  if (p % p.floor() == 0) return p.floor().toString();
  return p.toString();
}

formatPrice2(String price) {
  List<String> ps = price.split(" ");
  if (ps.length == 2) {
    double p = double.tryParse(ps[0]) ?? 0;
    if (p % p.floor() == 0) return "${p.floor().toString()} ${ps[1]}";
    return "${p.toString()} ${ps[1]}";
  }
  return "";
}

formatPrice3(double price) {
  if (price % price.floor() == 0) return price.floor().toString();
  return price.toString();
}

String addPrice(String price1, String price2) {
  double p1 = double.tryParse(price1.split(" ")[0]) ?? 0;
  double p2 = double.tryParse(price2.split(" ")[0]) ?? 0;
  double p = p1 + p2;
  List<String> ps = price1.split(" ");
  if (ps.length == 2) {
    if (p % p.floor() == 0) return "${p.floor().toString()} ${ps[1]}";
    return "${p.toString()} ${ps[1]}";
  }
  return formatPrice3(p);
}

Key randomKey() {
  return Key(DateTime.now().toIso8601String() + Random.secure().nextInt(10000).toString());
}

String getErrorMessage(String src) {
  if (src.startsWith("assertion failure with message: ")) return src.split(": ")[1];
  return src;
}

String getIPFSUrl(String path) {
  return path.startsWith("http://") || path.startsWith("https://") ? path : URL_IPFS_GATEWAY + path;
}

Widget buildReturnStatus(BaseProvider provider, ProReturn pr) {
  if (pr == null) return Text("");
  Color color = Colors.black;
  switch (pr.status) {
    case ReturnStatus.pendingShipment:
    case ReturnStatus.pendingReceipt:
      color = Colors.red;
      break;
    case ReturnStatus.arbitration:
      color = Colors.orange[800];
      break;
    default:
      color = Colors.grey;
      break;
  }
  return Text(provider.translate('returns_status.${pr.status}'), style: TextStyle(color: color, fontSize: 13));
}

Widget buildOrderStatus(BaseProvider provider, Order order) {
  // status = Random.secure().nextInt(4);
  Color color = Colors.black;
  int status = order.status;

  if (status == OrderStatus.pendingPayment) {
    DateTime now = DateTime.now();
    DateTime expired = DateTime.parse("${order.payOutTime}Z");
    expired = expired.add(Duration(hours: now.timeZoneOffset.inHours));

    if (now.isAfter(expired)) {
      status = -1;
    }
  }

  switch (status) {
    case OrderStatus.pendingPayment:
      color = Colors.green;
      break;
    case OrderStatus.pendingConfirm:
    case OrderStatus.pendingShipment:
    case OrderStatus.pendingReceipt:
      color = Colors.red;
      break;
    case OrderStatus.completed:
      color = Colors.grey;
      break;
    case OrderStatus.arbitration:
    case OrderStatus.returning:
      color = Colors.orange[800];
      break;
    default:
      color = Colors.grey;
      break;
  }

  return Text(provider.translate('order_type.$status'), style: TextStyle(color: color, fontSize: 13));
}

Widget buildShipNumber(String shipNum, Map data) {
  if (data == null) {
    return shipNum == null ? Text("") : Text("$shipNum");
  } else {
    return Text("$shipNum (${data['expName']})");
  }
}

List<Widget> buildLogistics(BaseProvider provider, List<dynamic> data) {
  List<Widget> logisticsList = new List<Widget>();
  if (data != null && data.length > 0) {
    int i = 1;
    for (int n = 0; n < data.length; ++n, ++i)
      logisticsList.add(i == data.length ? buildLogisticsItem(provider.context, data[n], i, true) : buildLogisticsItem(provider.context, data[n], i, false));
  } else {
    logisticsList.add(Center(child: Text(provider.translate("order_detail.not_logistics"))));
  }
  return logisticsList;
}

Widget buildLogisticsItem(BuildContext context, Map value, int i, bool flag) {
  double height = 1;
  if (flag) height = 0;
  return i == 1
      ? Container(
          // width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 0.0, left: 0.0, bottom: 0.0), //容器外填充
          padding: EdgeInsets.only(top: 15.0, bottom: 0, left: 0, right: 0), //容器内填充
          child: Card(
            margin: EdgeInsets.only(left: 0.0, right: 0),
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 90,
                      child: Text(
                        "${value['time']}",
                        style: TextStyle(fontSize: 15.0, height: 1.28, color: Color(0xFF999999)),
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 26.0, left: 6.5, right: 6.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.adjust,
                            size: 12,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 1,
                            height: 28,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      // width: MediaQuery.of(context).size.width - 165,
                      child: Text(
                        "${value['status']}",
                        style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold, height: 1.28),
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                //垂直分割线
                Padding(
                  //左边添加像素补白
                  padding: const EdgeInsets.only(left: 91.5),
                  child: SizedBox(
                    width: 1,
                    height: height,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      : Container(
          // width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 0.0, left: 0.0, bottom: 0.0), //容器外填充
          padding: EdgeInsets.only(top: 0, bottom: 0), //容器内填充
          child: Card(
            margin: EdgeInsets.only(left: 0.0, right: 0),
            elevation: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 90,
                      child: Text(
                        "${value['time']}",
                        style: TextStyle(fontSize: 15.0, height: 1.28, color: Color(0xFF999999)),
                        maxLines: 2,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    Padding(
                      padding: height == 0 ? EdgeInsets.only(bottom: 32, left: 10.0, right: 10.5) : EdgeInsets.only(bottom: 0, left: 10.0, right: 10.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 1,
                            height: 32,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                            ),
                          ),
                          Icon(
                            Icons.adjust,
                            size: 5,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 1,
                            height: height == 0 ? 0 : 32,
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      // width: MediaQuery.of(context).size.width - 50,
                      child: Text(
                        "${value['status']}",
                        style: TextStyle(fontSize: 15.0, height: 1.28, color: Color(0xFF999999)),
                        maxLines: 3,
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ],
                ),
                //垂直分割线
                Padding(
                  //左边添加像素补白
                  padding: const EdgeInsets.only(left: 91.5),
                  child: SizedBox(
                    width: 1,
                    height: height,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Color(0xFFCCCCCC)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
}
