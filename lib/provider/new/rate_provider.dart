import 'package:fiat_match/models/rating.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/rating_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RatingProvider extends ChangeNotifier {
  late RatingRepository _rateRepository;
  late ApiResponse<RatingResponse> rate;

  ApiResponse<dynamic> get rateGetter => rate;

  RatingProvider(BuildContext context) {
    _rateRepository = RatingRepository(context);
    rate = ApiResponse.initial('Initialize data');
  }

  submitTradeRating(
      {String? tradeId,
      String? subject,
      String? critic,
      String? comments,
      int? rating}) async {
    rate = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Rating obj = Rating(
          comments: comments,
          critic: critic,
          rating: rating,
          subject: subject,
          tradeId: tradeId);
      var response = await _rateRepository.submitTradeRating(obj);
      rate = ApiResponse.completed(response);

      notifyListeners();
    } catch (e) {
      rate = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
