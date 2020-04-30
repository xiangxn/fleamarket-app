class Address{
  Address(){
    // this.name = '龙杰 ${Random.secure().nextInt(100)}';
    // this.phone = '15823877477';
    // this.position = '重庆市 重庆市区 九龙坡区';
    // this.detail = '龙城锦都44栋2单元3-2';
    // this.postcode = '0000000';
    // this.isDefault = true;
  }

  int id;
  int userid;
  String province;
  String city;
  String district;
  String phone;
  String name;
  String address;
  String postcode;
  bool isDefault;

  String get position => '$province $city $district';

  set position(String p){
    List<String> arr = p.split(' ');
    this.province = arr[0];
    this.city = arr[1];
    this.district = arr[2];
  }

  Address.fromJson(Map<String, dynamic> json){
    this.id = json['id'];
    this.userid = json['userid'];
    this.province = json['province'];
    this.city = json['city'];
    this.district = json['district'];
    this.phone = json['phone'];
    this.name = json['name'];
    this.address = json['address'];
    this.postcode = json['postcode'] ?? '000000';
    this.isDefault = json['isdefault'] == 1;
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> json = Map<String, dynamic>();
    json['id'] = this.id;
    json['userid'] = this.userid;
    json['province'] = this.province;
    json['city'] = this.city;
    json['district'] = this.district;
    json['phone'] = this.phone;
    json['name'] = this.name;
    json['address'] = this.address;
    json['postcode'] = this.postcode ?? '000000';
    json['isdefault'] = this.isDefault ?? false ? 1 : 0;
    return json;
  }

  Address clone(){
    return Address.fromJson(this.toJson());
  }
}