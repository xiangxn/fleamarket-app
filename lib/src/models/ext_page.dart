class ExtPage<T>{
  int pageNo;
  int pageSize;
  int totalCount;
  int totalPage;
  List<T> data;

  ExtPage() 
    : pageNo = 1,
      pageSize = 20,
      totalCount = 100,
      totalPage = 100,
      data = [];

  ExtPage.fromJson(Map<String, dynamic> json, Function format){
    this.pageNo = json['pageNo'];
    this.pageSize = json['pageSize'];
    this.totalCount = json['totalCount'];
    this.totalPage = json['totalPage'];
    this.data = json['data'] != null ? (json['data'] as List<dynamic>).map<T>((f) => format(f)).toList() : [];
  }

  incres(){
    this.pageNo ++;
    if(this.pageNo >= this.totalPage){
      this.pageNo = this.totalPage;
    }
  }

  clean(){
    this.pageNo = 1;
    this.data.clear();
  }

  update(List<T> pre){
    pre ??= [];
    this.data = [
      ...pre,
      ...this.data,
    ];
  }

  hasMore(){
    return this.data.length < this.totalCount;
  }
}