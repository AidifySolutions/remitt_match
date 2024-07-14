class ListBeneficiary {
  String? message;
  List<Beneficiaries>? beneficiaries;

  ListBeneficiary({this.message, this.beneficiaries});

  ListBeneficiary.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['beneficiaries'] != null) {
      beneficiaries = [];
      json['beneficiaries'].forEach((v) {
        beneficiaries!.add(new Beneficiaries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.beneficiaries != null) {
      data['beneficiaries'] =
          this.beneficiaries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Beneficary {
  String? message;
  Beneficiaries? beneficiary;

  Beneficary({this.message, this.beneficiary});

  Beneficary.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['beneficiary'] != null) {
      beneficiary = Beneficiaries.fromJson(json['beneficiary']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['beneficiary'] = this.beneficiary;

    return data;
  }
}

class Beneficiaries {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  PhoneNumber? phoneNumber;
  String? countryCode;
  List<Channel>? channel;
  String? customer;

  Beneficiaries(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.phoneNumber,
      this.countryCode,
      this.channel,
      this.customer});

  Beneficiaries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phoneNumber = json['phoneNumber'] != null
        ? new PhoneNumber.fromJson(json['phoneNumber'])
        : null;
    countryCode = json['countryCode'];
    if (json['channel'] != null) {
      channel = [];
      json['channel'].forEach((v) {
        channel!.add(new Channel.fromJson(v));
      });
    }
    customer = json['customer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    if (this.phoneNumber != null) {
      data['phoneNumber'] = this.phoneNumber!.toJson();
    }

    data['countryCode'] = this.countryCode;
    if (this.channel != null) {
      data['channel'] = this.channel!.map((v) => v.toJson()).toList();
    }
    data['customer'] = this.customer;
    return data;
  }
}

class PhoneNumber {
  String? countryCode;
  String? dialCode;
  String? number;

  PhoneNumber({this.countryCode, this.dialCode, this.number});

  PhoneNumber.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    dialCode = json['dialCode'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['dialCode'] = this.dialCode;
    data['number'] = this.number;
    return data;
  }
}

class Channel {
  String? id;
  String? countryCode;
  String? channelType;
  String? currency;
  dynamic fieldDetails;

  Channel(
      {this.id,
      this.countryCode,
      this.channelType,
      this.currency,
      this.fieldDetails});

  Channel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryCode = json['countryCode'];
    channelType = json['channelType'];
    currency = json['currency'];
    fieldDetails = json['fieldDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['countryCode'] = this.countryCode;
    data['channelType'] = this.channelType;
    data['currency'] = this.currency;
    data['fieldDetails'] = this.fieldDetails;

    return data;
  }
}

class ReceiptChannels {
  String? message;
  List<Channel>? channels;

  ReceiptChannels({this.message, this.channels});

  ReceiptChannels.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['channels'] != null) {
      channels = [];
      json['channels']!.forEach((v) {
        channels!.add(new Channel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.channels != null) {
      data['channels'] = this.channels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReceiptChannel {
  String? message;
  Channel? channel;

  ReceiptChannel({this.message, this.channel});

  ReceiptChannel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['channel'] != null) {
      channel = Channel.fromJson(json['channel']);
    }
  }
}

class TradeStatus {
  String? message;
  String? status;

  TradeStatus({this.message, this.status});

  TradeStatus.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
