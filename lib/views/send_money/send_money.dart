// import 'dart:html';

import 'package:fiat_match/models/advertisement.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/models/plans/plans.dart';
import 'package:fiat_match/provider/new/currency_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/provider/new/mid_market_rate_provider.dart';
import 'package:fiat_match/provider/new/payment_plan_provider.dart';
import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/payment/send_payment.dart';
import 'package:fiat_match/views/payment_plan/initial_plan.dart';
import 'package:fiat_match/views/payment_plan/payment_subscription.dart';
import 'package:fiat_match/views/post_offer/post_offer.dart';
import 'package:fiat_match/views/profile/profile_new.dart';
import 'package:fiat_match/views/send_money/user_offers.dart';
import 'package:fiat_match/widgets/fm_currency_bottomsheet.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_mid_market_card.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SendMoney extends StatefulWidget {
  @override
  _SendMoneyState createState() => _SendMoneyState();
}

class _SendMoneyState extends State<SendMoney> {
  late UserOffersProvider _userOffersProvider;
  late PaymentPlanProvider _paymentPlanProvider;
  late LoginProvider _loginProvider;
  late CurrencyProvider _currencyProvider;
  String offerused = '';
  Ads? _selectedAd;
  bool _isloading = false;
  int _offerCount = 20;
  CustomerData _selectedAdSeller = CustomerData();

  bool isValidate = false;

