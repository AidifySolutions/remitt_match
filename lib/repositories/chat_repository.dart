import 'dart:convert';

import 'package:fiat_match/models/chat_room_list.dart';
import 'package:fiat_match/models/room.dart';
import 'package:fiat_match/network_module/api_path.dart';
import 'package:fiat_match/network_module/http_client.dart';
import 'package:fiat_match/utils/constants.dart';
import 'package:fiat_match/utils/helper.dart';
import 'package:flutter/material.dart';

class ChatRepository {
  late final BuildContext _context;

  ChatRepository(BuildContext context) {
    _context = context;
  }

  Future<Room> getRoomId(String recipientId) async {
    Map<String, String> queryParam = Map<String, String>();
    queryParam.putIfAbsent("recipient", () => recipientId);

    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.GetRoomId), _context,
        params: queryParam, token: _token);

    print(response);
    Room room = Room.fromJson(response);
    return room;
  }

  Future<Room> sendMessages(String msg, String roomId, MessageType messageType,
      TradeStatus? tradeStatus, double? rate, double? count) async {
    var body = {
      "roomId": roomId,
      "content": msg,
      "type": Helper.getEnumValue(messageType.toString()),
      "status": tradeStatus != null
          ? Helper.getEnumValue(tradeStatus.toString())
          : null,
      "rate": rate ?? null,
      "count": count ?? null
    };
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.postData(
        ApiPathHelper.getValue(APIPath.SendMessage),
        json.encode(body),
        _context,
        token: _token);
    var a = Room.fromJson(response);
    return Room.fromJson(response);
  }

  //ChatRooms
  Future<ChatRooms> getRooms() async {
    String? _token = Helper.getToken(_context);
    final response = await HttpClient.instance.fetchData(
        ApiPathHelper.getValue(APIPath.Rooms), _context,
        token: _token);

    print(response);
    ChatRooms room = ChatRooms.fromJson(response);
    return room;
  }
}
