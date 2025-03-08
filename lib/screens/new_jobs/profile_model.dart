import 'dart:convert';

import 'package:intl/intl.dart';

class ApiResponse {
  final String? resultKey;
  final int? code;
  final String? errorMessage;
  final ResultData? resultData;

  ApiResponse({
    this.resultKey,
    this.code,
    this.errorMessage,
    this.resultData,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      resultKey: json['resultKey'] as String?,
      code: json['code'] as int?,
      errorMessage: json['errorMessage'] as String?,
      resultData: json['resultData'] != null
          ? ResultData.fromJson(json['resultData'])
          : null,
    );
  }
}

class ResultData {
  final ProfileModel? profile;

  ResultData({this.profile});

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      profile: json['profile'] != null
          ? ProfileModel.fromJson(json['profile'])
          : null,
    );
  }
}

class ProfileModel {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? userLocation;
  String? profilePic;
  String? bio;
  int? usertype;
  List<String>? languagesKnown;
  List<String>? profileSkills;
  List<String>? allSkills;
  List<Experience>? experiences;
  List<EducationDetail>? educationDetails;
  List<CertificationDetailModel>? certifications;
  String? resume;
  int? reportTo;
  int? isFreelancer;
  String? role;
  int? mobile;
  int? alternateNo;
  String? gmail;
  String? gender;
  String? dob;
  String? pinCode;
  String? profileHeadline;
  bool? vacination;
  String? vaccination_certificate;
  String? userFullLocation;
  String? userlocality;

  ProfileModel(
      {this.id,
      this.firstName,
      this.middleName,
      this.lastName,
      this.userLocation,
      this.profilePic,
      this.bio,
      this.languagesKnown,
      this.profileSkills,
      this.allSkills,
      this.experiences,
      this.educationDetails,
      this.certifications,
      this.usertype,
      this.reportTo,
      this.isFreelancer,
      this.role,
      this.mobile,
      this.profileHeadline,
      this.alternateNo,
      this.dob,
      this.gender,
      this.gmail,
      this.pinCode,
      this.vacination,
      this.vaccination_certificate,
      this.userFullLocation,
      this.userlocality,
      this.resume});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
        id: json['id'] as int?,
        firstName: json['firstName'] as String?,
        middleName: json['middleName'] as String?,
        lastName: json['lastName'] as String?,
        userLocation: json['userLocation'] as String?,
        profilePic: json['profilePic'] as String?,
        bio: json['bio'] as String?,
        languagesKnown: _parseLanguages(json['languagesKnown']),
        profileSkills: (json['profileSkills'] as List?)
            ?.map((item) => item as String)
            .toList(),
        allSkills: (json['allSkills'] as List?)
            ?.map((item) => item as String)
            .toList(),
        experiences: (json['experiences'] as List?)
            ?.map((item) => Experience.fromJson(item))
            .toList(),
        educationDetails: (json['educationDetails'] as List?)
            ?.map((item) => EducationDetail.fromJson(item))
            .toList(),
        certifications: (json['certifications'] as List?)
            ?.map((item) => CertificationDetailModel.fromJson(item))
            .toList(),
        resume: json['resume'],
        usertype: json['usertype'],
        reportTo: json['reportTo'],
        isFreelancer: json['isFreelancer'],
        role: json['role'],
        profileHeadline: json['profileHeadline'],
        mobile: json['mobile'],
        alternateNo: json['alternateNo'],
        dob: json['dob'],
        gender: json['gender'],
        pinCode: json['pinCode'],
        vacination: json['vaccination'],
        userFullLocation: json['userFullLocation'],
        vaccination_certificate: json['vaccination_certificate'],
        userlocality: json['userLocality'],
        gmail: json['gmail']);
  }

  get languages => null;

  get education => null;

  String? get userLocality => userlocality;
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
}

