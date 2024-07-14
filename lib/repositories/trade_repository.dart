import 'dart:convert';
import 'dart:developer';

import 'package:fiat_match/models/advertisement.dart';
import 'package:fiat_match/models/recipient.dart';
import 'package:fiat_match/models/trade_info.dart';
import 'package:fiat_match/models/transaction_history.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/material.dart';

class TradeRepository {
  late final BuildContext _context;

  TradeRepository(BuildContext context) {
    _context = context;
  }

  Future<TradeInfo> initiateTrade(
      Ads? ads,
      Beneficiaries? beneficiaries,
      Channel? channel,
      String? agreedRate,
      String? currencyCount,
      bool isFiatMatchOffer) async {
    var body = tradeRequestBody(
        beneficiaries,
        channel,
        ads,
        agreedRate,
        currencyCount,
        TradeStatus(
            status: ads?.openToNegotiate ?? false
                ? "AwaitingConfirmation"
                : "AwaitingPayment",
            message: "No message"),
        isFiatMatchOffer);
    String? _token = Helper.getToken(_context);
    var response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.InitiateTrade),
        json.encode(body),
        _context,
        token: _token);

    return TradeInfo.fromJson(response);
  }

  Future<TradeInfo> updateTrade(
      Ads? ads,
      Beneficiaries? beneficiaries,
      Channel? channel,
      String? agreedRate,
      String? currencyCount,
      TradeStatus? status,
      String? tradeId,
      bool isFiatMatch,
      {bool sendId = false}) async {
    var body = tradeRequestBody(beneficiaries, channel, ads, agreedRate,
        currencyCount, status, isFiatMatch,
        tradeId: !sendId ? null : tradeId);
    inspect(body);
    print(body.toString());
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.putData(
        ApiPathHelper.getValue(APIPath.UpdateTrade)
            .toString()
            .replaceAll('tradeId', tradeId.toString()),
        json.encode(body),
        _context,
        token: _token);

    return TradeInfo.fromJson(response);
  }

  Future<TransactionHistory> getAllTrade(
      String? traderType, String? pageNumber, String? noOfEntries,
      {bool activeTrades = false}) async {
    var queryParam = {
      "traderType": traderType ?? '',
      'pageNumber': pageNumber ?? '',
      'noOfEntries': noOfEntries ?? ''
    };
    if (activeTrades) {
      queryParam.addAll({"activeTrades": "true"});
    }
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetAllTrades), _context,
        params: queryParam, token: _token);
    TransactionHistory transactionHistory =
        TransactionHistory.fromJson(response);
    print('transactionHistory--$transactionHistory');
    return transactionHistory;
  }

  Future<TradeInfo> getTradeById(String? tradeId) async {
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetTradeById)
            .toString()
            .replaceAll('Id', tradeId.toString()),
        _context,
        token: _token);
    print(response);
    return TradeInfo.fromJson(response);
  }

  Future<AdData> getAdvertisementById(String id) async {
    Map<String, String> queryParam = Map<String, String>();

    String? _token = Helper.getToken(_context);
    try {
      final response = await HttpClient.instance.fetchData(
          ApiPathHelper.getValue(APIPath.GetAdvertisementsWithRateById)
              .replaceAll('Id', id),
          _context,
          params: queryParam,
          token: _token);
      var a = AdData.fromJson(response);
      return a;
    } catch (exp) {
      return AdData();
    }
  }

  tradeRequestBody(
    Beneficiaries? beneficiaries,
    Channel? channel,
    Ads? ads,
    String? agreedRate,
    String? currencyCount,
    TradeStatus? status,
    bool isFiatMatchOffer, {
    String? tradeId,
  }) {
    var buyer = {
      "buyerId": beneficiaries?.customer,
      "beneficiaryId": beneficiaries?.id,
      "channelId": channel?.id
    };
    var seller = {
      "sellerId": ads?.customer,
      "beneficiaryId": ads?.recipient?.beneficiaryId,
      "channelId": ads?.recipient?.channelId
    };
    var body = {
      "buyer": buyer,
      "seller": isFiatMatchOffer ? null : seller,
      "fromCurrency": ads?.sellingCurrency,
      "toCurrency": ads?.buyingCurrency,
      "proposedRate": ads?.rate?.value,
      "agreedRate": isFiatMatchOffer ? ads?.rate?.value : agreedRate,
      "adId": isFiatMatchOffer ? null : ads?.id,
      "currencyCount": currencyCount,
      "tradeType": isFiatMatchOffer ? "PlatformBased" : "UserBased",
      "status": status,
    };
    if (tradeId != null) body.addAll({"id": tradeId});
    return body;
  }
}
