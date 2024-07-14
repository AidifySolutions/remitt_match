import 'advertisement.dart';

class PostOffer {
  String? sellingCurrency;
  String? buyingCurrency;
  num? sellingLimit;
  String? expiry;
  Rate? rate;
  Recipient? recipient;
  bool? openToNegotiate;

  PostOffer(
      {this.buyingCurrency,
      this.expiry,
      this.openToNegotiate,
      this.rate,
      this.recipient,
      this.sellingCurrency,
      this.sellingLimit});

  PostOffer.fromJson(Map<String, dynamic> json) {
    sellingCurrency = json['sellingCurrency'];
    buyingCurrency = json['buyingCurrency'];
    sellingLimit = json['sellingLimit'];
    rate = Rate.fromJson(json['rate']);
    recipient = Recipient?.fromJson(json['recipient']);
    openToNegotiate = json['openToNegotiate'];
    expiry = json['expiry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sellingCurrency'] = this.sellingCurrency;
    data['buyingCurrency'] = this.buyingCurrency;
    data['sellingLimit'] = this.sellingLimit;
    data['rate'] = this.rate;
    data['recipient'] = this.recipient;
    data['openToNegotiate'] = this.openToNegotiate;
    data['expiry'] = this.expiry;
    return data;
  }
}

class Rate {
  String? type;
  num? value;
  String? operator;
  num? factor;

  Rate({this.type, this.value, this.operator, this.factor});

  Rate.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    value = json['value'];
    operator = json['operator'];
    factor = json['factor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['value'] = this.value;
    data['operator'] = this.operator;
    data['factor'] = this.factor;
    return data;
  }
}

class PostOfferResponse {
  String? message;

  PostOfferResponse({this.message});

  PostOfferResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}
