class District{
  String citycode;
  String adcode;
  String name;
  String center;
  String level;
  DateTime lastUpdate;
  List<District> districts;

  District.fromJson(Map<String, dynamic> json){
    citycode = json['citycode'].length != 0 ? json['citycode'] : '';
    adcode = json['adcode'];
    name = json['name'];
    center = json['center'];
    level = json['level'];
    lastUpdate = DateTime.parse(json['lastUpdate'] ?? '1900-01-01');
    districts = (json['districts'] as List<dynamic>).map((j) => District.fromJson(j)).toList();
    districts.sort((d1, d2) => d1.adcode.compareTo(d2.adcode));
  }

  Map<String, dynamic> toJson(){
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['citycode'] = this.citycode;
    data['adcode'] = this.adcode;
    data['name'] = this.name;
    data['center'] = this.center;
    data['level'] = this.level;
    data['lastUpdate'] = this.lastUpdate.toIso8601String();
    data['districts'] = this.districts.map((f) => f.toJson()).toList();
    return data;
  }
}