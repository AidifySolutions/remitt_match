import 'dart:convert';
import 'dart:io';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_base.dart';
import 'api_exception.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;

  Future<dynamic> fetchData(String url, BuildContext context,
      {Map<String, String>? params, String? token}) async {
    var responseJson;

    var uri = ApiBase.baseURL +
        url +
        ((params != null) ? this.queryParameters(params) : "");
    // print(uri);
    try {
      final response = await http.get(Uri.parse(uri), headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "authorization": 'Bearer $token',
      });
      // print(response.body.toString());
      responseJson = _returnResponse(response, context: context);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  String queryParameters(Map<String, String> params) {
    final jsonString = Uri(queryParameters: params);
    return '?${jsonString.query}';
  }

  Future<dynamic> postData(String url, dynamic body, BuildContext context,
      {Map<String, String>? params, String? token}) async {
    var responseJson;

    var uri = ApiBase.baseURL +
        url +
        ((params != null) ? this.queryParameters(params) : "");

    try {
      var response = await http.post(Uri.parse(uri), body: body, headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "authorization": 'Bearer $token'
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> putData(String url, dynamic body, BuildContext context,
      {String? token}) async {
    var responseJson;
    try {
      final response = await http
          .put(Uri.parse(ApiBase.baseURL + url), body: body, headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "authorization": 'Bearer $token',
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> deleteData(String url, BuildContext context,
      {String? token}) async {
    var responseJson;
    var uri = ApiBase.baseURL + url;
    try {
      final response = await http.delete(Uri.parse(uri), headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "authorization": 'Bearer $token',
      });
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response, {BuildContext? context}) {
    switch (response.statusCode) {
      case 201:
      case 202:
      case 200:
      case 302:
        var responseJson = response.body.isNotEmpty
            ? json.decode(response.body.toString())
            : null;
        return responseJson;
      case 400:
        var responseJson = response.body.isNotEmpty
            ? json.decode(response.body.toString())
            : null;
        // print(responseJson);
        throw BadRequestException(responseJson["message"]);
      case 401:
        return Navigator.pushAndRemoveUntil(
          context!,
          MaterialPageRoute(builder: (context) => Login()),
          (Route<dynamic> route) => false,
        );
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
