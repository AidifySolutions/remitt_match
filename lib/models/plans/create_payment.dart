class CreatePaymentReq {
  String? customerId;
  String? stripeCustomer;
  String? price;
  String? paymentMethod;
  String? planId;
  String? planName;

  CreatePaymentReq(
      {this.customerId,
      this.paymentMethod,
      this.planId,
      this.planName,
      this.price,
      this.stripeCustomer});

  CreatePaymentReq.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    stripeCustomer = json['stripeCustomer'];
    price = json['price'];
    paymentMethod = json['paymentMethod'];
    planId = json['planId'];
    planName = json['planName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['stripeCustomer'] = this.stripeCustomer;
    data['price'] = this.price;
    data['paymentMethod'] = this.paymentMethod;
    data['planId'] = this.planId;
    data['planName'] = this.planName;

    return data;
  }
}

class CreatePaymentRes {
  String? message;
  Payment? payment;
  String? url;

  CreatePaymentRes({this.message, this.payment, this.url});

  CreatePaymentRes.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    payment = Payment.fromJson(json['payment']);
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['payment'] = this.payment;
    data['url'] = this.url;
    return data;
  }
}

class Payment {
  String? id;
  String? invoice;
  String? customer;

  String? planId;
  String? planName;
  String? date;

  String? stripePaymentId;
  String? paymentStatus;

  Payment(
      {this.id,
      this.invoice,
      this.customer,
      this.date,
      this.paymentStatus,
      this.planId,
      this.planName,
      this.stripePaymentId});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    invoice = json['invoice'];
    customer = json['customer'];

    planId = json['planId'];
    planName = json['planName'];
    date = json['date'];

    stripePaymentId = json['stripePaymentId'];
    paymentStatus = json['paymentStatus'];
  }
}

class CreateTradePaymentReq {
  String? customerId; // Cutomer_id
  String? planId; // Trade-ID

  CreateTradePaymentReq({
    this.customerId,
    this.planId,
  });

  CreateTradePaymentReq.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    planId = json['planId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['planId'] = this.planId;

    return data;
  }
}
