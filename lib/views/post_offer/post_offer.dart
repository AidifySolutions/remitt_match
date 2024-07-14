import 'package:fiat_match/models/advertisement.dart';
import 'package:fiat_match/models/post_offer.dart';
import 'package:fiat_match/provider/new/currency_provider.dart';
import 'package:fiat_match/provider/new/mid_market_rate_provider.dart';
import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/views/payment/send_payment.dart';
import 'package:fiat_match/views/post_offer/rate_selection_widget.dart';
import 'package:fiat_match/views/send_money/user_offers.dart';
import 'package:fiat_match/widgets/fm_currency_bottomsheet.dart';
import 'package:fiat_match/widgets/new/fm_mid_market_card.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fiat_match/models/post_offer.dart' as rate;

class PostOfferPage extends StatefulWidget {
  @override
  _PostOfferPageState createState() => _PostOfferPageState();
}

class _PostOfferPageState extends State<PostOfferPage> {
  late UserOffersProvider _userOffersProvider;
  double? selectedRate = 0;
  String? selectedType = '';
  bool isValidate = false;
  bool openToNegotiate = false;
  DateTime? currentDate = DateTime.now();
  late CurrencyProvider _currencyProvider;
  @override
  void initState() {
    super.initState();

    _userOffersProvider =
        Provider.of<UserOffersProvider>(context, listen: false);
    _currencyProvider = context.read<CurrencyProvider>();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _userOffersProvider.reset();
    });

    _initiateApiCalls();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _userOffersProvider.amountYouWantToSendController.clear();
      _userOffersProvider.amountRecipientWillGetController.clear();
      _userOffersProvider.reset();
    });
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate!,
        firstDate: DateTime.now(),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate)
      setState(() {
        currentDate = pickedDate;
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

  _validateData() {
    if (_userOffersProvider.currencyYouWantToSend!.isNotEmpty &&
        _userOffersProvider.currencyRecipientWillGet!.isNotEmpty &&
        selectedRate != 0.0 &&
        selectedType!.isNotEmpty &&
        _userOffersProvider.amountYouWantToSendController.text.isNotEmpty &&
        _userOffersProvider.amountRecipientWillGetController.text.isNotEmpty) {
      isValidate = true;
    } else {
      isValidate = false;
    }
    setState(() {});
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Post offer',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(12.31),
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 1,
      leadingWidth: 105,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    print(
      SizeConfig.resizeFont(7.7),
    );
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar: buildAppBar(),
        body: SafeArea(
          child:
              Consumer<UserOffersProvider>(builder: (context, response, child) {
            // Provider.of<MidMarketRateProvider>(context).getMidMarketRate(
            //   response.offers.data?.ads?.first.sellingCurrency ?? '',
            //   response.offers.data?.ads?.first.buyingCurrency ?? '',
            // );
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: SizeConfig.resizeHeight(1.87),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.resizeWidth(9.35),
                        vertical: SizeConfig.resizeHeight(1),
                      ),
                      child: MidMarketRateCard(showButton: false),
                    ),
                    //if (response.offers.data != null)
                    UserOffers(
                      offers: response.fetchOffers,
                      showButtons: false,
                      userOffersProvider: _userOffersProvider,
                      onTapCallback: (ad, seller) {},
                      clearFillterCallback: () {
                        _userOffersProvider.clearOffers();
                        _userOffersProvider.getAllOffers(
                            userType: UserType.Seller);
                        context.read<MidMarketRateProvider>().getMidMarketRate(
                              _userOffersProvider.currencyRecipientWillGet!,
                              _userOffersProvider.currencyYouWantToSend!,
                            );
                      },
                      onUpdateCallback:
                          (offferExpire, userTrasnaction, sortBy, maxLimit) {
                        _userOffersProvider.clearOffers();
                        _userOffersProvider.getAllOffers(
                          userType: UserType.Seller,
                          buyingCurrency: response.currencyYouWantToSend,
                          sellingCurrency: response.currencyRecipientWillGet,
                          sorttype: sortBy,
                        );
                        Navigator.pop(context);
                      },
                    ),
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
                          response.setAmountRecipientWillGetPostOffer(
                              value,
                              context
                                  .read<MidMarketRateProvider>()
                                  .selectedRate);
                          _validateData();
                        },
                        onCurrencyTap: (value) {
                          response.clearOffers();
                          response.setCurrencyYouWantToSend(value);
                          var val = _currencyProvider.currency.data?.currencies?.firstWhere((element) => element.name != value);
                          response.setCurrencyRecipientWillGet(val?.name);
                          _userOffersProvider.getAllOffers(
                              userType: UserType.Seller,
                              buyingCurrency:
                                  _userOffersProvider.currencyRecipientWillGet,
                              sellingCurrency:
                                  _userOffersProvider.currencyYouWantToSend);
                          _getMidMarketRate(context);
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            response.amountYouWantToSendController.text = '';
                            response.amountRecipientWillGetController.text = '';
                          });
                        },
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.resizeWidth(9.35),
                          vertical: SizeConfig.resizeWidth(3.35),
                        ),
                        child: RateSelectionWidget(
                          currency: response.currencyRecipientWillGet ?? '',
                          onRateUpdated: (value, type) {
                            setState(() {
                              response.amountYouWantToSendController.text = '';
                              response.amountRecipientWillGetController.text =
                                  '';
                              selectedType = type;
                              selectedRate = value;
                              print(type);
                              print(value);
                              _validateData();
                            });
                          },
                        )),

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
                          response.setAmountYouWantToSendPostOffer(
                              value,
                              context
                                  .read<MidMarketRateProvider>()
                                  .selectedRate);
                          _validateData();
                        },
                        onCurrencyTap: (value) {
                          response.clearOffers();
                          response.setCurrencyRecipientWillGet(value);
                          var val = _currencyProvider.currency.data?.currencies?.firstWhere((element) => element.name != value);
                          response.setCurrencyYouWantToSend(val?.name);
                          _userOffersProvider.getAllOffers(
                              userType: UserType.Seller,
                              buyingCurrency:
                                  _userOffersProvider.currencyRecipientWillGet,
                              sellingCurrency:
                                  _userOffersProvider.currencyYouWantToSend);
                          _getMidMarketRate(context);
                          WidgetsBinding.instance?.addPostFrameCallback((_) {
                            response.amountYouWantToSendController.text = '';
                            response.amountRecipientWillGetController.text = '';
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.resizeWidth(9.35),
                        vertical: SizeConfig.resizeWidth(4.35),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Offer expiry'),
                          SizedBox(
                            height: 8,
                          ),
                          FmSubmitButton(
                            showOutlinedButton: true,
                            onPressed: () => _selectDate(context),
                            text:
                                DateFormat('yyyy MMMM dd').format(currentDate!),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: Constants.featureVisibilty,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.resizeWidth(4.35),
                          //vertical: SizeConfig.resizeWidth(2.35),
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            Checkbox(
                                value: openToNegotiate,
                                onChanged: (value) {
                                  setState(() {
                                    openToNegotiate = value!;
                                  });
                                }),
                            SizedBox(width: 4),
                            Text(
                              'Open to negotiate',
                              style: TextStyle(fontSize: 17.0),
                            ), //Checkbox
                          ], //<Widget>[]
                        ),
                      ),
                    ), //
                    SizedBox(
                      height: SizeConfig.resizeHeight(7),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.resizeWidth(9.35),
                      ),
                      child: FmSubmitButton(
                          text: 'Post Offer',
                          onPressed: () {
                            if (_userOffersProvider
                                    .currencyYouWantToSend!.isNotEmpty &&
                                _userOffersProvider
                                    .currencyRecipientWillGet!.isNotEmpty &&
                                selectedType!.isNotEmpty &&
                                _userOffersProvider
                                    .amountYouWantToSendController
                                    .text
                                    .isNotEmpty &&
                                _userOffersProvider
                                    .amountRecipientWillGetController
                                    .text
                                    .isNotEmpty) {
                              if (double.parse(_userOffersProvider
                                          .amountYouWantToSendController
                                          .text) <=
                                      0.0 ||
                                  double.parse(_userOffersProvider
                                          .amountRecipientWillGetController
                                          .text) <=
                                      0.0) {
                                _showSnackBar(msg: "Amount cannot be zero");
                              } else {
                                _moveToNextScreen(context, response);
                              }
                            } else {
                              _showSnackBar(msg: "Please enter amount");
                            }
                          },
                          // isValidate
                          //     ? () {
                          //         PostOffer _obj = PostOffer(
                          //             sellingCurrency: _userOffersProvider
                          //                 .currencyYouWantToSend,
                          //             buyingCurrency: _userOffersProvider
                          //                 .currencyRecipientWillGet,
                          //             expiry: currentDate!.toIso8601String(),
                          //             openToNegotiate: openToNegotiate,
                          //             sellingLimit: int.parse(_userOffersProvider
                          //                 .amountYouWantToSendController.text),
                          //             recipient: Recipient(
                          //                 channelId: '', beneficiaryId: ''),
                          //             rate: rate.Rate(
                          //                 factor: 2,
                          //                 type: selectedType,
                          //                 operator: "Add",
                          //                 value: selectedRate.toString()));
                          //
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => SelectPaymentMethod(
                          //                     youSent: response
                          //                         .amountYouWantToSendController
                          //                         .text,
                          //                     receiptGet: response
                          //                         .amountRecipientWillGetController
                          //                         .text,
                          //                     offerused:
                          //                         '1 ${_userOffersProvider.currencyYouWantToSend} = ${context.read<MidMarketRateProvider>().selectedRate} ${_userOffersProvider.currencyRecipientWillGet}',
                          //                     selectedAd: null,
                          //                     seller: null,
                          //                     fromPostOffer: true,
                          //                     postOffer: _obj,
                          //                   )),
                          //         );
                          //       }
                          //     : () {},
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
                          text: 'Cancel',
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          showOutlinedButton: true),
                    ),
                    SizedBox(
                      height: SizeConfig.resizeHeight(3.5),
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
      ),
    );
  }

  void _moveToNextScreen(BuildContext context, UserOffersProvider response) {
    PostOffer _obj = PostOffer(
        sellingCurrency: _userOffersProvider.currencyYouWantToSend,
        buyingCurrency: _userOffersProvider.currencyRecipientWillGet,
        expiry: currentDate!.toIso8601String(),
        openToNegotiate: openToNegotiate,
        sellingLimit:
            num.parse(_userOffersProvider.amountYouWantToSendController.text),
        recipient: Recipient(channelId: '', beneficiaryId: ''),
        rate: rate.Rate(
            factor: selectedRate,
            type: selectedType,
            operator: "Add",
            value: selectedRate));
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SelectPaymentMethod(
                youSent: response.amountYouWantToSendController.text,
                receiptGet: response.amountRecipientWillGetController.text,
                offerused:
                    '1 ${_userOffersProvider.currencyYouWantToSend} = ${context.read<MidMarketRateProvider>().selectedRate} ${_userOffersProvider.currencyRecipientWillGet}',
                selectedAd: null,
                seller: null,
                fromPostOffer: true,
                postOffer: _obj,
              )),
    );
  }

  void _getMidMarketRate(BuildContext context) {
    Provider.of<MidMarketRateProvider>(context, listen: false).getMidMarketRate(
      _userOffersProvider.currencyRecipientWillGet!,
      _userOffersProvider.currencyYouWantToSend!,
    );
  }

  Widget topOffer(Ads? ads) {
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
            Text(
              'top offer',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.resizeFont(11.54),
              ),
            ),
            SizedBox(
              width: SizeConfig.resizeWidth(2.09),
            ),
            Text(
              ads != null
                  ? '1 ${ads.sellingCurrency} = ${ads.rate?.value} ${ads.buyingCurrency}'
                  : '...',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.resizeFont(11.54),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Column searchField(String label, String? flag, String currency,
      TextEditingController textEditingController,
      {required onChange(value), required onCurrencyTap(value)}) {
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
          onChanged: (value) => onChange(value),
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
                      flag != null && flag != ".png"
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

  _getOffers({bool clearfilter = false}) {
    if (clearfilter) {
      _userOffersProvider.clearOffers();
    }
    _userOffersProvider.getAllOffers(
      userType: UserType.Seller,
      buyingCurrency: _userOffersProvider.currencyRecipientWillGet,
      sellingCurrency: _userOffersProvider.currencyYouWantToSend,
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

// Card fiatMatchOffer(BuildContext context) {
//   return Card(
//     elevation: 3,
//     shadowColor: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     child: Container(
//       padding: EdgeInsets.all(
//         SizeConfig.resizeWidth(4),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'FiatMatch Offer',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     color: Theme.of(context).appBarTheme.foregroundColor,
//                     fontSize: SizeConfig.resizeFont(11.22),
//                   ),
//                 ),
//                 SizedBox(
//                   height: SizeConfig.resizeHeight(0.5),
//                 ),
//                 Consumer<UserOffersProvider>(
//                     builder: (context, response, child) {
//                   if (response.loadOffers) {
//                     return Text('...');
//                   }
//                   return Text(
//                     '1 ${response.currencyYouWantToSend} = ${response.parallelMarketRate} ${response.currencyRecipientWillGet}',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       color: Theme.of(context).appBarTheme.foregroundColor,
//                       fontSize: SizeConfig.resizeFont(8.42),
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

class FmDateFormat {
  static String formatDate({String? date}) {
    return DateFormat('yyyy MMMM dd').format(DateTime.parse(date!));
  }
}
