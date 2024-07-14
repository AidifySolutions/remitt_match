import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:fiat_match/chat/chat_provider.dart';
import 'package:fiat_match/chat/negotiate.dart';
import 'package:fiat_match/chat/offer_bubble.dart';
import 'package:fiat_match/chat/seller_info.dart';
import 'package:fiat_match/chat/send_message_area.dart';
import 'package:fiat_match/chat/text_bubble.dart';
import 'package:fiat_match/chat/trading_provider.dart';
import 'package:fiat_match/models/chat_messages.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/customer_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/provider/new/mid_market_rate_provider.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:fiat_match/utils/loader.dart';
import 'package:fiat_match/utils/size_config.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/views/home/landing_new.dart';
import 'package:fiat_match/views/send_money/send_money.dart';
import 'package:fiat_match/views/transaction_history/transaction_history.dart';
import 'package:fiat_match/widgets/fm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  late MidMarketRateProvider _midMarketRateProvider;
  late TradingProvider _tradingProvider;
  late ChatProvider _chatProvider;
  late CustomerProvider _customerProvider;
  Customer? buyer;
  Customer? seller;
  var _client;
  var _streamResponse;
  bool isSeller = false;
  bool isLoading = false;
 bool isScrolled = false;
  late ScrollController _scrollController;
  Timer? timer;
  DateTime? _tradeCreationDate ;
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();

    _midMarketRateProvider =
        Provider.of<MidMarketRateProvider>(context, listen: false);
    _tradingProvider = Provider.of<TradingProvider>(context, listen: false);
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _chatProvider.clearMessages();
      streamMessages();
      timer = Timer.periodic(Duration(seconds: 5), (Timer t) => sendStayAliveMsg());
      getBuyerSellerInfo();
      _midMarketRateProvider.getMidMarketRate(
          _tradingProvider.advertisement?.sellingCurrency ?? '',
          _tradingProvider.advertisement?.buyingCurrency ?? '');
      _tradingProvider.setNegotiatedRate(
          _tradingProvider.tradeInfo.data!.trade!.agreedRate.toString(),
          _tradingProvider.tradeInfo.data!.trade!.currencyCount.toString());
    });

    isSeller = _tradingProvider.tradeInfo.data!.trade!.seller!.sellerId ==
        Provider.of<LoginProvider>(context, listen: false)
            .authentication
            .data!
            .customerData!
            .id;
    try {
      _tradeCreationDate = DateTime.parse(
          _tradingProvider.tradeInfo.data?.trade?.creationDateTime ?? '');
    }catch(e){
      print(e);
    }
    _tradingProvider.tradeInfo.status = Status.INITIAL;
    _tradingProvider.resetNegotiation();

  }

  getBuyerSellerInfo() async {
    try {
      isLoading = true;
      buyer = await _customerProvider.getAnyCustomerByID(
          _tradingProvider.tradeInfo.data!.trade!.buyer!.buyerId!);
      seller = await _customerProvider.getAnyCustomerByID(
          _tradingProvider.tradeInfo.data!.trade!.seller!.sellerId!);

      print(buyer);
    } catch (exp) {
      print(exp);
    } finally {
      isLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loader()
        : GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              appBar: _appBar(),
              body: Container(
                color: FiatColors.fiatBackgorund,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<TradingProvider>(
                        builder: (context, response, child) {
                      return SellerInfo(
                        tradingProvider: _tradingProvider,
                        chatProvider: _chatProvider,
                        isSeller: isSeller,
                      );
                    }),
                    Consumer<ChatProvider>(builder: (context, response, child) {

                        WidgetsBinding.instance!
                            .addPostFrameCallback((_) => _scrollToBottom());

                      return Expanded(
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: response.chatMessages.length,
                              itemBuilder: (BuildContext context, int position) {
                                ChatMessage message =
                                    response.chatMessages[position];
                                DateTime chatTime = DateTime.parse(message.time ?? '');
                                if (response.chatMessages[position].type ==
                                    Helper.getEnumValue(
                                        MessageType.Offer.toString())) {
                                  if (message.rate != null && chatTime.isAfter(_tradeCreationDate!)) {
                                    // _tradingProvider.setNegotiatedRate(
                                    //     message.rate.toString(),
                                    //     message.count.toString());
                                    _tradingProvider.setTradeStatus(
                                        message.status.toString());
                                    if (_tradingProvider.tradeInfo.data != null)
                                      _tradingProvider.setTradeId(_tradingProvider
                                          .tradeInfo.data!.trade!.id!);
                                  }
                                  return OfferBubble(
                                    tradingProvider: _tradingProvider,
                                    chatMessage: response.chatMessages[position],
                                    chatProvider: _chatProvider,
                                  );
                                } else {
                                  // if (message.status ==
                                  //         Helper.getEnumValue(TradeStatus
                                  //             .AwaitingSettlement.toString()) &&
                                  //     DateTime.now()
                                  //             .toUtc()
                                  //             .difference(DateTime.parse(
                                  //                 message.time.toString()))
                                  //             .inSeconds <=
                                  //         5) {
                                  //   WidgetsBinding.instance!
                                  //       .addPostFrameCallback((_) {
                                  //     goToNewScreen(Transaction(
                                  //         // tradingProvider: _tradingProvider,
                                  //         ));
                                  //   });
                                  // }
                                  if(message.type == Helper.getEnumValue(MessageType.OfferAccepted.toString()) && chatTime.isAfter(_tradeCreationDate!)){
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) {
                                      unsubscribe();
                                      _chatProvider.clearMessages();
                                      _showSnackBar("Offer accepted successfully");
                                      Navigator.of(context)
                                          .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (buildContext) =>
                                                LandingNewPage(
                                                  tabSelection: 3,
                                                ),
                                          ), (Route<dynamic> route) => false);
                                    });
                                  } else if(message.type == Helper.getEnumValue(MessageType.OfferRejected.toString()) && chatTime.isAfter(_tradeCreationDate!)){
                                    WidgetsBinding.instance!
                                        .addPostFrameCallback((_) {
                                       unsubscribe();
                                      _chatProvider.clearMessages();
                                     _showErrorDialog('Transaction failed', 'Your transaction was not completed','Close', Icons.cancel);

                                    });
                                  }
                                  return response.chatMessages[position].content
                                              .toString() ==
                                          ''
                                      ? SizedBox()
                                      : TextBubble(
                                          chatMessage:
                                              response.chatMessages[position],
                                          tradingProvider: _tradingProvider,
                                        );
                                }
                              }),
                        ),
                      );
                    }),
                    Consumer<ChatProvider>(builder: (context,response,child){
                     return SendMessageArea();
                    })

                  ],
                ),
              ),
            ),
        );
  }

  _scrollToBottom() async {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if (_chatProvider.chatMessages.isNotEmpty &&
          _chatProvider.chatMessages.last.rate != null &&
          _chatProvider.chatMessages.last.rate !=
              _tradingProvider.tradeInfo.data!.trade!.agreedRate) {
        await _tradingProvider.getTradeById(_tradingProvider.tradeId!);
       // _chatProvider.isScrolled = true;
      }
    });
  }

  AppBar _appBar() {
    return AppBar(
      leadingWidth: SizeConfig.resizeWidth(7),
      toolbarHeight: SizeConfig.resizeHeight(14),
      leading: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: IconButton(
          icon: Icon(
            Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (buyer != null && seller != null)
                  Text(isSeller
                      ? buyer!.customerData!.nickName!
                      : seller!.customerData!.nickName!),
              ],
            ),
          ),
        ],
      ),
      actions: [
        CircleAvatar(
            backgroundColor: Colors.transparent,
            child: ClipOval(child: Image.network('${isSeller ? buyer?.customerData?.profilePhoto : seller?.customerData?.profilePhoto}', width: 35, height: 35, fit: BoxFit.cover, errorBuilder: (BuildContext context, Object o, StackTrace? s){
              return CircleAvatar(
                radius: 18,
                child: Icon(Icons.person, color: FiatColors.darkBlue,),
              );
            },),)
        ),
        SizedBox(
          width: 24,
        )
      ],
    );
  }

  Future<dynamic> streamMessages() async {
    _client = http.Client();
    final url =
        'https://services-backend.com/fiatmatch/messages?roomId=${_chatProvider.roomId}';
    var headers = {
      HttpHeaders.acceptHeader: 'text/event-stream',
      HttpHeaders.cacheControlHeader: 'no-cache',
      HttpHeaders.authorizationHeader: Helper.getToken(context).toString(),
    };

    final req = http.Request('GET', Uri.parse(url));
    req.headers.addAll(headers);

    final res = await _client.send(req);

    _streamResponse = res.stream
        .transform(new Utf8Decoder())
        .transform(new LineSplitter())
        .listen((value) {
      if (value.toString().isNotEmpty) {
        RegExp lineRegex = new RegExp(r"^([^:]*)(?::)?(?: )?(.*)?$");
        RegExpMatch? match = lineRegex.firstMatch(value.toString());
        String? value1 = match!.group(2) ?? "";

        ChatMessage chatMessage = ChatMessage.fromJson(jsonDecode(value1));
        _chatProvider.addMessage(chatMessage);
      }
    });
  }

  sendStayAliveMsg(){
    _chatProvider.sendMessage('', _chatProvider.roomId, MessageType.StayAlive, null, null, null);
  }

  unsubscribe() {
    if (_streamResponse != null) _streamResponse.cancel();
    if (_client != null) _client.close();
  }

  @override
  void dispose() {
    unsubscribe();
    timer?.cancel();
    super.dispose();
  }

  goToNewScreen(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
  _showSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  _showErrorDialog(String title,String message, String buttonText, IconData icon) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          return FmDialogWidget(
              iconData: icon,
              title: title,
              message: message,
              buttonText: buttonText,
              voidCallback: () async {
                //context.read<ForgotPasswordProvider>().reset();
                Navigator.pop(dialogContext);
                Navigator.of(context)
                    .pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (buildContext) =>
                          LandingNewPage(
                            tabSelection: 0,
                          ),
                    ), (Route<dynamic> route) => false);
              });
        });
  }
}
