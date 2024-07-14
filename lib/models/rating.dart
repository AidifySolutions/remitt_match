
class RatingResponse {
  String? message;
  Rating? rating;

  RatingResponse({this.message, this.rating});

  RatingResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    rating =
    json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }
}

class Rating {
  String? id;
  String? tradeId;
  String? subject;
  String? critic;
  int? rating;
  String? comments;

  Rating(
      {this.id,
        this.tradeId,
        this.subject,
        this.critic,
        this.rating,
        this.comments});

  Rating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tradeId = json['tradeId'];
    subject = json['subject'];
    critic = json['critic'];
    rating = json['rating'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tradeId'] = this.tradeId;
    data['subject'] = this.subject;
    data['critic'] = this.critic;
    data['rating'] = this.rating;
    data['comments'] = this.comments;
    return data;
  }
}

