import 'package:fiat_match/models/authentication.dart';
import 'package:fiat_match/models/plans/create_payment.dart';
import 'package:fiat_match/models/plans/free_plan.dart';
import 'package:fiat_match/models/plans/instrument.dart';
import 'package:fiat_match/models/plans/plans.dart';
import 'package:fiat_match/models/plans/subscriptions.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/repositories/add_payment_repository.dart';
import 'package:flutter/cupertino.dart';

class PaymentPlanProvider extends ChangeNotifier {
  late final BuildContext _context;
  late AddPaymentPlanRepository _planRepo;

  late ApiResponse<InitialPlans> _plans;
  late ApiResponse<FreePlan> _freePlansSubscritpion;
  late bool isloading = false;

  late ApiResponse<Subscriptions> _subscritpion;
  late ApiResponse<Instruments> _instruments;
  late ApiResponse<AddInstrumentsResponse> _addInstrument;
  late ApiResponse<CreatePaymentRes> _createPayment;
  late ApiResponse<CreatePaymentRes> _paymentStatus;

  ApiResponse<InitialPlans> get intialPlans => _plans;
  ApiResponse<FreePlan> get freePlanSubcription => _freePlansSubscritpion;
  ApiResponse<Subscriptions> get subscritpion => _subscritpion;
  ApiResponse<Instruments> get instruments => _instruments;
  ApiResponse<AddInstrumentsResponse> get addInstruments => _addInstrument;
  ApiResponse<CreatePaymentRes> get createPayment => _createPayment;
  ApiResponse<CreatePaymentRes> get paymentStatus => _paymentStatus;

  PaymentPlanProvider(BuildContext context) {
    _planRepo = AddPaymentPlanRepository(context);
    _plans = ApiResponse.initial('Not Initialized');
    _freePlansSubscritpion = ApiResponse.initial('Not Initialized');
    _instruments = ApiResponse.initial('Not Initialized');
    _addInstrument = ApiResponse.initial('Not Initialized');
    _createPayment = ApiResponse.initial('Not Initialized');
    _paymentStatus = ApiResponse.initial('Not Initialized');
    isloading = false;
  }

  getInitialPlans() async {
    isloading = true;
    _plans = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      InitialPlans response = await _planRepo.getInitialPlans();
      _plans = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _plans = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  getFreePlanSubscription() async {
    isloading = true;
    _plans = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      FreePlan response = await _planRepo.getFreemiumPlan();
      _freePlansSubscritpion = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _plans = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  getSubscriptionPlan({String plandId = ''}) async {
    isloading = true;
    _plans = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Subscriptions response =
          await _planRepo.getSubscritpionPlans(plandId: plandId);
      _subscritpion = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _plans = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  getSavedPaymentPlans() async {
    isloading = true;
    _instruments = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Instruments response = await _planRepo.getSavedPaymentMethods();
      _instruments = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _instruments = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  addPaymentPlans(
      {required String customer,
      required String externalCustomer,
      required String cardNo,
      required String cardExpiry,
      required String cardCvv,
      required String cardBusineesAddress}) async {
    isloading = true;
    _addInstrument = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      var _expiry = cardExpiry.split('/');
      AddInstrument _obj = AddInstrument(
          customer: customer,
          externalCustomer: externalCustomer,
          billingAddress: cardBusineesAddress,
          cvv: cardCvv,
          number: cardNo,
          expiry: Expiry(month: _expiry[0], year: _expiry[1]));

      AddInstrumentsResponse response = await _planRepo.addPaymentPlans(_obj);
      _addInstrument = ApiResponse.completed(response);
      getSavedPaymentPlans();
      notifyListeners();
    } catch (e) {
      _addInstrument = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  createPaymentCall({required CreatePaymentReq obj}) async {
    isloading = true;
    _createPayment = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      CreatePaymentRes response = await _planRepo.createPayment(obj);
      _createPayment = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _createPayment = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  checkPayemntStatus({required String intend}) async {
    isloading = true;
    _paymentStatus = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      CreatePaymentRes response = await _planRepo.checkPaymentStatus(intend);
      _paymentStatus = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _paymentStatus = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  deletePaymentMethod({required String id}) async {
    isloading = true;
    notifyListeners();
    try {
      Instruments response = await _planRepo.deletePaymentInstruemnt(id);
      getSavedPaymentPlans();
      notifyListeners();
    } catch (e) {} finally {
      isloading = false;
      notifyListeners();
    }
  }
}
