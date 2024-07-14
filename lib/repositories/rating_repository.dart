import 'dart:convert';
import 'package:fiat_match/models/rating.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/material.dart';

class RatingRepository {
  late final BuildContext _context;

  RatingRepository(BuildContext context) {
    _context = context;
  }

  Future<RatingResponse> submitTradeRating(Rating? rate) async {
    print(json.encode(rate));
    var body = {
      "tradeId": rate?.tradeId,
      "critic":rate?.critic,
      "subject":rate?.subject,
      "rating":rate?.rating,
      "comments":rate?.comments
    };
    String? _token = Helper.getToken(_context);
    var response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.Rating), json.encode(body), _context,
        token: _token);

    return RatingResponse.fromJson(response);
  }
}
