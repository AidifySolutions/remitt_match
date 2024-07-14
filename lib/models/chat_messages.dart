class ChatMessage {
  String? id;
  String? roomId;
  String? content;
  String? sender;
  String? type;
  String? status;
  double? rate;
  int? count;
  String? time;

  ChatMessage(
      {this.id,
      this.roomId,
      this.content,
      this.sender,
      this.type,
      this.status,
      this.rate,
      this.count,
      this.time});

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roomId = json['roomId'];
    content = json['content'];
    sender = json['sender'];
    type = json['type'];
    status = json['status'];
    rate = json['rate'];
    count = json['count'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['roomId'] = this.roomId;
    data['content'] = this.content;
    data['sender'] = this.sender;
    data['type'] = this.type;
    data['status'] = this.status;
    data['rate'] = this.rate;
    data['count'] = this.count;
    data['time'] = this.time;
    return data;
  }
}
