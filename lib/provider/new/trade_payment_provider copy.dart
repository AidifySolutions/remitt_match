import 'package:fiat_match/models/plans/activity.dart';
import 'package:fiat_match/models/plans/create_payment.dart';
import 'package:fiat_match/models/plans/free_plan.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/trade_payment_repository.dart';
import 'package:flutter/cupertino.dart';

class TradePaymentProvider extends ChangeNotifier {
  late final BuildContext _context;
  late TradePaymentPlanRepository _tradePaymentRepo;

  late ApiResponse<TradePaymentStatusResp> tradeStatus;
  late ApiResponse<FreePlan> _freePlansSubscritpion;
  late bool isloading = false;
  late ApiResponse<ActivityResponse> activityStatus;
  late ApiResponse<CreatePaymentRes> _createPayemntResp;
  ApiResponse<TradePaymentStatusResp> get getTradeStatus => tradeStatus;
  ApiResponse<FreePlan> get freePlanSubcription => _freePlansSubscritpion;

  TradePaymentProvider(BuildContext context) {
    _tradePaymentRepo = TradePaymentPlanRepository(context);
    tradeStatus = ApiResponse.initial('Not Initialized');
    _freePlansSubscritpion = ApiResponse.initial('Not Initialized');
    _createPayemntResp = ApiResponse.initial('Not Initialized');
    activityStatus = ApiResponse.initial('Not Initialized');
    isloading = false;
  }
  createPayment(CreateTradePaymentReq obj) async {
    isloading = true;
    tradeStatus = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      CreatePaymentRes response = await _tradePaymentRepo.createPaymentForTrade(obj);
      _createPayemntResp = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      tradeStatus = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  createActivity(ActivityRequest obj) async {
    isloading = true;
    tradeStatus = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      ActivityResponse response = await _tradePaymentRepo.createActivityForTrade(obj);
      activityStatus = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      tradeStatus = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  getTradePaymentStatus(String tradeId) async {
    isloading = true;
    tradeStatus = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      TradePaymentStatusResp response =
          await _tradePaymentRepo.getTradePaymentStatus(tradeId);
      tradeStatus = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      tradeStatus = ApiResponse.error(e.toString());
    } finally {
      isloading = false;
      notifyListeners();
    }
  }

  reset() {
    tradeStatus = ApiResponse.initial('Not Initialized');
  }
}
