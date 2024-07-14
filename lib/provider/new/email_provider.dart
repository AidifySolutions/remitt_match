import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:flutter/material.dart';

class EmailProvider extends ChangeNotifier {
  late CustomerRepository _customerRepository;
  late ApiResponse<bool> _emailSent;

  ApiResponse<bool> get emailSent => _emailSent;

  EmailProvider(BuildContext context) {
    _customerRepository = CustomerRepository(context);
    _emailSent = ApiResponse.initial('Not Initialized');
  }

  resendEmail(String customerId) async {
    _emailSent = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      bool response = await _customerRepository.resendEmail(customerId);
      _emailSent = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _emailSent = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  reset() {
    _emailSent = ApiResponse.initial('Not Initialized');
  }
}
