class City {
  String? id;
  String? province;
  List<Cities>? cities;

  City({this.id, this.province, this.cities});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    province = json['province'];
    if (json['cities'] != null) {
      cities = [];
      json['cities'].forEach((v) {
        cities?.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['province'] = this.province;
    if (this.cities != null) {
      data['cities'] = this.cities?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  String? name;
  String? code;

  Cities({this.name, this.code});

  Cities.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}