import 'package:fiat_match/models/chat_messages.dart';
import 'package:fiat_match/models/chat_room_list.dart';
import 'package:fiat_match/network_module/api_response.dart';
import 'package:fiat_match/repositories/chat_repository.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  late ChatRepository _chatRepository;
  late ApiResponse _messageSent;
  late List<ChatMessage> _chatMessages;
  late String _roomId;
  late ApiResponse<ChatRooms> _getChatRooms;

  List<ChatMessage> get chatMessages => _chatMessages;

  ApiResponse get messageSent => _messageSent;

  ApiResponse<ChatRooms> get getChatRoom => _getChatRooms;

  String get roomId => _roomId;

  bool isScrolled = false;

  ChatProvider(BuildContext context) {
    _chatRepository = ChatRepository(context);
    _messageSent = ApiResponse.initial('Not Initialized');
    _getChatRooms = ApiResponse.initial('Not Initialized');
    _chatMessages = [];
  }

  setRoomId(String value) {
    _roomId = value;
  }

  sendMessage(String msg, String roomId, MessageType messageType,
      TradeStatus? tradeStatus, double? rate, double? count) async {
    _messageSent = ApiResponse.loading('Fetching Data');
    if(messageType != MessageType.StayAlive) {
      notifyListeners();
    }
    try {
      await _chatRepository.sendMessages(
          msg, roomId, messageType, tradeStatus, rate, count);
      _messageSent = ApiResponse.completed(true);
      if(messageType != MessageType.StayAlive) {
        notifyListeners();
      }
    } catch (e) {
      _messageSent = ApiResponse.error(e.toString());
      if(messageType != MessageType.StayAlive) {
        notifyListeners();
      }
    }
  }

  getChatRooms() async {
    _getChatRooms = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      ChatRooms resp = await _chatRepository.getRooms();
      var filterresp =
          resp.roomIds!.where((e) => e.chatRoom!.latestTrade != null).toList();
      _getChatRooms = ApiResponse.completed(
          ChatRooms(roomIds: filterresp, message: resp.message));

      notifyListeners();
    } catch (e) {
      _messageSent = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  getChatRoomsMessages() async {
    _getChatRooms = ApiResponse.loading('Fetching Data');
    notifyListeners();
    try {
      var resp = await _chatRepository.getRooms();
      _getChatRooms = ApiResponse.completed(resp);
      notifyListeners();
    } catch (e) {
      _messageSent = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  addMessage(ChatMessage chatMessage) {
    _chatMessages.add(chatMessage);
    notifyListeners();
  }

  clearMessages() {
    _chatMessages = [];
  }

}
