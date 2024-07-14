import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:flutter/material.dart';
import 'package:fiat_match/models/customer.dart';

class ForgotPasswordProvider with ChangeNotifier {
  late CustomerRepository _customerRepository;
  late ApiResponse<Customer> _forgotPassword;

  ApiResponse<Customer> get forgotPassword => _forgotPassword;

  ForgotPasswordProvider(BuildContext context){
    _customerRepository = CustomerRepository(context);
    _forgotPassword = ApiResponse.initial('Not Initialized');
  }
  reset(){
    _forgotPassword = ApiResponse.initial('Not Initialized');
  }
  sendForgotPassword(String email) async{
    _forgotPassword = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try{
      Customer response = await _customerRepository.forgotPassword(email);
      _forgotPassword = ApiResponse.completed(response);
      notifyListeners();
    }catch(e){
      _forgotPassword = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}