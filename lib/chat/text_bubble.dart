import 'package:fiat_match/chat/trading_provider.dart';
import 'package:fiat_match/models/chat_messages.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TextBubble extends StatelessWidget {
  final ChatMessage chatMessage;
  final TradingProvider tradingProvider;

  TextBubble({required this.chatMessage, required this.tradingProvider});

  @override
  Widget build(BuildContext context) {
    bool myContent = chatMessage.sender ==
        Provider.of<LoginProvider>(context, listen: false)
            .authentication
            .data!
            .customerData!
            .id;

    return chatMessage.content!.toString() == ''
        ? SizedBox()
        : Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment:
                  myContent ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.80),
                padding:
                    EdgeInsets.only(left: 13, right: 13, top: 13, bottom: 3),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                decoration: BoxDecoration(
                  color:chatMessage.type == Helper.getEnumValue(MessageType.OfferAccepted.toString()) ? FiatColors.fiatGreen : myContent ? FiatColors.white : FiatColors.darkBlue,
                  borderRadius: myContent
                      ? BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        )
                      : BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      chatMessage.content.toString(),
                      style: TextStyle(
                          letterSpacing: 0.4,
                          color: myContent
                              ? FiatColors.fiatBlack
                              : FiatColors.white),
                    ),
                    SizedBox(
                      height: SizeConfig.resizeHeight(1),
                    ),
                    Text(
                      getDateTime(),
                      style: TextStyle(
                        color:chatMessage.type == Helper.getEnumValue(MessageType.OfferAccepted.toString()) ? Colors.black45 :FiatColors.fiatGrey,
                        fontSize: SizeConfig.resizeFont(7),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  String getDateTime() {
    String? dateTime;
    var parseDate = DateTime.parse(chatMessage.time!);
    var formattedTime = parseDate.toLocal();

    if (DateTime.now().difference(formattedTime).inDays == 0) {
      dateTime = DateFormat('hh:mm aa').format(formattedTime);
    } else {
      dateTime = DateFormat('yyyy MMM dd hh:mm aa').format(formattedTime);
    }
    return dateTime;
  }
}
