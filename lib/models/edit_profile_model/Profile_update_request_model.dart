class UserUpdateRequestModel {
  List<CertificationRequestDto>? certificationsRequestDtos;
  List<EducationRequestDto>? educationRequestDtos;
  List<ExperienceRequestDto>? experienceRequestDtos;
  ProfileUpdateRequestDto? profileUpdateRequestDto;

  UserUpdateRequestModel({
    this.certificationsRequestDtos,
    this.educationRequestDtos,
    this.experienceRequestDtos,
    this.profileUpdateRequestDto,
  });

  factory UserUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    return UserUpdateRequestModel(
      certificationsRequestDtos: json['certificationsRequestDtos'] != null
          ? (json['certificationsRequestDtos'] as List)
              .map((e) => CertificationRequestDto.fromJson(e))
              .toList()
          : null,
      educationRequestDtos: json['educationRequestDtos'] != null
          ? (json['educationRequestDtos'] as List)
              .map((e) => EducationRequestDto.fromJson(e))
              .toList()
          : null,
      experienceRequestDtos: json['experienceRequestDtos'] != null
          ? (json['experienceRequestDtos'] as List)
              .map((e) => ExperienceRequestDto.fromJson(e))
              .toList()
          : null,
      profileUpdateRequestDto: json['profileUpdateRequestDto'] != null
          ? ProfileUpdateRequestDto.fromJson(json['profileUpdateRequestDto'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificationsRequestDtos':
          certificationsRequestDtos?.map((e) => e.toJson()).toList(),
      'educationRequestDtos':
          educationRequestDtos?.map((e) => e.toJson()).toList(),
      'experienceRequestDtos':
          experienceRequestDtos?.map((e) => e.toJson()).toList(),
      'profileUpdateRequestDto': profileUpdateRequestDto?.toJson(),
    };
  }
}

class CertificationRequestDto {
  int? userId;
  int? id;
  String? certificationName;
  String? issuingOrganization;
  String? credentialId;
  String? credentialUrl;
  String? startMonth;
  int? startYear;
  String? endMonth;
  int? endYear;
  String? certificate;

  CertificationRequestDto({
    this.userId,
    this.id,
    this.certificationName,
    this.issuingOrganization,
    this.credentialId,
    this.credentialUrl,
    this.startMonth,
    this.startYear,
    this.endMonth,
    this.endYear,
    this.certificate,
  });

  factory CertificationRequestDto.fromJson(Map<String, dynamic> json) {
    return CertificationRequestDto(
      userId: json['userId'],
      id: json['id'],
      certificationName: json['certificationName'],
      issuingOrganization: json['issuingOrganization'],
      credentialId: json['credentialId'],
      credentialUrl: json['credentialUrl'],
      startMonth: json['startMonth'],
      startYear: json['startYear'],
      endMonth: json['endMonth'],
      endYear: json['endYear'],
      certificate: json['certificate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'certificationName': certificationName,
      'issuingOrganization': issuingOrganization,
      'credentialId': credentialId,
      'credentialUrl': credentialUrl,
      'startMonth': startMonth,
      'startYear': startYear,
      'endMonth': endMonth,
      'endYear': endYear,
      'certificate': certificate,
    };
  }
}

class EducationRequestDto {
  int? id;
  int? userId;
  String? schoolOrCollegeName;
  String? university;
  String? degreeSpc;
  String? fieldOfStudy;
  int? startMonth;
  int? firstYear;
  int? endMonth;
  int? passingYear;
  int? isCurrent;
  int? isRemote;
  String? marksheet;

  EducationRequestDto({
    this.degreeSpc,
    this.endMonth,
    this.fieldOfStudy,
    this.firstYear,
    this.id,
    this.isCurrent,
    this.marksheet,
    this.passingYear,
    this.schoolOrCollegeName,
    this.startMonth,
    this.university,
    this.userId,
    this.isRemote,
  });

  factory EducationRequestDto.fromJson(Map<String, dynamic> json) {
    return EducationRequestDto(
        degreeSpc: json['degreeSpc'],
        endMonth: json['endMonth'],
        fieldOfStudy: json['fieldOfStudy'],
        firstYear: json['firstYear'],
        id: json['id'],
        isCurrent: json['isCurrent'],
        marksheet: json['marksheet'],
        passingYear: json['passingYear'],
        schoolOrCollegeName: json['schoolOrCollegeName'],
        startMonth: json['startMonth'],
        university: json['university'],
        userId: json['userId'],
        isRemote: json['isRemote']);
  }

  Map<String, dynamic> toJson() {
    return {
      'degreeSpc': degreeSpc,
      'endMonth': endMonth,
      'fieldOfStudy': fieldOfStudy,
      'firstYear': firstYear,
      'id': id,
      'isCurrent': isCurrent,
      'marksheet': marksheet,
      'passingYear': passingYear,
      'schoolOrCollegeName': schoolOrCollegeName,
      'startMonth': startMonth,
      'university': university,
      'userId': userId,
      'isRemote': isRemote
    };
  }
}

class ExperienceRequestDto {
  int? id;
  int? userId;
  String? jobTitle;
  String? companyName;
  String? industry;
  String? functionalArea;
  String? empType;
  String? workType;
  String? jobLocation;
  String? jobRole;
  DateTime? joiningDate;
  DateTime? lastWorkingDate;
  int? isCurrent;
  String? salary;
  String? appointmentLetter;
  String? experienceLettter; // Note: Typo in field name (as per given data)
  String? incrementLetter;
  String? offerLetter;
  String? salarySlip; // Note: Typo in field name (as per given data)
  List<String>? skillsExp;

  ExperienceRequestDto({
    this.id,
    this.userId,
    this.jobTitle,
    this.companyName,
    this.industry,
    this.functionalArea,
    this.empType,
    this.workType,
    this.jobLocation,
    this.jobRole,
    this.joiningDate,
    this.lastWorkingDate,
    this.isCurrent,
    this.salary,
    this.appointmentLetter,
    this.experienceLettter, // Note: Typo in field name (as per given data)
    this.incrementLetter,
    this.offerLetter,
    this.salarySlip, // Note: Typo in field name (as per given data)
    this.skillsExp,
  });

  factory ExperienceRequestDto.fromJson(Map<String, dynamic> json) {
    return ExperienceRequestDto(
      id: json['id'],
      userId: json['userId'],
      jobTitle: json['jobTitle'],
      companyName: json['companyName'],
      industry: json['industry'],
      functionalArea: json['functionalArea'],
      empType: json['empType'],
      workType: json['workType'],
      jobLocation: json['jobLocation'],
      jobRole: json['jobRole'],
      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'])
          : null,
      lastWorkingDate: json['lastWorkingDate'] != null
          ? DateTime.parse(json['lastWorkingDate'])
          : null,
      isCurrent: json['isCurrent'],
      salary: json['salary'],
      appointmentLetter: json['appointmentLetter'],
      experienceLettter: json[
          'experienceLettter'], // Note: Typo in field name (as per given data)
      incrementLetter: json['incrementLetter'],
      offerLetter: json['offerLetter'],
      salarySlip:
          json['salarySlip'], // Note: Typo in field name (as per given data)
      skillsExp: json['skillsExp'] != null
          ? List<String>.from(json['skillsExp'])
          : null,
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
      'jobLocation': jobLocation,
      'jobRole': jobRole,
      'joiningDate': joiningDate?.toIso8601String(),
      'lastWorkingDate': lastWorkingDate?.toIso8601String(),
      'isCurrent': isCurrent,
      'salary': salary,
      'appointmentLetter': appointmentLetter,
      'experienceLettter':
          experienceLettter, // Note: Typo in field name (as per given data)
      'incrementLetter': incrementLetter,
      'offerLetter': offerLetter,
      'salarySlip': salarySlip, // Note: Typo in field name (as per given data)
      'skillsExp': skillsExp,
    };
  }

  // CopyWith method
  ExperienceRequestDto copyWith({
    int? id,
    int? userId,
    String? jobTitle,
    String? companyName,
    String? industry,
    String? functionalArea,
    String? empType,
    String? workType,
    String? jobLocation,
    String? jobRole,
    DateTime? joiningDate,
    DateTime? lastWorkingDate,
    int? isCurrent,
    String? salary,
    String? appointmentLetter,
    String? experienceLettter, // Note: Typo in field name (as per given data)
    String? incrementLetter,
    String? offerLetter,
    String? salarySlip, // Note: Typo in field name (as per given data)
    List<String>? skillsExp,
  }) {
    return ExperienceRequestDto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobTitle: jobTitle ?? this.jobTitle,
      companyName: companyName ?? this.companyName,
      industry: industry ?? this.industry,
      functionalArea: functionalArea ?? this.functionalArea,
      empType: empType ?? this.empType,
      workType: workType ?? this.workType,
      jobLocation: jobLocation ?? this.jobLocation,
      jobRole: jobRole ?? this.jobRole,
      joiningDate: joiningDate ?? this.joiningDate,
      lastWorkingDate: lastWorkingDate ?? this.lastWorkingDate,
      isCurrent: isCurrent ?? this.isCurrent,
      salary: salary ?? this.salary,
      appointmentLetter: appointmentLetter ?? this.appointmentLetter,
      experienceLettter: experienceLettter ??
          this.experienceLettter, // Note: Typo in field name (as per given data)
      incrementLetter: incrementLetter ?? this.incrementLetter,
      offerLetter: offerLetter ?? this.offerLetter,
      salarySlip: salarySlip ??
          this.salarySlip, // Note: Typo in field name (as per given data)
      skillsExp: skillsExp ?? this.skillsExp,
    );
  }
}

/* class ExperienceRequestDto {
  int? id;
  int? userId;
  String? jobTitle;
  String? companyName;
  String? industry;
  String? functionalArea;
  String? empType;
  String? workType;
  String? jobLocation;
  String? jobRole;
  DateTime? joiningDate;
  DateTime? lastWorkingDate;
  int? isCurrent;
  String? salary;
  String? appointmentLetter;
  String? experienceLettter;
  String? incrementLetter;
  String? offerLetter;
  String? salarySlip;
  List<String>? skillsExp;

  ExperienceRequestDto({
    this.appointmentLetter,
    this.companyName,
    this.empType,
    this.experienceLettter,
    this.functionalArea,
    this.id,
    this.incrementLetter,
    this.industry,
    this.isCurrent,
    this.jobLocation,
    this.jobRole,
    this.jobTitle,
    this.joiningDate,
    this.lastWorkingDate,
    this.offerLetter,
    this.salary,
    this.salarySlip,
    this.skillsExp,
    this.userId,
    this.workType,
  });

  factory ExperienceRequestDto.fromJson(Map<String, dynamic> json) {
    return ExperienceRequestDto(
      appointmentLetter: json['appointmentLetter'],
      companyName: json['companyName'],
      empType: json['empType'],
      experienceLettter: json['experienceLettter'],
      functionalArea: json['functionalArea'],
      id: json['id'],
      incrementLetter: json['incrementLetter'],
      industry: json['industry'],
      isCurrent: json['isCurrent'],
      jobLocation: json['jobLocation'],
      jobRole: json['jobRole'],
      jobTitle: json['jobTitle'],
      joiningDate: json['joiningDate'] != null
          ? DateTime.parse(json['joiningDate'])
          : null,
      lastWorkingDate: json['lastWorkingDate'] != null
          ? DateTime.parse(json['lastWorkingDate'])
          : null,
      offerLetter: json['offerLetter'],
      // profileHeadline: json['profileHeadline'],
      salary: json['salary'],
      salarySlip: json['salarySlip'],
      skillsExp: json['skillsExp'] != null
          ? List<String>.from(json['skillsExp'])
          : null,
      userId: json['userId'],
      workType: json['workType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'appointmentLetter': appointmentLetter,
      'companyName': companyName,
      'empType': empType,
      'experienceLettter': experienceLettter,
      'functionalArea': functionalArea,
      'id': id,
      'incrementLetter': incrementLetter,
      'industry': industry,
      'isCurrent': isCurrent,
      'jobLocation': jobLocation,
      'jobRole': jobRole,
      'jobTitle': jobTitle,
      'joiningDate': joiningDate?.toIso8601String(),
      'lastWorkingDate': lastWorkingDate?.toIso8601String(),
      'offerLetter': offerLetter,
      // 'profileHeadline': profileHeadline,
      'salary': salary,
      'salarySlip': salarySlip,
      'skillsExp': skillsExp,
      'userId': userId,
      'workType': workType,
    };
  }
}
 */
/* class ProfileUpdateRequestDto {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
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
  String? cvLink;
//  DateTime? cvUpdatedDate;
  String? profilePic;
  List<String>? skills;
  String? profileHeadline;
  String? bio;

  ProfileUpdateRequestDto({
    this.cvLink,
    //  this.cvUpdatedDate,
    this.firstName,
    this.id,
    this.languages,
    this.lastName,
    this.middleName,
    this.profilePic,
    this.skills,
    this.userLocality,
    this.userLocation,
    this.profileHeadline,
    this.alternateNo,
    this.dateOfBirth,
    this.email,
    this.gender,
    this.pinCode,
    this.vaccination,
    this.vaccinationCertificate,
    this.bio,
  });

  factory ProfileUpdateRequestDto.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateRequestDto(
        cvLink: json['cvLink'],
        /*  cvUpdatedDate: json['cvUpdatedDate'] != null
          ? CvUpdatedDate.fromJson(json['cvUpdatedDate'])
          : null, */
        firstName: json['firstName'],
        id: json['id'],
        languages: json['languages'] != null
            ? List<String>.from(json['languages'])
            : null,
        lastName: json['lastName'],
        middleName: json['middleName'],
        profilePic: json['profilePic'],
        skills:
            json['skills'] != null ? List<String>.from(json['skills']) : null,
        userLocality: json['userLocality'],
        userLocation: json['userLocation'],
        profileHeadline: json['profileHeadline'],
        alternateNo: json['alternateNo'],
        // cvUpdatedDate: json['cvUpdatedDate'],
        dateOfBirth: json['dateOfBirth'],
        email: json['email'],
        gender: json['gender'],
        pinCode: json['pinCode'],
        vaccination: json['vaccination'],
        vaccinationCertificate: json['vaccinationCertificate'],
        bio: json['bio']);
  }

  Map<String, dynamic> toJson() {
    return {
      'alternateNo': alternateNo,
      //  'cvUpdatedDate': cvUpdatedDate!.toIso8601String(),
      'dateOfBirth': dateOfBirth,
      'email': email,
      'gender': gender,
      'pinCode': pinCode,
      'vaccination': vaccination,
      'vaccinationCertificate': vaccinationCertificate,
      'cvLink': cvLink,
      // 'cvUpdatedDate': cvUpdatedDate?.toJson(),
      'firstName': firstName,
      'id': id,
      'languages': languages,
      'lastName': lastName,
      'middleName': middleName,
      'profilePic': profilePic,
      'skills': skills,
      'userLocality': userLocality,
      'userLocation': userLocation,
      'profileHeadline': profileHeadline,
      'bio': bio,
    };
  }
}
 */

