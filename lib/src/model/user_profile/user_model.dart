class ProfileModel {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? userLocation;
  String? userLocality;
  String? profilePic;
  String? bio;
  List<String>? languagesKnown;
  List<String>? profileSkills;
  List<String>? allSkills;
  String? profileHeadline;
  int? mobile;
  int? alternateNo;
  String? gmail;
  String? gender;
  String? dob;
  String? userFullLocation;
  String? pinCode;
  dynamic vaccinationCertificate;
  bool? vaccination;
  String? resume;
  bool? isActive;
  String? experience;
  dynamic education;
  List<Experience>? experiences;
  List<EducationDetail>? educationDetails;
  List<CertificationDetailModel>? certifications;
  List<ProjectModel>? projects;

  ProfileModel({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.userLocation,
    this.userLocality,
    this.profilePic,
    this.bio,
    this.languagesKnown,
    this.profileSkills,
    this.allSkills,
    this.profileHeadline,
    this.mobile,
    this.alternateNo,
    this.gmail,
    this.gender,
    this.dob,
    this.userFullLocation,
    this.pinCode,
    this.vaccinationCertificate,
    this.vaccination,
    this.resume,
    this.isActive,
    this.experience,
    this.education,
    this.experiences,
    this.educationDetails,
    this.certifications,
    this.projects,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    id: json["id"],
    firstName: json["firstName"],
    middleName: json["middleName"],
    lastName: json["lastName"],
    userLocation: json["userLocation"],
    userLocality: json["userLocality"],
    profilePic: json["profilePic"],
    bio: json["bio"],
    languagesKnown: json["languagesKnown"] == null
        ? []
        : List<String>.from(json["languagesKnown"].map((x) => x)),
    profileSkills: json["profileSkills"] == null
        ? []
        : List<String>.from(json["profileSkills"].map((x) => x)),
    allSkills: json["allSkills"] == null
        ? []
        : List<String>.from(json["allSkills"].map((x) => x)),
    profileHeadline: json["profileHeadline"],
    mobile: json["mobile"],
    alternateNo: json["alternateNo"],
    gmail: json["gmail"],
    gender: json["gender"],
    dob: json["dob"],
    userFullLocation: json["userFullLocation"],
    pinCode: json["pinCode"],
    vaccinationCertificate: json["vaccination_certificate"],
    vaccination: json["vaccination"],
    resume: json["resume"],
    isActive: json["isActive"],
    experience: json["experience"],
    education: json["education"],
    experiences: json["experiences"] == null
        ? []
        : List<Experience>.from(
            json["experiences"].map((x) => Experience.fromJson(x)),
          ),
    educationDetails: json["educationDetails"] == null
        ? []
        : List<EducationDetail>.from(
            json["educationDetails"].map((x) => EducationDetail.fromJson(x)),
          ),
    certifications: json["certifications"] == null
        ? []
        : List<CertificationDetailModel>.from(
            json["certifications"].map(
              (x) => CertificationDetailModel.fromJson(x),
            ),
          ),
    projects: json['projects'] == null
        ? []
        : List<ProjectModel>.from(
            json['projects'].map((e) => ProjectModel.fromJson(e)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "middleName": middleName,
    "lastName": lastName,
    "userLocation": userLocation,
    "userLocality": userLocality,
    "profilePic": profilePic,
    "bio": bio,
    "languagesKnown": languagesKnown == null
        ? []
        : List<dynamic>.from(languagesKnown!.map((x) => x)),
    "profileSkills": profileSkills == null
        ? []
        : List<dynamic>.from(profileSkills!.map((x) => x)),
    "allSkills": allSkills == null
        ? []
        : List<dynamic>.from(allSkills!.map((x) => x)),
    "profileHeadline": profileHeadline,
    "mobile": mobile,
    "alternateNo": alternateNo,
    "gmail": gmail,
    "gender": gender,
    "dob": dob,
    "userFullLocation": userFullLocation,
    "pinCode": pinCode,
    "vaccination_certificate": vaccinationCertificate,
    "vaccination": vaccination,
    "resume": resume,
    "isActive": isActive,
    "experience": experience,
    "education": education,
    "experiences": experiences == null
        ? []
        : List<dynamic>.from(experiences!.map((x) => x.toJson())),
    "educationDetails": educationDetails == null
        ? []
        : List<dynamic>.from(educationDetails!.map((x) => x.toJson())),
    "certifications": certifications == null
        ? []
        : List<dynamic>.from(certifications!.map((x) => x.toJson())),
  };
}

class Experience {
  int? id;
  String? jobTitle;
  String? companyName;
  int? companyId;
  String? jobRole;
  String? workType;
  String? salary;
  String? joiningDate;
  String? lastWorkingDate;
  String? empType;
  int? isCurrent;
  String? jobLocation;
  String? workingPeriod;
  String? companyLogo;
  String? workingCompany;
  List<String>? skillsExp;
  String? offerletter;
  String? increamentLetter;
  String? appointmentLetter;
  String? salarySlip;
  String? expLetter;
  String? industry;
  String? functionalArea;

  Experience({
    this.id,
    this.jobTitle,
    this.companyName,
    this.companyId,
    this.jobRole,
    this.workType,
    this.salary,
    this.joiningDate,
    this.lastWorkingDate,
    this.empType,
    this.isCurrent,
    this.jobLocation,
    this.workingPeriod,
    this.companyLogo,
    this.workingCompany,
    this.skillsExp,
    this.offerletter,
    this.increamentLetter,
    this.appointmentLetter,
    this.salarySlip,
    this.expLetter,
    this.industry,
    this.functionalArea,
  });

  factory Experience.fromJson(Map<String, dynamic> json) => Experience(
    id: json["id"],
    jobTitle: json["jobTitle"],
    companyName: json["companyName"],
    companyId: json["companyId"],
    jobRole: json["jobRole"],
    workType: json["workType"],
    salary: json["salary"],
    joiningDate: json["joiningDate"],
    lastWorkingDate: json["lastWorkingDate"],
    empType: json["empType"],
    isCurrent: json["isCurrent"],
    jobLocation: json["jobLocation"],
    workingPeriod: json["workingPeriod"],
    companyLogo: json["companyLogo"],
    workingCompany: json["workingCompany"],
    skillsExp: json["skillsExp"] == null
        ? []
        : List<String>.from(json["skillsExp"].map((x) => x)),
    offerletter: json["offerletter"],
    increamentLetter: json["increamentLetter"],
    appointmentLetter: json["appointmentLetter"],
    salarySlip: json["salarySlip"],
    expLetter: json["expLetter"],
    industry: json["industry"],
    functionalArea: json["functionalArea"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "jobTitle": jobTitle,
    "companyName": companyName,
    "companyId": companyId,
    "jobRole": jobRole,
    "workType": workType,
    "salary": salary,
    "joiningDate": joiningDate,
    "lastWorkingDate": lastWorkingDate,
    "empType": empType,
    "isCurrent": isCurrent,
    "jobLocation": jobLocation,
    "workingPeriod": workingPeriod,
    "companyLogo": companyLogo,
    "workingCompany": workingCompany,
    "skillsExp": skillsExp == null
        ? []
        : List<dynamic>.from(skillsExp!.map((x) => x)),
    "offerletter": offerletter,
    "increamentLetter": increamentLetter,
    "appointmentLetter": appointmentLetter,
    "salarySlip": salarySlip,
    "expLetter": expLetter,
    "industry": industry,
    "functionalArea": functionalArea,
  };
}

class EducationDetail {
  int? id;
  String? university;
  String? fieldOfStudy;
  int? firstYear;
  int? passingYear;
  int? isCurrent;
  String? educationPeriod;
  String? startMonth;
  String? endMonth;
  String? schoolOrCollegeName;
  String? marksheet;
  String? degreeSpc;
  String? universityLogo;
  int? isRemote;

  EducationDetail({
    this.id,
    this.university,
    this.fieldOfStudy,
    this.firstYear,
    this.passingYear,
    this.isCurrent,
    this.educationPeriod,
    this.startMonth,
    this.endMonth,
    this.schoolOrCollegeName,
    this.marksheet,
    this.degreeSpc,
    this.universityLogo,
    this.isRemote,
  });

  factory EducationDetail.fromJson(Map<String, dynamic> json) =>
      EducationDetail(
        id: json["id"],
        university: json["university"],
        fieldOfStudy: json["fieldOfStudy"],
        firstYear: json["firstYear"],
        passingYear: json["passingYear"],
        isCurrent: json["isCurrent"],
        educationPeriod: json["educationPeriod"],
        startMonth: json["startMonth"],
        endMonth: json["endMonth"],
        schoolOrCollegeName: json["schoolOrCollegeName"],
        marksheet: json["marksheet"],
        degreeSpc: json["degree_spc"],
        universityLogo: json["universityLogo"],
        isRemote: json["isRemote"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "university": university,
    "fieldOfStudy": fieldOfStudy,
    "firstYear": firstYear,
    "passingYear": passingYear,
    "isCurrent": isCurrent,
    "educationPeriod": educationPeriod,
    "startMonth": startMonth,
    "endMonth": endMonth,
    "schoolOrCollegeName": schoolOrCollegeName,
    "marksheet": marksheet,
    "degree_spc": degreeSpc,
    "universityLogo": universityLogo,
    "isRemote": isRemote,
  };
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

  factory CertificationDetailModel.fromJson(Map<String, dynamic> json) =>
      CertificationDetailModel(
        id: json["id"],
        certificationName: json["certificationName"],
        issuingOrganization: json["issuingOrganization"],
        issueDate: json["issueDate"],
        expirationDate: json["expirationDate"],
        certificate: json["certificate"],
        credentialId: json["credentialId"],
        credentialUrl: json["credentialUrl"],
        startMonth: json["StartMonth"],
        endMonth: json["EndMonth"],
        startYear: json["startYear"],
        endYear: json["endYear"],
        certLogo: json["certLogo"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "certificationName": certificationName,
    "issuingOrganization": issuingOrganization,
    "issueDate": issueDate,
    "expirationDate": expirationDate,
    "certificate": certificate,
    "credentialId": credentialId,
    "credentialUrl": credentialUrl,
    "StartMonth": startMonth,
    "EndMonth": endMonth,
    "startYear": startYear,
    "endYear": endYear,
    "certLogo": certLogo,
  };
}

class ProjectModel {
  final String? description;
  final String? duration;
  final String? itSkillsByProject;
  final String? projectTitle;
  final String? role;
  final List<String>? technologiesUsed;
  final String? url;
  final int? id;

  ProjectModel({
    this.description,
    this.duration,
    this.itSkillsByProject,
    this.projectTitle,
    this.role,
    this.technologiesUsed,
    this.url,
    this.id,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
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
