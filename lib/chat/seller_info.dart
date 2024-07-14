import 'package:fiat_match/chat/chat_provider.dart';
import 'package:fiat_match/chat/negotiate.dart';
import 'package:fiat_match/chat/trading_provider.dart';
import 'package:fiat_match/models/trade_info.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/trade_payment_provider%20copy.dart';
import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/widgets/fm_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SellerInfo extends StatefulWidget with ChangeNotifier {
  final TradingProvider tradingProvider;
  final ChatProvider chatProvider;
  final bool isSeller;
  SellerInfo(
      {required this.tradingProvider,
      required this.chatProvider,
      required this.isSeller});

  @override
  _SellerInfoState createState() => _SellerInfoState();
}

class _SellerInfoState extends State<SellerInfo> {
  late FToast _fToast;
  late UserOffersProvider _userOffersProvider;

  @override
  void initState() {
    super.initState();
    _fToast = FToast();
    _fToast.init(context);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _userOffersProvider =
          Provider.of<UserOffersProvider>(context, listen: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(13),
      color: FiatColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  '1 ${widget.tradingProvider.advertisement?.sellingCurrency.toString()}',
                  style: TextStyle(
                      color: FiatColors.darkBlue,
                      fontSize: SizeConfig.resizeFont(10),
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  width: SizeConfig.resizeWidth(2),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: FiatColors.darkBlue,
                  size: SizeConfig.resizeWidth(5),
                ),
                SizedBox(
                  width: SizeConfig.resizeWidth(2),
                ),
                !widget.tradingProvider.isLoading &&
                        widget.tradingProvider.tradeInfo.data != null
                    ? Text(
                        '${widget.tradingProvider.tradeInfo.data!.trade!.agreedRate!.toStringAsFixed(5)} ${widget.tradingProvider.advertisement?.buyingCurrency}',
                        style: TextStyle(
                            color: FiatColors.darkBlue,
                            fontSize: SizeConfig.resizeFont(10),
                            fontWeight: FontWeight.w600),
                      )
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: Text('...'),
                      ),
                SizedBox(
                  width: SizeConfig.resizeWidth(2),
                ),
                Spacer(),
                // if (widget.tradingProvider.tradeInfo.data!.trade!.status ==
                //     TradeStatus.AwaitingConfirmation) ...[
                if (!widget.isSeller) ...[
                  Consumer<TradingProvider>(
                      builder: (context, response, child) {
                    if (response.tradeInfo.status == Status.COMPLETED) {
                      response.tradeInfo.status = Status.INITIAL;
                      // WidgetsBinding.instance!.addPostFrameCallback((_) {
                      //   widget.chatProvider.sendMessage(
                      //       'OFFER ACCEPTED',
                      //       response.tradeInfo.data!.roomId.toString(),
                      //       MessageType.Content,
                      //       TradeStatus.AwaitingPayment,
                      //       double.parse(widget.tradingProvider.agreedRate!),
                      //       double.parse(
                      //           widget.tradingProvider.currencyCount!));
                      // });
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
                ] else if (widget.isSeller) ...[
                  InkWell(
                    onTap: () async {
                      if(widget.tradingProvider.tradeInfo.data != null) {
                        bool pop = await _showDialog();
                        if (pop) {
                          setState(() {});
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      child: Center(
                        child: Icon(Icons.edit, color: FiatColors.fiatGreen),
                      ),
                    ),
                  )
                ]
              ],
              // ],
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text(
                'Offer is valid till ${new DateFormat.yMMMd().format(DateTime.parse(widget.tradingProvider.advertisement!.expiry.toString()))}',
                style: TextStyle(
                    fontSize: SizeConfig.resizeFont(8),
                    color: Theme.of(context).accentColor),
              ),
              Spacer(),
              SizedBox(
                  height: 30,
                  width: 100,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.white)))),
                    onPressed: () async {
                      try {
                        await widget.tradingProvider.setTradeStatus(
                            Helper.getEnumValue(
                                TradeStatus.Cancelled.toString()));

                        await widget.tradingProvider.updateTrade(
                            widget.tradingProvider.tradeId.toString(),
                            sendId: true);
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          widget.chatProvider.sendMessage(
                              'OFFER DISCARD',
                              widget.tradingProvider.tradeInfo.data!.roomId.toString(),
                              MessageType.OfferRejected,
                              null,
                              null,
                              null);
                        });
                      } catch (exp) {
                        _showToast('Some thing went wrong!', Icons.error);
                      } finally {}
                    },
                    child: Text(
                      'Discard',
                      style: TextStyle(
                        color: FiatColors.white,
                        fontSize: SizeConfig.resizeFont(8),
                      ),
                    ),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget _midMarketRate(String rate) {
    return Text(
      rate,
      style: TextStyle(
          fontSize: SizeConfig.resizeFont(13), fontWeight: FontWeight.w600),
    );
  }

  Widget acceptOfferButton() {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF2FBF71)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white)))),
      onPressed: () async {
        try {
          widget.tradingProvider.setTradeStatus(
              Helper.getEnumValue(TradeStatus.AwaitingPayment.toString()));
          // widget.tradingProvider.setNegotiatedRate(
          //     widget.tradingProvider.prposedRate.toString(),
          //     widget.tradingProvider.currencyCount.toString());
          if (widget.tradingProvider.agreedRate == null ||
              widget.tradingProvider.currencyCount == null) {
            _showToast('Please enter rate or count.', Icons.error);
            return;
          }
          await widget.tradingProvider.updateTrade(
              widget.tradingProvider.tradeId.toString(),
              sendId: true);
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            widget.chatProvider.sendMessage(
                'OFFER ACCEPTED',
                widget.tradingProvider.tradeInfo.data!.roomId.toString(),
                MessageType.OfferAccepted,
                TradeStatus.AwaitingPayment,
                double.parse(widget.tradingProvider.agreedRate!),
                double.parse(widget.tradingProvider.currencyCount!));
          });
        } catch (exp) {
          _showToast('Some thing went wrong!', Icons.error);
        }
      },
      child: Text(
        'Accept Offer',
        style: TextStyle(
          color: FiatColors.white,
          fontSize: SizeConfig.resizeFont(8),
        ),
      ),
    );
  }

  Future<bool> _showDialog() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 40,
            child: Negotiate(
              tradingProvider: widget.tradingProvider,
              chatProvider: widget.chatProvider,
            ),
          );
        });
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
}
