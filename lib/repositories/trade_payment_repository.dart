import 'dart:convert';

import 'package:fiat_match/models/plans/activity.dart';
import 'package:fiat_match/models/plans/create_payment.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/material.dart';

class TradePaymentPlanRepository {
  late final BuildContext _context;

  TradePaymentPlanRepository(BuildContext context) {
    _context = context;
  }
//1
  Future<CreatePaymentRes> createPaymentForTrade(
      CreateTradePaymentReq obj) async {
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.Payments),
        json.encode(obj.toJson()),
        _context,
        token: Helper.getToken(_context));

    return CreatePaymentRes.fromJson(response);
  }

//2
  Future<ActivityResponse> createActivityForTrade(ActivityRequest obj) async {
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.Activity),
        json.encode(obj.toJson()),
        _context,
        token: Helper.getToken(_context));

    return ActivityResponse.fromJson(response);
  }

//3
  Future<TradePaymentStatusResp> getTradePaymentStatus(String tradeId) async {
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.TradePaymentStatus)
            .replaceAll("tradeId", tradeId),
        _context,
        token: Helper.getToken(_context));

    return TradePaymentStatusResp.fromJson(response);
  }
}
