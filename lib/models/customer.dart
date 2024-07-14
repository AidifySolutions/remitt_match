class Customer {
  String? message;
  CustomerData? customerData;

  Customer({this.message, this.customerData});

  Customer.fromJson(Map<String, dynamic> json) {
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

class OffersSellers {
  List<CustomerData>? sellerData;

  OffersSellers({this.sellerData});

  OffersSellers.fromJson(Map<String, dynamic> json) {
    sellerData = json['items'] != null
        ? json['items']
            .map((v) => CustomerData.fromJson(v))
            .cast<CustomerData>()
            .toList()
        : null;
  }
}

class CustomerData {
  String? id;
  String? title;
  String? firstName;
  String? lastName;
  String? bio;
  String? nickName;
  String? dateOfBirth;
  PhoneNumber? phoneNumber;
  String? email;
  String? address1;
  String? address2;
  String? city;
  String? province;
  String? country;
  bool isEmailVerified = false;
  bool isPhoneVerified = false;
  LivenessStatus? livenessStatus;
  ProfileStatus? profileStatus;
  double? score;
  Threshold? threshold;
  String? timer;
  int? noOfTransactions;
  double? rating;
  String? profilePhoto;
  String? occupation;
  String? employment;
  String? incomeSource;
  String? firstTransaction;
  String? stripeId;

  CustomerData(
      {this.id,
      this.title,
      this.firstName,
      this.lastName,
      this.bio,
      this.nickName,
      this.dateOfBirth,
      this.phoneNumber,
      this.email,
      this.address1,
      this.address2,
      this.city,
      this.province,
      this.country,
      this.isEmailVerified = false,
      this.isPhoneVerified = false,
      this.livenessStatus,
      this.profileStatus,
      this.score,
      this.threshold,
      this.timer,
      this.noOfTransactions,
      this.rating,
      this.profilePhoto,
      this.occupation,
      this.employment,
      this.incomeSource,
      this.firstTransaction,
      this.stripeId});

  CustomerData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    bio = json['bio'];
    nickName = json['nickName'];
    dateOfBirth = json['dateOfBirth'];
    phoneNumber = json['phoneNumber'] != null
        ? new PhoneNumber.fromJson(json['phoneNumber'])
        : null;
    email = json['email'];
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    province = json['province'];
    country = json['country'];
    isEmailVerified = json['isEmailVerified'];
    isPhoneVerified = json['isPhoneVerified'];
    livenessStatus = json['livenessStatus'] != null
        ? new LivenessStatus.fromJson(json['livenessStatus'])
        : null;
    profileStatus = json['profileStatus'] != null
        ? new ProfileStatus.fromJson(json['profileStatus'])
        : null;
    score = json['score'];
    threshold = json['threshold'] != null
        ? new Threshold.fromJson(json['threshold'])
        : null;
    timer = json['timer'];
    noOfTransactions = json['noOfTransactions'];
    rating = json['rating'];
    profilePhoto = json['profilePhoto'];
    occupation = json['occupation'];
    employment = json['employment'];
    firstTransaction = json['firstTransaction'];
    incomeSource = json['incomeSource'];
    stripeId = json['stripeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['bio'] = this.bio;
    data['nickName'] = this.nickName;
    data['dateOfBirth'] = this.dateOfBirth;
    if (this.phoneNumber != null) {
      data['phoneNumber'] = this.phoneNumber!.toJson();
    }
    data['email'] = this.email;
    data['address1'] = this.address1;
    data['address2'] = this.address2;
    data['city'] = this.city;
    data['province'] = this.province;
    data['country'] = this.country;
    data['isEmailVerified'] = this.isEmailVerified;
    data['isPhoneVerified'] = this.isPhoneVerified;
    if (this.livenessStatus != null) {
      data['livenessStatus'] = this.livenessStatus!.toJson();
    }
    data['profileStatus'] = this.profileStatus;
    data['score'] = this.score;
    data['threshold'] = this.threshold;
    data['timer'] = this.timer;
    data['noOfTransactions'] = this.noOfTransactions;
    data['rating'] = this.rating;
    data['profilePhoto'] = this.profilePhoto;
    data['occupation'] = this.occupation;
    data['employment'] = this.employment;
    data['incomeSource'] = this.incomeSource;
    data['firstTransaction'] = this.firstTransaction;
    data['stripeId'] = this.stripeId;
    return data;
  }
}

class PhoneNumber {
  String? countryCode;
  String? dialCode;
  String? number;

  PhoneNumber({this.countryCode, this.dialCode, this.number});

  PhoneNumber.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    dialCode = json['dialCode'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['dialCode'] = this.dialCode;
    data['number'] = this.number;
    return data;
  }
}

class LivenessStatus {
  String? status;
  String? comments;
  String? updatedAt;

  LivenessStatus({this.status, this.comments, this.updatedAt});

  LivenessStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    comments = json['comments'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['comments'] = this.comments;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class ProfileStatus {
  late String status;
  late String comments;
  late String updatedAt;

  ProfileStatus(
      {required this.status, required this.comments, required this.updatedAt});

  ProfileStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'] as String? ?? "";
    comments = json['comments'] as String? ?? "";
    updatedAt = json['updatedAt'] as String? ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['comments'] = this.comments;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Threshold {
  double? e3;
  double? e4;
  double? e5;

  Threshold({this.e3, this.e4, this.e5});

  Threshold.fromJson(Map<String, dynamic> json) {
    e3 = json['1e-3'];
    e4 = json['1e-4'];
    e5 = json['1e-5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1e-3'] = this.e3;
    data['1e-4'] = this.e4;
    data['1e-5'] = this.e5;
    return data;
  }
}
