class InitialPlans {
  String? message;
  List<Plans>? plans;

  InitialPlans({this.message, this.plans});

  InitialPlans.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['plans'] != null) {
      plans = [];
      json['plans'].forEach((v) {
        plans!.add(Plans.fromJson(v));
      });
    }
  }
}

class Plans {
  String? id;
  String? name;
  int? transactionLimit;
  double? price;
  double? feeInPercentage;

  Plans(
      {this.id,
      this.name,
      this.transactionLimit,
      this.price,
      this.feeInPercentage});

  Plans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    transactionLimit = json['transactionLimit'];
    price = json['price'];
    feeInPercentage = json['feeInPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['transactionLimit'] = this.transactionLimit;
    data['price'] = this.price;
    data['feeInPercentage'] = this.feeInPercentage;
    return data;
  }
}
