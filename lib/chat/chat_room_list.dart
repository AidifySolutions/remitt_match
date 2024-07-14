import 'package:fiat_match/chat/chat.dart';
import 'package:fiat_match/chat/chat_provider.dart';
import 'package:fiat_match/chat/offer_bubble.dart';
import 'package:fiat_match/chat/trading_provider.dart';
import 'package:fiat_match/models/chat_room_list.dart';
import 'package:fiat_match/models/customer.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/provider/new/customer_provider.dart';
import 'package:fiat_match/provider/new/login_provider.dart';
import 'package:fiat_match/provider/new/user_offers_provider.dart';
import 'package:fiat_match/provider/recipient_provider.dart';
import 'package:fiat_match/utils/styles.dart';
import 'package:fiat_match/widgets/fm__home_screen_loader.dart';
import 'package:fiat_match/widgets/fm_toast.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../utils/size_config.dart';

class ChatRoomList extends StatefulWidget {
  ChatRoomList({Key? key}) : super(key: key);

  @override
  _ChatRoomListState createState() => _ChatRoomListState();
}

class _ChatRoomListState extends State<ChatRoomList> {
  late ChatProvider _chatProvider;
  late TradingProvider _tradingProvider;
  late RecipientProvider _recipientProvider;
  late UserOffersProvider _userOffersProvider;
  late CustomerProvider _customerProvider;
  bool _isLoading = false;
  String? user_id = '';
  late FToast _fToast;

