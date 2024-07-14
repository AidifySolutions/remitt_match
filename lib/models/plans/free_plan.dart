import 'package:fiat_match/models/customer.dart';

class FreePlan {
  String? message;
  CustomerData? customerData;

  FreePlan({this.message, this.customerData});

  FreePlan.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    customerData = json['customerData'] != null
        ? new CustomerData.fromJson(json['customerData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;

    if (this.customerData != null) {
      data['customerData'] = this.customerData!.toJson();
    }
    return data;
  }
}
