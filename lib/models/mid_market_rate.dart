class MidMarketRate {
  double? rate;
  String? message;

  MidMarketRate({this.rate, this.message});

  MidMarketRate.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['message'] = this.message;
    return data;
  }
}
