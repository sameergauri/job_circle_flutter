class CardModel {
  String? cardName;
  String? jobTitle;
  String? education;
  String? exprince;
  String? location;
  String? university;
  String? mobile;
  String? email;
  CardModel(
      {this.cardName,
      this.jobTitle,
      this.education,
      this.exprince,
      this.location,
      this.university,
      this.mobile,
      this.email});
  factory CardModel.fromJson(dynamic json) {
    return CardModel(
      cardName: json['cardName'],
      mobile: json['mobile'],
      email: json['email'],
    );
  }
  Map toJson() => {'cardName': cardName, 'mobile': mobile, 'email': email};
}
