class Country {
  String? id;
  String? name;
  String? code;
  String? dialCode;
  String? sampleNumber;
  int? length;
  String? currency;
  List<String>? channels;
  bool? forAddress;

  Country(
      {this.id,
      this.name,
      this.code,
      this.dialCode,
      this.sampleNumber,
      this.length,
      this.currency,
      this.channels,
      this.forAddress});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    dialCode = json['dialCode'];
    sampleNumber = json['sampleNumber'];
    length = json['length'];
    currency = json['currency'];
    channels = json['channels'].cast<String>();
    forAddress = json['forAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['dialCode'] = this.dialCode;
    data['sampleNumber'] = this.sampleNumber;
    data['length'] = this.length;
    data['currency'] = this.currency;
    data['channels'] = this.channels;
    data['forAddress'] = this.forAddress;
    return data;
  }
}