class Experience {
  int? id;
  String? jobTitle;
  String? companyName;
  String? industry;
  String? functionalArea;
  String? empType;
  String? workType;
  String? jobRole;
  String? jobLocation;
  DateTime? joiningDate;
  DateTime? lastWorkingDate;
  int? isCurrent;
  String? salary;
  String? workingPeriod;
  String? companyLogo;
  String? workingCompany;
  List<String>? skillsExp;
  String? offerletter;
  String? increamentLetter;
  String? appointmentLetter;
  String? salarySlip;
  String? expLetter;

  Experience(
      {this.id,
      this.jobTitle,
      this.companyName,
      this.workType,
      this.salary,
      this.joiningDate,
      this.lastWorkingDate,
      this.empType,
      this.isCurrent,
      this.workingPeriod,
      this.companyLogo,
      this.workingCompany,
      this.skillsExp,
      this.functionalArea,
      this.industry,
      this.jobLocation,
      this.jobRole,
      this.appointmentLetter,
      this.expLetter,
      this.increamentLetter,
      this.offerletter,
      this.salarySlip,
      int? userId});

  factory Experience.fromJson(Map<String, dynamic> json) {
    final dateFormat = DateFormat("dd MMMM yyyy");
    return Experience(
        id: json['id'] as int?,
        jobTitle: json['jobTitle'] as String?,
        companyName: json['companyName'] as String?,
        workType: json['workType'] as String?,
        salary: json['salary'] as String?,
        joiningDate: json['joiningDate'] != null && json['joiningDate'] != "N/A"
            ? dateFormat.parse(json['joiningDate'])
            : null,
        /*  joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'])
          : null, */
        lastWorkingDate:
            json['lastWorkingDate'] != null && json['lastWorkingDate'] != "N/A"
                ? dateFormat.parse(json['lastWorkingDate'])
                : null,
        empType: json['empType'] as String?,
        isCurrent: json['isCurrent'] as int?,
        workingPeriod: json['workingPeriod'] as String?,
        companyLogo: json['companyLogo'] as String?,
        workingCompany: json['workingCompany'] as String?,
        skillsExp: (json['skillsExp'] as List?)
            ?.map((item) => item as String)
            .toList(),
        functionalArea: json['functionalArea'],
        industry: json['industry'],
        jobLocation: json['jobLocation'],
        jobRole: json['jobRole'],
        appointmentLetter: json['appointmentLetter'],
        expLetter: json['expLetter'],
        increamentLetter: json['increamentLetter'],
        offerletter: json['offerletter'],
        salarySlip: json['salarySlip']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'workType': workType,
      'salary': salary,
      'joiningDate': joiningDate,
      'lastWorkingDate': lastWorkingDate,
      'empType': empType,
      'isCurrent': isCurrent,
      'workingPeriod': workingPeriod,
      'companyLogo': companyLogo,
      'workingCompany': workingCompany,
      'skillsExp': skillsExp,
      'functionalArea': functionalArea,
      'industry': industry,
      'jobLocation': jobLocation,
      'jobRole': jobRole
    };
  }

  get last_working_date => null;
}

class EducationDetail {
  int? id;
  String? university;
  String? fieldOfStudy;
  int? firstYear;
  int? passingYear;
  String? startMonth;
  String? endMonth;
  int? isCurrent;
  String? educationPeriod;
  String? degree_spc;
  String? ficon;
  String? icon;
  String? board;
  String? level;
  String? marksheet;
  String? schoolOrCollegeName;
  int? isRemote;

  EducationDetail(
      {this.id,
      this.university,
      this.fieldOfStudy,
      this.firstYear,
      this.passingYear,
      this.isCurrent,
      this.degree_spc,
      this.educationPeriod,
      this.ficon,
      this.board,
      this.level,
      this.endMonth,
      this.marksheet,
      this.startMonth,
      this.isRemote,
      this.schoolOrCollegeName,
      this.icon});

