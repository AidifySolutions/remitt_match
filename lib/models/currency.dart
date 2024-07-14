class Currency {
  String? message;
  List<Currencies>? currencies;

  Currency({this.message, this.currencies});

  Currency.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['currencies'] != null) {
      currencies = [];
      json['currencies'].forEach((v) {
        currencies!.add(new Currencies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.currencies != null) {
      data['currencies'] = this.currencies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Currencies {
  String? name;
  String? code;

  Currencies({this.name, this.code});

  Currencies.fromJson(Map<String, dynamic> json) {
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
