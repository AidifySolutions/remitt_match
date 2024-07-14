import 'package:fiat_match/models/advertisement.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/models/post_offer.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AdvertisementRepository {
  late final BuildContext _context;

  AdvertisementRepository(BuildContext context) {
    _context = context;
  }

  Future<Advertisement> getAllAdvertisement(
      String? sellingCurrency,
      String? buyingCurrency,
      String? filter,
      String? pageNumber,
      String? noOfEntries,
      String? buyingLimit,
      String? sellingLimit,
      UserType? userType,
      String? sorttype,
      String? limit,
      String? noOfTransactions,
      String? expiry) async {
    Map<String, String> queryParam = Map<String, String>();

    if (sellingCurrency != null) {
      queryParam.putIfAbsent("sellingCurrency", () => sellingCurrency);
    }
    if (buyingCurrency != null) {
      queryParam.putIfAbsent("buyingCurrency", () => buyingCurrency);
    }
    if (filter != null) {
      queryParam.putIfAbsent("filter", () => filter);
    }
    if (buyingLimit != null) {
      queryParam.putIfAbsent("buyingLimit", () => buyingLimit);
    }
    if (sellingLimit != null) {
      queryParam.putIfAbsent("sellingLimit", () => sellingLimit);
    }
    if (sorttype != null && sorttype.isNotEmpty) {
      queryParam.putIfAbsent("sorttype", () => sorttype);
    }
    if (limit != null) {
      queryParam.putIfAbsent("limit", () => limit);
    }
    if (userType != null) {
      queryParam.putIfAbsent(
          "userType", () => Helper.getEnumValue(userType.toString()));
    }
    if (pageNumber != null) {
      queryParam.putIfAbsent("pageNumber", () => pageNumber.toString());
    }
    if (noOfEntries != null) {
      queryParam.putIfAbsent("noOfEntries", () => noOfEntries.toString());
    }
    if (noOfTransactions != null && noOfTransactions.isNotEmpty) {
      queryParam.putIfAbsent(
          "noOfTransactions", () => noOfTransactions.toString());
    }
    if (expiry != null && expiry.isNotEmpty) {
      queryParam.putIfAbsent("offerFilter", () => expiry.toString());
    }
    print(queryParam);
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetAdvertisementsWithRate), _context,
        params: queryParam, token: _token);
    Advertisement advertisement = Advertisement.fromJson(response);
    return advertisement;
  }

  Future<OffersSellers> getAllAdvertisementSellers(List<String?> ids) async {
    Map<String, String> queryParam = Map<String, String>();

    queryParam.addAll({'customerIds': ids.join(',')});
    // queryParam.addAll({'profileStatus': 'Verified'});

    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.AllCustomers), _context,
        params: queryParam, token: _token);
    OffersSellers _sellers = OffersSellers.fromJson(response);

    return _sellers;
  }

  Future<PostOfferResponse> postAdvertisement(PostOffer obj) async {
    String? _token = Helper.getToken(_context);
    print(json.encode(obj.toJson()));
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.AddAdvertisements),
        json.encode(obj.toJson()),
        _context,
        token: _token);
    return PostOfferResponse.fromJson(response);
  }

  Future<AdData> getAdvertisementById(String id) async {
    Map<String, String> queryParam = Map<String, String>();

    String? _token = Helper.getToken(_context);
    try {
      final response = await HttpClient.instance.fetchData(
          ApiPathHelper.getValue(APIPath.GetAdvertisementsWithRateById)
              .replaceAll('Id', id),
          _context,
          params: queryParam,
          token: _token);
      var a = AdData.fromJson(response);
      return a;
    } catch (exp) {
      print(exp);
      return AdData();
    }
  }
}
