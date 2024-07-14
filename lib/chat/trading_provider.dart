import 'package:fiat_match/models/advertisement.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/models/recipient.dart';
import 'package:fiat_match/models/trade_info.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/trade_repository.dart';
import 'package:flutter/material.dart';

class TradingProvider extends ChangeNotifier {
  late final BuildContext _context;

  late Ads? _advertisement;
  late Beneficiaries? _beneficiaries;
  late Channel? _channel;
  late ApiResponse<TradeInfo> _tradeInfo;
  late TradeRepository _tradeRepository;
  late String? _agreedRate;
  late String? _currencyCount;
  late String? _status;
  late String? _tradeId;
  late String? _prosedRate;
  late String? _prevAgreedRate;

  TradingProvider(BuildContext context) {
    _context = context;
    _advertisement = null;
    _channel = null;
    _beneficiaries = null;
    _tradeInfo = ApiResponse.initial('Not Initialized');
    _tradeRepository = TradeRepository(context);
    _agreedRate = null;
    _currencyCount = null;
    _status = null;
    _prosedRate = null;
  }

  Ads? get advertisement => _advertisement;

  Channel? get channel => _channel;

  Beneficiaries? get beneficiaries => _beneficiaries;

  ApiResponse<TradeInfo> get tradeInfo => _tradeInfo;

  String? get agreedRate => _agreedRate;

  String? get currencyCount => _currencyCount;

  String? get status => _status;

  String? get tradeId => _tradeId;

  String? get prevAgreedRate => _prevAgreedRate;

  bool isLoading = false;

  setTradeId(String value) {
    _tradeId = value;
  }

  setAdvertisement(Ads value) {
    _advertisement = value;
  }

  setSelectedRecipient(Beneficiaries beneficiaries, Channel channel) {
    _beneficiaries = beneficiaries;
    _channel = channel;
    // _channel = beneficiaries.channel![channelIndex];
    notifyListeners();
  }

  setNegotiatedRate(String? agreedRate, String currencyCount) {
    _prevAgreedRate = _agreedRate;
    _agreedRate = agreedRate;
    _currencyCount = currencyCount;
    //notifyListeners();
  }

  setTradeStatus(String status) {
    _status = status;
  }

  resetBeneficiarySelection() {
    _beneficiaries = null;
    _channel = null;
  }

  resetTradeInfo() {
    _tradeInfo = ApiResponse.initial('Initial');
  }

  resetNegotiation() {
    _agreedRate = null;
    _currencyCount = null;
    _status = null;
  }

  initiateTrade(
      {Ads? ads,
      Beneficiaries? beneficiaries,
      Channel? channel,
      String? currencyCount,
      bool isFiatMatchOffer = false}) async {
    _tradeInfo = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      var response = await _tradeRepository.initiateTrade(
          ads,
          beneficiaries,
          channel,
          ads!.rate!.value!.toString(),
          currencyCount,
          isFiatMatchOffer);
      _tradeInfo = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _tradeInfo = ApiResponse.error(e.toString());
      
      notifyListeners();
    }
  }

  updateTrade(String tradeId, {bool sendId = false}) async {
    _tradeInfo = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      TradeInfo response = await _tradeRepository.updateTrade(
          _advertisement,
          _beneficiaries,
          _channel,
          _agreedRate,
          _currencyCount,
          TradeStatus(status: status, message: "message"),
          tradeId,
          false,
          sendId: sendId);
      _tradeInfo = ApiResponse.completed(response);

      notifyListeners();
    } catch (e) {
      _tradeInfo = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  getTradeById(String tradeId) async {
    _tradeInfo = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      TradeInfo response = await _tradeRepository.getTradeById(tradeId);
      print(response);
      _tradeInfo = ApiResponse.completed(response);
      setTradeId(_tradeInfo.data!.trade!.id!);

      notifyListeners();
    } catch (e) {
      _tradeInfo = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
