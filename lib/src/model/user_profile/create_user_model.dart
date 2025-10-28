class CreateNewUserModel {
  final List<CertificationRequest>? certificationsRequest;
  final List<EducationRequest>? educationRequest;
  final List<ExperienceRequest>? experienceRequest;
  final List<UserProjectRequest>? userProjectRequest;
  final UserRequest? userRequest;

  CreateNewUserModel({
    this.certificationsRequest,
    this.educationRequest,
    this.experienceRequest,
    this.userRequest,
    this.userProjectRequest,
  });

  CreateNewUserModel copyWith({
    List<CertificationRequest>? certificationsRequest,
    List<EducationRequest>? educationRequest,
    List<ExperienceRequest>? experienceRequest,
    List<UserProjectRequest>? userProjectRequest,
    UserRequest? userRequest,
  }) {
    return CreateNewUserModel(
      certificationsRequest:
          certificationsRequest ?? this.certificationsRequest,
      educationRequest: educationRequest ?? this.educationRequest,
      experienceRequest: experienceRequest ?? this.experienceRequest,
      userProjectRequest: userProjectRequest ?? this.userProjectRequest,
      userRequest: userRequest ?? this.userRequest,
    );
  }

  factory CreateNewUserModel.fromJson(Map<String, dynamic> json) {
    return CreateNewUserModel(
      certificationsRequest: (json['certificationsRequest'] as List?)
          ?.map((e) => CertificationRequest.fromJson(e))
          .toList(),
      educationRequest: (json['educationRequest'] as List?)
          ?.map((e) => EducationRequest.fromJson(e))
          .toList(),
      experienceRequest: (json['experienceRequest'] as List?)
          ?.map((e) => ExperienceRequest.fromJson(e))
          .toList(),
      userProjectRequest: (json['userProjectRequest'] as List?)
          ?.map((e) => UserProjectRequest.fromJson(e))
          .toList(),
      userRequest: json['userRequest'] != null
          ? UserRequest.fromJson(json['userRequest'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "certificationsRequest": certificationsRequest
          ?.map((e) => e.toJson())
          .toList(),
      "educationRequest": educationRequest?.map((e) => e.toJson()).toList(),
      "experienceRequest": experienceRequest?.map((e) => e.toJson()).toList(),
      'userProjectRequest': userProjectRequest?.map((e) => e.toJson()).toList(),
      "userRequest": userRequest?.toJson(),
    };
  }
}

class CertificationRequest {
  final String? certificate;
  final int? certificateId;
  final String? certificationName;
  final String? credentialId;
  final String? credentialUrl;
  final String? endMonth;
  final int? endYear;
  final String? expirationDate;
  final int? id;
  final String? issueDate;
  final String? issuingOrganization;
  final String? startMonth;
  final int? startYear;
  final int? userId;

  CertificationRequest({
    this.certificate,
    this.certificateId,
    this.certificationName,
    this.credentialId,
    this.credentialUrl,
    this.endMonth,
    this.endYear,
    this.expirationDate,
    this.id,
    this.issueDate,
    this.issuingOrganization,
    this.startMonth,
    this.startYear,
    this.userId,
  });

  CertificationRequest copyWith({
    String? certificate,
    int? certificateId,
    String? certificationName,
    String? credentialId,
    String? credentialUrl,
    String? endMonth,
    int? endYear,
    String? expirationDate,
    int? id,
    String? issueDate,
    String? issuingOrganization,
    String? startMonth,
    int? startYear,
    int? userId,
  }) {
    return CertificationRequest(
      certificate: certificate ?? this.certificate,
      certificateId: certificateId ?? this.certificateId,
      certificationName: certificationName ?? this.certificationName,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
      endMonth: endMonth ?? this.endMonth,
      endYear: endYear ?? this.endYear,
      expirationDate: expirationDate ?? this.expirationDate,
      id: id ?? this.id,
      issueDate: issueDate ?? this.issueDate,
      issuingOrganization: issuingOrganization ?? this.issuingOrganization,
      startMonth: startMonth ?? this.startMonth,
      startYear: startYear ?? this.startYear,
      userId: userId ?? this.userId,
    );
  }

  factory CertificationRequest.fromJson(Map<String, dynamic> json) {
    return CertificationRequest(
      certificate: json['certificate'],
      certificateId: json['certificateId'],
      certificationName: json['certificationName'],
      credentialId: json['credentialId'],
      credentialUrl: json['credentialUrl'],
      endMonth: json['endMonth'],
      endYear: json['endYear'],
      expirationDate: json['expirationDate'],
      id: json['id'],
      issueDate: json['issueDate'],
      issuingOrganization: json['issuingOrganization'],
      startMonth: json['startMonth'],
      startYear: json['startYear'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "certificate": certificate,
      "certificateId": certificateId,
      "certificationName": certificationName,
      "credentialId": credentialId,
      "credentialUrl": credentialUrl,
      "endMonth": endMonth,
      "endYear": endYear,
      "expirationDate": expirationDate,
      "id": id,
      "issueDate": issueDate,
      "issuingOrganization": issuingOrganization,
      "startMonth": startMonth,
      "startYear": startYear,
      "userId": userId,
    };
  }
}

class EducationRequest {
  final String? degreeSpc;
  final int? endMonth;
  final String? fieldOfStudy;
  final int? firstYear;
  final int? id;
  final int? isCurrent;
  final int? isRemote;
  final String? marksheet;
  final int? passingYear;
  final String? schoolOrCollegeName;
  final int? startMonth;
  final String? university;
  final int? userId;

  EducationRequest({
    this.degreeSpc,
    this.endMonth,
    this.fieldOfStudy,
    this.firstYear,
    this.id,
    this.isCurrent,
    this.isRemote,
    this.marksheet,
    this.passingYear,
    this.schoolOrCollegeName,
    this.startMonth,
    this.university,
    this.userId,
  });

  EducationRequest copyWith({
    String? degreeSpc,
    int? endMonth,
    String? fieldOfStudy,
    int? firstYear,
    int? id,
    int? isCurrent,
    int? isRemote,
    String? marksheet,
    int? passingYear,
    String? schoolOrCollegeName,
    int? startMonth,
    String? university,
    int? userId,
  }) {
    return EducationRequest(
      degreeSpc: degreeSpc ?? this.degreeSpc,
      endMonth: endMonth ?? this.endMonth,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      firstYear: firstYear ?? this.firstYear,
      id: id ?? this.id,
      isCurrent: isCurrent ?? this.isCurrent,
      isRemote: isRemote ?? this.isRemote,
      marksheet: marksheet ?? this.marksheet,
      passingYear: passingYear ?? this.passingYear,
      schoolOrCollegeName: schoolOrCollegeName ?? this.schoolOrCollegeName,
      startMonth: startMonth ?? this.startMonth,
      university: university ?? this.university,
      userId: userId ?? this.userId,
    );
  }

  factory EducationRequest.fromJson(Map<String, dynamic> json) {
    return EducationRequest(
      degreeSpc: json['degreeSpc'],
      endMonth: json['endMonth'],
      fieldOfStudy: json['fieldOfStudy'],
      firstYear: json['firstYear'],
      id: json['id'],
      isCurrent: json['isCurrent'],
      isRemote: json['isRemote'],
      marksheet: json['marksheet'],
      passingYear: json['passingYear'],
      schoolOrCollegeName: json['schoolOrCollegeName'],
      startMonth: json['startMonth'],
      university: json['university'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "degreeSpc": degreeSpc,
      "endMonth": endMonth,
      "fieldOfStudy": fieldOfStudy,
      "firstYear": firstYear,
      "id": id,
      "isCurrent": isCurrent,
      "isRemote": isRemote,
      "marksheet": marksheet,
      "passingYear": passingYear,
      "schoolOrCollegeName": schoolOrCollegeName,
      "startMonth": startMonth,
      "university": university,
      "userId": userId,
    };
  }
}

class ExperienceRequest {
  final String? appointmentLetter;
  final int? companyId;
  final String? companyName;
  final String? empType;
  final String? experienceLettter;
  final String? functionalArea;
  final int? id;
  final String? incrementLetter;
  final String? industry;
  final int? isCurrent;
  final String? jobLocation;
  final String? jobRole;
  final String? jobTitle;
  final String? joiningDate;
  final String? lastWorkingDate;
  final String? offerLetter;
  final String? salary;
  final String? salarySlip;
  final List<String>? skillsExp;
  final int? userId;
  final String? workType;

  ExperienceRequest({
    this.appointmentLetter,
    this.companyId,
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

  ExperienceRequest copyWith({
    String? appointmentLetter,
    int? companyId,
    String? companyName,
    String? empType,
    String? experienceLettter,
    String? functionalArea,
    int? id,
    String? incrementLetter,
    String? industry,
    int? isCurrent,
    String? jobLocation,
    String? jobRole,
    String? jobTitle,
    String? joiningDate,
    String? lastWorkingDate,
    String? offerLetter,
    String? salary,
    String? salarySlip,
    List<String>? skillsExp,
    int? userId,
    String? workType,
  }) {
    return ExperienceRequest(
      appointmentLetter: appointmentLetter ?? this.appointmentLetter,
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      empType: empType ?? this.empType,
      experienceLettter: experienceLettter ?? this.experienceLettter,
      functionalArea: functionalArea ?? this.functionalArea,
      id: id ?? this.id,
      incrementLetter: incrementLetter ?? this.incrementLetter,
      industry: industry ?? this.industry,
      isCurrent: isCurrent ?? this.isCurrent,
      jobLocation: jobLocation ?? this.jobLocation,
      jobRole: jobRole ?? this.jobRole,
      jobTitle: jobTitle ?? this.jobTitle,
      joiningDate: joiningDate ?? this.joiningDate,
      lastWorkingDate: lastWorkingDate ?? this.lastWorkingDate,
      offerLetter: offerLetter ?? this.offerLetter,
      salary: salary ?? this.salary,
      salarySlip: salarySlip ?? this.salarySlip,
      skillsExp: skillsExp ?? this.skillsExp,
      userId: userId ?? this.userId,
      workType: workType ?? this.workType,
    );
  }

  factory ExperienceRequest.fromJson(Map<String, dynamic> json) {
    return ExperienceRequest(
      appointmentLetter: json['appointmentLetter'],
      companyId: json['companyId'],
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
      joiningDate: json['joiningDate'],
      lastWorkingDate: json['lastWorkingDate'],
      offerLetter: json['offerLetter'],
      salary: json['salary'],
      salarySlip: json['salarySlip'],
      skillsExp: (json['skillsExp'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      userId: json['userId'],
      workType: json['workType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "appointmentLetter": appointmentLetter,
      "companyId": companyId,
      "companyName": companyName,
      "empType": empType,
      "experienceLettter": experienceLettter,
      "functionalArea": functionalArea,
      "id": id,
      "incrementLetter": incrementLetter,
      "industry": industry,
      "isCurrent": isCurrent,
      "jobLocation": jobLocation,
      "jobRole": jobRole,
      "jobTitle": jobTitle,
      "joiningDate": joiningDate,
      "lastWorkingDate": lastWorkingDate,
      "offerLetter": offerLetter,
      "salary": salary,
      "salarySlip": salarySlip,
      "skillsExp": skillsExp,
      "userId": userId,
      "workType": workType,
    };
  }
}

class UserRequest {
  final int? alternateNo;
  final String? bio;
  final int? block;
  final String? bloodGroup;
  final String? coverPic;
  final String? cvLink;
  final CvUpdatedDate? cvUpdatedDate;
  final String? dateOfBirth;
  final int? education;
  final String? email;
  final int? experience;
  final String? firstName;
  final String? gender;
  final List<String>? languages;
  final String? lastName;
  final String? loginType;
  final String? martialStatus;
  final String? middleName;
  final int? mobile;
  final int? otp;
  final int? otpExpirationTime;
  final OtpTimestamp? otpTimestamp;
  final String? pinCode;
  final String? profileHeadline;
  final String? profilePic;
  final int? reportTo;
  final int? role;
  final List<String>? skills;
  final int? userId;
  final String? userLocality;
  final String? userLocation;
  final int? userType;
  final String? userZone;
  final bool? vaccination;
  final String? vaccinationCertificate;

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
    this.profileHeadline,
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

  UserRequest copyWith({
    int? alternateNo,
    String? bio,
    int? block,
    String? bloodGroup,
    String? coverPic,
    String? cvLink,
    CvUpdatedDate? cvUpdatedDate,
    String? dateOfBirth,
    int? education,
    String? email,
    int? experience,
    String? firstName,
    String? gender,
    List<String>? languages,
    String? lastName,
    String? loginType,
    String? martialStatus,
    String? middleName,
    int? mobile,
    int? otp,
    int? otpExpirationTime,
    OtpTimestamp? otpTimestamp,
    String? pinCode,
    String? profileHeadline,
    String? profilePic,
    int? reportTo,
    int? role,
    List<String>? skills,
    int? userId,
    String? userLocality,
    String? userLocation,
    int? userType,
    String? userZone,
    bool? vaccination,
    String? vaccinationCertificate,
  }) {
    return UserRequest(
      alternateNo: alternateNo ?? this.alternateNo,
      bio: bio ?? this.bio,
      block: block ?? this.block,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      coverPic: coverPic ?? this.coverPic,
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
      loginType: loginType ?? this.loginType,
      martialStatus: martialStatus ?? this.martialStatus,
      middleName: middleName ?? this.middleName,
      mobile: mobile ?? this.mobile,
      otp: otp ?? this.otp,
      otpExpirationTime: otpExpirationTime ?? this.otpExpirationTime,
      otpTimestamp: otpTimestamp ?? this.otpTimestamp,
      pinCode: pinCode ?? this.pinCode,
      profileHeadline: profileHeadline ?? this.profileHeadline,
      profilePic: profilePic ?? this.profilePic,
      reportTo: reportTo ?? this.reportTo,
      role: role ?? this.role,
      skills: skills ?? this.skills,
      userId: userId ?? this.userId,
      userLocality: userLocality ?? this.userLocality,
      userLocation: userLocation ?? this.userLocation,
      userType: userType ?? this.userType,
      userZone: userZone ?? this.userZone,
      vaccination: vaccination ?? this.vaccination,
      vaccinationCertificate:
          vaccinationCertificate ?? this.vaccinationCertificate,
    );
  }

  factory UserRequest.fromJson(Map<String, dynamic> json) {
    return UserRequest(
      alternateNo: json['alternateNo'],
      bio: json['bio'],
      block: json['block'],
      bloodGroup: json['bloodGroup'],
      coverPic: json['coverPic'],
      cvLink: json['cvLink'],
      cvUpdatedDate: json['cvUpdatedDate'] != null
          ? CvUpdatedDate.fromJson(json['cvUpdatedDate'])
          : null,
      dateOfBirth: json['dateOfBirth'],
      education: json['education'],
      email: json['email'],
      experience: json['experience'],
      firstName: json['firstName'],
      gender: json['gender'],
      languages: (json['languages'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      lastName: json['lastName'],
      loginType: json['loginType'],
      martialStatus: json['martialStatus'],
      middleName: json['middleName'],
      mobile: json['mobile'],
      otp: json['otp'],
      otpExpirationTime: json['otpExpirationTime'],
      otpTimestamp: json['otpTimestamp'] != null
          ? OtpTimestamp.fromJson(json['otpTimestamp'])
          : null,
      pinCode: json['pinCode'],
      profileHeadline: json['profileHeadline'],
      profilePic: json['profilePic'],
      reportTo: json['reportTo'],
      role: json['role'],
      skills: (json['skills'] as List?)?.map((e) => e.toString()).toList(),
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
      "alternateNo": alternateNo,
      "bio": bio,
      "block": block,
      "bloodGroup": bloodGroup,
      "coverPic": coverPic,
      "cvLink": cvLink,
      "cvUpdatedDate": cvUpdatedDate?.toJson(),
      "dateOfBirth": dateOfBirth,
      "education": education,
      "email": email,
      "experience": experience,
      "firstName": firstName,
      "gender": gender,
      "languages": languages,
      "lastName": lastName,
      "loginType": loginType,
      "martialStatus": martialStatus,
      "middleName": middleName,
      "mobile": mobile,
      "otp": otp,
      "otpExpirationTime": otpExpirationTime,
      "otpTimestamp": otpTimestamp?.toJson(),
      "pinCode": pinCode,
      "profileHeadline": profileHeadline,
      "profilePic": profilePic,
      "reportTo": reportTo,
      "role": role,
      "skills": skills,
      "userId": userId,
      "userLocality": userLocality,
      "userLocation": userLocation,
      "userType": userType,
      "userZone": userZone,
      "vaccination": vaccination,
      "vaccinationCertificate": vaccinationCertificate,
    };
  }
}

class CvUpdatedDate {
  final int? date;
  final int? hours;
  final int? minutes;
  final int? month;
  final int? nanos;
  final int? seconds;
  final int? time;
  final int? year;

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

  CvUpdatedDate copyWith({
    int? date,
    int? hours,
    int? minutes,
    int? month,
    int? nanos,
    int? seconds,
    int? time,
    int? year,
  }) {
    return CvUpdatedDate(
      date: date ?? this.date,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      month: month ?? this.month,
      nanos: nanos ?? this.nanos,
      seconds: seconds ?? this.seconds,
      time: time ?? this.time,
      year: year ?? this.year,
    );
  }

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
      "date": date,
      "hours": hours,
      "minutes": minutes,
      "month": month,
      "nanos": nanos,
      "seconds": seconds,
      "time": time,
      "year": year,
    };
  }
}

class OtpTimestamp {
  final int? date;
  final int? hours;
  final int? minutes;
  final int? month;
  final int? nanos;
  final int? seconds;
  final int? time;
  final int? year;

  OtpTimestamp({
    this.date,
    this.hours,
    this.minutes,
    this.month,
    this.nanos,
    this.seconds,
    this.time,
    this.year,
  });

  OtpTimestamp copyWith({
    int? date,
    int? hours,
    int? minutes,
    int? month,
    int? nanos,
    int? seconds,
    int? time,
    int? year,
  }) {
    return OtpTimestamp(
      date: date ?? this.date,
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      month: month ?? this.month,
      nanos: nanos ?? this.nanos,
      seconds: seconds ?? this.seconds,
      time: time ?? this.time,
      year: year ?? this.year,
    );
  }

  factory OtpTimestamp.fromJson(Map<String, dynamic> json) {
    return OtpTimestamp(
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
      "date": date,
      "hours": hours,
      "minutes": minutes,
      "month": month,
      "nanos": nanos,
      "seconds": seconds,
      "time": time,
      "year": year,
    };
  }
}

class UserProjectRequest {
  final String? description;
  final String? duration;
  final String? itSkillsByProject;
  final String? projectTitle;
  final String? role;
  final List<String>? technologiesUsed;
  final String? url;
  final int? id;

  UserProjectRequest({
    this.description,
    this.duration,
    this.itSkillsByProject,
    this.projectTitle,
    this.role,
    this.technologiesUsed,
    this.url,
    this.id,
  });

  /// ✅ copyWith for immutability
  UserProjectRequest copyWith({
    String? description,
    String? duration,
    String? itSkillsByProject,
    String? projectTitle,
    String? role,
    List<String>? technologiesUsed,
    String? url,
    int? id,
  }) {
    return UserProjectRequest(
      description: description ?? this.description,
      duration: duration ?? this.duration,
      itSkillsByProject: itSkillsByProject ?? this.itSkillsByProject,
      projectTitle: projectTitle ?? this.projectTitle,
      role: role ?? this.role,
      technologiesUsed: technologiesUsed ?? this.technologiesUsed,
      url: url ?? this.url,
      id: id ?? this.id,
    );
  }

  /// ✅ From JSON
  factory UserProjectRequest.fromJson(Map<String, dynamic> json) {
    return UserProjectRequest(
      description: json['Description'] as String?,
      duration: json['Duration'] as String?,
      itSkillsByProject: json['ITSkillsByProject'] as String?,
      projectTitle: json['ProjectTitle'] as String?,
      role: json['Role'] as String?,
      technologiesUsed: (json['TechnologiesUsed'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      url: json['URL'] as String?,
      id: json['id'] as int?,
    );
  }

  /// ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      'Description': description,
      'Duration': duration,
      'ITSkillsByProject': itSkillsByProject,
      'ProjectTitle': projectTitle,
      'Role': role,
      'TechnologiesUsed': technologiesUsed,
      'URL': url,
      'id': id,
    };
  }
}
