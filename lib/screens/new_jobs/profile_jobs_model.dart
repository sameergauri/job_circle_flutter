import 'dart:convert';

class ProfileModelForJob {
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
  int? dateOfBirth;
  String? userLocation;
  List<dynamic>? languages;
  String? email;
  int? cvUploadedDate;
  String? martialStatus;
  int? hasExperience;
  int? isFav;
  int? favId;
  int? userId;
  int? uid;
  String? status;
  int? usertype;
  int? alternateNo;
  int? isFreelancer;
  String? user_locality;

  ProfileModelForJob({
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
    this.alternateNo,
    this.isFreelancer,
    this.user_locality,
  });

  factory ProfileModelForJob.fromJson(Map<String, dynamic> json) {
    return ProfileModelForJob(
      id: json['id'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      role: json['role'],
      universityId: json['university_id'],
      workExperience: json['work_experience'],
      reportTo: json['report_to'],
      experience: json['experience'],
      companyName: json['company_name'],
      degreeSpcId: json['degree_spc_id'],
      officialEmail: json['official_email'],
      education: json['education'],
      experienceId: json['experience_id'],
      profilePic: json['profile_pic'],
      cvLink: json['cv_link'],
      educationId: json['education_id'],
      mobile: json['mobile'],
      partnerRequest: json['partner_request'],
      passingYear: json['passing_year'] != 0 ? json['passing_year'] : null,
      degreeSpc: json['degree_spc'],
      dateOfBirth: json['dateofbirth'],
      userLocation: json['user_location'],
      languages: _parseLanguages(json['languages']),
      email: json['email'],
      cvUploadedDate: json['cv_upladted_date'],
      martialStatus: json['martial_status'],
      hasExperience: json['has_experience'],
      isFav: json['is_fav'],
      favId: json['fav_id'],
      userId: json['user_id'],
      uid: json['uid'],
      status: json['status'],
      usertype: json['usertype'],
      alternateNo: json['alternate_no'],
      isFreelancer: json['is_freelancer'],
      user_locality: json['user_locality'],
    );
  }
  static List<String>? _parseLanguages(dynamic languages) {
    if (languages == null) {
      return null;
    } else if (languages is String) {
      // If it's a string, attempt to decode it as a JSON array
      try {
        return List<String>.from(jsonDecode(languages));
      } catch (e) {
        // If decoding fails, return the string wrapped in a list
        return [languages];
      }
    } else if (languages is List) {
      // If it's already a list, ensure it's a list of strings
      return languages.map((e) => e.toString()).toList();
    } else {
      return null;
    }
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
      'languages': languages,
      'email': email,
      'cv_upladted_date': cvUploadedDate,
      'martial_status': martialStatus,
      'has_experience': hasExperience,
      'is_fav': isFav,
      'fav_id': favId,
      'user_id': userId,
      'uid': uid,
      'status': status,
      'usertype': usertype,
      'alternate_no': alternateNo,
      'is_freelancer': isFreelancer,
      'user_locality': user_locality,
    };
  }
}
