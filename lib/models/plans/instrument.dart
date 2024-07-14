import 'package:fiat_match/utils/aes_utils.dart';

class Instruments {
  String? message;
  List<Instrument>? instruments;

  Instruments({this.message, this.instruments});

  Instruments.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['instruments'] != null) {
      instruments = [];
      json['instruments'].forEach((v) {
        instruments!.add(Instrument.fromJson(v));
      });
    }
  }
}

class Instrument {
  String? id;
  String? customer;
  String? externalCustomer;
  String? externalPaymentMethod;
  String? cardBrand;
  String? last4;
  String? billingAddress;

  Instrument(
      {this.id,
      this.customer,
      this.billingAddress,
      this.cardBrand,
      this.externalCustomer,
      this.externalPaymentMethod,
      this.last4});

  Instrument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'];
    billingAddress = json['billingAddress'];
    cardBrand = json['cardBrand'];
    externalCustomer = json['externalCustomer'];
    externalPaymentMethod = json['externalPaymentMethod'];
    last4 = json['last4'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer'] = this.customer;
    data['billingAddress'] = this.billingAddress;
    data['cardBrand'] = this.cardBrand;
    data['externalCustomer'] = this.externalCustomer;
    data['externalPaymentMethod'] = this.externalPaymentMethod;
    data['last4'] = this.last4;
    return data;
  }
}

class AddInstrument {
  String? customer;
  String? externalCustomer;
  String? cvv;
  String? number;
  String? billingAddress;
  Expiry? expiry;

  AddInstrument(
      {this.billingAddress,
      this.externalCustomer,
      this.cvv,
      this.customer,
      this.number,
      this.expiry});

  AddInstrument.fromJson(Map<String, dynamic> json) {
    customer = json['customer'];
    billingAddress = json['billingAddress'];
    cvv = json['cvv'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['externalCustomer'] = this.externalCustomer;
    data['customer'] = this.customer;
    data['billingAddress'] = this.billingAddress;
    data['cvv'] = AesUtils.aesEncryptedText(this.cvv!);
    data['number'] = AesUtils.aesEncryptedText(this.number!);
    data['expiry'] = Expiry(month: expiry!.month, year: expiry!.year).toJson();
    return data;
  }
}

class AddInstrumentsResponse {
  String? message;
  Instrument? instruments;

  AddInstrumentsResponse({this.message, this.instruments});

  AddInstrumentsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message']!;
    instruments = Instrument.fromJson(json['instrument']);
  }
}

class Expiry {
  String? month;
  String? year;

  Expiry({this.month, this.year});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = AesUtils.aesEncryptedText(this.month!);
    data['year'] = AesUtils.aesEncryptedText(this.year!);

    return data;
  }
}
