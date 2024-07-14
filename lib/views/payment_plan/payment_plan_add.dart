/*
import 'package:fiat_match/models/plans/create_payment.dart';
import 'package:fiat_match/models/plans/instrument.dart';
import 'package:fiat_match/models/plans/plans.dart';
import 'package:fiat_match/models/plans/subscriptions.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/provider/new/payment_plan_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/loader.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/fm_toast.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class PaymentPlanAdd extends StatefulWidget {
  final Subscription selectedSubscription;
  final Plans selectedplan;
  PaymentPlanAdd(
      {Key? key,
      required this.selectedSubscription,
      required this.selectedplan})
      : super(key: key);

  @override
  _PaymentPlanAddState createState() => _PaymentPlanAddState();
}

class _PaymentPlanAddState extends State<PaymentPlanAdd> {
  int _groupValue = 0;
  late PaymentPlanProvider _paymentPlanProvider;
  Instrument _selectedSavedMethod = Instrument();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String? _cardNo;
  String? _cardExpiry;
  String? _cardCvv;
  String? _cardBillingAddress;

  List<String> schems = [
    'visa',
    'mastercard',
    'american_express',
    'discover',
    'jcb',
    'unionpay'
  ];
  @override
  void initState() {
    super.initState();
    _paymentPlanProvider =
        Provider.of<PaymentPlanProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _paymentPlanProvider.getSavedPaymentPlans();
    });
  }

  _addPaymentMethod() async {
    String _userid =
        context.read<LoginProvider>().authentication.data!.customerData!.id!;
    String _stripeId = context
        .read<LoginProvider>()
        .authentication
        .data!
        .customerData!
        .stripeId!;

    await _paymentPlanProvider.addPaymentPlans(
        customer: _userid,
        externalCustomer: _stripeId,
        cardNo: _cardNo!,
        cardBusineesAddress: _cardBillingAddress!,
        cardCvv: _cardCvv!,
        cardExpiry: _cardExpiry!);
    await _createPaymentMethod();
  }

  _createPaymentMethod() async {
    try {
      var _obj = CreatePaymentReq(
          customerId: context
              .read<LoginProvider>()
              .authentication
              .data!
              .customerData!
              .id!,
          paymentMethod: _groupValue == 0
              ? _selectedSavedMethod.externalPaymentMethod
              : _paymentPlanProvider
                  .addInstruments.data!.instruments!.externalPaymentMethod,
          planId: widget.selectedplan.id,
          planName: widget.selectedSubscription.name,
          price: widget.selectedSubscription.priceId,
          stripeCustomer: context
              .read<LoginProvider>()
              .authentication
              .data!
              .customerData!
              .stripeId!);
      await _paymentPlanProvider.createPaymentCall(obj: _obj);
      if (_paymentPlanProvider.createPayment.data!.url != null) {
        _openPayementUrl(_paymentPlanProvider.createPayment.data!.url!);
      } else {
        _showSuccessDialog(
            title: 'Add Payment method Complete!',
            msg:
                'Awesome! You can now send money to anyone around the world up to 10 times in a month! You can proceed with your transaction on FiatMatch.',
            buttonText: 'Continue',
            navigate: false);
      }
    } catch (e) {
      showToast("Error", Icons.error);
    }
  }

  showToast(String? msg, IconData icon) {
    FToast _fToast;
    _fToast = FToast();
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

  _showSuccessDialog(
      {String title = '',
      String msg = '',
      String buttonText = '',
      IconData icon = Icons.done,
      bool navigate = true}) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: icon,
              title: title,
              message: msg,
              buttonText: buttonText,
              voidCallback: () async {
                if (navigate) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                } else {
                  Navigator.pop(context);
                }
              });
        });
  }

  _checkPaymentStatus(String _indent) async {
    if (_indent.isEmpty) return;
    try {
      await _paymentPlanProvider.checkPayemntStatus(intend: _indent);
      if (_paymentPlanProvider.paymentStatus.data!.message ==
          "Payment Successfull") {
        _showSuccessDialog(
            title: 'Purchase Complete!',
            msg:
                'Awesome! You can now send money to anyone around the world up to 10 times in a month! You can proceed with your transaction on FiatMatch.',
            buttonText: 'Continue');
      }
    } catch (exp) {
      showToast(exp.toString(), Icons.error);
    }
  }

  _openPayementUrl(String url) {
    if (url.isEmpty) return;
    try {
      final flutterWebviewPlugin = FlutterWebviewPlugin();
      flutterWebviewPlugin.launch(
        url,
      );
      flutterWebviewPlugin.onUrlChanged.listen((String _url) async {
        print(_url);
        if (_url.contains('payment_intent')) {
          var paymentIntent = _url.split('?')[1].split('=')[1].split('&')[0];
          print(paymentIntent);
          flutterWebviewPlugin.close();
          _checkPaymentStatus(paymentIntent);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentPlanProvider>(builder: (context, response, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Color(0xfff5f5f5),
        appBar: buildAppBar(),
        body: _paymentPlanProvider.isloading ? Loader() : _buildBody(),
      );
    });
  }

  Widget _buildBody() {
    return LayoutBuilder(builder: (context, constraint) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraint.maxHeight),
          child: IntrinsicHeight(
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.resizeWidth(9.35)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 32,
                  ),
                  Text(
                    "Complete your purchase",
                    style: FiatStyles.body2().copyWith(
                        color: FiatColors.darkBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  ),
                  SizedBox(
                    height: 36,
                  ),
                  Text('Payment Method',
                      style: FiatStyles.body2().copyWith(
                          color: FiatColors.darkBlue,
                          fontWeight: FontWeight.w600,
                          fontSize: 16)),
                  SizedBox(
                    height: 32,
                  ),
                  Divider(),
                  Row(
                    children: [
                      _myRadioButton(
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue),
                        value: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text("Saved payment method",
                            style: FiatStyles.body14()),
                      )
                    ],
                  ),
                  if (_groupValue == 0) _buildSavedPayementMethods(),
                  Divider(),
                  Row(
                    children: [
                      _myRadioButton(
                        onChanged: (newValue) =>
                            setState(() => _groupValue = newValue),
                        value: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text("Add a payment method",
                            style: FiatStyles.body14()),
                      )
                    ],
                  ),
                  if (_groupValue == 1) ...[
                    _buildSchemeWidegt(),
                    _buildSchemeCardAddtion()
                  ],
                  _buildSummary(),
                  Spacer(),
                  FmSubmitButton(
                      text: 'Continue to check out',
                      onPressed: () {
                        if (_groupValue == 0) {
                          _createPaymentMethod();
                        } else {
                          if (formKey.currentState!.validate()) {
                            print("validate");
                            if (_groupValue == 1) {
                              _addPaymentMethod();
                            }
                          }
                        }
                      },
                      showOutlinedButton: false),
                  SizedBox(
                    height: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSummary() {
    var _total = widget.selectedSubscription.interval! ==
            Constants.subscriptionMonthlyInterval
        ? widget.selectedSubscription.price
        : (widget.selectedSubscription.price! * 12);

    return Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
              Radius.circular(8.0) //                 <--- border radius here
              ),
          border: Border.all(color: FiatColors.darkBlue, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Summary",
              style: FiatStyles.body2().copyWith(fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Extra Savings",
                      style: FiatStyles.setStyle(
                          style: FiatStyles.body2(),
                          color: FiatColors.fiatBlack)),
                  RichText(
                      text: TextSpan(
                    text: 'US \$ ${widget.selectedSubscription.price} X',
                    style: FiatStyles.setStyle(
                        style: FiatStyles.body2(), color: FiatColors.fiatBlack),
                    children: <TextSpan>[
                      TextSpan(
                          text: widget.selectedSubscription.interval! ==
                                  Constants.subscriptionMonthlyInterval
                              ? ' 1 month'
                              : ' 12 months',
                          style: FiatStyles.setStyle(
                              style: FiatStyles.body2(),
                              color: FiatColors.fiatBlack)),
                    ],
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total",
                      style: FiatStyles.setStyle(
                          style: FiatStyles.body2(),
                          color: FiatColors.fiatBlack)),
                  RichText(
                      text: TextSpan(
                    text: 'US \$ $_total',
                    style: FiatStyles.setStyle(
                        style: FiatStyles.body2(), color: FiatColors.fiatBlack),
                    children: <TextSpan>[],
                  )),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _myRadioButton({int value = 0, required Function onChanged}) {
    return Radio(
      value: value,
      groupValue: _groupValue,
      onChanged: (value) {
        onChanged(value!);
      },
    );
  }

  Widget _buildSavedPayementMethods() {
    return Consumer<PaymentPlanProvider>(builder: (context, response, child) {
      if (response.instruments.status == Status.LOADING) {
        return Loader();
      } else if (response.instruments.status == Status.COMPLETED) {
        if (response.instruments.data!.instruments!.isNotEmpty)
          _selectedSavedMethod = response.instruments.data!.instruments!.first;

        return response.instruments.data!.instruments != null &&
                response.instruments.data!.instruments!.length > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 160,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount:
                            response.instruments.data!.instruments!.length,
                        itemBuilder: (BuildContext context, int index) {
                          var item =
                              response.instruments.data!.instruments![index];

                          return InkWell(
                            onTap: () {
                              _selectedSavedMethod = item;
                              setState(() {});
                            },
                            child: Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                border: Border.all(
                                    color: _selectedSavedMethod == item
                                        ? FiatColors.darkBlue
                                        : FiatColors.fiatGrey,
                                    width: 1),
                              ),
                              width: MediaQuery.of(context).size.width / 2,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Spacer(),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Image.asset(
                                      _getAssetsOfScheme(item.cardBrand!),
                                    ),
                                  ),
                                  Text(
                                    item.cardBrand!,
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 15),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, bottom: 8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          " .... ",
                                          style: FiatStyles.body5(),
                                        ),
                                        Text(
                                          item.last4!,
                                          style: FiatStyles.body3(),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  InkWell(
                      onTap: () {
                        print(_selectedSavedMethod.billingAddress);
                        _paymentPlanProvider.deletePaymentMethod(
                            id: _selectedSavedMethod.id!);
                      },
                      child: Text(
                        "Remove",
                        style: FiatStyles.body2(),
                      ))
                ],
              )
            : Container();
      } else if (response.instruments.status == Status.ERROR) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {});
        return Container();
      } else {
        return Container();
      }
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Billing Cycles'),
      leadingWidth: SizeConfig.resizeWidth(26),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: SizeConfig.resizeFont(11.22),
          color: Theme.of(context).appBarTheme.foregroundColor),
    );
  }

  Widget _buildSchemeWidegt() {
    return Row(
      children: schems
          .map((e) => Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: SizedBox(
                  height: 30,
                  width: 40,
                  child: Image.asset(_getAssetsOfScheme(e)),
                ),
              ))
          .toList(),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      _cardNo = creditCardModel.cardNumber;
      _cardExpiry = creditCardModel.expiryDate;
      _cardBillingAddress = creditCardModel.cardHolderName;
      _cardCvv = creditCardModel.cvvCode;

      print(creditCardModel);
    });
  }

  InputDecoration buildInputDecoration() {
    return InputDecoration(
      errorMaxLines: 3,
      //filled: FiatColors.gr,
      fillColor:
          Theme.of(context).appBarTheme.foregroundColor!.withOpacity(0.09),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    );
  }

  Widget _buildSchemeCardAddtion() {
    return CreditCardForm(
      formKey: formKey,
      onCreditCardModelChange: onCreditCardModelChange,
      obscureCvv: true,
      obscureNumber: true,
      cardNumberDecoration: const InputDecoration(
        fillColor: Colors.green,
        border: OutlineInputBorder(),
        labelText: 'Card Number',
        hintText: 'XXXX XXXX XXXX XXXX',
      ),
      expiryDateDecoration: const InputDecoration(
        fillColor: Colors.green,
        border: OutlineInputBorder(),
        labelText: 'Expired Date',
        hintText: 'XX/XX',
      ),
      cvvCodeDecoration: const InputDecoration(
        fillColor: Colors.green,
        border: OutlineInputBorder(),
        labelText: 'CVV',
        hintText: 'XXX',
      ),
      cardHolderDecoration: const InputDecoration(
        fillColor: Colors.green,
        border: OutlineInputBorder(),
        labelText: 'Business Address',
      ),
      cardHolderName: '',
      expiryDate: '',
      themeColor: FiatColors.fiatGreen,
      cvvCode: '',
      cardNumber: '',
    );
  }

  String _getAssetsOfScheme(String scheme) {
    switch (scheme) {
      case 'visa':
        return 'assets/visa_electron.png';
      case 'mastercard':
        return 'assets/mastercard.png';
      case 'discover':
        return 'assets/discover.png';
      case 'unionpay':
        return 'assets/union_pay.png';
      case 'american_express':
        return 'assets/american_express.png';
      case 'jcb':
        return 'assets/jcb.png';
      default:
        return 'assets/visa_electron.png';
    }
  }
}
*/
