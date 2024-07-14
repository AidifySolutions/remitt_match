import 'package:fiat_match/models/currency.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/recipient_repository.dart';
import 'package:flutter/material.dart';

class CurrencyProvider extends ChangeNotifier {
  late RecipientRepository _recipientRepository;
  late ApiResponse<Currency> _currency;

  ApiResponse<Currency> get currency => _currency;

  CurrencyProvider(BuildContext context) {
    _recipientRepository = RecipientRepository(context);
    _currency = ApiResponse.initial('Not Initialized');
  }

  getCurrency() async {
    _currency = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Currency response = await _recipientRepository.getCurrency();
      _currency = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _currency = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  resetCurrencyState() {
    _currency.status = Status.INITIAL;
  }
}
