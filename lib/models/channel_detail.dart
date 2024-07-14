class ChannelDetail {
  String? message;
  List<ChannelDetails>? channelDetails;

  ChannelDetail({this.message, this.channelDetails});

  ChannelDetail.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    channelDetails = json['channelDetails'] != null
        ? json['channelDetails']
            .map<ChannelDetails>((e) => ChannelDetails.fromJson(e))
            .toList()
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.channelDetails != null) {
      data['channelDetails'] = this.channelDetails!;
    }
    return data;
  }
}

class ChannelDetails {
  String? countryCode;
  String? channelType;
  List<FieldDetails>? fieldDetails;

  ChannelDetails({this.countryCode, this.channelType, this.fieldDetails});

  ChannelDetails.fromJson(Map<String, dynamic> json) {
    countryCode = json['countryCode'];
    channelType = json['channelType'];
    if (json['fieldDetails'] != null) {
      fieldDetails = [];
      json['fieldDetails'].forEach((v) {
        fieldDetails!.add(new FieldDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countryCode'] = this.countryCode;
    data['channelType'] = this.channelType;
    if (this.fieldDetails != null) {
      data['fieldDetails'] = this.fieldDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FieldDetails {
  String? label;
  String? code;
  String? regex;
  bool? isMandatory;
  String? description;
  String? hint;
  String? type;

  FieldDetails(
      {this.label,
      this.code,
      this.regex,
      this.isMandatory,
      this.description,
      this.hint,
      this.type});

  FieldDetails.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    code = json['code'];
    regex = json['regex'];
    isMandatory = json['isMandatory'];
    description = json['description'];
    hint = json['hint'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['code'] = this.code;
    data['regex'] = this.regex;
    data['isMandatory'] = this.isMandatory;
    data['description'] = this.description;
    data['hint'] = this.hint;
    data['type'] = this.type;
    return data;
  }
}
