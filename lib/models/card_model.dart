class CardModel {
  String? cardName;
  String? firstName;
  String? lastName;
  String? gender;
  String? martial_status;
  String? jobTitle;
  String? education;
  String? exprince;
  String? location;
  String? university;
  String? mobile;
  String? email;
  String? role;
  String? alternate_no;

  String? userLocation;
  CardModel(
      {this.cardName,
      this.firstName,
      this.lastName,
      this.gender,
      this.martial_status,
      this.jobTitle,
      this.education,
      this.exprince,
      this.location,
      this.university,
      this.mobile,
      this.email,
      this.userLocation,
      this.role,
      this.alternate_no});
  factory CardModel.fromJson(dynamic json) {
    return CardModel(
        cardName: json['cardName'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        mobile: json['mobile'],
        email: json['email'],
        gender: json['gender'] ?? '',
        martial_status: json['martial_status'] ?? '',
        userLocation: json['userLocation'] ?? '',
        alternate_no: json['alternate_no']);
  }

  Map toJson() => {
        'cardName': cardName,
        'mobile': mobile,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'martial_status': martial_status,
        'userLocation': userLocation,
        'alternate_no': alternate_no
      };
}
