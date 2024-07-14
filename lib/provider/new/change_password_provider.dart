import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:flutter/material.dart';

class ChangePasswordProvider with ChangeNotifier {
  late CustomerRepository _customerRepository;
  late ApiResponse<Customer> _changePassword;
  ApiResponse<Customer> get changePassword => _changePassword;

  ChangePasswordProvider(BuildContext context){
    _customerRepository = CustomerRepository(context);
    _changePassword = ApiResponse.initial('Not Initialized');
  }
  reset(){
    _changePassword = ApiResponse.initial('Not Initialized');
  }
  sendChangePassword(String email, String code,Map<String, dynamic> body) async{
    _changePassword = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try{
      Customer response = await _customerRepository.updatePassword(email,code,body);
      _changePassword = ApiResponse.completed(response);
      notifyListeners();
    }catch(e){
      _changePassword = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}