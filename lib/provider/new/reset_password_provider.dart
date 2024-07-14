import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:flutter/material.dart';
import 'package:fiat_match/models/customer.dart';

class ResetPasswordProvider with ChangeNotifier {
  late CustomerRepository _customerRepository;
  late ApiResponse<Customer> _resetPassword;
  bool isPasswordResetSuccess = false;
  ApiResponse<Customer> get resetPassword => _resetPassword;

  ResetPasswordProvider(BuildContext context){
    _customerRepository = CustomerRepository(context);
    _resetPassword = ApiResponse.initial('Not Initialized');
  }
  reset(){
    _resetPassword = ApiResponse.initial('Not Initialized');
  }
  sendResetPassword(String email, String code,Map<String, dynamic> body) async{
    _resetPassword = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try{
      Customer response = await _customerRepository.updatePassword(email,code,body);
      _resetPassword = ApiResponse.completed(response);
      isPasswordResetSuccess = _resetPassword.data?.customerData != null ? true : false;
      notifyListeners();
    }catch(e){
      _resetPassword = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}