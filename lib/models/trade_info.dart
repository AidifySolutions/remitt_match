import 'package:fiat_match/models/recipient.dart';


class TradeInfo {
  String? message;
  Trade? trade;
  String? roomId;

  TradeInfo({this.message, this.trade, this.roomId});

  TradeInfo.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    trade = json['trade'] != null ? new Trade.fromJson(json['trade']) : null;
    roomId = json['roomId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.trade != null) {
      data['trade'] = this.trade!.toJson();
    }
    data['roomId'] = this.roomId;
    return data;
  }
}

class Trade {
  String? id;
  String? tradeId;
  Buyer? buyer;
  Seller? seller;
  String? fromCurrency;
  String? toCurrency;
  String? proposedRate;
  num? agreedRate;
  String? adId;
  num? currencyCount;
  String? creationDateTime;
  TradeStatus? status;
  String? updatedDateTime;
  String? tradeType;
  bool? buyerRating;
  bool? sellerRating;
  Trade(
      {this.id,
      this.tradeId,
      this.buyer,
      this.seller,
      this.fromCurrency,
      this.toCurrency,
      this.proposedRate,
      this.agreedRate,
      this.adId,
      this.currencyCount,
      this.creationDateTime,
      this.status});

  Trade.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tradeId = json['tradeId'];
    buyer = json['buyer'] != null ? new Buyer.fromJson(json['buyer']) : null;
    seller =
        json['seller'] != null ? new Seller.fromJson(json['seller']) : null;
    fromCurrency = json['fromCurrency'];
    toCurrency = json['toCurrency'];
    proposedRate = json['proposedRate'];
    agreedRate = json['agreedRate'];
    adId = json['adId'];
    currencyCount = json['currencyCount'];
    creationDateTime = json['creationDateTime'];
    status =
        json['status'] != null ? TradeStatus.fromJson(json['status']) : null;
    updatedDateTime = json['updatedDateTime'];
    tradeType = json['tradeType'];
    buyerRating = json['buyerRating'];
    sellerRating = json['sellerRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tradeId'] = this.tradeId;
    if (this.buyer != null) {
      data['buyer'] = this.buyer!.toJson();
    }
    if (this.seller != null) {
      data['seller'] = this.seller!.toJson();
    }
    data['fromCurrency'] = this.fromCurrency;
    data['toCurrency'] = this.toCurrency;
    data['proposedRate'] = this.proposedRate;
    data['agreedRate'] = this.agreedRate;
    data['adId'] = this.adId;
    data['currencyCount'] = this.currencyCount;
    data['creationDateTime'] = this.creationDateTime;
    data['status'] = this.status;
    data['updatedDateTime'] = this.updatedDateTime;
    data['tradeType'] = this.tradeType;
    data['buyerRating'] = this.buyerRating;
    data['sellerRating'] = this.sellerRating;

    return data;
  }
}

class Buyer {
  String? buyerId;
  String? beneficiaryId;
  String? channelId;
  num? fiatFee;

  Buyer({this.buyerId, this.beneficiaryId, this.channelId});

  Buyer.fromJson(Map<String, dynamic> json) {
    buyerId = json['buyerId'];
    beneficiaryId = json['beneficiaryId'];
    channelId = json['channelId'];
    fiatFee = json['fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buyerId'] = this.buyerId;
    data['beneficiaryId'] = this.beneficiaryId;
    data['channelId'] = this.channelId;
    data['fee'] = this.fiatFee;
    return data;
  }
}

class Seller {
  String? sellerId;
  String? beneficiaryId;
  String? channelId;
  num? fiatFee;
  Seller({this.sellerId, this.beneficiaryId, this.channelId});

  Seller.fromJson(Map<String, dynamic> json) {
    sellerId = json['sellerId'];
    beneficiaryId = json['beneficiaryId'];
    channelId = json['channelId'];
    fiatFee = json['fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sellerId'] = this.sellerId;
    data['beneficiaryId'] = this.beneficiaryId;
    data['channelId'] = this.channelId;
    data['fee'] = this.fiatFee;
    return data;
  }
}
