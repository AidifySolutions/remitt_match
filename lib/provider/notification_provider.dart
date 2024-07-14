import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class NotificationProvider extends ChangeNotifier {
  late bool _isProfileInComplete;
  late bool _isLivenessInComplete;
  late BuildContext _context;
  late LoginProvider _customerProvider;

  bool get isProfileInComplete => _isProfileInComplete;

  bool get isLivenessInComplete => _isLivenessInComplete;

  NotificationProvider(BuildContext context) {
    _context = context;
    _customerProvider = Provider.of<LoginProvider>(_context, listen: false);
    checkStatus();
  }

  bool userIsLoggedIn() {
    CustomerData? customerData = _customerProvider.authentication.data?.customerData;
    return customerData?.id != null ? true : false;
  }

  checkStatus() {
    CustomerData? customerData = _customerProvider.authentication.data?.customerData;
    _isProfileInComplete = customerData?.profileStatus?.status ==
        Helper.getEnumValue(ProfileStatusEnum.Incomplete.toString());
    _isLivenessInComplete = customerData?.livenessStatus!.status ==
        Helper.getEnumValue(livenessStatus.Incomplete.toString());
    notifyListeners();
  }

  setSelectedTab(int value) {
    notifyListeners();
  }
}
