import 'customer.dart';

class Authentication {
  String? message;
  Token? token;
  CustomerData? customerData;

  Authentication({this.message, this.token, this.customerData});

  Authentication.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['token'] != null ? new Token.fromJson(json['token']) : null;
    customerData = json['customerData'] != null
        ? new CustomerData.fromJson(json['customerData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.token != null) {
      data['token'] = this.token!.toJson();
    }
    if (this.customerData != null) {
      data['customerData'] = this.customerData!.toJson();
    }
    return data;
  }
}

class Token {
  String? accessToken;
  String? expiresIn;
  String? refreshToken;

  Token({this.accessToken, this.expiresIn, this.refreshToken});

  Token.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    data['refresh_token'] = this.refreshToken;
    return data;
  }
}
