class DepositInfoResponse {
  String? message;
  DepositInformation? depositInformation;

  DepositInfoResponse({this.message, this.depositInformation});

  DepositInfoResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    depositInformation = json['depositInformation'] != null
        ? new DepositInformation.fromJson(json['depositInformation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.depositInformation != null) {
      data['depositInformation'] = this.depositInformation!.toJson();
    }
    return data;
  }
}

class DepositInformation {
  String? country;
  String? currency;
  String? accountNumber;
  String? bankName;
  String? accountTitle;

  DepositInformation(
      {this.country,
        this.currency,
        this.accountNumber,
        this.bankName,
        this.accountTitle});

  DepositInformation.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    currency = json['currency'];
    accountNumber = json['accountNumber'];
    bankName = json['bankName'];
    accountTitle = json['accountTitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['currency'] = this.currency;
    data['accountNumber'] = this.accountNumber;
    data['bankName'] = this.bankName;
    data['accountTitle'] = this.accountTitle;
    return data;
  }
}
