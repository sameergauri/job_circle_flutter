class CardModel {
  String? cardName;
  String? firstName;
  String? lastName;
  String? gender;
  String? jobTitle;
  String? education;
  String? exprince;
  String? location;
  String? university;
  String? mobile;
  String? email;
  String? role;
  CardModel(
      {this.cardName,
      this.firstName,
      this.lastName,
      this.gender,
      this.jobTitle,
      this.education,
      this.exprince,
      this.location,
      this.university,
      this.mobile,
      this.email,
      this.role});
  factory CardModel.fromJson(dynamic json) {
    return CardModel(
      cardName: json['cardName'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      mobile: json['mobile'],
      email: json['email'],
      gender: json['gender'] ?? '',
    );
  }
  Map toJson() => {
        'cardName': cardName,
        'mobile': mobile,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender
      };
}
