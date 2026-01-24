class OnBoardCvParseModel {
  String? summary;
  String? firstName;
  String? middleName;
  String? lastName;
  String? email;
  String? mobileNumber;
  String? alternateNumber;
  String? gender;
  String? dateOfBirth;
  String? locationLocality;
  String? locationCity;
  String? pinCode;
  String? educationLevel;
  List<OnBoardCvParseEducation>? education;
  List<OnBoardCvParseExperience>? experience;
  List<OnBoardCvParseProject>? projects;
  OnBoardCvParseSkills? skills;
  List<OnBoardCvParseCertification>? certifications;
  OnBoardCvParseLanguages? languages;

  OnBoardCvParseModel({
    this.summary,
    this.firstName,
    this.middleName,
    this.lastName,
    this.email,
    this.mobileNumber,
    this.alternateNumber,
    this.gender,
    this.dateOfBirth,
    this.locationLocality,
    this.locationCity,
    this.pinCode,
    this.educationLevel,
    this.education,
    this.experience,
    this.projects,
    this.skills,
    this.certifications,
    this.languages,
  });

  factory OnBoardCvParseModel.fromJson(Map<String, dynamic> json) {
    return OnBoardCvParseModel(
      summary: json['Summary'],
      firstName: json['firstName'],
      middleName: json['middleName'],
      lastName: json['lastName'],
      email: json['Email'],
      mobileNumber: json['MobileNumber'],
      alternateNumber: json['AlternateNumber'],
      gender: json['Gender'],
      dateOfBirth: json['DateOfBirth'],
      locationLocality: json['LocationLocality'],
      locationCity: json['LocationCity'],
      pinCode: json['PinCode'],
      educationLevel: json['EducationLevel'],
      education: (json['Education'] as List<dynamic>?)
          ?.map((e) => OnBoardCvParseEducation.fromJson(e))
          .toList(),
      experience: (json['Experience'] as List<dynamic>?)
          ?.map((e) => OnBoardCvParseExperience.fromJson(e))
          .toList(),
      projects: (json['Projects'] as List<dynamic>?)
          ?.map((e) => OnBoardCvParseProject.fromJson(e))
          .toList(),
      skills: json['Skills'] != null
          ? OnBoardCvParseSkills.fromJson(json['Skills'])
          : null,
      certifications: (json['Certifications'] as List<dynamic>?)
          ?.map((e) => OnBoardCvParseCertification.fromJson(e))
          .toList(),
      languages: json['Languages'] != null
          ? OnBoardCvParseLanguages.fromJson(json['Languages'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Summary': summary,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'Email': email,
      'MobileNumber': mobileNumber,
      'AlternateNumber': alternateNumber,
      'Gender': gender,
      'DateOfBirth': dateOfBirth,
      'LocationLocality': locationLocality,
      'LocationCity': locationCity,
      'PinCode': pinCode,
      'EducationLevel': educationLevel,
      'Education': education?.map((e) => e.toJson()).toList(),
      'Experience': experience?.map((e) => e.toJson()).toList(),
      'Projects': projects?.map((e) => e.toJson()).toList(),
      'Skills': skills?.toJson(),
      'Certifications': certifications?.map((e) => e.toJson()).toList(),
      'Languages': languages?.toJson(),
    };
  }
}

class OnBoardCvParseEducation {
  String? courseName;
  String? specialization;
  String? universityInstitute;
  String? passingYear;
  String? universityIcon;

  OnBoardCvParseEducation({
    this.courseName,
    this.specialization,
    this.universityInstitute,
    this.passingYear,
    this.universityIcon,
  });

  factory OnBoardCvParseEducation.fromJson(Map<String, dynamic> json) {
    return OnBoardCvParseEducation(
      courseName: json['CourseName'],
      specialization: json['Specialization'],
      universityInstitute: json['UniversityInstitute'],
      passingYear: json['PassingYear'],
      universityIcon: json['universityIcon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CourseName': courseName,
      'Specialization': specialization,
      'UniversityInstitute': universityInstitute,
      'PassingYear': passingYear,
      'universityIcon': universityIcon,
    };
  }
}

class OnBoardCvParseExperience {
  String? jobTitle;
  String? companyName;
  String? empType;
  String? startDate;
  String? endDate;
  List<String>? responsibilities;
  List<String>? skills;
  String? companyIcon;

  OnBoardCvParseExperience({
    this.jobTitle,
    this.companyName,
    this.empType,
    this.startDate,
    this.endDate,
    this.responsibilities,
    this.skills,
    this.companyIcon,
  });

  factory OnBoardCvParseExperience.fromJson(Map<String, dynamic> json) {
    return OnBoardCvParseExperience(
      jobTitle: json['JobTitle'],
      companyName: json['CompanyName'],
      empType: json['EmpType'],
      startDate: json['StartDate'],
      endDate: json['EndDate'],
      responsibilities: (json['Responsibilities'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      skills: List<String>.from(json['Skills'] ?? []),
      companyIcon: json['companyIcon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'JobTitle': jobTitle,
      'CompanyName': companyName,
      'EmpType': empType,
      'StartDate': startDate,
      'EndDate': endDate,
      'Responsibilities': responsibilities,
      'Skills': skills,
      'companyIcon': companyIcon,
    };
  }
}

class OnBoardCvParseProject {
  String? projectTitle;
  String? description;
  List<String>? technologiesUsed;
  String? duration;
  String? role;
  List<String>? url;
  String? itSkillsByProject;

  OnBoardCvParseProject({
    this.projectTitle,
    this.description,
    this.technologiesUsed,
    this.duration,
    this.role,
    this.url,
    this.itSkillsByProject,
  });

  factory OnBoardCvParseProject.fromJson(Map<String, dynamic> json) {
    return OnBoardCvParseProject(
      projectTitle: json['ProjectTitle'],
      description: json['Description'],
      technologiesUsed: (json['TechnologiesUsed'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      duration: json['Duration'],
      role: json['Role'],
      url: (json['URL'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      itSkillsByProject: json['ITSkillsByProject'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProjectTitle': projectTitle,
      'Description': description,
      'TechnologiesUsed': technologiesUsed,
      'Duration': duration,
      'Role': role,
      'URL': url,
      'ITSkillsByProject': itSkillsByProject,
    };
  }
}

class OnBoardCvParseSkills {
  List<String>? softSkills;
  List<String>? itSkill;
  List<String>? toolsKnowledgeSkills;

  OnBoardCvParseSkills({
    this.softSkills,
    this.itSkill,
    this.toolsKnowledgeSkills,
  });

  factory OnBoardCvParseSkills.fromJson(Map<String, dynamic> json) {
    return OnBoardCvParseSkills(
      softSkills: (json['SoftSkills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      itSkill: (json['ITSkill'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      toolsKnowledgeSkills: (json['ToolsKnowledgeSkills'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SoftSkills': softSkills,
      'ITSkill': itSkill,
      'ToolsKnowledgeSkills': toolsKnowledgeSkills,
    };
  }
}

class OnBoardCvParseCertification {
  String? certificateName;
  String? organization;
  String? issueDate; // month-year
  String? validTill; // month-year

  OnBoardCvParseCertification({
    this.certificateName,
    this.organization,
    this.issueDate,
    this.validTill,
  });

  factory OnBoardCvParseCertification.fromJson(Map<String, dynamic> json) {
    return OnBoardCvParseCertification(
      certificateName: json['certificate_name'],
      organization: json['organization'],
      issueDate: json['issuedate'],
      validTill: json['valid_till'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'certificate_name': certificateName,
      'organization': organization,
      'issuedate': issueDate,
      'valid_till': validTill,
    };
  }
}

class OnBoardCvParseLanguages {
  List<String>? professionalLanguages;
  List<String>? regionalLanguages;

  OnBoardCvParseLanguages({this.professionalLanguages, this.regionalLanguages});

  factory OnBoardCvParseLanguages.fromJson(Map<String, dynamic> json) {
    return OnBoardCvParseLanguages(
      professionalLanguages: (json['ProfessionalLanguages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      regionalLanguages: (json['RegionalLanguages'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProfessionalLanguages': professionalLanguages,
      'RegionalLanguages': regionalLanguages,
    };
  }
}
