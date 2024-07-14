import 'package:fiat_match/models/advertisement.dart';
import 'package:fiat_match/models/recipient.dart';
import 'package:fiat_match/models/trade_info.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/trade_repository.dart';
import 'package:flutter/cupertino.dart';

// class TradeProvider extends ChangeNotifier {
//   late TradeRepository _tradeRepository;
//   late ApiResponse<dynamic> _trade;
//
//   ApiResponse<dynamic> get trade => _trade;
//
//   TradeProvider(BuildContext context) {
//     _tradeRepository = TradeRepository(context);
//   }
//
  // initiateTrade(
  //     {Ads? ads,
  //     Beneficiaries? beneficiaries,
  //     Channel? channel,
  //     String? currencyCount}) async {
  //   _trade = ApiResponse.loading('Fetching Data');
  //   notifyListeners();
  //   try {
  //     var response = await _tradeRepository.initiateTrade(ads, beneficiaries,
  //         channel, ads!.rate!.value!.toString(), currencyCount);
  //     _trade = ApiResponse.completed(response);
  //     notifyListeners();
  //   } catch (e) {
  //     _trade = ApiResponse.error(e.toString());
  //     notifyListeners();
  //   }
  // }
// }
