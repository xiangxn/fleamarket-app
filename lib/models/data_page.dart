import 'package:protobuf/protobuf.dart';

class DataPage<T extends GeneratedMessage> {
  int pageNo = 1;
  int pageSize = 10;
  int totalCount = 0;
  int totalPage = 0;
  List<T> data;

  DataPage()
      : pageNo = 1,
        pageSize = 20,
        totalCount = 100,
        totalPage = 100,
        data = [];

  DataPage.fromJson(Map<String, dynamic> json, T type) {
    this.pageNo = json['pageNo'];
    this.pageSize = json['pageSize'];
    this.totalCount = json['totalCount'];
    this.totalPage = this.totalCount ~/ this.pageSize + (this.totalCount % this.pageSize == 0 ? 0 : 1);
    this.data = [];
    if (json['list'] != null) {
      json['list'].forEach((e) {
        var t = type.createEmptyInstance();
        t.mergeFromProto3Json(e);
        this.data.add(t);
      });
    }
  }

  incres() {
    this.pageNo++;
    if (this.pageNo >= this.totalPage) {
      this.pageNo = this.totalPage;
    }
  }

  clean() {
    this.pageNo = 1;
    this.data.clear();
  }

  update(List<T> pre) {
    pre ??= [];
    this.data = [
      ...pre,
      ...this.data,
    ];
  }

  hasMore() {
    return this.data.length < this.totalCount;
  }

  @override
  String toString() {
    return '{"pageNo":$pageNo,"pageSize":$pageSize,"totalCount":$totalCount,"totalPage":$totalPage,"data":$data}';
  }
}
