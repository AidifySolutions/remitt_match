import 'package:fiat_match/models/advertisement.dart';
import 'package:fiat_match/models/country.dart';
import 'package:fiat_match/models/deposit_information.dart';
import 'package:fiat_match/models/recipient.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/deposit_info_repository.dart';
import 'package:fiat_match/repositories/recipient_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'new/country_provider.dart';

class RecipientProvider extends ChangeNotifier {
  late RecipientRepository _recipientRepository;
  late DepositInfoRepository _depositInfoRepository;
  late ApiResponse<ListBeneficiary> _recipients;
  late ApiResponse<Beneficary> _beneficary;
  late ApiResponse<Country> _paymentChannel;
  late ApiResponse<Channel> _channel;
  late ApiResponse<ReceiptChannels> _beneChannels;
  late ApiResponse<ReceiptChannel> _beneChannel;
  late ApiResponse<Beneficary> _recipient;
  late ApiResponse<DepositInfoResponse> _depositInfo;
  bool isLoading = false;
  ApiResponse<ListBeneficiary> get recipients => _recipients;
  ApiResponse<Country> get paymentChannel => _paymentChannel;
  ApiResponse<Channel> get channel => _channel;
  ApiResponse<Beneficary> get bene => _beneficary;
  ApiResponse<ReceiptChannels> get beneChannels => _beneChannels;
  ApiResponse<ReceiptChannel> get beneChannel => _beneChannel;
  ApiResponse<Beneficary> get recipient => _recipient;
  ApiResponse<DepositInfoResponse> get depositInfo => _depositInfo;

  RecipientProvider(BuildContext context) {
    _recipientRepository = RecipientRepository(context);
    _recipients = ApiResponse.initial('Not Initialized');
    _paymentChannel = ApiResponse.initial('Not Initialized');
    _channel = ApiResponse.initial('Not Initialized');
    _beneChannels = ApiResponse.initial('Not Initialized');
    _depositInfoRepository = DepositInfoRepository(context);
  }

  getAllRecipients() async {
    isLoading = true;
    _recipients = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      ListBeneficiary response = await _recipientRepository.getAllRecipients();
      _recipients = ApiResponse.completed(response);
    } catch (e) {
      _recipients = ApiResponse.error(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
    notifyListeners();
  }

  getRecipientById(id) async {
    isLoading = true;
    _recipient = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Beneficary response =
          await _recipientRepository.getRecipientsById(id: id);
      _recipient = ApiResponse.completed(response);
    } catch (e) {
      _recipient = ApiResponse.error(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  getPaymentChannel(Beneficiaries recipient, BuildContext context) async {
    isLoading = true;
    _paymentChannel = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      _paymentChannel = ApiResponse.completed(
          Provider.of<CountryProvider>(context, listen: false)
              .country
              .data!
              .where((element) => element.code == recipient.countryCode)
              .first);
    } catch (e) {
      _paymentChannel = ApiResponse.error(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  addChannel(String recipientId, String countryCode, String paymentChannel,
      String? currency, Map<String, dynamic> textFieldController) async {
    isLoading = true;
    _channel = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      Channel channel = await _recipientRepository.addChannels(recipientId,
          countryCode, paymentChannel, currency, textFieldController);
      _channel = ApiResponse.completed(channel);
      await getAllRecipients();
    } catch (e) {
      _channel = ApiResponse.error(e.toString());
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  getReceiptchannels(String recipientId) async {
    isLoading = true;
    _beneChannels = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      ReceiptChannels channel =
          await _recipientRepository.getReceiptchannels(recipientId);
      _beneChannels = ApiResponse.completed(channel);
    } catch (e) {
      _channel = ApiResponse.error(e.toString());
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  deleteChannel(String beneficiaryId, String channelId) async {
    isLoading = true;
    _paymentChannel = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      await _recipientRepository.deleteChannel(beneficiaryId, channelId);
      _paymentChannel = ApiResponse.completed(null);
      await getAllRecipients();
    } catch (e) {
      _paymentChannel = ApiResponse.error(e.toString());
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  getReceiptchannel({String? beneficiaryId, String? channelId}) async {
    isLoading = true;
    _beneChannel = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      ReceiptChannel channel =
          await _recipientRepository.getBeneChannel(beneficiaryId!, channelId!);
      _beneChannel = ApiResponse.completed(channel);
    } catch (e) {
      _beneChannel = ApiResponse.error(e.toString());
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  deleteRecipient(String beneficiaryId) async {
    isLoading = true;
    _paymentChannel = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      await _recipientRepository.deleteRecipient(beneficiaryId);
      _paymentChannel = ApiResponse.completed(null);
      await getAllRecipients();
    } catch (e) {
      _paymentChannel = ApiResponse.error(e.toString());
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  getFiatMatchAccountDetails(String country, String currency) async {
    _depositInfo = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
     DepositInfoResponse depositInfoResponse = await _depositInfoRepository.getDepositInformation(country,currency);
      _depositInfo = ApiResponse.completed(depositInfoResponse);
      await getAllRecipients();
    } catch (e) {
      _depositInfo = ApiResponse.error(e.toString());
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  resetPaymentChannel() {
    _paymentChannel.status = Status.INITIAL;
  }

  resetChannel() {
    _channel.status = Status.INITIAL;
  }
}