  @override
  void initState() {
    super.initState();

    _userOffersProvider =
        Provider.of<UserOffersProvider>(context, listen: false);
    _userOffersProvider.reset();
    _paymentPlanProvider =
        Provider.of<PaymentPlanProvider>(context, listen: false);
    _loginProvider = Provider.of<LoginProvider>(context, listen: false);
    _currencyProvider = context.read<CurrencyProvider>();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _userOffersProvider.reset();
     //Hide this payment selection for now ... 
     // _checkPaymentStatus();
      _initiateApiCalls();
      if(_loginProvider.authentication.data?.customerData?.profileStatus?.status == Helper.getEnumValue(ProfileStatusEnum.Incomplete.toString()) && Constants.showProfileDialog) {
        _showProfileDialog();
      }

    });
  }

  Future<void> _initiateApiCalls() async {
    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await _userOffersProvider.getAllOffers();
      Provider.of<MidMarketRateProvider>(context, listen: false)
          .getMidMarketRate(
        _userOffersProvider.currencyRecipientWillGet!,
        _userOffersProvider.currencyYouWantToSend!,
      );
    });
  }

  _showProfileDialog() {
    Constants.showProfileDialog = false;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FmDialogWidget(
            titleHeading: 'Welcome to FiatMatch!',
            title: '',
            message: 'In compliance with global finance regulations, we would like you to complete your profile and identity verification with your phone. If you skip this step, you will be able to explore the platform but you won’t be able to perform any transactions.\n\nWe will never share your information with anybody.',
            buttonText: 'Go to my profile',
            voidCallback: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Profile(),
                ),
              );
            },
            secondButtonText: 'Skip, I just want to explore',
            secondButtonCallback: (){
              Navigator.pop(context);
            },
          );
        });
  }

  _checkPaymentStatus() {
    var status = _loginProvider.authentication.data!.customerData;
    if (status!.profileStatus!.status != "Verified") {
      showDialog(
          context: context,
          builder: (ctxt) => new AlertDialog(
                elevation: 0,
                contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                backgroundColor: Colors.transparent,
                content: InitialPaymentPlan(
                  onSelectPlan: (e) {
                    if (e.name == 'Freemium') {
                   //   _initiateFreeMiumPlan(e);
                    } else {
                   //   _initiateSubscriptionPlan(e);
                    }
                    print(e);
                  },
                ),
              ));
    }
    setState(() {});
  }

  _getOffers({
    bool clearfilter = false,
  }) {
    if (clearfilter) {
      _userOffersProvider.clearOffers();
    }

    _userOffersProvider.getAllOffers(
      userType: UserType.Buyer,
      buyingCurrency: _userOffersProvider.currencyRecipientWillGet,
      sellingCurrency: _userOffersProvider.currencyYouWantToSend,
    );
  }

  _initiateFreeMiumPlan(Plans obj) async {
    try {
      setState(() {
        _isloading = true;
      });
      await _paymentPlanProvider.getFreePlanSubscription();
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _isloading = false;
      });
    }
  }

  // _initiateSubscriptionPlan(Plans plan) async {
  //   try {
  //     setState(() {
  //       _isloading = true;
  //     });
  //     await _paymentPlanProvider.getSubscriptionPlan(plandId: plan.id!);
  //     Navigator.of(context).pop();
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => PaymentPlanSubscription(
  //                   subscriptions:
  //                       _paymentPlanProvider.subscritpion.data!.subscriptions!,
  //                   plan: plan,
  //                 )));
  //   } catch (e) {
  //     print(e);
  //   } finally {
  //     setState(() {
  //       _isloading = false;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        body: Consumer<UserOffersProvider>(builder: (context, response, child) {
          if (_selectedAd == null &&
              response.offers.data != null &&
              response.offers.data!.ads!.length > 0)
            _selectedAd = response.offers.data!.ads!.first;

          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                top: SizeConfig.resizeHeight(1.87),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.resizeWidth(9.35),
                    ),
                    child: searchField(
                      'You send',
                      '${response.currencyYouWantToSend}.png',
                      response.currencyYouWantToSend ?? 'Currency',
                      response.amountYouWantToSendController,
                      onChange: (value) {
                        response.setAmountRecipientWillGet(value);
                        if (_userOffersProvider.selectedOffer != null) {
                          var a =
                              response.amountRecipientWillGetController.text ==
                                          "0" &&
                                      response.amountRecipientWillGetController
                                              .text ==
                                          ""
                                  ? 0.0
                                  : double.parse(response
                                      .amountRecipientWillGetController.text);
                          if (a >
                              _userOffersProvider
                                  .selectedOffer!.sellingLimit!) {
                            _showSnackBar(msg: "Value exceed selling limit");
                          }
                        }
                      },
                      onCurrencyTap: (value) {
                        _clearTexFields(response);
                        response.setCurrencyYouWantToSend(value);
                       var val = _currencyProvider.currency.data?.currencies?.firstWhere((element) => element.name != value);
                        response.setCurrencyRecipientWillGet(val?.name);
                        _getOffers(clearfilter: true);
                        _getMidMarketRate(context);
                      },
                    ),
                  ),
                  if (response.selectedOffer != null &&
                      response.selectedFiatOffer == null) ...[
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.resizeWidth(9.35),
                        ),
                        child: topOffer(
                            buyingCurrency:
                                response.selectedOffer?.buyingCurrency,
                            sellingCurrency:
                                response.selectedOffer?.sellingCurrency,
                            rate: response.selectedOffer?.rate?.value)),
                  ] else ...[
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.resizeWidth(9.35),
                        ),
                        child: topOffer(
                            buyingCurrency:
                                response.currencyRecipientWillGet ?? '',
                            sellingCurrency:
                                response.currencyYouWantToSend ?? '',
                            rate: response.parallelMarketRate,
                            isFiatOffer: true)),
                  ],
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.resizeWidth(9.35),
                    ),
                    child: searchField(
                      'Recipient gets',
                      '${response.currencyRecipientWillGet}.png',
                      response.currencyRecipientWillGet ?? 'Currency',
                      response.amountRecipientWillGetController,
                      onChange: (value) {
                        if (_userOffersProvider.selectedOffer != null) {
                          var a = value == "0" && value == ""
                              ? 0.0
                              : double.parse(value);
                          if (a >
                              _userOffersProvider
                                  .selectedOffer!.sellingLimit!) {
                            _showSnackBar(msg: "Value exceed selling limit");
                          }
                        }
                        response.setAmountYouWantToSend(value);
                      },
                      onCurrencyTap: (value) {
                        _clearTexFields(response);
                        response.setCurrencyRecipientWillGet(value);
                        var val = _currencyProvider.currency.data?.currencies?.firstWhere((element) => element.name != value);
                        response.setCurrencyYouWantToSend(val?.name);
                        _getOffers(clearfilter: true);
                        _getMidMarketRate(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.resizeHeight(7),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.resizeWidth(9.35),
                    ),
                    child: FmSubmitButton(
                        text: 'Send',
                        onPressed: () async {
                          if (response
                                  .amountYouWantToSendController.text.isEmpty ||
                              response.amountRecipientWillGetController.text
                                  .isEmpty) {
                            _showSnackBar(msg: "Please enter send amount");
                          } else {
                            var recipientAmount = double.parse(
                                _userOffersProvider
                                    .amountRecipientWillGetController.text);
                            var sellingLimit =
                                _userOffersProvider.selectedOffer != null
                                    ? _userOffersProvider
                                        .selectedOffer!.sellingLimit!
                                    : 0.0;
                            if (_userOffersProvider.selectedOffer != null &&
                                recipientAmount > sellingLimit) {
                              return _showSnackBar(
                                  msg: "Selling limit exceeded");
                            }
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SelectPaymentMethod(
                                      youSent: response
                                          .amountYouWantToSendController.text,
                                      receiptGet: response
                                          .amountRecipientWillGetController
                                          .text,
                                      offerused: offerused,
                                      selectedAd:
                                          response.selectedFiatOffer != null
                                              ? response.selectedFiatOffer
                                              : response.selectedOffer,
                                      seller: response.sellerOfferData,
                                      isFiatMatchOffer:
                                          response.selectedFiatOffer != null
                                              ? true
                                              : false)),
                            );
                            // if (pop) {
                            //   _getOffers(clearfilter: true);
                            // }
                            response.amountYouWantToSendController.clear();
                            response.amountRecipientWillGetController.clear();
                          }
                        },
                        showOutlinedButton: false),
                  ),
                  SizedBox(
                    height: SizeConfig.resizeHeight(2),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.resizeWidth(9.35),
                    ),
                    child: FmSubmitButton(
                        text: 'I don\'t like these offers',
                        onPressed: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PostOfferPage(),
                            ),
                          );
                          _initiateApiCalls();
                        },
                        showOutlinedButton: true),
                  ),
                  SizedBox(
                    height: SizeConfig.resizeHeight(3.5),
                  ),
                  NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          if (response.hasMoreOffers) _getOffers();
                        }
                        return true;
                      },
                      child: UserOffers(
                        offers: response.fetchOffers,
                        userOffersProvider: _userOffersProvider,
                        onTapCallback: (ad, seller) {
                          _clearTexFields(response);
                          response.setSelectedOffer(ad);
                          response.setSelectedOfferSeller(seller);
                          setState(() {});
                        },
                        clearFillterCallback: () {
                          _userOffersProvider.clearOffers();
                          _userOffersProvider.getAllOffers(
                              userType: UserType.Buyer);
                          context
                              .read<MidMarketRateProvider>()
                              .getMidMarketRate(
                                _userOffersProvider.currencyRecipientWillGet!,
                                _userOffersProvider.currencyYouWantToSend!,
                              );
                        },
                        onUpdateCallback:
                            (offferExpire, noOfTransactions, sortBy, maxLimit) {
                          _userOffersProvider.clearOffers();
                          _userOffersProvider.getAllOffers(
                              userType: UserType.Buyer,
                              sorttype: sortBy,
                              sellingLimit: maxLimit,
                              noOfTransactions: noOfTransactions,
                              buyingCurrency:
                                  _userOffersProvider.currencyRecipientWillGet,
                              sellingCurrency:
                                  _userOffersProvider.currencyYouWantToSend,
                              expiry: offferExpire);

                          Navigator.pop(context);
                        },
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.resizeWidth(9.35),
                      vertical: SizeConfig.resizeHeight(1),
                    ),
                    child: MidMarketRateCard(
                      showButton: true,
                      onTapUseOffer: () {
                        _clearTexFields(response);
                        _userOffersProvider.setSelectedFiatOffer(
                            sellingCurrency:
                            _userOffersProvider.currencyYouWantToSend,
                            buyingCurrency:
                            _userOffersProvider.currencyRecipientWillGet,
                            rate: _userOffersProvider.parallelMarketRate);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.resizeWidth(9.35),
                      vertical: SizeConfig.resizeHeight(1),
                    ),
                    child: MidMarketRateCard(
                      showButton: false,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.resizeHeight(3),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  _validateData() {
    if (_userOffersProvider.currencyYouWantToSend!.isNotEmpty &&
        _userOffersProvider.currencyRecipientWillGet!.isNotEmpty &&
        _userOffersProvider.amountYouWantToSendController.text.isNotEmpty &&
        _userOffersProvider.amountRecipientWillGetController.text.isNotEmpty) {
      isValidate = true;
    } else {
      isValidate = false;
    }
    setState(() {});
  }

  void _getMidMarketRate(BuildContext context) {
    Provider.of<MidMarketRateProvider>(context, listen: false).getMidMarketRate(
      _userOffersProvider.currencyRecipientWillGet!,
      _userOffersProvider.currencyYouWantToSend!,
    );
  }

  void _clearTexFields(UserOffersProvider response) {
    response.amountRecipientWillGetController.text = '';
    response.amountYouWantToSendController.text = '';
  }

  Widget topOffer(
      {@required String? sellingCurrency,
      @required String? buyingCurrency,
      @required double? rate,
      bool isFiatOffer = false}) {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (isFiatOffer) {
        _userOffersProvider.setSelectedFiatOffer(
            sellingCurrency: sellingCurrency,
            buyingCurrency: buyingCurrency,
            rate: rate);
      }
    });
    offerused =
        '1 $sellingCurrency = ${isFiatOffer ? rate!.toStringAsFixed(5) : rate!.toStringAsFixed(5)} $buyingCurrency';
    return Stack(children: [
      Container(
        margin: EdgeInsets.only(
          left: SizeConfig.resizeWidth(5.47),
          top: SizeConfig.resizeHeight(2.31),
          bottom: SizeConfig.resizeHeight(2.31),
        ),
        width: SizeConfig.resizeWidth(0.15),
        height: SizeConfig.resizeHeight(18),
        color: Theme.of(context).appBarTheme.foregroundColor,
      ),
      Positioned(
        top: SizeConfig.resizeHeight(9),
        right: 0,
        left: 0,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: SizeConfig.resizeHeight(1.5),
                left: SizeConfig.resizeWidth(4.2),
              ),
              height: SizeConfig.resizeWidth(2.81),
              width: SizeConfig.resizeWidth(2.81),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            SizedBox(
              width: SizeConfig.resizeWidth(2.91),
            ),
            Flexible(
              flex: 1,
              child: Text(
                isFiatOffer ? 'Preferred Partner' : 'Selected Offer',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.resizeFont(11.54),
                ),
              ),
            ),
            SizedBox(
              width: SizeConfig.resizeWidth(2.09),
            ),
            Flexible(
              flex: 2,
              child: Text(
                rate != null || rate != 0 ? offerused : '...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w400,
                  fontSize: SizeConfig.resizeFont(11.54),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget searchField(String label, String? flag, String currency,
      TextEditingController textEditingController,
      {required onChange(value), required onCurrencyTap(value)}) {
    // if (flag == "null.png") return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        SizedBox(
          height: SizeConfig.resizeHeight(1),
        ),
        TextFormField(
          onChanged: (value) {
            if (value.isNotEmpty && _userOffersProvider.selectedOffer != null) {
              // var a = value == "0" && value == "" ? 0.0 : double.parse(value);
              // if (a > _userOffersProvider.selectedOffer!.sellingLimit!) {
              //   _showSnackBar(msg: "Value exceed selling limit");
              // } else {
              onChange(value);
              // }
            } else if (value.isNotEmpty) {
              onChange(value);
            } else {
              _userOffersProvider.amountRecipientWillGetController.clear();
              _userOffersProvider.amountYouWantToSendController.clear();
            }
          },
          controller: textEditingController,
          keyboardType: TextInputType.number,
          style: TextStyle(
              fontSize: SizeConfig.resizeFont(11.22), color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: SizeConfig.resizeWidth(4.11),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(7.5),
              borderSide: const BorderSide(
                color: Color(0xffCACACA),
              ),
            ),
            fillColor: Theme.of(context).primaryColor,
            filled: true,
            suffixIcon: InkWell(
              onTap: () {
                String currency = '';
                if (textEditingController ==
                    _userOffersProvider.amountRecipientWillGetController) {
                  currency = _userOffersProvider.currencyYouWantToSend ?? '';
                } else {
                  currency = _userOffersProvider.currencyRecipientWillGet ?? '';
                }
                _currencyBottomSheet(
                    label, (value) => onCurrencyTap(value), currency);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1.25,
                      color: Color(0xffC4C4C4),
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: SizeConfig.resizeWidth(3.34),
                    right: SizeConfig.resizeWidth(2.06),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      flag != null && flag != "null.png"
                          ? Image.asset(
                              'flags/${flag.toLowerCase()}',
                              width: SizeConfig.resizeWidth(7.18),
                              height: SizeConfig.resizeWidth(10.26),
                            )
                          : Container(),
                      SizedBox(
                        width: SizeConfig.resizeWidth(1.8),
                      ),
                      Text(
                        currency,
                        style: TextStyle(
                            fontSize: SizeConfig.resizeFont(13),
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: SizeConfig.resizeWidth(1.02),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).appBarTheme.foregroundColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Send money',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(11.22),
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 1,
      leading: Image.asset(
        'assets/hamburger.png',
        width: SizeConfig.resizeWidth(5.61),
        height: SizeConfig.resizeHeight(5.61),
      ),
      leadingWidth: 105,
      actions: [
        Image.asset(
          'assets/new_message.png',
          width: SizeConfig.resizeWidth(25),
        )
      ],
    );
  }

  void _currencyBottomSheet(
      String title, onTap(value), String disableCurrency) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (builder) {
          return FmCurrencyBottomSheet(
            onTap: (value) {
              onTap(value);
              Navigator.pop(context);
            },
            title: title,
            disableCurrency: disableCurrency,
          );
        });
  }

  _showSnackBar({String msg = 'Please fill amount you want to send.'}) {
    final snackBar = SnackBar(
      content: Text(msg),
      duration: Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
