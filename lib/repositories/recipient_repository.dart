import 'dart:convert';

import 'package:fiat_match/models/currency.dart';
import 'package:fiat_match/models/channel_detail.dart';
import 'package:fiat_match/models/recipient.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/material.dart';

class RecipientRepository {
  late final BuildContext _context;

  RecipientRepository(BuildContext context) {
    _context = context;
  }

  Future<ListBeneficiary> getAllRecipients() async {
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetAllBeneficiaries), _context,
        token: _token);
    return ListBeneficiary.fromJson(response);
  }

  Future<Beneficary> getRecipientsById({String id = ''}) async {
    String? _token = Helper.getToken(_context);

    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetBeneficiariesById)
            .replaceAll('Id', id),
        _context,
        token: _token);
    var a = Beneficary.fromJson(response);
    return a;
  }

  Future<Beneficiaries> addNewRecipient(
      String firstName,
      String lastName,
      String email,
      String dialCode,
      String phoneNumber,
      String isoCountryCode,
      String country) async {
    var phone = {
      "dialCode": dialCode,
      "number": phoneNumber,
      "countryCode": isoCountryCode
    };
    var body = {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phone,
      "email": email,
      "countryCode": country,
    };
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.AddNewBeneficiary),
        json.encode(body),
        _context,
        token: _token);
    return Beneficiaries.fromJson(response["beneficiary"]);
  }

  Future<ChannelDetail> getChannelDetails(
      String channelType, String countryCode) async {
    var queryParam = {"channelType": channelType, "countryCode": countryCode};

    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetChannelDetails), _context,
        params: queryParam);

    return ChannelDetail.fromJson(response);
  }

  Future<ChannelDetail> getChannelDetailsByCountryCode(
      String countryCode) async {
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetChannelDetails) + '/$countryCode',
        _context);

    return ChannelDetail.fromJson(response);
  }

  Future<Currency> getCurrency() async {
    final response = await HttpClient.instance
        .fetchData(ApiPathHelper.getValue(APIPath.GetCurrency), _context);

    return Currency.fromJson(response);
  }

  Future<Channel> addChannels(
      String beneficiaryId,
      String countryCode,
      String channelType,
      String? currency,
      Map<String, dynamic> textFieldController) async {
    Map<String, String> fieldDetails = Map<String, String>();
    textFieldController.forEach((key, value) {
      fieldDetails.putIfAbsent(key, () => value.text.toString());
    });

    var body = {
      "countryCode": countryCode,
      "channelType": channelType,
      "currency": currency,
      "fieldDetails": fieldDetails,
    };
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.AddChannels)
            .toString()
            .replaceAll("beneficiaryId", beneficiaryId),
        json.encode(body),
        _context,
        token: _token);
    return Channel.fromJson(response);
  }

  Future<ReceiptChannels> getReceiptchannels(String beneficiaryId) async {
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetReceiptChannels)
            .toString()
            .replaceAll("beneficiaryId", beneficiaryId),
        _context,
        token: _token);
    return ReceiptChannels.fromJson(response);
  }

  Future<void> deleteChannel(String beneficiaryId, String channelId) async {
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.deleteData(
        ApiPathHelper.getValue(APIPath.DeleteChannels)
            .toString()
            .replaceAll('beneficiaryId', beneficiaryId)
            .replaceAll('channelId', channelId),
        _context,
        token: _token);
  }

  Future<ReceiptChannel> getBeneChannel(
      String beneficiaryId, String channelId) async {
    String? _token = Helper.getToken(_context);
    String url = ApiPathHelper.getValue(APIPath.GetBeneChannel)
        .toString()
        .replaceAll('beneficiaryId', beneficiaryId)
        .replaceAll('channelId', channelId);
    final response =
        await HttpClient.instance.fetchData(url, _context, token: _token);
    return ReceiptChannel.fromJson(response);
  }

  Future<Beneficiaries> updateRecipient(
      String beneficiaryId,
      String firstName,
      String lastName,
      String email,
      String dialCode,
      String phoneNumber,
      String isoCountryCode,
      String country) async {
    var phone = {
      "dialCode": dialCode,
      "number": phoneNumber,
      "countryCode": isoCountryCode
    };
    var body = {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phone,
      "email": email,
      "countryCode": country,
    };
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.putData(
        ApiPathHelper.getValue(APIPath.UpdateBeneficiary)
            .toString()
            .replaceAll('beneficiaryId', beneficiaryId),
        json.encode(body),
        _context,
        token: _token);
    return Beneficiaries.fromJson(response["beneficiary"]);
  }

  Future<void> deleteRecipient(String beneficiaryId) async {
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.deleteData(
        ApiPathHelper.getValue(APIPath.DeleteBeneficiary)
            .toString()
            .replaceAll('beneficiaryId', beneficiaryId),
        _context,
        token: _token);
  }

  Future<Channel> updateChannel(
      String beneficiaryId,
      String channelId,
      String countryCode,
      String channelType,
      String? currency,
      Map<String, dynamic> textFieldController) async {
    Map<String, String> fieldDetails = Map<String, String>();
    textFieldController.forEach((key, value) {
      fieldDetails.putIfAbsent(key, () => value.text.toString());
    });

    var body = {
      "countryCode": countryCode,
      "channelType": channelType,
      "currency": currency,
      "fieldDetails": fieldDetails,
    };
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.putData(
        ApiPathHelper.getValue(APIPath.UpdateChannel)
            .toString()
            .replaceAll("beneficiaryId", beneficiaryId)
            .replaceAll('channelId', channelId),
        json.encode(body),
        _context,
        token: _token);
    return Channel.fromJson(response);
  }
}