  _getInitialDataForChat(tradeId) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _tradingProvider.getTradeById(tradeId);
      if (_tradingProvider.tradeInfo.data != null) {
        var adId = _tradingProvider.tradeInfo.data?.trade?.adId;
        await _userOffersProvider.getAdvertismentById(adId);
        await _tradingProvider.setAdvertisement(_userOffersProvider.ad.data!);
        if (_tradingProvider.tradeInfo.data != null) {
          var sellerId =
              _tradingProvider.tradeInfo.data!.trade!.seller!.sellerId;
          var beneId = '';
          var channelId = '';
          if (sellerId == user_id) {
            beneId =
                _tradingProvider.tradeInfo.data!.trade!.seller!.beneficiaryId!;
            channelId =
                _tradingProvider.tradeInfo.data!.trade!.seller!.channelId!;
          } else {
            beneId =
                _tradingProvider.tradeInfo.data!.trade!.buyer!.beneficiaryId!;
            channelId =
                _tradingProvider.tradeInfo.data!.trade!.buyer!.channelId!;
          }
          await _recipientProvider.getRecipientById(beneId);
          await _recipientProvider.getReceiptchannel(
              beneficiaryId: beneId, channelId: channelId);
          if (_recipientProvider.recipient.data != null &&
              _recipientProvider.beneChannel.data != null)
            _tradingProvider.setSelectedRecipient(
                _recipientProvider.recipient.data!.beneficiary!,
                _recipientProvider.beneChannel.data!.channel!);
          if (_tradingProvider.tradeInfo.data!.trade!.status!.status !=
              'AwaitingConfirmation') {
            _showToast(
                msg: 'Chat for this transaction has ended.', icon: Icons.error);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Chat(),
              ),
            );
          }
        }
      } else {
        _showToast(msg: 'Some thing went wrong!', icon: Icons.error);
      }
    } catch (exp) {
      _showToast(msg: 'Some thing went wrong!', icon: Icons.error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _tradingProvider = Provider.of<TradingProvider>(context, listen: false);
    _recipientProvider = Provider.of<RecipientProvider>(context, listen: false);
    _userOffersProvider =
        Provider.of<UserOffersProvider>(context, listen: false);
    _customerProvider = Provider.of<CustomerProvider>(context, listen: false);
    user_id = Provider.of<LoginProvider>(context, listen: false)
        .authentication
        .data!
        .customerData!
        .id;

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _chatProvider.getChatRooms();
    });
    _fToast = FToast();
    _fToast.init(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _customerProvider.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, response, child) {
          if (response.getChatRoom.status == Status.COMPLETED) {
            return _chatRoomList(response.getChatRoom.data!.roomIds);
          } else if (response.getChatRoom.status == Status.ERROR) {
            WidgetsBinding.instance!.addPostFrameCallback((_) {
              print("error");
            });
            return Container();
          } else if (response.getChatRoom.status == Status.LOADING) {
            return FmHomeScreenLoader();
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _chatRoomList(List<RoomData>? data) {
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.separated(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: data!.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              var item = data[index];
              var lastMsg = data[index].latestMesage;
              var sendTo =
                  item.chatRoom?.participants!.firstWhere((e) => e != user_id);

              var isSender =
                  lastMsg == null ? false : lastMsg.sender == user_id;

              return FutureBuilder<Customer>(
                  future: _customerProvider.getChatCustomer(sendTo!),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) return Text('error');

                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text('Loading');

                      case ConnectionState.done:
                        return InkWell(
                            onTap: lastMsg == null
                                ? () {
                                    _showToast(
                                        msg: 'Chat for this user ended.',
                                        icon: Icons.error);
                                  }
                                : () {
                                    _chatProvider.setRoomId(item.chatRoom!.id!);

                                    _getInitialDataForChat(
                                        item.chatRoom?.latestTrade);
                                  },
                            child: ListTile(
                                leading: snapshot.data == null
                                    ? SizedBox()
                                    : SizedBox(
                                        height: 32,
                                        width: 32,
                                        child: snapshot.data != null &&
                                                snapshot.data!.customerData !=
                                                    null &&
                                                snapshot.data!.customerData!
                                                        .profilePhoto !=
                                                    null
                                            ? ClipOval(
                                                child: Image.network(snapshot
                                                    .data!
                                                    .customerData!
                                                    .profilePhoto!),
                                              )
                                            : CircleAvatar(
                                                radius: (52),
                                                backgroundColor: Colors.white,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.asset(
                                                      "assets/avatar.png"),
                                                )),
                                      ),
                                trailing: lastMsg == null
                                    ? Text(
                                        getDateTime(item.chatRoom!.updatedAt
                                            .toString()),
                                        style: TextStyle(
                                            fontSize: SizeConfig.resizeFont(8),
                                            fontWeight: FontWeight.w600),
                                      )
                                    : Text(
                                        getDateTime(lastMsg.time.toString()),
                                        style: TextStyle(
                                            fontSize: SizeConfig.resizeFont(8),
                                            fontWeight: FontWeight.w600),
                                      ),
                                title: isSender
                                    ? Text(
                                        "You send msg to ${snapshot.data!.customerData == null ? '' : snapshot.data!.customerData!.nickName} : ${lastMsg == null ? '' : lastMsg.content}")
                                    : Text(
                                        "${snapshot.data!.customerData?.nickName ?? ''} send message to you :${lastMsg == null ? '' : lastMsg.content}")));

                      default:
                        return Text('data');
                    }
                  });
            });
  }

  _showToast({String? msg, IconData? icon}) {
    _fToast.showToast(
      child: FmToast(
        message: msg,
        icon: icon!,
      ),
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

  String getDateTime(String time) {
    String? dateTime;
    var parseDate = DateTime.parse(time);
    var formattedTime = parseDate.toLocal();

    if (DateTime.now().difference(formattedTime).inDays == 0) {
      dateTime = DateFormat('hh:mm a').format(formattedTime);
    } else if (DateTime.now().difference(formattedTime).inDays > 1 &&
        DateTime.now().difference(formattedTime).inDays < 4) {
      dateTime =
          DateTime.now().difference(formattedTime).inDays.toString() + 'd ago';
    } else {
      dateTime = DateFormat('dd-MMM-yyyy').format(formattedTime);
    }
    return dateTime;
  }
}
