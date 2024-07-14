class Room {
  String? message;
  String? roomId;

  Room({this.message, this.roomId});

  Room.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    roomId = json['roomId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['roomId'] = this.roomId;
    return data;
  }
}
