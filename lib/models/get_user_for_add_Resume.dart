class UserDataForAddResumeModel {
  final String resultKey;
  final UserDataForAddResumeModelResultData resultData;
  final String code;
  final String errorMessage;

  UserDataForAddResumeModel({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory UserDataForAddResumeModel.fromJson(Map<String, dynamic> json) {
    return UserDataForAddResumeModel(
      resultKey: json['resultKey'],
      resultData:
          UserDataForAddResumeModelResultData.fromJson(json['resultData']),
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultKey': resultKey,
      'resultData': resultData.toJson(),
      'code': code,
      'errorMessage': errorMessage,
    };
  }
}

class UserDataForAddResumeModelResultData {
  final int id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? martialStatus;
  final int? userType;
  final int? reportTo;
  final int? role;
  final int? mobile;
  final int? alternateNo;
  final List<String>? languages;
  final String? gender;
  final int? education;
  final int? degreeSpc;
  final int? univercity;
  final int? passingYear;
  final int? experience;
  final int? jobTitle;
  final String? companyName;
  final int? hasExperience;
  final int? workExperience;
  final double? ctc;
  final String? profilePic;
  final String? coverPic;
  final String? bio;
  final int? otp;
  final int? altOtp;
  final String? createdOn;
  final String? otpTimestamp;
  final int? block;
  final String? dateOfBirth;
  final String? email;
  final String? flag;
  final String? cvLink;
  final String? cvUpladtedDate;
  final int? partnerRequest;
  final List<String>? skills;
  final String? userLocation;
  final String? officialEmail;
  final int? officialNo;
  final String? userZone;
  final String? vaccinationCertificate;
  final String? bloodGroup;
  final bool? vaccination;
  final String? userLocality;
  final String? updatedDate;
  final String? lastActive;
  final bool? active;

  UserDataForAddResumeModelResultData({
    required this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.martialStatus,
    this.userType,
    this.reportTo,
    this.role,
    this.mobile,
    this.alternateNo,
    this.languages,
    this.gender,
    this.education,
    this.degreeSpc,
    this.univercity,
    this.passingYear,
    this.experience,
    this.jobTitle,
    this.companyName,
    this.hasExperience,
    this.workExperience,
    this.ctc,
    this.profilePic,
    this.coverPic,
    this.bio,
    this.otp,
    this.altOtp,
    this.createdOn,
    this.otpTimestamp,
    this.block,
    this.dateOfBirth,
    this.email,
    this.flag,
    this.cvLink,
    this.cvUpladtedDate,
    this.partnerRequest,
    this.skills,
    this.userLocation,
    this.officialEmail,
    this.officialNo,
    this.userZone,
    this.vaccinationCertificate,
    this.bloodGroup,
    this.vaccination,
    this.userLocality,
    this.updatedDate,
    this.lastActive,
    this.active,
  });

  factory UserDataForAddResumeModelResultData.fromJson(
      Map<String, dynamic> json) {
    return UserDataForAddResumeModelResultData(
      id: json['id'],
      firstName: json['first_name'],
      middleName: json['middle_name'],
      lastName: json['last_name'],
      martialStatus: json['martial_status'],
      userType: json['usertype'],
      reportTo: json['report_to'],
      role: json['role'],
      mobile: json['mobile'],
      alternateNo: json['alternate_no'],
      languages: List<String>.from(json['languages'] ?? []),
      gender: json['gender'],
      education: json['education'],
      degreeSpc: json['degree_spc'],
      univercity: json['univercity'],
      passingYear: json['passing_year'],
      experience: json['experience'],
      jobTitle: json['job_title'],
      companyName: json['company_name'],
      hasExperience: json['has_experience'],
      workExperience: json['work_experience'],
      ctc: json['ctc']?.toDouble(),
      profilePic: json['profile_pic'],
      coverPic: json['cover_pic'],
      bio: json['bio'],
      otp: json['otp'],
      altOtp: json['alt_otp'],
      createdOn: json['createdon'],
      otpTimestamp: json['otp_timestamp'],
      block: json['block'],
      dateOfBirth: json['dateofbirth'],
      email: json['email'],
      flag: json['flag'],
      cvLink: json['cv_link'],
      cvUpladtedDate: json['cv_upladted_date'],
      partnerRequest: json['partner_request'],
      skills: List<String>.from(json['skills'] ?? []),
      userLocation: json['user_location'],
      officialEmail: json['official_email'],
      officialNo: json['official_no'],
      userZone: json['user_zone'],
      vaccinationCertificate: json['vaccination_certificate'],
      bloodGroup: json['blood_group'],
      vaccination: json['vaccination'],
      userLocality: json['user_locality'],
      updatedDate: json['updated_date'],
      lastActive: json['lastActive'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'martial_status': martialStatus,
      'usertype': userType,
      'report_to': reportTo,
      'role': role,
      'mobile': mobile,
      'alternate_no': alternateNo,
      'languages': languages,
      'gender': gender,
      'education': education,
      'degree_spc': degreeSpc,
      'univercity': univercity,
      'passing_year': passingYear,
      'experience': experience,
      'job_title': jobTitle,
      'company_name': companyName,
      'has_experience': hasExperience,
      'work_experience': workExperience,
      'ctc': ctc,
      'profile_pic': profilePic,
      'cover_pic': coverPic,
      'bio': bio,
      'otp': otp,
      'alt_otp': altOtp,
      'createdon': createdOn,
      'otp_timestamp': otpTimestamp,
      'block': block,
      'dateofbirth': dateOfBirth,
      'email': email,
      'flag': flag,
      'cv_link': cvLink,
      'cv_upladted_date': cvUpladtedDate,
      'partner_request': partnerRequest,
      'skills': skills,
      'user_location': userLocation,
      'official_email': officialEmail,
      'official_no': officialNo,
      'user_zone': userZone,
      'vaccination_certificate': vaccinationCertificate,
      'blood_group': bloodGroup,
      'vaccination': vaccination,
      'user_locality': userLocality,
      'updated_date': updatedDate,
      'lastActive': lastActive,
      'active': active,
    };
  }
}
