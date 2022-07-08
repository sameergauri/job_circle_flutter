class CardModel {
  String? cardName;
  String? firstName;
  String? lastName;
  String? jobTitle;
  String? education;
  String? exprince;
  String? location;
  String? university;
  String? mobile;
  String? email;
  CardModel(
      {this.cardName,
      this.firstName,
      this.lastName,
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
      firstName: json['firstName'],
      lastName: json['lastName'],
      mobile: json['mobile'],
      email: json['email'],
    );
  }
  Map toJson() => {
        'cardName': cardName,
        'mobile': mobile,
        'email': email,
        'firstName': firstName,
        'lastName': lastName
      };
}
