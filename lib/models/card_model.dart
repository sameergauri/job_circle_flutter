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
  String? vacination_certificate;
  String? dateofbirth;
  String? bio;
  int? vaccination;
  String? vaccination_certificate;
  String? middle_name;
  String? user_locality;
  String? usertype;
  int? id;

  String? userLocation;
  CardModel({
    this.cardName,
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
    this.alternate_no,
    this.dateofbirth,
    this.bio,
    this.vaccination,
    this.vaccination_certificate,
    this.middle_name,
    this.user_locality,
    this.usertype,
    this.id,
  });
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
      alternate_no: json['alternate_no'] ?? '',
      dateofbirth: json['dateofbirth'] ?? '',
      bio: json['bio'] ?? '',
      vaccination: json['vaccination'] ?? 0,
      vaccination_certificate: json['vaccination_certificate'] ?? '',
      middle_name: json['middle_name'],
      user_locality: json['user_locality'],
      id: json['id'],
      usertype: json['usertype'],
    );
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
        'alternate_no': alternate_no,
        'dateofbirth': dateofbirth,
        'bio': bio,
        'vaccination': vaccination,
        'vaccination_certificate': vaccination_certificate,
        'middle_name': middle_name,
        'user_locality': user_locality,
        'usertpe': usertype,
        'id': id,
      };
}
