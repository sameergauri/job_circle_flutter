// Dart model for the provided JSON structure

class UserData {
  List<CertificationRequest>? certificationsRequest;
  List<EducationRequest>? educationRequest;
  List<ExperienceRequest>? experienceRequest;
  UserRequest? userRequest;

  UserData({
    this.certificationsRequest,
    this.educationRequest,
    this.experienceRequest,
    this.userRequest,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      certificationsRequest: json['certificationsRequest'] != null
          ? (json['certificationsRequest'] as List)
              .map((e) => CertificationRequest.fromJson(e))
              .toList()
          : null,
      educationRequest: json['educationRequest'] != null
          ? (json['educationRequest'] as List)
              .map((e) => EducationRequest.fromJson(e))
              .toList()
          : null,
      experienceRequest: json['experienceRequest'] != null
          ? (json['experienceRequest'] as List)
              .map((e) => ExperienceRequest.fromJson(e))
              .toList()
          : null,
      userRequest: json['userRequest'] != null
          ? UserRequest.fromJson(json['userRequest'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificationsRequest':
          certificationsRequest?.map((e) => e.toJson()).toList(),
      'educationRequest': educationRequest?.map((e) => e.toJson()).toList(),
      'experienceRequest': experienceRequest?.map((e) => e.toJson()).toList(),
      'userRequest': userRequest?.toJson(),
    };
  }
}

class CertificationRequest {
  String? certificate;
  int? certificateId;
  String? certificationName;
  String? credentialId;
  String? credentialUrl;
  String? endMonth;
  int? endYear;
  String? expirationDate;
  String? issueDate;
  String? issuingOrganization;
  String? startMonth;
  int? startYear;
  int? userId;

  CertificationRequest(
      {this.certificate,
      this.certificationName,
      this.expirationDate,
      this.certificateId,
      this.credentialId,
      this.credentialUrl,
      this.issueDate,
      this.issuingOrganization,
      this.userId,
      this.endMonth,
      this.endYear,
      this.startMonth,
      this.startYear});

  factory CertificationRequest.fromJson(Map<String, dynamic> json) {
    return CertificationRequest(
      certificate: json['certificate'],
      certificateId: json['certificateId'],
      certificationName: json['certificationName'],
      credentialId: json['credentialId'],
      expirationDate: json['expirationDate'],
      credentialUrl: json['credentialUrl'],
      issueDate: json['issueDate'],
      issuingOrganization: json['issuingOrganization'],
      userId: json['userId'],
      endMonth: json['endMonth'],
      endYear: json['endYear'],
      startMonth: json['startMonth'],
      startYear: json['startYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificate': certificate,
      'certificateId': certificateId,
      'certificationName': certificationName,
      'credentialId': credentialId,
      'credentialUrl': credentialUrl,
      'expirationDate': expirationDate,
      'issueDate': issueDate,
      'issuingOrganization': issuingOrganization,
      'userId': userId,
      'endMonth': endMonth,
      'endYear': endYear,
      'startMonth': startMonth,
      'startYear': startYear
    };
  }
}

class EducationRequest {
  String? degreeSpc;
  String? fieldOfStudy;
  String? university;
  String? schoolOrCollegeName;
  int? id;
  int? userId;
  int? isCurrent;
  int? firstYear;
  int? passingYear;
  int? endMonth;
  int? startMonth;
  String? marksheet;
  int? isRemote;

  EducationRequest(
      {this.degreeSpc,
      this.fieldOfStudy,
      this.firstYear,
      this.id,
      this.isCurrent,
      this.passingYear,
      this.university,
      this.userId,
      this.schoolOrCollegeName,
      this.endMonth,
      this.startMonth,
      this.isRemote,
      this.marksheet});

  factory EducationRequest.fromJson(Map<String, dynamic> json) {
    return EducationRequest(
      degreeSpc: json['degreeSpc'],
      fieldOfStudy: json['fieldOfStudy'],
      firstYear: json['firstYear'],
      id: json['id'],
      isCurrent: json['isCurrent'],
      passingYear: json['passingYear'],
      university: json['university'],
      userId: json['userId'],
      endMonth: json['endMonth'],
      startMonth: json['startMonth'],
      schoolOrCollegeName: json['schoolOrCollegeName'],
      marksheet: json['marksheet'],
      isRemote: json['isRemote'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'degreeSpc': degreeSpc,
      'fieldOfStudy': fieldOfStudy,
      'firstYear': firstYear,
      'id': id,
      'isCurrent': isCurrent,
      'passingYear': passingYear,
      'university': university,
      'userId': userId,
      'schoolOrCollegeName': schoolOrCollegeName,
      'startMonth': startMonth,
      'endMonth': endMonth,
      'marksheet': marksheet,
      'isRemote': isRemote,
    };
  }
}

class ExperienceRequest {
  int? id;
  int? userId;
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
  List<String>? skillsExp;
  String? offerLetter;
  String? appointmentLetter;
  String? incrementLetter;
  String? salarySlip;
  String? experienceLettter;

  ExperienceRequest({
    this.id,
    this.userId,
    this.jobTitle,
    this.companyName,
    this.industry,
    this.functionalArea,
    this.empType,
    this.workType,
    this.jobRole,
    this.jobLocation,
    this.joiningDate,
    this.lastWorkingDate,
    this.isCurrent,
    this.salary,
    this.skillsExp,
    this.offerLetter,
    this.appointmentLetter,
    this.incrementLetter,
    this.salarySlip,
    this.experienceLettter,
  });

  ExperienceRequest copyWith({
    int? id,
    int? userId,
    String? jobTitle,
    String? companyName,
    String? industry,
    String? functionalArea,
    String? empType,
    String? workType,
    String? jobRole,
    String? jobLocation,
    DateTime? joiningDate,
    DateTime? lastWorkingDate,
    int? isCurrent,
    String? salary,
    List<String>? skillsExp,
    String? offerLetter,
    String? appointmentLetter,
    String? incrementLetter,
    String? salarySlip,
    String? experienceLettter,
  }) {
    return ExperienceRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      functionalArea: functionalArea ?? this.functionalArea,
      empType: empType ?? this.empType,
      workType: workType ?? this.workType,
      jobRole: jobRole ?? this.jobRole,
      jobLocation: jobLocation ?? this.jobLocation,
      joiningDate: joiningDate ?? this.joiningDate,
      lastWorkingDate: lastWorkingDate ?? this.lastWorkingDate,
      isCurrent: isCurrent ?? this.isCurrent,
      salary: salary ?? this.salary,
      skillsExp: skillsExp ?? this.skillsExp,
      offerLetter: offerLetter ?? this.offerLetter,
      appointmentLetter: appointmentLetter ?? this.appointmentLetter,
      incrementLetter: incrementLetter ?? this.incrementLetter,
      salarySlip: salarySlip ?? this.salarySlip,
      experienceLettter: experienceLettter ?? this.experienceLettter,
    );
  }

  factory ExperienceRequest.fromJson(Map<String, dynamic> json) {
    return ExperienceRequest(
      id: json['id'],
      userId: json['userId'],
      jobTitle: json['jobTitle'],
      companyName: json['companyName'],
      industry: json['industry'],
      functionalArea: json['functionalArea'],
      empType: json['empType'],
      workType: json['workType'],
      jobRole: json['jobRole'],
      jobLocation: json['jobLocation'],
      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'])
          : null,
      lastWorkingDate: json['lastWorkingDate'] != null
          ? DateTime.parse(json['lastWorkingDate'])
          : null,
      isCurrent: json['isCurrent'],
      salary: json['salary'],
      skillsExp: json['skillsExp'] != null
          ? List<String>.from(json['skillsExp'])
          : null,
      offerLetter: json['offerLetter'],
      appointmentLetter: json['appointmentLetter'],
      incrementLetter: json['incrementLetter'],
      salarySlip: json['salarySlip'],
      experienceLettter: json['experienceLettter'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'jobTitle': jobTitle,
      'companyName': companyName,
      'industry': industry,
      'functionalArea': functionalArea,
      'empType': empType,
      'workType': workType,
      'jobRole': jobRole,
      'jobLocation': jobLocation,
      'joiningDate': joiningDate?.toIso8601String(),
      'lastWorkingDate': lastWorkingDate?.toIso8601String(),
      'isCurrent': isCurrent,
      'salary': salary,
      'skillsExp': skillsExp,
      'offerLetter': offerLetter,
      'appointmentLetter': appointmentLetter,
      'incrementLetter': incrementLetter,
      'salarySlip': salarySlip,
      'experienceLettter': experienceLettter,
    };
  }
}

class UserRequest {
  int? userId;
  String? firstName;
  String? middleName;
  String? lastName;
  int? mobile;
  int? alternateNo;
  String? email;
  String? gender;
  String? dateOfBirth;
  String? userLocality;
  String? userLocation;
  String? pinCode;
  List<String>? languages;
  bool? vaccination;
  String? vaccinationCertificate;
  String? profileHeadline;
  String? bio;
  int? education;
  int? experience;
  String? cvLink;
  String? cvUpdatedDate;
  DateTime? otpTimestamp;
  String? profilePic;
  int? reportTo;
  int? role;
  List<String>? skills;
  int? userType;

  UserRequest({
    this.alternateNo,
    this.bio,
    this.cvLink,
    this.cvUpdatedDate,
    this.dateOfBirth,
    this.education,
    this.email,
    this.experience,
    this.firstName,
    this.gender,
    this.languages,
    this.lastName,
    this.middleName,
    this.mobile,
    this.otpTimestamp,
    this.pinCode,
    this.profilePic,
    this.reportTo,
    this.role,
    this.skills,
    this.userId,
    this.userLocality,
    this.userLocation,
    this.userType,
    this.vaccination,
    this.profileHeadline,
    this.vaccinationCertificate,
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      alternateNo: json['alternateNo'],
      bio: json['bio'],
      cvLink: json['cvLink'],
      cvUpdatedDate: json['cvUpdatedDate'],
      dateOfBirth: json['dateOfBirth'],
      education: json['education'],
      email: json['email'],
      experience: json['experience'],
      firstName: json['firstName'],
      gender: json['gender'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      lastName: json['lastName'],
      middleName: json['middleName'],
      mobile: json['mobile'],
      otpTimestamp: json['otpTimestamp'] != null
          ? DateTime.parse(json['otpTimestamp'])
          : null,
      pinCode: json['pinCode'],
      profilePic: json['profilePic'],
      reportTo: json['reportTo'],
      role: json['role'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      userId: json['userId'],
      userLocality: json['userLocality'],
      userLocation: json['userLocation'],
      userType: json['userType'],
      profileHeadline: json['profileHeadline'],
      vaccination: json['vaccination'],
      vaccinationCertificate: json['vaccinationCertificate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alternateNo': alternateNo,
      'bio': bio,
      'cvLink': cvLink,
      'cvUpdatedDate': cvUpdatedDate,
      'dateOfBirth': dateOfBirth,
      'education': education,
      'email': email,
      'experience': experience,
      'firstName': firstName,
      'gender': gender,
      'languages': languages,
      'lastName': lastName,
      'middleName': middleName,
      'mobile': mobile,
      'otpTimestamp': otpTimestamp?.toIso8601String(),
      'pinCode': pinCode,
      'profilePic': profilePic,
      'reportTo': reportTo,
      'role': role,
      'skills': skills,
      'userId': userId,
      'userLocality': userLocality,
      'userLocation': userLocation,
      'userType': userType,
      'vaccination': vaccination,
      'profileHeadline': profileHeadline,
      'vaccinationCertificate': vaccinationCertificate,
    };
  }

  UserRequest copyWith({
    int? userId,
    String? firstName,
    String? middleName,
    String? lastName,
    int? mobile,
    int? alternateNo,
    String? email,
    String? gender,
    String? dateOfBirth,
    String? userLocality,
    String? userLocation,
    String? pinCode,
    List<String>? languages,
    bool? vaccination,
    String? vaccinationCertificate,
    String? profileHeadline,
    String? bio,
    int? education,
    int? experience,
    String? cvLink,
    String? cvUpdatedDate,
    DateTime? otpTimestamp,
    String? profilePic,
    int? reportTo,
    int? role,
    List<String>? skills,
    int? userType,
  }) {
    return UserRequest(
      alternateNo: alternateNo ?? this.alternateNo,
      bio: bio ?? this.bio,
      cvLink: cvLink ?? this.cvLink,
      cvUpdatedDate: cvUpdatedDate ?? this.cvUpdatedDate,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      education: education ?? this.education,
      email: email ?? this.email,
      experience: experience ?? this.experience,
      firstName: firstName ?? this.firstName,
      gender: gender ?? this.gender,
      languages: languages ?? this.languages,
      lastName: lastName ?? this.lastName,
      middleName: middleName ?? this.middleName,
      mobile: mobile ?? this.mobile,
      otpTimestamp: otpTimestamp ?? this.otpTimestamp,
      pinCode: pinCode ?? this.pinCode,
      profilePic: profilePic ?? this.profilePic,
      reportTo: reportTo ?? this.reportTo,
      role: role ?? this.role,
      skills: skills ?? this.skills,
      userId: userId ?? this.userId,
      userLocality: userLocality ?? this.userLocality,
      userLocation: userLocation ?? this.userLocation,
      userType: userType ?? this.userType,
      vaccination: vaccination ?? this.vaccination,
      profileHeadline: profileHeadline ?? this.profileHeadline,
      vaccinationCertificate:
          vaccinationCertificate ?? this.vaccinationCertificate,
    );
  }
}


/* class UserRequest {
  int? alternateNo;
  String? bio;
  int? block;
  String? bloodGroup;
  String? coverPic;
  String? cvLink;
  DateTime? cvUpdatedDate;
  String? dateOfBirth;
  int? education;
  String? email;
  int? experience;
  String? firstName;
  String? gender;
  List<String>? languages;
  String? lastName;
  String? loginType;
  String? martialStatus;
  String? middleName;
  int? mobile;
  int? otp;
  int? otpExpirationTime;
  DateTime? otpTimestamp;
  String? pinCode;
  String? profilePic;
  int? reportTo;
  int? role;
  List<String>? skills;
  int? userId;
  String? userLocality;
  String? userLocation;
  int? userType;
  String? userZone;
  bool? vaccination;
  String? vaccinationCertificate;

  UserRequest({
    this.alternateNo,
    this.bio,
    this.block,
    this.bloodGroup,
    this.coverPic,
    this.cvLink,
    this.cvUpdatedDate,
    this.dateOfBirth,
    this.education,
    this.email,
    this.experience,
    this.firstName,
    this.gender,
    this.languages,
    this.lastName,
    this.loginType,
    this.martialStatus,
    this.middleName,
    this.mobile,
    this.otp,
    this.otpExpirationTime,
    this.otpTimestamp,
    this.pinCode,
    this.profilePic,
    this.reportTo,
    this.role,
    this.skills,
    this.userId,
    this.userLocality,
    this.userLocation,
    this.userType,
    this.userZone,
    this.vaccination,
    this.vaccinationCertificate,
  });

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      alternateNo: json['alternateNo'],
      bio: json['bio'],
      block: json['block'],
      bloodGroup: json['bloodGroup'],
      coverPic: json['coverPic'],
      cvLink: json['cvLink'],
      cvUpdatedDate: json['cvUpdatedDate'] != null
          ? DateTime.parse(json['cvUpdatedDate'])
          : null,
      dateOfBirth: json['dateOfBirth'],
      education: json['education'],
      email: json['email'],
      experience: json['experience'],
      firstName: json['firstName'],
      gender: json['gender'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      lastName: json['lastName'],
      loginType: json['loginType'],
      martialStatus: json['martialStatus'],
      middleName: json['middleName'],
      mobile: json['mobile'],
      otp: json['otp'],
      otpExpirationTime: json['otpExpirationTime'],
      otpTimestamp: json['otpTimestamp'] != null
          ? DateTime.parse(json['otpTimestamp'])
          : null,
      pinCode: json['pinCode'],
      profilePic: json['profilePic'],
      reportTo: json['reportTo'],
      role: json['role'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      userId: json['userId'],
      userLocality: json['userLocality'],
      userLocation: json['userLocation'],
      userType: json['userType'],
      userZone: json['userZone'],
      vaccination: json['vaccination'],
      vaccinationCertificate: json['vaccinationCertificate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alternateNo': alternateNo,
      'bio': bio,
      'block': block,
      'bloodGroup': bloodGroup,
      'coverPic': coverPic,
      'cvLink': cvLink,
      'cvUpdatedDate': cvUpdatedDate?.toIso8601String(),
      'dateOfBirth': dateOfBirth,
      'education': education,
      'email': email,
      'experience': experience,
      'firstName': firstName,
      'gender': gender,
      'languages': languages,
      'lastName': lastName,
      'loginType': loginType,
      'martialStatus': martialStatus,
      'middleName': middleName,
      'mobile': mobile,
      'otp': otp,
      'otpExpirationTime': otpExpirationTime,
      'otpTimestamp': otpTimestamp?.toIso8601String(),
      'pinCode': pinCode,
      'profilePic': profilePic,
      'reportTo': reportTo,
      'role': role,
      'skills': skills,
      'userId': userId,
      'userLocality': userLocality,
      'userLocation': userLocation,
      'userType': userType,
      'userZone': userZone,
      'vaccination': vaccination,
      'vaccinationCertificate': vaccinationCertificate,
    };
  }
} */

