class Province {
  String? id;
  String? country;
  List<Provinces>? provinces;

  Province({this.id, this.country, this.provinces});

  Province.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    country = json['country'];
    if (json['provinces'] != null) {
      provinces = [];
      json['provinces'].forEach((v) {
        provinces!.add(new Provinces.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country'] = this.country;
    if (this.provinces != null) {
      data['provinces'] = this.provinces!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Provinces {
  String? name;
  String? code;

  Provinces({this.name, this.code});

  Provinces.fromJson(Map<String, dynamic> json) {
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
