import 'package:fiat_match/models/authentication.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  late CustomerRepository _customerRepository;
  late ApiResponse<Authentication> _authentication;
  late bool _logInWithMobile;
  late bool _isProfileInComplete;
  late bool _isLivenessInComplete;

  ApiResponse<Authentication> get authentication => _authentication;

  bool get logInWithMobile => _logInWithMobile;

  bool get isProfileInComplete => _isProfileInComplete;

  bool get isLivenessInComplete => _isLivenessInComplete;

  LoginProvider(BuildContext context) {
    _customerRepository = CustomerRepository(context);
    _authentication = ApiResponse.initial('Not Initialized');
    _logInWithMobile = false;
  }

  authenticate(String email, String password, String dialCode,
      String phoneNumber, String isoCountryCode, LoginType loginType) async {
    _authentication = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Authentication response = await _customerRepository.authenticate(
          email, password, dialCode, phoneNumber, isoCountryCode, loginType);
      _authentication = ApiResponse.completed(response);
      SharedPref.setValueString('userId', response.customerData!.id!);
      notifyListeners();
    } catch (e) {
      _authentication = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  setLogInWithMobile(bool value) {
    _logInWithMobile = value;
    notifyListeners();
  }

  reset() {
    _authentication = ApiResponse.initial('Not Initialized');
    Constants.showProfileDialog = true;
  }

  checkStatus() {
    // _isProfileInComplete = _authentication.data?.customerData?.profileStatus?.status ==
    //     Helper.getEnumValue(ProfileStatusEnum.Incomplete.toString());
    // _isLivenessInComplete = _authentication.data?.customerData?.livenessStatus!.status ==
    //     Helper.getEnumValue(livenessStatus.Incomplete.toString());
    notifyListeners();
  }
}
