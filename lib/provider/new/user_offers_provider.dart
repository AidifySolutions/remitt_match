import 'dart:convert';
import 'dart:math';

import 'package:fiat_match/models/advertisement.dart';
import 'package:fiat_match/models/currency.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/models/post_offer.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/mid_market_rate_provider.dart';
import 'package:fiat_match/repositories/advertisement_repository.dart';
import 'package:fiat_match/repositories/mid_market_rate_repository.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fiat_match/models/advertisement.dart' as AdRate;
class UserOffersProvider extends ChangeNotifier {
  late AdvertisementRepository _advertisementRepository;

  late ApiResponse<Advertisement> _offers;
  late Ads? _selectedOffer;
  late Ads? _selectedFiatOffer;
  late CustomerData? _selectedOfferData;
  late TextEditingController amountYouWantToSendController;
  late TextEditingController amountRecipientWillGetController;
  late String? _currencyYouWantToSend;
  late String? _currencyRecipientWillGet;
  late ApiResponse<OffersSellers> _offersSellers;
  late ApiResponse<PostOfferResponse> _postOffer;
  late ApiResponse<Ads> _getAddById;

  bool isLoading = false;
  List<Ads> fetchOffers = [];
  List<CustomerData> fetchOffersSellers = [];
  bool hasMoreOffers = true;
  bool loadOffers = true;
  int _pageNo = 1;
  ApiResponse<OffersSellers> get sellers => _offersSellers;
  CustomerData? get sellerOfferData => _selectedOfferData;
  ApiResponse<Advertisement> get offers => _offers;
  ApiResponse<PostOfferResponse> get postOffer => _postOffer;
  ApiResponse<Ads> get ad => _getAddById;

  late MidMarketRateRepository _midMarketRateRepository;
  double parallelMarketRate = 0;
  Ads? get selectedOffer => _selectedOffer;
  Ads? get selectedFiatOffer => _selectedFiatOffer;
  String? get currencyRecipientWillGet => _currencyRecipientWillGet;

  String? get currencyYouWantToSend => _currencyYouWantToSend;

  UserOffersProvider(BuildContext context) {
    _advertisementRepository = AdvertisementRepository(context);
    _midMarketRateRepository = MidMarketRateRepository(context);
    _offers = ApiResponse.initial('Not Initialized');
    _postOffer = ApiResponse.initial('Not Initialized');
    _getAddById = ApiResponse.initial('Not Initialized');
    _currencyYouWantToSend = null;
    _currencyRecipientWillGet = null;
    _selectedFiatOffer = null;
    amountYouWantToSendController = TextEditingController();
    amountRecipientWillGetController = TextEditingController();
  }

  getAllOffers(
      {String? sellingCurrency,
      String? buyingCurrency,
      String? filter,
      String? buyingLimit,
      String? sellingLimit,
      UserType? userType = UserType.Buyer,
      String? sorttype,
      String? limit,
      String? expiry,
      String? noOfTransactions}) async {
    _offers = ApiResponse.loading('Fetching Data');
    loadOffers = true;
    notifyListeners();
    try {
      Advertisement response =
          await _advertisementRepository.getAllAdvertisement(
              sellingCurrency,
              buyingCurrency,
              filter,
              _pageNo.toString(),
              '20',
              buyingLimit,
              sellingLimit,
              userType,
              sorttype,
              limit,
              noOfTransactions,
              expiry);
      hasMoreOffers =
          (response.paging?.pageNumber! != response.paging?.totalPages!);
      _pageNo = response.paging?.pageNumber ?? 0 + 1;
      _offers = ApiResponse.completed(response);
      _selectedOffer = null;
      _selectedFiatOffer = null;
      if (response.ads!.length > 0) fetchOffers.addAll(_offers.data!.ads!);
      var _sellerIds = response.ads!.map((e) => e.customer).toList();
      getOffersSellers(_sellerIds);
      // if (userType == UserType.Buyer) {
      //   setSelectedOffer(fetchOffers.first);
      // }
      if(_sellerIds.length > 0)
         getOffersSellers(_sellerIds);
      if( userType == UserType.Buyer && fetchOffers.length > 0) {
         setSelectedOffer(fetchOffers.first);
      }else{
        setCurrencyYouWantToSend(sellingCurrency ?? 'CAD');
        setCurrencyRecipientWillGet(buyingCurrency ?? 'NGN');
      }
      var res =  await _midMarketRateRepository.getMidMarketRate(currencyRecipientWillGet!, currencyYouWantToSend!);
      var parallerRateResponse = await _midMarketRateRepository.getParallelMarketRate(currencyRecipientWillGet!, currencyYouWantToSend!);
      parallelMarketRate =  parallerRateResponse.rate ?? 0;
      print("Total offers" + fetchOffers.length.toString());
      notifyListeners();
    } catch (e) {
      _offers = ApiResponse.error(e.toString());
      loadOffers = false;
      notifyListeners();
    } finally {
      loadOffers = false;
      notifyListeners();
    }
  }

