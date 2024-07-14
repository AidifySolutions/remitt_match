import 'package:fiat_match/models/mid_market_rate.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/mid_market_rate_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MidMarketRateProvider extends ChangeNotifier {
  late MidMarketRateRepository _midMarketRateRepository;
  ApiResponse<MidMarketRate> _rateResponse = ApiResponse.loading('Fetching Data');
  ApiResponse<MidMarketRate> _parallelRateResponse = ApiResponse.loading('Fetching Data');

  ApiResponse<MidMarketRate> get rateResponse => _rateResponse;
  ApiResponse<MidMarketRate> get parallelRateResponse => _parallelRateResponse;

  bool _isAbsolute = true;

  bool get isAbsolute => _isAbsolute;

  setRateType(bool value) => _isAbsolute = value;

  double _customRate = 0.0;

  double get customRate => _customRate;

  setCustomRate(double value){ _customRate = value; notifyListeners();}

  double get midMarketRate => rateResponse.data?.rate ?? 0.0;

  double get rate => isAbsolute ? customRate : midMarketRate + customRate;

  double get selectedRate => rate;


  String buyingCurrency = '';
  String sellingCurrency = '';

  MidMarketRateProvider(BuildContext context) {
    _midMarketRateRepository = MidMarketRateRepository(context);
  }

  Future getMidMarketRate(String buyingCurrency, String sellingCurrency) async {
    _rateResponse = ApiResponse.loading('Fetching Data');
    this.buyingCurrency = buyingCurrency;
    this.sellingCurrency = sellingCurrency;
    notifyListeners();
    try {
      var response = await _midMarketRateRepository.getMidMarketRate(buyingCurrency,sellingCurrency);
      _rateResponse = ApiResponse.completed(response);
      var parallelMarketResponse = await _midMarketRateRepository.getParallelMarketRate(buyingCurrency, sellingCurrency);
      _parallelRateResponse = ApiResponse.completed(parallelMarketResponse);
      notifyListeners();
    } catch (e) {
      _rateResponse = ApiResponse.error(e.toString());
      _parallelRateResponse = ApiResponse.error(e.toString());
    } finally {
      notifyListeners();
    }
  }
}