class ProfileUpdateRequestDto {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
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
  String? cvLink;
  // DateTime? cvUpdatedDate;
  String? profilePic;
  List<String>? skills;
  String? profileHeadline;
  String? bio;
 /*  int? experience;
  int? education; */

  ProfileUpdateRequestDto({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.alternateNo,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.userLocality,
    this.userLocation,
    this.pinCode,
    this.languages,
    this.vaccination,
    this.vaccinationCertificate,
    this.cvLink,
    // this.cvUpdatedDate,
    this.profilePic,
    this.skills,
    this.profileHeadline,
    this.bio,
  /*   this.experience,
    this.education */
  });

  factory ProfileUpdateRequestDto.fromJson(Map<String, dynamic> json) {
    return ProfileUpdateRequestDto(
      id: json['id'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      alternateNo: json['alternateNo'],
      email: json['email'],
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      userLocality: json['userLocality'],
      userLocation: json['userLocation'],
      pinCode: json['pinCode'],
      languages: json['languages'] != null
          ? List<String>.from(json['languages'])
          : null,
      vaccination: json['vaccination'],
      vaccinationCertificate: json['vaccinationCertificate'],
      cvLink: json['cvLink'],
      // cvUpdatedDate: json['cvUpdatedDate'] != null
      //     ? DateTime.parse(json['cvUpdatedDate'])
      //     : null,
      profilePic: json['profilePic'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : null,
      profileHeadline: json['profileHeadline'],
      bio: json['bio'],
     /*  education: json['education'],
      experience: json['experience'] */
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'alternateNo': alternateNo,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'userLocality': userLocality,
      'userLocation': userLocation,
      'pinCode': pinCode,
      'languages': languages,
      'vaccination': vaccination,
      'vaccinationCertificate': vaccinationCertificate,
      'cvLink': cvLink,
      // 'cvUpdatedDate': cvUpdatedDate?.toIso8601String(),
      'profilePic': profilePic,
      'skills': skills,
      'profileHeadline': profileHeadline,
      'bio': bio,
    /*   'experience': experience,
      'education': education */
    };
  }

  // CopyWith method
  ProfileUpdateRequestDto copyWith({
    int? id,
    String? firstName,
    String? middleName,
    String? lastName,
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
    String? cvLink,
    // DateTime? cvUpdatedDate,
    String? profilePic,
    List<String>? skills,
    String? profileHeadline,
    String? bio,
  /*   int? education,
    int? experience, */
  }) {
    return ProfileUpdateRequestDto(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      alternateNo: alternateNo ?? this.alternateNo,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      userLocality: userLocality ?? this.userLocality,
      userLocation: userLocation ?? this.userLocation,
      pinCode: pinCode ?? this.pinCode,
      languages: languages ?? this.languages,
      vaccination: vaccination ?? this.vaccination,
      vaccinationCertificate:
          vaccinationCertificate ?? this.vaccinationCertificate,
      cvLink: cvLink ?? this.cvLink,
      // cvUpdatedDate: cvUpdatedDate ?? this.cvUpdatedDate,
      profilePic: profilePic ?? this.profilePic,
      skills: skills ?? this.skills,
      profileHeadline: profileHeadline ?? this.profileHeadline,
      bio: bio ?? this.bio,
     /*  experience: experience??this.experience,
      education: education??this.education */
    );
  }
}

class CvUpdatedDate {
  int? date;
  int? hours;
  int? minutes;
  int? month;
  int? nanos;
  int? seconds;
  int? time;
  int? year;

  CvUpdatedDate({
    this.date,
    this.hours,
    this.minutes,
    this.month,
    this.nanos,
    this.seconds,
    this.time,
    this.year,
  });

  factory CvUpdatedDate.fromJson(Map<String, dynamic> json) {
    return CvUpdatedDate(
      date: json['date'],
      hours: json['hours'],
      minutes: json['minutes'],
      month: json['month'],
      nanos: json['nanos'],
      seconds: json['seconds'],
      time: json['time'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'hours': hours,
      'minutes': minutes,
      'month': month,
      'nanos': nanos,
      'seconds': seconds,
      'time': time,
      'year': year,
    };
  }
}
