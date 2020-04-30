class ExtResult{
  int code ;
  String msg ;
  dynamic data;

  ExtResult({this.code, this.msg, this.data});

  ExtResult.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }

  get success => this.code == 0;
}