import 'package:fiat_match/chat/chat_provider.dart';
import 'package:fiat_match/chat/trading_provider.dart';
import 'package:fiat_match/models/chat_messages.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/widgets/fm_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessageConstant {
  static var offerAccepted = "OFFER ACCEPTED";
}

class OfferBubble extends StatefulWidget {
  final ChatMessage chatMessage;
  final TradingProvider tradingProvider;
  final ChatProvider chatProvider;

  OfferBubble(
      {required this.chatMessage,
      required this.tradingProvider,
      required this.chatProvider});

  @override
  _OfferBubbleState createState() => _OfferBubbleState();
}

class _OfferBubbleState extends State<OfferBubble> {
  late FToast _fToast;

  @override
  void initState() {
    super.initState();
    _fToast = FToast();
    _fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    bool isBuyer = widget.chatMessage.sender ==
        widget.tradingProvider.beneficiaries?.customer;

    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: Align(
        alignment: isBuyer ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80),
          padding: EdgeInsets.only(left: 13, right: 13, top: 13, bottom: 3),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 1,
            ),
            color: Color.fromRGBO(47, 191, 113, 0.05),
            borderRadius: isBuyer ? isBuyerBorder() : isSellerBorder(),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              offerInfo(isBuyer, context),
              SizedBox(
                height: SizeConfig.resizeHeight(1),
              ),
              Text(
                getDateTime(),
                style: TextStyle(
                  color: FiatColors.fiatBlack,
                  fontSize: SizeConfig.resizeFont(7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getStatus() {
    if (widget.chatMessage.status ==
        Helper.getEnumValue(TradeStatus.AwaitingConfirmation.toString())) {
      return "Pending";
    } else {
      return "Rejected";
    }
  }

  String getDateTime() {
    String? dateTime;
    if (DateTime.now()
            .difference(DateTime.parse(widget.chatMessage.time.toString()))
            .inDays ==
        0) {
      dateTime = DateFormat('hh:mm aa')
          .format(DateTime.parse(widget.chatMessage.time.toString()).toLocal());
    } else {
      dateTime = DateFormat('yyyy MMM dd hh:mm aa')
          .format(DateTime.parse(widget.chatMessage.time.toString()).toLocal());
    }
    return dateTime;
  }

  Widget offerInfo(bool isBuyer, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.info,
              color: FiatColors.fiatGreen,
            ),
            SizedBox(width: 8),
            Text(
              'Offer updated',
              style: TextStyle(
                color: FiatColors.fiatGreen,
                fontSize: SizeConfig.resizeFont(10),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        if (widget.tradingProvider.advertisement != null)
          Row(
            children: [
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  '${widget.chatMessage.content?.split(',').first}',
                  style: TextStyle(
                      color: FiatColors.darkBlue,
                      fontSize: SizeConfig.resizeFont(10)),
                ),
              ),
              Text('>',
                  style: TextStyle(
                    color: FiatColors.fiatGreen,
                    fontSize: SizeConfig.resizeFont(14),
                  )),
              Flexible(
                child: Text(
                  '1 ${widget.tradingProvider.advertisement?.sellingCurrency} = ${widget.chatMessage.rate} ${widget.tradingProvider.advertisement?.buyingCurrency} ',
                  style: TextStyle(
                      color: FiatColors.darkBlue,
                      fontSize: SizeConfig.resizeFont(10)),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Row offerButton() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: Container(),
        ),
//        Container(
//            child: TextButton(
//          onPressed: () {},
//          child: Text(
//            'Reject',
//            textAlign: TextAlign.start,
//            style: TextStyle(
//                color: Colors.blue, fontSize: SizeConfig.resizeFont(9)),
//          ),
//        )),
//        SizedBox(
//          width: SizeConfig.resizeWidth(5),
//        ),
        Consumer<TradingProvider>(builder: (context, response, child) {
          if (response.tradeInfo.status == Status.COMPLETED) {
            response.tradeInfo.status = Status.INITIAL;

//            goToNewScreen(Transaction(
//              ads: widget.tradingProvider.advertisement!,
//              proposedRate: widget.tradingProvider.agreedRate.toString(),
//              amountIHave: widget.tradingProvider.currencyCount.toString(),
//            ));
            return acceptOfferButton();
          } else if (response.tradeInfo.status == Status.ERROR) {
            response.tradeInfo.status = Status.INITIAL;
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              _showToast(response.tradeInfo.message, Icons.error);
            });
            return acceptOfferButton();
          } else if (response.tradeInfo.status == Status.LOADING) {
            return Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(11),
                  child: SizedBox(
                      width: SizeConfig.resizeWidth(5),
                      height: SizeConfig.resizeHeight(5),
                      child: CircularProgressIndicator()),
                ));
          } else {
            return acceptOfferButton();
          }
        }),
      ],
    );
  }

  Container acceptOfferButton() {
    return Container(
        child: TextButton(
      onPressed: () {
        print("_channel");
      },
      child: Text(
        'Accept',
        textAlign: TextAlign.end,
        style:
            TextStyle(color: Colors.blue, fontSize: SizeConfig.resizeFont(9)),
      ),
    ));
  }

  BorderRadius isBuyerBorder() {
    return BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
      bottomLeft: Radius.circular(8),
    );
  }

  BorderRadius isSellerBorder() {
    return BorderRadius.only(
      topLeft: Radius.circular(8),
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    );
  }

  _showToast(String? msg, IconData icon) {
    _fToast.showToast(
      child: FmToast(
        message: msg,
        icon: icon,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  goToNewScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
