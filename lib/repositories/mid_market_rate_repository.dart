import 'package:fiat_match/models/mid_market_rate.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MidMarketRateRepository {
  late final BuildContext _context;

  MidMarketRateRepository(BuildContext context) {
    _context = context;
  }

  Future<MidMarketRate> getMidMarketRate(
      String? sellingCurrency,
      String? buyingCurrency) async {

    Map<String, String> queryParam = Map<String, String>();

    if (sellingCurrency != null) {
      queryParam.putIfAbsent("sellingCurrency", () => sellingCurrency);
    }
    if (buyingCurrency != null) {
      queryParam.putIfAbsent("buyingCurrency", () => buyingCurrency);
    }
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetMidMarketRate), _context,
        params: queryParam, token: _token);

    print(response);
    MidMarketRate rate = MidMarketRate.fromJson(response);
    return rate;
  }
  Future<MidMarketRate> getParallelMarketRate(
      String? sellingCurrency,
      String? buyingCurrency) async {

    Map<String, String> queryParam = Map<String, String>();

    if (sellingCurrency != null) {
      queryParam.putIfAbsent("sellingCurrency", () => sellingCurrency);
    }
    if (buyingCurrency != null) {
      queryParam.putIfAbsent("buyingCurrency", () => buyingCurrency);
    }
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetParallelMarketRate), _context,
        params: queryParam, token: _token);

    print(response);
    MidMarketRate rate = MidMarketRate.fromJson(response);
    return rate;
  }
}
