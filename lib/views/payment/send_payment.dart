import 'dart:developer';

import 'package:fiat_match/chat/chat.dart';
import 'package:fiat_match/chat/chat_provider.dart';
import 'package:fiat_match/chat/trading_provider.dart';
import 'package:fiat_match/models/advertisement.dart' as adds;
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/models/post_offer.dart';
import 'package:fiat_match/models/recipient.dart';
import 'package:fiat_match/models/trade_info.dart';
import 'package:fiat_match/models/transaction_history.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/provider/new/rate_provider.dart';
import 'package:fiat_match/provider/new/trade_provider.dart';
import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/provider/recipient_provider.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/loader.dart';
import 'package:fiat_match/utils/shared_pref.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/views/home/landing_new.dart';
import 'package:fiat_match/views/post_offer/post_offer.dart';
import 'package:fiat_match/views/recipient/add_new_recipient.dart';
import 'package:fiat_match/views/transaction_history/transaction_history.dart';
import 'package:fiat_match/widgets/fm__home_screen_loader.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/fm_input_fields.dart';
import 'package:fiat_match/widgets/fm_toast.dart';
import 'package:fiat_match/widgets/new/fm_dropdown.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SelectPaymentMethod extends StatefulWidget {
  final String? youSent;
  final String? receiptGet;
  final String? offerused;
  final CustomerData? seller;
  final adds.Ads? selectedAd;
  final bool isFiatMatchOffer;
  PostOffer? postOffer;
  bool fromPostOffer;

  SelectPaymentMethod(
      {Key? key,
      @required this.offerused,
      @required this.youSent,
      @required this.receiptGet,
      @required this.seller,
      @required this.selectedAd,
      this.isFiatMatchOffer = false,
      this.fromPostOffer = false,
      this.postOffer})
      : super(key: key);

  @override
  _SelectPaymentMethodState createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
  var _recipientController = TextEditingController();
  var _recipientChannelController = TextEditingController();
  late RecipientProvider _recipientProvider;
  late TradingProvider _tradeProvider;
  late RatingProvider _ratingProvider;
  late UserOffersProvider _userOffersProvider;
  late ChatProvider _chatProvider;

  Beneficiaries _selectedbene = Beneficiaries();
  Channel _selectedBeneChannel = Channel();
  bool _isLoading = false;
  String? user_id = '';

  @override
  void initState() {
    _recipientProvider = Provider.of<RecipientProvider>(context, listen: false);
    _tradeProvider = Provider.of<TradingProvider>(context, listen: false);
    _ratingProvider = Provider.of<RatingProvider>(context, listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _recipientProvider.getAllRecipients();
    });
    _userOffersProvider =
        Provider.of<UserOffersProvider>(context, listen: false);
    user_id = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data!
        .customerData!
        .id;
  }

  _getInitialDataForChat(tradeId) async {
    try {
      setState(() => _isLoading = true);

      await _tradeProvider.getTradeById(tradeId);
      if (_tradeProvider.tradeInfo.data != null) {
        var adId = _tradeProvider.tradeInfo.data?.trade?.adId;
        await _userOffersProvider.getAdvertismentById(adId);
        await _tradeProvider.setAdvertisement(_userOffersProvider.ad.data!);
        if (_tradeProvider.tradeInfo.data != null) {
          var sellerId = _tradeProvider.tradeInfo.data!.trade!.seller!.sellerId;
          var beneId = '';
          var channelId = '';
          if (sellerId == user_id) {
            beneId =
                _tradeProvider.tradeInfo.data!.trade!.seller!.beneficiaryId!;
            channelId =
                _tradeProvider.tradeInfo.data!.trade!.seller!.channelId!;
          } else {
            beneId =
                _tradeProvider.tradeInfo.data!.trade!.buyer!.beneficiaryId!;
            channelId = _tradeProvider.tradeInfo.data!.trade!.buyer!.channelId!;
          }
          await _recipientProvider.getRecipientById(beneId);
          await _recipientProvider.getReceiptchannel(
              beneficiaryId: beneId, channelId: channelId);
          _tradeProvider.setSelectedRecipient(
              _recipientProvider.recipient.data!.beneficiary!,
              _recipientProvider.beneChannel.data!.channel!);
          if (_tradeProvider.tradeInfo.data!.trade!.status!.status ==
              'Cancelled') {
            _showToast('Chat for this transaction has ended.',
                icon: Icons.error);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Chat(),
              ),
            );
          }
        }
      } else {
        _showToast('Some thing went wrong!', icon: Icons.error);
      }
    } catch (exp) {
      _showToast('Some thing went wrong!', icon: Icons.error);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext buildContext) {
    final bool isValidate =
        (_selectedbene.id != null && _selectedBeneChannel.id != null);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select a payment method',
        ),
      ),
      body: _isLoading
          ? FmHomeScreenLoader()
          : Consumer<RecipientProvider>(builder: (context, response, child) {
              return _recipientProvider.isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(!widget.fromPostOffer) ...[
                            Text('Transaction Details',
                                style: FiatStyles.body5().copyWith(
                                  color: FiatColors.darkBlue,
                                )),
                            SizedBox(
                              height: 16,
                            ),
                            _detailSenderReceiverWidget(),
                            SizedBox(
                              height: 16,
                            ),
                            _detailOfferTraderWidget(),
                            SizedBox(
                              height: 16,
                            ),

                            _detailReceiptDateWidget(),
                            SizedBox(
                              height: 16,
                            ),
                            Divider(),
                            ],
                            SizedBox(
                              height: 16,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AddNewRecipient(
                                                        recipient: null)),
                                          );
                                        },
                                        child: Text(
                                          "Add new recipient",
                                          style: TextStyle(
                                                  fontSize:
                                                      SizeConfig.resizeFont(
                                                          9.24),
                                                  fontWeight: FontWeight.w600)
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .accentColor),
                                        )),
                                  ],
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                FmDropdown(
                                    textEditingController: _recipientController,
                                    maxLines: 1,
                                    onTap: () {
                                      if (_recipientProvider.recipients.data!
                                              .beneficiaries!.length >
                                          0)
                                        _selectedbene = _recipientProvider
                                            .recipients
                                            .data!
                                            .beneficiaries!
                                            .first;
                                      _receipientMethodBottomSheet();
                                    },
                                    title: 'Select recipient',
                                    // title: _selectedbene.firstName != null
                                    //     ? _selectedbene.firstName!
                                    //     : 'Select',
                                    onValidation: (value) {
                                      if (value.isEmpty) {
                                        return 'Required';
                                      }
                                    }),
                              ],
                            ),
                            if (_selectedBeneChannel.channelType != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 16,
                                  ),
                                  FmDropdown(
                                      textEditingController:
                                          _recipientChannelController,
                                      onTap: () {
                                        _receipientChannelsBottomSheet();
                                      },
                                      maxLines: 1,
                                      title: 'Select delivery method',
                                      //title: _selectedBeneChannel.channelType!,
                                      onValidation: (value) {
                                        if (value.isEmpty) {
                                          return 'Required';
                                        }
                                      }),
                                ],
                              ),
                            Consumer<TradingProvider>(
                                builder: (context, response, child) {
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 32),
                                child: FmSubmitButton(
                                    text: 'Continue',
                                    onPressed: isValidate
                                        ? () async {
                                            try {
                                              setState(() => _isLoading = true);
                                              if (!widget.fromPostOffer) {
                                                await _tradeProvider
                                                    .initiateTrade(
                                                        ads: widget.selectedAd,
                                                        beneficiaries:
                                                            _selectedbene,
                                                        channel:
                                                            _selectedBeneChannel,
                                                        currencyCount:
                                                            widget.youSent,
                                                        isFiatMatchOffer: widget
                                                            .isFiatMatchOffer);
                                                if (response.tradeInfo.status ==
                                                    Status.COMPLETED) {
                                                  if (widget.selectedAd
                                                          ?.openToNegotiate ??
                                                      false) {
                                                    // _tradeProvider.setAdvertisement(
                                                    //     widget.selectedAd!);
                                                    // _tradeProvider
                                                    //     .setSelectedRecipient(
                                                    //         _selectedbene,
                                                    //         _selectedBeneChannel);
                                                    _chatProvider.setRoomId(
                                                        response.tradeInfo.data!
                                                            .roomId!);
                                                    _getInitialDataForChat(
                                                        response.tradeInfo.data!
                                                            .trade!.id);
                                                    // Navigator.of(context).push(
                                                    //   MaterialPageRoute(
                                                    //     builder: (context) => Chat(),
                                                    //   ),
                                                    // );
                                                  } else {
                                                    //send to active transaction
                                                    Navigator.of(buildContext)
                                                        .pushAndRemoveUntil(
                                                      MaterialPageRoute(
                                                        builder: (buildContext) =>
                                                            LandingNewPage(
                                                          tabSelection: 3,
                                                        ),
                                                      ), (Route<dynamic> route) => false);
                                                  }
                                                } else if (response
                                                        .tradeInfo.status ==
                                                    Status.ERROR) {
                                                  _showPayemntSuccessDialog(
                                                      context,
                                                      isSuccess: false,
                                                      msg: response
                                                          .tradeInfo.message);
                                                } else if (response
                                                        .tradeInfo.status ==
                                                    Status.LOADING) {
                                                  FmHomeScreenLoader();
                                                } else {
                                                  Container();
                                                }
                                              } else {
                                                widget.postOffer?.recipient
                                                        ?.channelId =
                                                    _selectedBeneChannel.id;
                                                widget.postOffer?.recipient
                                                        ?.beneficiaryId =
                                                    _selectedbene.id;
                                                await _userOffersProvider
                                                    .postOffers(
                                                        widget.postOffer!);
                                                if (_userOffersProvider
                                                        .postOffer
                                                        .data!
                                                        .message ==
                                                    'Advertisement Posted') {
                                                  _showDialog(
                                                      buttonText: 'Ok',
                                                      icon: Icons.done,
                                                      msg: _userOffersProvider
                                                          .postOffer
                                                          .data!
                                                          .message,
                                                      title: 'Success');
                                                } else {
                                                  _showToast(
                                                      '${_userOffersProvider.postOffer.data!.message}');
                                                }
                                              }
                                            } catch (exp) {
                                              _showToast(
                                                  _tradeProvider
                                                      .tradeInfo.message,
                                                  icon: Icons.error);
                                            } finally {
                                              setState(
                                                  () => _isLoading = false);
                                            }
                                          }
                                        : () {
                                            _showToast(
                                                'Please select recipient & channel.');
                                          },
                                    showOutlinedButton: false),
                              );
                            }),
                          ],
                        ),
                      ),
                    );
            }),
    );
  }

  Widget _detailSenderReceiverWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailWidget(
            title: 'You send',
            value: widget.fromPostOffer
                ? ''
                : widget.youSent! +
                    ' ' +
                    _userOffersProvider.currencyYouWantToSend!),
        _detailWidget(
            title: 'Recipient gets',
            value: widget.receiptGet! +
                ' ' +
                _userOffersProvider.currencyRecipientWillGet!),
      ],
    );
  }

  Widget _detailOfferTraderWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _detailWidget(title: 'Offer used', value: widget.offerused!),
        _detailWidget(
            title: 'Trader',
            value: widget.fromPostOffer
                ? ''
                : widget.isFiatMatchOffer
                    ? 'FiatMatch'
                    : widget.seller!.nickName ?? ''),
      ],
    );
  }

  Row _detailReceiptDateWidget() {
    return Row(
      children: [
        _detailWidget(
            title: 'Recipient',
            value: _selectedbene.firstName != null
                ? _selectedbene.firstName!
                : 'No Recipient'),
        Spacer(),
        _detailWidget(
            title: 'Date',
            value: widget.fromPostOffer
                ? widget.postOffer!.expiry!
                : FmDateFormat.formatDate(date: DateTime.now().toString())),
        Spacer(),
      ],
    );
  }

  Widget _detailWidget({String title = '', String value = ''}) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: FiatStyles.body3().copyWith(fontSize: 14)),
          Text(value, style: FiatStyles.body14()),
        ],
      ),
    );
  }

  void _receipientMethodBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: false,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
        builder: (context) => Consumer<RecipientProvider>(
              builder: (context, response, child) {
                if (response.recipients.status == Status.COMPLETED) {
                  return _recipientList(response.recipients.data!);
                } else if (response.recipients.status == Status.ERROR) {
                  WidgetsBinding.instance!.addPostFrameCallback((_) {
                    FmToast(
                        message: response.recipients.message,
                        icon: Icons.error);
                  });
                  return Container();
                } else if (response.recipients.status == Status.LOADING) {
                  return FmHomeScreenLoader();
                } else {
                  return Container();
                }
              },
            ));
  }

  void _receipientChannelsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SingleChildScrollView(
        child: Consumer<RecipientProvider>(
          builder: (context, response, child) {
            if (response.recipients.status == Status.COMPLETED) {
              return _recipientChannelList(response.beneChannels.data!);
            } else if (response.recipients.status == Status.ERROR) {
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _showPayemntSuccessDialog(context, isSuccess: false);
              });
              return Container();
            } else if (response.recipients.status == Status.LOADING) {
              return FmHomeScreenLoader();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _recipientList(ListBeneficiary recipient) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            Text('Recipient', style: FiatStyles.body5()),
            SizedBox(
              height: 16,
            ),
            recipient.beneficiaries!.length == 0
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Text("No record found"),
                  )
                : Expanded(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: recipient.beneficiaries!.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () async {
                            _selectedbene = _recipientProvider
                                .recipients.data!.beneficiaries![index];
                            _recipientController.text = _selectedbene.firstName!;
                            Navigator.pop(context);
                            FocusManager.instance.primaryFocus!.unfocus();
                            await _recipientProvider.getReceiptchannels(
                                _recipientProvider
                                    .recipients.data!.beneficiaries![index].id!);
                            if (_recipientProvider.beneChannels.data != null) {
                              _selectedBeneChannel = _recipientProvider
                                  .beneChannels.data!.channels!.first;
                            }

                            setState(() {});
                          },
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text(
                                recipient.beneficiaries![index].firstName! +
                                    ' ' +
                                    recipient.beneficiaries![index].lastName!,
                                style: FiatStyles.body14()),
                          ),
                        );
                      }),
                ),
          ],
        ),
      ),
    );
  }

  Widget _recipientChannelList(ReceiptChannels channels) {
    if (channels.channels!.length == 0) return Text("No channel");
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Channels', style: FiatStyles.body5()),
          ListView.separated(
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: channels.channels!.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    _selectedBeneChannel = channels.channels![index];
                    _recipientChannelController.text =
                        _selectedBeneChannel.channelType!;
                    setState(() {});
                    Navigator.pop(context);
                    FocusManager.instance.primaryFocus!.unfocus();
                  },
                  child: ListTile(
                      leading: Icon(Icons.info),
                      title: Text(channels.channels![index].channelType!)),
                );
              }),
        ],
      ),
    );
  }

  _showPayemntSuccessDialog(BuildContext context,
      {bool isSuccess = false, String? msg = '', TradeInfo? trade}) {
    bool _isLoading = false;
    var _descriptionCOntroller = TextEditingController();
    double? _selectedRating = 0.0;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return StreamBuilder<Object>(builder: (context, snapshot) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 40,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.resizeHeight(9.35)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(
                          isSuccess
                              ? Icons.check_circle_sharp
                              : Icons.cancel_outlined,
                          size: SizeConfig.resizeWidth(14),
                          color: isSuccess
                              ? Theme.of(context).accentColor
                              : Colors.red,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: SizeConfig.resizeWidth(8),
                              right: SizeConfig.resizeWidth(8),
                              top: SizeConfig.resizeWidth(5.61),
                              bottom: SizeConfig.resizeHeight(5.61)),
                          child: Text(
                            isSuccess
                                ? 'Transaction complete!'
                                : 'Transaction failed',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConfig.resizeFont(11.22),
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        if (!isSuccess) ...[
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.resizeWidth(8),
                                right: SizeConfig.resizeWidth(8),
                                top: SizeConfig.resizeWidth(5.61),
                                bottom: SizeConfig.resizeHeight(5.61)),
                            child: Text(
                              msg!,
                              style: TextStyle(
                                  fontSize: SizeConfig.resizeFont(11.22),
                                  color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        if (isSuccess) ...[
                          Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.resizeWidth(8),
                                right: SizeConfig.resizeWidth(8),
                                top: SizeConfig.resizeWidth(1.61),
                                bottom: SizeConfig.resizeHeight(5.61)),
                            child: Column(
                              children: [
                                Text(
                                  'Rate your seller',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: SizeConfig.resizeFont(11.22),
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.resizeWidth(2.61),
                                      bottom: SizeConfig.resizeWidth(2.61)),
                                  child: Text(
                                    'Any comments about the seller?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: SizeConfig.resizeFont(11.22),
                                        color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.resizeWidth(2.61),
                                      bottom: SizeConfig.resizeWidth(2.61)),
                                  child: RatingBar(
                                    initialRating: 1.0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 32,
                                    ratingWidget: RatingWidget(
                                      full: Image.asset(
                                          'assets/rating_star_filled.png'),
                                      half: Image.asset(
                                          'assets/rating_star_empty.png'),
                                      empty: Image.asset(
                                          'assets/rating_star_empty.png'),
                                    ),
                                    itemPadding: EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 0),
                                    onRatingUpdate: (double value) {
                                      _selectedRating = value;
                                    },
                                  ),
                                ),
                                FmInputFields(
                                    hint: '',
                                    title: '',
                                    obscureText: false,
                                    textEditingController:
                                        _descriptionCOntroller,
                                    textInputType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    onValidation: (value) {
                                      if (value.isEmpty) {
                                        return 'Required';
                                      }
                                    },
                                    autoFocus: false,
                                    maxLines: 4),
                              ],
                            ),
                          ),
                        ],
                        Consumer<RatingProvider>(
                            builder: (context, response, child) {
                          return Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.resizeWidth(20.5),
                                right: SizeConfig.resizeWidth(20.5),
                                bottom: SizeConfig.resizeWidth(9.2)),
                            child: FmSubmitButton(
                                text: 'Close',
                                onPressed: () async {
                                  if (isSuccess) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    try {
                                      String _userId =
                                          SharedPref.getString('userId')!;
                                      await _ratingProvider.submitTradeRating(
                                          comments: _descriptionCOntroller.text,
                                          rating: _selectedRating!.toInt(),
                                          subject: _userId,
                                          //to be asked
                                          critic: trade!.roomId,
                                          //to be asked
                                          tradeId: trade.trade!.id //to be asked
                                          );
                                      FmToast(
                                          message: _ratingProvider.rate.message,
                                          icon: Icons.done);
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      Navigator.pop(context, true);
                                    } catch (exp) {
                                      print(exp);
                                    } finally {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  }
                                  Navigator.pop(context, true);
                                },
                                showOutlinedButton: false),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
        });
  }

  _showToast(String? msg, {IconData icon = Icons.done}) {
    var _fToast = FToast();
    _fToast.init(context);
    _fToast.showToast(
      child: FmToast(
        message: msg,
        icon: icon,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  _showDialog(
      {String? title, String? msg, String? buttonText, IconData? icon}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: icon!,
              title: title!,
              message: msg!,
              buttonText: buttonText!,
              voidCallback: () async {
                //context.read<ForgotPasswordProvider>().reset();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              });
        });
  }
}
