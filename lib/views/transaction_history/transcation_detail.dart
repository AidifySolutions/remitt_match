import 'dart:developer';

import 'package:fiat_match/models/plans/activity.dart';
import 'package:fiat_match/models/plans/create_payment.dart';
import 'package:fiat_match/models/trade_info.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/provider/new/trade_payment_provider%20copy.dart';
import 'package:fiat_match/provider/new/transaction_history_provider.dart';
import 'package:fiat_match/provider/recipient_provider.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TradeDetails extends StatefulWidget {
  final Trade? trade;

  const TradeDetails({Key? key, this.trade}) : super(key: key);
  @override
  State<TradeDetails> createState() => _TradeDetailsState();
}

class _TradeDetailsState extends State<TradeDetails> {
  late TransactionHistoryProvider _transactionHistoryProvider;
  late TradePaymentProvider _tradePaymentProvider;
  late RecipientProvider _recipientProvider;
  bool _isloading = false;
  late bool isUserBuyer;
  late bool isUserSeller;
  @override
  void initState() {
    super.initState();

    _transactionHistoryProvider =
        Provider.of<TransactionHistoryProvider>(context, listen: false);
    _tradePaymentProvider =
        Provider.of<TradePaymentProvider>(context, listen: false);
    _recipientProvider = context.read<RecipientProvider>();
     isUserBuyer = _transactionHistoryProvider.customer?.id == widget.trade!.buyer?.buyerId;
     isUserSeller = _transactionHistoryProvider.customer?.id == widget.trade!.seller?.sellerId;
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _tradePaymentProvider.getTradePaymentStatus(widget.trade!.tradeId!);
      var  country = context.read<LoginProvider>().authentication.data?.customerData?.country ?? '';
      var currency = '';
      if(widget.trade?.tradeType == 'PlatformBased'){
        currency = widget.trade?.fromCurrency ?? '';
      }else{
        currency = widget.trade?.fromCurrency ?? '';
      }
      _recipientProvider.getFiatMatchAccountDetails(country, currency);
      if(isUserBuyer) {
        _recipientProvider.getRecipientById(widget.trade!.buyer?.beneficiaryId);
      }else if(isUserSeller){
        _recipientProvider.getRecipientById(widget.trade!.seller?.beneficiaryId);
      }
    });

  }

  @override
  void dispose() {
    super.dispose();
   // _transactionHistoryProvider.reset();
    _tradePaymentProvider.reset();
  }

  doPayement() async {
    try {
      setState(() => _isloading = true);
      CreateTradePaymentReq obj = CreateTradePaymentReq(
          customerId: Provider.of<LoginProvider>(context, listen: false)
              .authentication
              .data!
              .customerData!
              .id,
          planId: widget.trade!.tradeId);
      ActivityRequest activityObj = ActivityRequest(
        actionCode: 'payment',
        actorId: Provider.of<LoginProvider>(context, listen: false)
            .authentication
            .data!
            .customerData!
            .id,
        customerId: null,
        comments: "",
        tradeId: widget.trade!.id,
      );

      inspect(obj);
      inspect(activityObj);
      await _tradePaymentProvider.createPayment(obj);
      await _tradePaymentProvider.createActivity(activityObj);
      await _tradePaymentProvider.getTradePaymentStatus(widget.trade!.tradeId!);
    } catch (exp) {
      debugPrint("Some thing went wrong.");
    } finally {
      setState(() => _isloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff5f5f5),
        appBar: buildAppBar(),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.only(
                    left: SizeConfig.resizeWidth(6.14),
                    right: SizeConfig.resizeWidth(6.16),
                    top: SizeConfig.resizeWidth(4.11),
                    bottom: 50),
                child: ListView(children: [
                  _tradeDetailWidget(),
                  SizedBox(
                    height: 32,
                  ),
                  Divider(),
                  _tradeReceiptWidget(),
                  SizedBox(
                    height: 32,
                  ),
                  Divider(),
                  _FiatmatchAccountDetailWidget(),
                  SizedBox(
                    height: 32,
                  ),
                  _paymentBtn()
                ]),
              ));
  }

  Widget _statusBtn() {
    return Consumer<TradePaymentProvider>(
      builder: (context, response, child) {
        if (response.getTradeStatus.status == Status.COMPLETED) {
          return response.getTradeStatus.data!.status != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        color: response.tradeStatus.data?.status == false ? Color(getTradeStatusColor(
                            widget.trade?.status?.status ?? '')) : Color(getTradeStatusColor('Completed')),
                      ),
                      child: Text(
                        '${response.tradeStatus.data?.status == false ? 'Awaiting Verification' : 'Payment verified successfully'}',
                        style: TextStyle(
                          color: response.tradeStatus.data?.status == false ? Theme.of(context).primaryColor : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.resizeFont(7.01),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox();
        } else if (response.getTradeStatus.status == Status.ERROR) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            print("error");
          });
          return Container();
        } else if (response.getTradeStatus.status == Status.LOADING) {
          return _customLoader();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _customLoader() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        color: FiatColors.fiatGreen,
      ),
    );
  }

  Widget _paymentBtn() {
    return Consumer<TradePaymentProvider>(
      builder: (context, response, child) {
        if (response.getTradeStatus.status == Status.COMPLETED) {
          return _tradePaymentProvider.tradeStatus.data!.status == null
              ? Container(
                  width: MediaQuery.of(context).size.width / 3,
                  child: FmSubmitButton(
                      text: 'I have paid',
                      onPressed: doPayement,
                      showOutlinedButton: false),
                )
              : SizedBox();
        } else if (response.getTradeStatus.status == Status.ERROR) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            print("error");
          });
          return Container();
        } else if (response.getTradeStatus.status == Status.LOADING) {
          return _customLoader();
        } else {
          return Container();
        }
      },
    );
  }

  Widget _tradeDetailWidget() {
    var seller = _transactionHistoryProvider
        .getSellerBuyerName(widget.trade!.seller?.sellerId);
    var buyer = _transactionHistoryProvider
        .getSellerBuyerName(widget.trade!.buyer?.buyerId);

    print('isUserIsBuyer: $isUserBuyer');
    print('isUserIsSeller: $isUserSeller');
    print('buyer: $buyer');
    print('seller: $seller');
    var _offerUsed =
        "1 ${widget.trade!.fromCurrency} = ${widget.trade!.proposedRate} ${widget.trade!.toCurrency}";
    var _offerAccepted =
        "1 ${widget.trade!.fromCurrency} = ${widget.trade!.agreedRate} ${widget.trade!.toCurrency}";

    var _fiatFee = isUserSeller ? widget.trade!.seller?.fiatFee != null ? widget.trade!.seller?.fiatFee : 0
        : isUserBuyer ? widget.trade!.buyer?.fiatFee != null ? widget.trade!.buyer?.fiatFee : 0 : 0;
    var _youSell = "";
    var _youReceive= "";
    if(widget.trade?.tradeType == 'PlatformBased'){
      _youSell = "${(widget.trade!.currencyCount! + _fiatFee!).toStringAsFixed(4)} ${widget.trade!.fromCurrency}";
      _youReceive = widget.trade!.agreedRate != null && widget.trade!.currencyCount != null
          ? '${(widget.trade!.currencyCount! * widget.trade!.agreedRate!)
          .toStringAsFixed(4)} ${widget.trade!.toCurrency}'
          : 'N/A';
    }
    else if(isUserBuyer){
      _youSell = "${(widget.trade!.currencyCount! + _fiatFee!).toStringAsFixed(4)} ${widget.trade!.toCurrency}";
      _youReceive =
      widget.trade!.agreedRate != null && widget.trade!.currencyCount != null
          ? '${(widget.trade!.currencyCount! / widget.trade!.agreedRate!)
          .toStringAsFixed(4)} ${widget.trade!.fromCurrency}'
          : 'N/A';
    }else if(isUserSeller){
      _youSell = '${(widget.trade!.currencyCount! / widget.trade!.agreedRate! + _fiatFee! )
          .toStringAsFixed(4)}';
      _youReceive = '${widget.trade!.currencyCount} ${widget.trade!.toCurrency}';
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Transaction Details',
                style: FiatStyles.body5().copyWith(
                  color: FiatColors.darkBlue,
                )),
            Spacer(),
            _statusBtn(),
          ],
        ),
        SizedBox(
          height: 16,
        ),
        _detailOfferTraderWidget(
            titleLeading: 'Trade ID:',
            valueLeading: widget.trade!.tradeId,
            titleTrailing: isUserBuyer ? "Seller:" : isUserSeller ? "Buyer:" : 'N/A',
            valueTrailing: widget.trade?.tradeType == 'PlatformBased' ? 'FiatMatch':isUserBuyer ?  seller : isUserSeller ? buyer : 'N/A'),
        SizedBox(
          height: 16,
        ),
        _detailOfferTraderWidget(
            titleLeading: 'Initiated at:',
            valueLeading: Helper.dateTimeFormat(widget.trade!.creationDateTime),
            titleTrailing: "Updated at:",
            valueTrailing: Helper.dateTimeFormat(widget.trade!.updatedDateTime)),
        SizedBox(
          height: 16,
        ),
        _detailOfferTraderWidget(
            titleLeading: 'Offer Used:',
            valueLeading: _offerUsed,
            titleTrailing: "Offer Accepted:",
            valueTrailing: _offerAccepted),
        //You Sell
        SizedBox(
          height: 16,
        ),
        _detailOfferTraderWidget(
          titleLeading: "You Receive:",
          valueLeading: _youReceive,
          titleTrailing: 'FiatMatch Fee:',
          valueTrailing: '$_fiatFee ${widget.trade?.tradeType == 'PlatformBased'? widget.trade?.fromCurrency :isUserBuyer ? widget.trade?.toCurrency : widget.trade?.fromCurrency} (${_fiatFee != 0 ?'2' : '0'} USD)',
           ),
        SizedBox(
          height: 16,
        ),
        _detailOfferTraderWidget(
          titleLeading: 'You Send:',
          valueLeading: _youSell,
          titleTrailing: '',
          valueTrailing: '',
            ),
      ],
    );
  }

  Widget _tradeReceiptWidget() {

    var buyer = _transactionHistoryProvider
        .getSellerBuyerInfo(widget.trade!.buyer?.buyerId);
    return Consumer<RecipientProvider>(builder: (context,response,child){

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recipient Details',
              style: FiatStyles.body5().copyWith(
                color: FiatColors.darkBlue,
              )),
          SizedBox(
            height: 16,
          ),
          _detailOfferTraderWidget(
              titleLeading: 'Name:',
              valueLeading: response.recipient.data?.beneficiary?.firstName ?? 'N/A',
              titleTrailing: "Email:",
              valueTrailing: response.recipient.data?.beneficiary?.email ??  'N/A'),
          SizedBox(
            height: 16,
          ),
          _detailOfferTraderWidget(
              titleLeading: 'Phone No:',
              valueLeading:
              "+${response.recipient.data?.beneficiary?.phoneNumber?.dialCode} ${response.recipient.data?.beneficiary?.phoneNumber?.number}",
              titleTrailing: "Payment Method:",
              valueTrailing:
              response.recipient.data?.beneficiary?.channel?.first.channelType == null ? 'N/A' : response.recipient.data?.beneficiary?.channel?.first.channelType),
        ],
      );
    });

  }

  Widget _FiatmatchAccountDetailWidget() {

    var buyer = _transactionHistoryProvider
        .getSellerBuyerInfo(widget.trade!.buyer?.buyerId);
    return Consumer<RecipientProvider>(builder: (context,response,child){

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FiatMatch Account Details',
              style: FiatStyles.body5().copyWith(
                color: FiatColors.darkBlue,
              )),
          SizedBox(
            height: 16,
          ),
          _detailOfferTraderWidget(
              titleLeading: 'Bank Name:',
              valueLeading: response.depositInfo.data?.depositInformation?.bankName ?? 'N/A',
              titleTrailing: "Account Title:",
              valueTrailing: response.depositInfo.data?.depositInformation?.accountTitle??  'N/A'),
          SizedBox(
            height: 16,
          ),
          _detailOfferTraderWidget(
              titleLeading: 'Account Number:',
              valueLeading: response.depositInfo.data?.depositInformation?.accountNumber??  'N/A',
              titleTrailing: "",
              valueTrailing:"",)
        ],
      );
    });

  }

  Widget _detailOfferTraderWidget(
      {String? titleLeading,
      String? valueLeading,
      String? titleTrailing,
      String? valueTrailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _detailWidget(title: titleLeading!, value: valueLeading ?? 'N/A'),
        _detailWidget(title: titleTrailing!, value: valueTrailing ?? 'N/A'),
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



  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        'Transaction Detail',
        style: TextStyle(
            fontSize: SizeConfig.resizeFont(12.31),
            fontWeight: FontWeight.w500),
      ),
      centerTitle: true,
      elevation: 1,
      leadingWidth: 105,
    );
  }

  _showDialog(String title, String buttonText, IconData icon) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: icon,
              title: title,
              message: '',
              buttonText: buttonText,
              voidCallback: () async {
                context.read<TransactionHistoryProvider>().reset();
                Navigator.pop(dialogContext);
              });
        });
  }

  goToNewScreen(Widget screen) async {
    _transactionHistoryProvider.reset();
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  int getTradeStatusColor(String tradeStatus) {
    switch (tradeStatus) {
      case 'AwaitingConfirmation':
      case 'InReview':
      case 'AwaitingPayment':
      case 'AwaitingSettlement':
      case 'AwaitingVerification':
        return 0xffFB7800; //orange
      case 'Rejected':
        return 0xffFF0B0B; //red
      case 'Completed':
        return 0xff2FBF71; //green
      case 'Cancelled':
        return 0xffFF0B0B; //red

      default:
        return 0xffFFFFFF;
    }
  }

  String getTradeStatusMsg(String tradeStatus) {
    switch (tradeStatus) {
      case 'AwaitingConfirmation':
        return 'In Progress'; //orange
      case 'Completed':
        return 'Successful'; //green
      case 'Cancelled':
        return 'Discard'; //red
      case 'InReview':
        return 'In Review'; //orange
      case 'AwaitingPayment':
        return 'Transferring InProgress'; //orange
      case 'AwaitingSettlement':
        return 'Awaiting Settlement';
      case 'AwaitingVerification':
        return 'Awaiting Verification';
      case 'Rejected':
        return 'Rejected'; //red
      default:
        return 'No status found';
    }
  }
}
