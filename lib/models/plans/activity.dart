class ActivityRequest {
  String? actionCode;
  String? tradeId;
  String? actorId;
  String? customerId;
  String? comments;

  ActivityRequest(
      {this.actionCode,
      this.actorId,
      this.customerId,
      this.tradeId,
      this.comments});

  ActivityRequest.fromJson(Map<String, dynamic> json) {
    actionCode = json['actionCode'];
    tradeId = json['tradeId'];
    actorId = json['actorId'];
    customerId = json['customerId'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['actionCode'] = this.actionCode;
    data['tradeId'] = this.tradeId;
    data['actorId'] = this.actorId;
    data['customerId'] = this.customerId;
    data['comments'] = this.comments;
    return data;
  }
}

class ActivityResponse {
  String? message;
  Activity? activity;

  ActivityResponse({
    this.message,
    this.activity,
  });

  ActivityResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    activity = Activity.fromJson(json['activity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['activity'] = this.activity;
    return data;
  }
}

class Activity {
  String? id;
  String? actionCode;
  String? tradeId;

  String? createdAt;
  String? actorId;
  String? customerId;

  String? comments;

  Activity(
      {this.id,
      this.actionCode,
      this.tradeId,
      this.customerId,
      this.createdAt,
      this.actorId,
      this.comments});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    actionCode = json['actionCode'];
    tradeId = json['tradeId'];

    createdAt = json['createdAt'];
    actorId = json['actorId'];
    customerId = json['customerId'];

    comments = json['comments'];
  }
}

class TradePaymentStatusResp {
  String? message;
  bool? status;

  TradePaymentStatusResp({
    this.message,
    this.status,
  });

  TradePaymentStatusResp.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}
