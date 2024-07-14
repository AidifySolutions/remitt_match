import 'package:fiat_match/models/channel_detail.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/recipient_repository.dart';
import 'package:flutter/material.dart';

class ChannelDetailProvider extends ChangeNotifier {
  late RecipientRepository _recipientRepository;
  late ApiResponse<ChannelDetail> _channelDetails;

  ApiResponse<ChannelDetail> get channelDetail => _channelDetails;

  ChannelDetailProvider(BuildContext context) {
    _recipientRepository = RecipientRepository(context);
    _channelDetails = ApiResponse.initial('Not Initialized');
  }

  getChannelDetails(String paymentChannel, String countryCode) async {
    _channelDetails = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      ChannelDetail response = await _recipientRepository.getChannelDetails(
          paymentChannel, countryCode);
      _channelDetails = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _channelDetails = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  getChannelDetailsByCountryCode(String countryCode) async {
    _channelDetails = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      ChannelDetail response = await _recipientRepository.getChannelDetailsByCountryCode(countryCode);
      _channelDetails = ApiResponse.completed(response);
      notifyListeners();
    } catch (e) {
      _channelDetails = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
  resetChannelDetailState() {
    _channelDetails.status = Status.INITIAL;
  }
}
