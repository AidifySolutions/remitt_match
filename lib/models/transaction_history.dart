import 'package:fiat_match/models/trade_info.dart';

class TransactionHistory {
  String? message;
  List<Trade>? trades;
  Paging? paging;

  TransactionHistory({this.message, this.trades, this.paging});

  TransactionHistory.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['trades'] != null) {
      trades = [];
      json['trades'].forEach((v) {
        trades!.add(new Trade.fromJson(v));
      });
    }
    paging =
    json['paging'] != null ? new Paging.fromJson(json['paging']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.trades != null) {
      data['trades'] = this.trades!.map((v) => v.toJson()).toList();
    }
    if (this.paging != null) {
      data['paging'] = this.paging!.toJson();
    }
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
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    totalItems = json['totalItems'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['totalItems'] = this.totalItems;
    data['totalPages'] = this.totalPages;
    return data;
  }
}