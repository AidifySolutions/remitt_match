import 'package:fiat_match/chat/chat_provider.dart';
import 'package:fiat_match/chat/trading_provider.dart';
import 'package:fiat_match/provider/recipient_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/widgets/fm_input_fields.dart';
import 'package:fiat_match/widgets/new/fm_submit_button.dart';
import 'package:flutter/material.dart';

class Negotiate extends StatefulWidget {
  final TradingProvider tradingProvider;
  final ChatProvider chatProvider;

  Negotiate({
    required this.tradingProvider,
    required this.chatProvider,
  });

  @override
  _NegotiateState createState() => _NegotiateState();
}

class _NegotiateState extends State<Negotiate> {
  late TextEditingController _proposedRateController;
  late TextEditingController _amountIHaveController;
  @override
  void initState() {
    super.initState();
    _proposedRateController = TextEditingController();
    _amountIHaveController = TextEditingController();
    _amountIHaveController.text = widget
        .tradingProvider.tradeInfo.data!.trade!.agreedRate!
        .toStringAsFixed(4);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Negotiate an amount',
            style: TextStyle(fontSize: SizeConfig.resizeFont(12)),
          ),
          SizedBox(
            height: SizeConfig.resizeHeight(5),
          ),
          Row(
            children: [
              Expanded(
                  child: Text(
                      '1 ${widget.tradingProvider.advertisement?.buyingCurrency}')),
              // Expanded(
              //   child: FmInputFields(
              //       title:
              //           'Rate (${widget.tradingProvider.advertisement?.buyingCurrency})',
              //       hint: '0.00',
              //       obscureText: false,
              //       textEditingController: _proposedRateController,
              //       textInputType: TextInputType.number,
              //       textInputAction: TextInputAction.done,
              //       onValidation: (value) {},
              //       autoFocus: true,
              //       maxLines: 1),
              // ),
              SizedBox(
                width: SizeConfig.resizeWidth(4),
              ),
              Expanded(
                child: FmInputFields(
                    title:
                        'Amount I have (${widget.tradingProvider.advertisement?.sellingCurrency})',
                    hint: '0.00',
                    obscureText: false,
                    textEditingController: _amountIHaveController,
                    textInputType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onValidation: (value) {},
                    autoFocus: true,
                    maxLines: 1),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.resizeWidth(4),
          ),
          FmSubmitButton(
              text: 'Send',
              onPressed: () async {
                if (_amountIHaveController.text.isEmpty) {
                  print("PLease enter amount");
                  return;
                }
                await widget.tradingProvider.setNegotiatedRate(
                  _amountIHaveController.text.toString(),
                  widget.tradingProvider.tradeInfo.data!.trade!.currencyCount
                      .toString(),
                );

                await widget.tradingProvider.setTradeStatus(Helper.getEnumValue(
                    TradeStatus.AwaitingConfirmation.toString()));
                await widget.tradingProvider
                    .updateTrade(widget.tradingProvider.tradeId.toString());
                await widget.chatProvider.sendMessage(
                    '1 ${widget.tradingProvider.advertisement?.sellingCurrency} = ${widget.tradingProvider.prevAgreedRate} ${widget.tradingProvider.advertisement?.buyingCurrency} ,1 ${widget.tradingProvider.advertisement?.sellingCurrency} = ${_amountIHaveController.text} ${widget.tradingProvider.advertisement?.buyingCurrency}',
                    //'1 CAD = 364.333 NGN ,1 CAD = 374.333 NGN',
                    widget.tradingProvider.tradeInfo.data!.roomId.toString(),
                    MessageType.Offer,
                    TradeStatus.AwaitingConfirmation,
                    double.parse(widget.tradingProvider.agreedRate!),
                    double.parse(widget.tradingProvider.currencyCount!));

                await widget.tradingProvider
                    .getTradeById(widget.tradingProvider.tradeId!);
                Navigator.pop(context, true);
              },
              showOutlinedButton: false),
        ],
      ),
    );
  }

  goToNewScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