  getOffersSellers(
    List<String?> ids,
  ) async {
    _offersSellers = ApiResponse.loading('Fetching Data');
    loadOffers = true;
    notifyListeners();
    try {
      OffersSellers response =
          await _advertisementRepository.getAllAdvertisementSellers(ids);
      _selectedOfferData = setSelectedOfferSeller(response.sellerData!.first);
      _offersSellers = ApiResponse.completed(response);
      fetchOffersSellers.addAll(_offersSellers.data!.sellerData!);
      notifyListeners();
    } catch (e) {
      _offersSellers = ApiResponse.error(e.toString());
      notifyListeners();
    } finally {
      loadOffers = false;
      notifyListeners();
    }
  }

  postOffers(PostOffer _obj) async {
    _postOffer = ApiResponse.loading('Fetching Data');
    isLoading = true;
    notifyListeners();
    try {
      PostOfferResponse response =
          await _advertisementRepository.postAdvertisement(_obj);
      _postOffer = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _postOffer = ApiResponse.error(e.toString());
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  getAdvertismentById(id) async {
    notifyListeners();
    try {
      var response = await _advertisementRepository.getAdvertisementById(id);
      _getAddById = ApiResponse.completed(response.ads!);
      notifyListeners();
    } catch (e) {
      print(e);
    } finally {
      notifyListeners();
    }
  }

  setAmountRecipientWillGet(String amountYouWantToSend) {
    var amount =
        amountYouWantToSend.isEmpty ? 0 : double.parse(amountYouWantToSend);
    if(_selectedFiatOffer != null) {
      double rate = parallelMarketRate;
      amountRecipientWillGetController.text =
      rate == 0 ? '0' : (amount * rate).toStringAsFixed(5);
    }else if(_selectedOffer != null){
      double rate = _selectedOffer?.rate?.value ?? 0;
      amountRecipientWillGetController.text =
      rate == 0 ? '0' : (amount / rate).toStringAsFixed(5);
    }
    notifyListeners();
  }

  setAmountYouWantToSend(String amountRecipientWillGet) {
    var amount = amountRecipientWillGet.isEmpty
        ? 0
        : double.parse(amountRecipientWillGet);
    if(_selectedFiatOffer != null) {
      double rate =  parallelMarketRate;
      amountYouWantToSendController.text =
      rate == 0 ? '0' : (amount / rate).toStringAsFixed(5);
    }else if(_selectedOffer != null){
      double rate = _selectedOffer?.rate?.value ?? 0;
      amountYouWantToSendController.text =
      rate == 0 ? '0' : (amount * rate).toStringAsFixed(5);
    }
    notifyListeners();
  }

  //for post offer
  setAmountRecipientWillGetPostOffer(
      String amountYouWantToSend, double userRate) {
    var amount =
        amountYouWantToSend.isEmpty ? 0 : double.parse(amountYouWantToSend);
    double rate = userRate;
    amountRecipientWillGetController.text =
        rate == 0 ? '0' : (amount * rate).toStringAsFixed(5);
    notifyListeners();
  }

  setAmountYouWantToSendPostOffer(
      String amountRecipientWillGet, double userRate) {
    var amount = amountRecipientWillGet.isEmpty
        ? 0
        : double.parse(amountRecipientWillGet);
    double rate = userRate;
    amountYouWantToSendController.text =
        rate == 0 ? '0' : (amount / rate).toStringAsFixed(5);
    notifyListeners();
  }

  setCurrencyYouWantToSend(String? value) {
    _currencyYouWantToSend = value;
    _selectedOffer = null;
    _selectedFiatOffer = null;
    notifyListeners();
  }

  setCurrencyRecipientWillGet(String? value) {
    _currencyRecipientWillGet = value;
    _selectedOffer = null;
    _selectedFiatOffer = null;
    notifyListeners();
  }

  setSelectedOffer(Ads? ads) {
    _selectedFiatOffer = null;
    _selectedOffer = ads;
    _currencyYouWantToSend = ads?.buyingCurrency;
    _currencyRecipientWillGet = ads?.sellingCurrency;
    notifyListeners();
  }

  setSelectedFiatOffer({String? sellingCurrency, String? buyingCurrency, double? rate}){
    _selectedOffer = null;
    _selectedFiatOffer = new Ads(sellingCurrency: sellingCurrency,buyingCurrency: buyingCurrency,rate: AdRate.Rate(value: rate));
    notifyListeners();
  }

  setSelectedOfferSeller(CustomerData? obj) {
    _selectedOfferData = obj;
    notifyListeners();
  }

  setSelectedOfferSellerByAdd() {
    try {
      if(_selectedOffer != null) {
        _selectedOfferData = _offersSellers.data!.sellerData!
            .where((e) => e.id == _selectedOffer!.customer)
            .first;
      }
    } catch (e) {
      print(e);
    }
  }

  reset() {
    _offers = ApiResponse.initial('Not Initialized');
    _selectedOffer = null;
    _currencyYouWantToSend = null;
    _currencyRecipientWillGet = null;
    amountYouWantToSendController.text = '';
    amountRecipientWillGetController.text = '';
    clearOffers();
  }

  clearOffers() {
    fetchOffers..clear();
    fetchOffersSellers..clear();
    _pageNo = 1;
    hasMoreOffers = true;
  }
}
