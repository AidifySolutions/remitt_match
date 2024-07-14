class Advertisement {
  String? message;
  List<Ads>? ads;
  Paging? paging;

  Advertisement({this.message, this.ads, this.paging});

  Advertisement.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['ads'] != null) {
      ads = [];
      json['ads'].forEach((v) {
        ads!.add(new Ads.fromJson(v));
      });
    }
    paging =
        json['paging'] != null ? new Paging.fromJson(json['paging']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.ads != null) {
      data['ads'] = this.ads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AdData {
  String? message;
  Ads? ads;

  AdData({this.message, this.ads});

  AdData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    ads = Ads.fromJson(json['ad']);
  }
}

class Ads {
  String? id;
  String? sellingCurrency;
  String? buyingCurrency;
  double? sellingLimit;
  String? expiry;
  Rate? rate;
  String? customer;
  Recipient? recipient;
  String? createdAt;
  String? updatedAt;
  String? adStatus;
  bool? openToNegotiate;

  Ads(
      {this.id,
      this.sellingCurrency,
      this.buyingCurrency,
      this.sellingLimit,
      this.expiry,
      this.rate,
      this.customer,
      this.recipient,
      this.createdAt,
      this.updatedAt,
      this.adStatus,
      this.openToNegotiate});

  Ads.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    sellingCurrency = json['sellingCurrency'];
    buyingCurrency = json['buyingCurrency'];
    sellingLimit = json['sellingLimit'];
    expiry = json['expiry'];
    rate = json['rate'] != null ? Rate.fromJson(json['rate']) : null;
    customer = json['customer'];
    recipient = json['recipient'] != null
        ? Recipient.fromJson(json['recipient'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    adStatus = json['adStatus'];
    openToNegotiate = json['openToNegotiate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sellingCurrency'] = this.sellingCurrency;
    data['buyingCurrency'] = this.buyingCurrency;
    data['sellingLimit'] = this.sellingLimit;
    data['expiry'] = this.expiry;
    if (this.rate != null) {
      data['rate'] = this.rate!.toJson();
    }
    data['customer'] = this.customer;
    if (this.recipient != null) {
      data['recipient'] = this.recipient!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['adStatus'] = this.adStatus;
    data['openToNegotiate'] = this.openToNegotiate;
    return data;
  }
}

class Rate {
  String? type;
  double? value;
  String? operator;
  int? factor;

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

class Recipient {
  String? beneficiaryId;
  String? channelId;

  Recipient({this.beneficiaryId, this.channelId});

  Recipient.fromJson(Map<String, dynamic> json) {
    beneficiaryId = json['beneficiaryId'];
    channelId = json['channelId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['beneficiaryId'] = this.beneficiaryId;
    data['channelId'] = this.channelId;
    return data;
  }
}

class Paging {
  int? pageNumber;
  int? pageSize;
  int? totalItems;
  int? totalPages;

  Paging({this.pageNumber, this.pageSize, this.totalItems, this.totalPages});

  Paging.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'] ?? '';
    pageSize = json['pageSize'] ?? '';
    totalItems = json['totalItems'] ?? '';
    totalPages = json['totalPages'] ?? '';
  }
}