  factory EducationDetail.fromJson(Map<String, dynamic> json) {
    return EducationDetail(
      id: json['id'] as int?,
      university: json['university'] as String?,
      fieldOfStudy: json['fieldOfStudy'] as String?,
      firstYear: json['firstYear'] as int?,
      passingYear: json['passingYear'] as int?,
      isCurrent: json['isCurrent'] as int?,
      educationPeriod: json['educationPeriod'] as String?,
      degree_spc: json['degree_spc'],
      ficon: json['ficon'],
      board: json['board'],
      level: json['level'],
      icon: json['universityLogo'],
      endMonth: json['endMonth'],
      marksheet: json['marksheet'],
      isRemote: json['isRemote'] as int?,
      schoolOrCollegeName: json['schoolOrCollegeName'],
      startMonth: json['startMonth'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'university': university,
      'fieldOfStudy': fieldOfStudy,
      'firstYear': firstYear,
      'passingYear': passingYear,
      'isCurrent': isCurrent,
      'educationPeriod': educationPeriod,
      'degree_spc': degree_spc,
      'ficon': ficon,
      'board': board,
      'level': level,
      'universityLogo': icon,
      'endMonth': endMonth,
      'marksheet': marksheet,
      'schoolOrCollegeName': schoolOrCollegeName,
      'isRemote': isRemote,
      'startMonth': startMonth,
    };
  }
}

class CertificationDetailModel {
  int? id;
  String? certificationName;
  String? issuingOrganization;
  String? issueDate;
  String? expirationDate;
  String? certificate;
  String? credentialId;
  String? credentialUrl;
  String? startMonth;
  String? endMonth;
  int? startYear;
  int? endYear;
  String? certLogo;

  CertificationDetailModel({
    this.id,
    this.certificationName,
    this.issuingOrganization,
    this.issueDate,
    this.expirationDate,
    this.certificate,
    this.credentialId,
    this.credentialUrl,
    this.startMonth,
    this.endMonth,
    this.startYear,
    this.endYear,
    this.certLogo,
  });

  factory CertificationDetailModel.fromJson(Map<String, dynamic> json) {
    return CertificationDetailModel(
      id: json['id'] as int?,
      certificationName: json['certificationName'] as String?,
      issuingOrganization: json['issuingOrganization'] as String?,
      issueDate: json['issueDate'] as String?,
      expirationDate: json['expirationDate'] as String?,
      certificate: json['certificate'] as String?,
      credentialId: json['credentialId'] as String?,
      credentialUrl: json['credentialUrl'] as String?,
      startMonth: json['StartMonth'] as String?,
      endMonth: json['EndMonth'] as String?,
      startYear: json['startYear'] as int?,
      endYear: json['endYear'] as int?,
      certLogo: json['certLogo'] as String?,
    );
  }
}


/* class ProfileModel {
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
  List<String>? languages;
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
  String? bio;

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
    this.alternateNo,
    this.isFreelancer,
    this.bio,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
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
      passingYear: json['passing_year'],
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
      bio: json['bio'],
    );
  }

  String? get user_locality => null;

  get skills => null;

  get vaccination_certificate => null;

  get vaccination => null;
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
      'bio': bio,
    };
  }
} */



/* // ignore_for_file: equal_keys_in_map, non_constant_identifier_names, avoid_print

import 'dart:convert';

class ProfileModelModel {
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
  int? is_freelancer;

  ProfileModelModel(
      {this.id,
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
      this.is_freelancer});

  factory ProfileModelModel.fromJson(Map<String, dynamic> json) {
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
      return ProfileModelModel(
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
        is_freelancer: json['is_freelancer'] as int?,
      );
    } catch (e) {
      print("Error parsing JSON: $e");
      return ProfileModelModel(); // Return a default instance or handle the error accordingly
    }
  }
  factory ProfileModelModel.fromMap(Map<String, dynamic> map) {
    return ProfileModelModel(
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
      is_freelancer: map['is_freelancer'] as int?,
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
      'is_freelancer': is_freelancer,
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
      "alternate_no": alternate_no,
      'is_freelancer': is_freelancer
    };
  }
}
 */