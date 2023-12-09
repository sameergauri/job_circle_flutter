import 'dart:convert';

class ProfileModel {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? role;
  int? universityId;
  String? workExperience;
  int? reportTo;
  String? experience;
  String? companyName;
  int? degreeSpcId;
  String? officialEmail;
  String? education;
  int? experienceId;
  String? profilePic;
  String? cvLink;
  int? educationId;
  int? mobile;
  int? partnerRequest;
  String? passingYear;
  String? degreeSpc;
  String? dateOfBirth;
  String? userLocation;
  List<dynamic>? languages;
  String? email;
  String? cvUploadedDate;
  String? martialStatus;
  int? hasExperience;
  int? isFav;
  int? favId;
  int? userId;
  int? uid;
  String? status;
  int? usertype;
  int? alternate_no;

  ProfileModel({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.gender,
    this.role,
    this.universityId,
    this.workExperience,
    this.reportTo,
    this.experience,
    this.companyName,
    this.degreeSpcId,
    this.officialEmail,
    this.education,
    this.experienceId,
    this.profilePic,
    this.cvLink,
    this.educationId,
    this.mobile,
    this.partnerRequest,
    this.passingYear,
    this.degreeSpc,
    this.dateOfBirth,
    this.userLocation,
    this.languages,
    this.email,
    this.cvUploadedDate,
    this.martialStatus,
    this.hasExperience,
    this.isFav,
    this.favId,
    this.userId,
    this.uid,
    this.status,
    this.usertype,
    this.alternate_no,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    try {
      List<String>? languagesList;
      if (json['languages'] is String) {
        try {
          languagesList = List<String>.from(jsonDecode(json['languages']));
        } catch (e) {
          // Handle JSON decoding error if needed
        }
      } else if (json['languages'] is List) {
        languagesList = List<String>.from(json['languages']);
      }
      return ProfileModel(
        id: json['id'] as int?,
        firstName: json['first_name'] as String?,
        middleName: json['middle_name'] as String?,
        lastName: json['last_name'] as String?,
        gender: json['gender'] as String?,
        role: json['role'] as String?,
        universityId: json['university_id'] as int?,
        workExperience: json['work_experience'] as String?,
        reportTo: json['report_to'] as int?,
        experience: json['experience'] as String?,
        companyName: json['company_name'] as String?,
        degreeSpcId: json['degree_spc_id'] as int?,
        officialEmail: json['official_email'] as String?,
        education: json['education'] as String?,
        experienceId: json['experience_id'] as int?,
        profilePic: json['profile_pic'] as String?,
        cvLink: json['cv_link'] as String?,
        educationId: json['education_id'] as int?,
        mobile: json['mobile'] as int?,
        partnerRequest: json['partner_request'] as int?,
        passingYear: json['passing_year']?.toString(),
        degreeSpc: json['degree_spc'] as String?,
        dateOfBirth: json['dateofbirth'] as String?,
        userLocation: json['user_location'] as String?,
        languages: languagesList,
        /* (json['languages'] != null)
              ? List<String>.from(jsonDecode(json['languages']))
              : null, */
        email: json['email'] as String?,
        cvUploadedDate: json['cv_upladted_date'] as String?,
        martialStatus: json['martial_status'] as String?,
        hasExperience: json['has_experience'] as int?,
        isFav: json['is_fav'] as int?,
        favId: json['favId'] as int?,
        userId: json['userId'] as int?,
        uid: json['uid'] as int?,
        status: json['status'] as String?,
        usertype: json['usertype'] as int?,
        alternate_no: json['alternate_no'] as int?,
      );
    } catch (e) {
      print("Error parsing JSON: $e");
      return ProfileModel(); // Return a default instance or handle the error accordingly
    }
  }
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as int?,
      firstName: map['first_name'] as String?,
      middleName: map['middle_name'] as String?,
      lastName: map['last_name'] as String?,
      gender: map['gender'] as String?,
      role: map['role'] as String?,
      universityId: map['university_id'] as int?,
      workExperience: map['work_experience'] as String?,
      reportTo: map['report_to'] as int?,
      experience: map['experience'] as String?,
      companyName: map['company_name'] as String?,
      degreeSpcId: map['degree_spc_id'] as int?,
      officialEmail: map['official_email'] as String?,
      education: map['education'] as String?,
      experienceId: map['experience_id'] as int?,
      profilePic: map['profile_pic'] as String?,
      cvLink: map['cv_link'] as String?,
      educationId: map['education_id'] as int?,
      mobile: map['mobile'] as int?,
      partnerRequest: map['partner_request'] as int?,
      passingYear: map['passing_year']?.toString(),
      degreeSpc: map['degree_spc'] as String?,
      dateOfBirth: map['dateofbirth'] as String?,
      userLocation: map['user_location'] as String?,
      languages: (map['languages'] != null)
          ? List<String>.from(jsonDecode(map['languages']))
          : null,
      email: map['email'] as String?,
      cvUploadedDate: map['cv_upladted_date'] as String?,
      martialStatus: map['martial_status'] as String?,
      hasExperience: map['has_experience'] as int?,
      isFav: map['is_fav'] as int?,
      favId: map['favId'] as int?,
      userId: map['userId'] as int?,
      uid: map['uid'] as int?,
      status: map['status'] as String?,
      usertype: map['usertype'] as int?,
      alternate_no: map['alternate_no'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'gender': gender,
      'role': role,
      'university_id': universityId,
      'work_experience': workExperience,
      'report_to': reportTo,
      'experience': experience,
      'company_name': companyName,
      'degree_spc_id': degreeSpcId,
      'official_email': officialEmail,
      'education': education,
      'last_name': lastName,
      'experience_id': experienceId,
      'profile_pic': profilePic,
      'cv_link': cvLink,
      'education_id': educationId,
      'mobile': mobile,
      'partner_request': partnerRequest,
      'passing_year': passingYear,
      'degree_spc': degreeSpc,
      'dateofbirth': dateOfBirth,
      'user_location': userLocation,
      'languages': (languages != null) ? jsonEncode(languages) : null,
      'email': email,
      'cv_upladted_date': cvUploadedDate,
      'martial_status': martialStatus,
      'has_experience': hasExperience,
      'is_fav': isFav,
      'favId': favId,
      "userId": userId,
      "uid": uid,
      "status": status,
      "usertype": usertype,
      "alternate_no": alternate_no,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'gender': gender,
      'role': role,
      'university_id': universityId,
      'work_experience': workExperience,
      'report_to': reportTo,
      'experience': experience,
      'company_name': companyName,
      'degree_spc_id': degreeSpcId,
      'official_email': officialEmail,
      'education': education,
      'last_name': lastName,
      'experience_id': experienceId,
      'profile_pic': profilePic,
      'cv_link': cvLink,
      'education_id': educationId,
      'mobile': mobile,
      'partner_request': partnerRequest,
      'passing_year': passingYear,
      'degree_spc': degreeSpc,
      'dateofbirth': dateOfBirth,
      'user_location': userLocation,
      'languages': (languages != null) ? jsonEncode(languages) : null,
      'email': email,
      'cv_upladted_date': cvUploadedDate,
      'martial_status': martialStatus,
      'has_experience': hasExperience,
      'is_fav': isFav,
      'favId': favId,
      "userId": userId,
      "uid": uid,
      "status": status,
      "usertype": usertype,
      "alternate_no": alternate_no
    };
  }
}
