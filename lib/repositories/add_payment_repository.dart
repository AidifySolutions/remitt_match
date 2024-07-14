import 'dart:convert';

import 'package:fiat_match/models/plans/create_payment.dart';
import 'package:fiat_match/models/plans/free_plan.dart';
import 'package:fiat_match/models/plans/instrument.dart';
import 'package:fiat_match/models/plans/plans.dart';
import 'package:fiat_match/models/plans/subscriptions.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddPaymentPlanRepository {
  late final BuildContext _context;

  AddPaymentPlanRepository(BuildContext context) {
    _context = context;
  }
  Future<InitialPlans> getInitialPlans() async {
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.Plans), _context,
        token: Helper.getToken(_context));
    return InitialPlans.fromJson(response);
  }

  Future<FreePlan> getFreemiumPlan() async {
    String userid =
        _context.read<LoginProvider>().authentication.data!.customerData!.id!;
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.Freeplan)
            .toString()
            .replaceAll("userId", userid),
        _context,
        token: Helper.getToken(_context));
    return FreePlan.fromJson(response);
  }

  Future<Subscriptions> getSubscritpionPlans({String plandId = ''}) async {
    Map<String, String> queryParam = Map<String, String>();
    queryParam.putIfAbsent("planId", () => plandId);

    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.Subscriptions).toString(), _context,
        params: queryParam, token: Helper.getToken(_context));
    return Subscriptions.fromJson(response);
  }

  Future<Instruments> getSavedPaymentMethods() async {
    try {
      final response = await HttpClient.instance.fetchData(
          ApiPathHelper.getValue(APIPath.Instruments).toString(), _context,
          token: Helper.getToken(_context));
      return Instruments.fromJson(response);
    } catch (e) {
      print(e);
    }
    return Instruments();
  }

  Future<AddInstrumentsResponse> addPaymentPlans(AddInstrument obj) async {
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.Instruments),
        json.encode(obj.toJson()),
        _context,
        token: Helper.getToken(_context));
    return AddInstrumentsResponse.fromJson(response);
  }

  Future<CreatePaymentRes> createPayment(CreatePaymentReq obj) async {
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.Payments),
        json.encode(obj.toJson()),
        _context,
        token: Helper.getToken(_context));

    return CreatePaymentRes.fromJson(response);
  }

  Future<CreatePaymentRes> checkPaymentStatus(String indent) async {
    final response = await HttpClient.instance.putData(
        ApiPathHelper.getValue(APIPath.CheckPayment)
            .toString()
            .replaceAll("payment_indent", indent),
        null,
        _context,
        token: Helper.getToken(_context));
    print(response);
    return CreatePaymentRes.fromJson(response);
  }

  Future<Instruments> deletePaymentInstruemnt(String id) async {
    try {
      final response = await HttpClient.instance.deleteData(
          ApiPathHelper.getValue(APIPath.RemoveInstruments)
              .replaceAll('instrumentid', id)
              .toString(),
          _context,
          token: Helper.getToken(_context));
      return Instruments.fromJson(response);
    } catch (e) {
      print(e);
    }
    return Instruments();
  }
}
