import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/models/trade_info.dart';
import 'package:fiat_match/models/transaction_history.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/repositories/customer_repo.dart';
import 'package:fiat_match/repositories/trade_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionHistoryProvider extends ChangeNotifier {
  late TradeRepository _tradeRepository;
  late CustomerRepository _customerRepository;
  late ApiResponse<TransactionHistory> _trade;
  late List<CustomerData> _buyerAndSellerData;
  late List<Trade> _paginatedTradeData;
  CustomerData? customer;
  ApiResponse<TransactionHistory> get trade => _trade;
  List<CustomerData> get buyerAndSellerData => _buyerAndSellerData;
  List<Trade> get paginatedTradeData => _paginatedTradeData;
  int pageCount = 1;
  int? numberOfEntries = 20;
  TransactionHistoryProvider(BuildContext context) {
    _tradeRepository = TradeRepository(context);
    _customerRepository = CustomerRepository(context);
    _trade = ApiResponse.initial('Not Initialized');
    _buyerAndSellerData = <CustomerData>[];
    customer = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data
        ?.customerData;
    _paginatedTradeData = [];
  }

  getAllTrade(
      {String? traderType,
      String? pageNumber,
      String? noOfEntries,
      bool activeTrades = false}) async {
    _trade = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      var response = await _tradeRepository.getAllTrade(
          traderType, pageCount.toString(), numberOfEntries.toString(),
          activeTrades: activeTrades);
      var custIds = response.trades!.map((e) => e.buyer!.buyerId).toList();
      custIds.addAll(response.trades!.map((e) => e.seller?.sellerId).toList());
      var ids = custIds.toSet().toList();

      for (int i = 0; i < _buyerAndSellerData.length; i++) {
        if (ids.contains(_buyerAndSellerData[i].id)) {
          ids.remove(_buyerAndSellerData[i].id);
        }
      }
      if (ids.length > 0) {
        var buyerSellerData = await _customerRepository.getBulkCustomers(ids);
        _buyerAndSellerData.addAll(buyerSellerData);
      }
      _paginatedTradeData.addAll(response.trades!.toList());
      _trade = ApiResponse.completed(response);
      pageCount++;

      notifyListeners();
    } catch (e) {
      _trade = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  getSellerBuyerName(custId) {
    return customer?.id == custId
        ? _buyerAndSellerData
            .singleWhere((element) => element.id == custId,
                orElse: () => CustomerData(firstName: ''))
            .firstName
        : _buyerAndSellerData
            .firstWhere((element) => element.id == custId,
                orElse: () => CustomerData(nickName: ''))
            .nickName;
  }

 CustomerData getSellerBuyerInfo(custId) {
    return customer?.id == custId
        ? _buyerAndSellerData.singleWhere((element) => element.id == custId,
            orElse: () => CustomerData(firstName: ''))
        : _buyerAndSellerData.firstWhere((element) => element.id == custId,
            orElse: () => CustomerData(nickName: ''));
  }

  reset() {
    _paginatedTradeData = [];
    _buyerAndSellerData = <CustomerData>[];
    customer = null;
    pageCount = 1;

    _trade = ApiResponse.initial('Not Initialized');
  }
}
