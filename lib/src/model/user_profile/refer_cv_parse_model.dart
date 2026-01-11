class ReferResumeParseModel {
  String? firstName;
  String? lastName;
  String? email;
  String? contactNumber;
  String? alternateNumber;
  String? gender;
  String? dateOfBirth;
  String? educationLevel;
  String? experienceLevel;

  ReferResumeParseModel({
    this.firstName,
    this.lastName,
    this.email,
    this.contactNumber,
    this.alternateNumber,
    this.gender,
    this.dateOfBirth,
    this.educationLevel,
    this.experienceLevel,
  });

  // Factory constructor for creating a new ReferResumeParseModel instance from a map
  factory ReferResumeParseModel.fromJson(Map<String, dynamic> json) {
    return ReferResumeParseModel(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      email: json['email'] as String?,
      contactNumber: json['contactNumber'] as String?,
      alternateNumber: json['alternateNumber'] as String?,
      gender: json['gender'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      educationLevel: json['educationLevel'] as String?,
      experienceLevel: json['experienceLevel'] as String?,
    );
  }

  // Method to convert the ReferResumeParseModel instance back to a map
  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'contactNumber': contactNumber,
      'alternateNumber': alternateNumber,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'educationLevel': educationLevel,
      'experienceLevel': experienceLevel,
    };
  }
}
