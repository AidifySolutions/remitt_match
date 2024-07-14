import 'package:fiat_match/models/authentication.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:flutter/material.dart';

class OtpProvider extends ChangeNotifier {
  late CustomerRepository _customerRepository;
  late ApiResponse<bool> _otpSent;
  late ApiResponse<bool> _phoneVerified;
  late ApiResponse<Authentication> _otpVerified;
  late String _otpCode;

  ApiResponse<bool> get otpSent => _otpSent;

  ApiResponse<bool> get phoneVerified => _phoneVerified;

  ApiResponse<Authentication> get otpVerified => _otpVerified;

  String get otpCode => _otpCode;

  OtpProvider(BuildContext context) {
    _customerRepository = CustomerRepository(context);
    _otpSent = ApiResponse.initial('Not Initialized');
    _phoneVerified = ApiResponse.initial('Not Initialized');
    _otpCode = "";
  }

  resendSms(String customerId, SmsType smsType) async {
    _otpSent = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      bool response = await _customerRepository.resendSms(customerId, smsType);
      _otpSent = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _otpSent = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  validatePhone(String customerId, String code) async {
    _phoneVerified = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      bool response = await _customerRepository.validatePhone(code, customerId);
      _phoneVerified = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _phoneVerified = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  validateOtp(String customerId, String code) async {
    _otpVerified = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Authentication response =
          await _customerRepository.validateOtp(customerId, code);
      _otpVerified = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _otpVerified = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  resetOtpSent() {
    _otpSent = ApiResponse.initial('Not Initialized');
    _otpCode = "";
  }

  resetPhoneVerified() {
    _phoneVerified = ApiResponse.initial('Not Initialized');
    _otpCode = "";
  }

  resetOtpVerified() {
    _otpVerified = ApiResponse.initial('Not Initialized');
    _otpCode = "";
  }

  setOtpCode(String value) {
    _otpCode = value;
  }
}
