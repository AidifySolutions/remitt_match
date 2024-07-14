import 'dart:convert';

import 'package:fiat_match/models/authentication.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/models/document.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class CustomerRepository {
  late final BuildContext _context;

  CustomerRepository(BuildContext context) {
    _context = context;
  }

  Future<Customer> createNewCustomer(
      String firstName,
      String phoneNumber,
      String dialCode,
      String isoCountryCode,
      String email,
      String password) async {
    var phone = {
      "dialCode": dialCode,
      "number": phoneNumber,
      "countryCode": isoCountryCode
    };
    var body = {
      "firstName": firstName,
      "lastName": "",
      "phoneNumber": phone,
      "email": email,
      "address": "",
      "country": null,
      "password": password,
    };
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.Register), json.encode(body), _context);
    return Customer.fromJson(response);
  }

  Future<Customer> getCustomer(String customerId) async {
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetCustomer) + "/$customerId", _context);
    print(response);
    Customer customer = Customer.fromJson(response);

    LoginProvider loginProvider =
        Provider.of<LoginProvider>(_context, listen: false);
    if (loginProvider.authentication.data != null) {
      Provider.of<LoginProvider>(_context, listen: false)
          .authentication
          .data!
          .customerData = customer.customerData;
    }

    return customer;
  }

  Future<Customer> updateCustomer(
      String? customerId, Map<String, dynamic> body) async {
    final response = await HttpClient.instance.putData(
        ApiPathHelper.getValue(APIPath.UpdateCustomer) + "/$customerId",
        json.encode(body),
        _context);
    Customer customer = Customer.fromJson(response);

    Provider.of<LoginProvider>(_context, listen: false)
        .authentication
        .data!
        .customerData = customer.customerData;

    return customer;
  }

  Future<bool> resendEmail(String customerId) async {
    var body = {
      "id": customerId,
    };
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.ResendEmail),
        json.encode(body),
        _context);
    print(response);
    return true;
  }

  Future<Customer> verifyEmail(String customerId) async {
    return await getCustomer(customerId);
  }

  Future<bool> resendSms(String customerId, SmsType smsType) async {
    var body = {
      "id": customerId,
    };
    var queryParam = {"purpose": smsTypeToString(smsType)};

    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.ResendSms), json.encode(body), _context,
        params: queryParam);
    print(response);
    return true;
  }

  Future<bool> validatePhone(String code, String customerId) async {
    var body = {
      "code": code,
    };
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.ValidatePhone)
            .toString()
            .replaceAll("customerId", customerId),
        json.encode(body),
        _context);
    print(response);
    return true;
  }

  Future<Authentication> authenticate(
      String email,
      String password,
      String dialCode,
      String phoneNumber,
      String isoCountryCode,
      LoginType loginType) async {
    var phone = {
      "dialCode": dialCode,
      "number": phoneNumber,
      "countryCode": isoCountryCode
    };
    var body = {
      "grantType": "password",
      "clientId": "cjGhup1fkP1JPvQUaPddR8vqPGcfJQCP",
      "clientSecret": "dKtkAV6nZZmLhFkdYXBRrBxqpI8lOX0O",
      "provisionKey": "unikrew",
      "otpOverride": true,
      "username": email,
      "password": password,
      "loginType": Helper.getEnumValue(loginType.toString()),
      "phoneNumber": phone,
    };
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.Authenticate),
        json.encode(body),
        _context);
    print(response);
    Authentication authentication = Authentication.fromJson(response);
    return authentication;
  }

  Future<Authentication> validateOtp(String customerId, String otp) async {
    var body = {
      "OTP": otp,
      "grantType": "password",
      "clientId": "cjGhup1fkP1JPvQUaPddR8vqPGcfJQCP",
      "clientSecret": "dKtkAV6nZZmLhFkdYXBRrBxqpI8lOX0O",
      "provisionKey": "unikrew"
    };
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.ValidateOtp)
            .toString()
            .replaceAll("customerId", customerId),
        json.encode(body),
        _context);

    Authentication authentication =
        Provider.of<LoginProvider>(_context, listen: false)
            .authentication
            .data!;

    authentication.token = Token.fromJson(response["token"]);

    Provider.of<LoginProvider>(_context, listen: false).authentication.data =
        authentication;

    return authentication;
  }

  Future<String> uploadDocument(String document, int documentType,
      String documentName, String? customerId) async {
    var body = {
      "fileName": documentName,
      "description": "testing",
      "identifier": customerId,
      "type": documentType,
      "extension": "jpg",
      "status": 0,
      "file": document
    };
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.DocumentUpload)
            .toString()
            .replaceAll("customerId", customerId.toString()),
        json.encode(body),
        _context);
    String docUrl = '';
    if (response['documentUrl'] != null) {
      docUrl = response['documentUrl'];
    }
    return docUrl;
  }

  Future<Customer> updateLiveness(bool isAlive, String? customerId) async {
    var body = {
      "isAlive": isAlive,
    };
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.UpdateLiveness)
            .toString()
            .replaceAll("customerId", customerId.toString()),
        json.encode(body),
        _context);
    Customer customer = Customer.fromJson(response);
    Provider.of<LoginProvider>(_context, listen: false)
        .authentication
        .data
        ?.customerData = customer.customerData;
    return customer;
  }

  Future<List<Document>> getDocuments(String? customerId) async {
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetDocument) + "/$customerId", _context);

    final parsed = response.cast<Map<String, dynamic>>();
    List<Document> documents =
        parsed.map<Document>((json) => Document.fromJson(json)).toList();

    return documents;
  }

  Future<Customer> forgotPassword(String email) async {
    var queryParam = {"email": email};
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.ForgotPassword), _context,
        params: queryParam);
    Customer customer = Customer.fromJson(response);

    return customer;
  }

  Future<Customer> updatePassword(
      String? email, String? code, Map<String, dynamic> body) async {
    final response = await HttpClient.instance.putData(
        ApiPathHelper.getValue(APIPath.UpdatePassword) +
            "?email=$email&code=$code",
        json.encode(body),
        _context);
    Customer customer = Customer.fromJson(response);

    return customer;
  }

  Future<List<CustomerData>> getBulkCustomers(List<String?> ids) async {
    Map<String, String> queryParam = Map<String, String>();
    queryParam.addAll({'customerIds': ids.join(',')});
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.AllCustomers), _context,
        params: queryParam, token: _token);

    var customerData = response['items'] != null
        ? (response['items']
            .map((v) => CustomerData.fromJson(v))
            .cast<CustomerData>()
            .toList())
        : null;
    return customerData;
  }

  Future<Customer> getAnyCustomerById(String customerId) async {
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetCustomer) + "/$customerId", _context);
    print(response);
    Customer customer = Customer.fromJson(response);

    return customer;
  }
}
