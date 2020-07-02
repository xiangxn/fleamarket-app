
import 'package:fleamarket/src/models/base_model.dart';

class ExtPage<T extends BaseModel> {
  int pageNo = 1;
  int pageSize = 10;
  int totalCount = 0;
  int totalPage = 0;
  List<T> data;

  ExtPage()
      : pageNo = 1,
        pageSize = 20,
        totalCount = 100,
        totalPage = 100,
        data = [];

  ExtPage.fromJson(Map<String, dynamic> json, T type) {
    //print("${this.pageSize}  $json");
    this.pageNo = json['pageNo'];
    this.pageSize = json['pageSize'];
    this.totalCount = json['totalCount'];
    this.totalPage = this.totalCount ~/ this.pageSize + (this.totalCount % this.pageSize == 0 ? 0 : 1);
    this.data = json['list'] != null ? (json['list'] as List<dynamic>).map((f) => (type.fromJson(f) as T)).toList() : [];
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
