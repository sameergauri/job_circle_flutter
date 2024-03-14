class ContactUsModel {
  final String? firstName;
  final int? reportTo;
  final int? officialNo;
  final String? profilePic;
  final String? gender;
  final String? lastName;
  final String? officialEmail;

  ContactUsModel({
    this.firstName,
    this.reportTo,
    this.officialNo,
    this.profilePic,
    this.gender,
    this.lastName,
    this.officialEmail,
  });

  factory ContactUsModel.fromJson(Map<String, dynamic> json) {
    return ContactUsModel(
      firstName: json['first_name'],
      reportTo: json['report_to'],
      officialNo: json['official_no'],
      profilePic: json['profile_pic'],
      gender: json['gender'],
      lastName: json['last_name'],
      officialEmail: json['official_email'],
    );
  }
}
