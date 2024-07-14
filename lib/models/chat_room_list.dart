import 'package:fiat_match/models/chat_messages.dart';

class ChatRooms {
  String? message;
  List<RoomData>? roomIds;

  ChatRooms({this.message, this.roomIds});

  ChatRooms.fromJson(Map<String, dynamic> json) {
    if (json['roomId'] != null) {
      roomIds = [];
      json['roomId'].forEach((v) {
        roomIds!.add(RoomData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['roomId'] = this.roomIds;
    return data;
  }
}

class RoomData {
  ChatRoom? chatRoom;
  ChatMessage? latestMesage;

  RoomData({this.chatRoom, this.latestMesage});

  RoomData.fromJson(Map<String, dynamic> json) {
    chatRoom = ChatRoom.fromJson(json['chatroom']);
    if (json['latestMessage'] != null) {
      latestMesage = ChatMessage.fromJson(json['latestMessage']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['chatRoom'] = this.chatRoom;
    data['latestMessage'] = this.latestMesage;
    return data;
  }
}

class ChatRoom {
  String? id;
  List<String>? participants;
  String? latestTrade;
  String? createdAt;
  String? updatedAt;

  ChatRoom(
      {this.id,
      this.participants,
      this.createdAt,
      this.latestTrade,
      this.updatedAt});

  ChatRoom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = json['participants'].cast<String>();
    createdAt = json['createdAt'];
    latestTrade = json['latestTrade'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['participants'] = this.participants;
    data['createdAt'] = this.createdAt;
    data['latestTrade'] = this.latestTrade;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
