import 'package:fiat_match/models/deposit_information.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/material.dart';

class DepositInfoRepository {
  late final BuildContext _context;

  DepositInfoRepository(BuildContext context) {
    _context = context;
  }

  Future<DepositInfoResponse> getDepositInformation(String country, String currency) async {
    var queryParam = {
      "country": country,
      'currency': currency,
    };
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetDepositInformation), _context,
        params: queryParam, token: _token);
    DepositInfoResponse depositInfoResponse =
    DepositInfoResponse.fromJson(response);
    print('DepositInfoResponse--$depositInfoResponse');
    return depositInfoResponse;
  }
}