class Subscriptions {
  String? message;
  List<Subscription>? subscriptions;

  Subscriptions({this.message, this.subscriptions});

  Subscriptions.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['subscriptions'] != null) {
      subscriptions = [];
      json['subscriptions'].forEach((v) {
        subscriptions!.add(Subscription.fromJson(v));
      });
    }
  }
}

class Subscription {
  String? id;
  String? name;
  String? planId;
  int? price;
  String? priceId;
  String? interval;
  String? currency;

  Subscription(
      {this.id,
      this.name,
      this.currency,
      this.price,
      this.interval,
      this.planId,
      this.priceId});

  Subscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    planId = json['planId'];
    price = json['price'];
    priceId = json['priceId'];
    interval = json['interval'];
    currency = json['currency'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['planId'] = this.planId;
    data['price'] = this.price;
    data['priceId'] = this.priceId;
    data['interval'] = this.interval;
    data['currency'] = this.currency;
    return data;
  }
}
