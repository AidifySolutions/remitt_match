class Document {
  String? name;
  String? description;
  String? identifier;
  int? type;
  String? extension;
  int? status;
  String? createdAt;

  Document(
      {this.name,
        this.description,
        this.identifier,
        this.type,
        this.extension,
        this.status,
        this.createdAt});

  Document.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    identifier = json['identifier'];
    type = json['type'];
    extension = json['extension'];
    status = json['status'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['identifier'] = this.identifier;
    data['type'] = this.type;
    data['extension'] = this.extension;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    return data;
  }
}