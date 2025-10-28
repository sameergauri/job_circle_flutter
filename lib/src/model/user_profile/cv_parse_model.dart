class CvParseModel {
  final String? name;
  final String? contactNumber;
  final String? alternateNumber;
  final String? email;
  final String? dateOfBirth;
  final String? location;
  final String? gender;
  final List<ParseExperience>? experience;
  final List<ParseEducation>? education;
  final List<String>? languagesKnown;
  final Skills? skills;
  final List<String>? certifications;

  CvParseModel({
    this.name,
    this.contactNumber,
    this.alternateNumber,
    this.email,
    this.dateOfBirth,
    this.location,
    this.gender,
    this.experience,
    this.education,
    this.languagesKnown,
    this.skills,
    this.certifications,
  });

  factory CvParseModel.fromJson(Map<String, dynamic> json) {
    return CvParseModel(
      name: json['name'] as String?,
      contactNumber: json['contactNumber'] as String?,
      alternateNumber: json['alternateNumber'] as String?,
      email: json['email'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      location: json['location'] as String?,
      gender: json['gender'] as String?,
      experience: (json['experience'] as List<dynamic>?)
          ?.map((e) => ParseExperience.fromJson(e as Map<String, dynamic>))
          .toList(),
      education: (json['education'] as List<dynamic>?)
          ?.map((e) => ParseEducation.fromJson(e as Map<String, dynamic>))
          .toList(),
      languagesKnown: (json['languagesKnown'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      skills: json['skills'] != null
          ? Skills.fromJson(json['skills'] as Map<String, dynamic>)
          : null,
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contactNumber': contactNumber,
      'alternateNumber': alternateNumber,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'location': location,
      'gender': gender,
      'experience': experience?.map((e) => e.toJson()).toList(),
      'education': education?.map((e) => e.toJson()).toList(),
      'languagesKnown': languagesKnown,
      'skills': skills?.toJson(),
      'certifications': certifications,
    };
  }
}

class ParseExperience {
  final String? role;
  final String? company;
  final String? duration;
  final String? employmentType;

  ParseExperience({this.role, this.company, this.duration, this.employmentType});

  factory ParseExperience.fromJson(Map<String, dynamic> json) {
    return ParseExperience(
      role: json['role'] as String?,
      company: json['company'] as String?,
      duration: json['duration'] as String?,
      employmentType: json['employmentType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'company': company,
      'duration': duration,
      'employmentType': employmentType,
    };
  }
}

class ParseEducation {
  final String? degree;
  final String? university;
  final String? year;

  ParseEducation({this.degree, this.university, this.year});

  factory ParseEducation.fromJson(Map<String, dynamic> json) {
    return ParseEducation(
      degree: json['degree'] as String?,
      university: json['university'] as String?,
      year: json['year'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'degree': degree, 'university': university, 'year': year};
  }
}

class Skills {
  final List<String>? softSkills;
  final List<String>? technicalSkills;
  final List<String>? toolsAndSoftware;

  Skills({this.softSkills, this.technicalSkills, this.toolsAndSoftware});

  factory Skills.fromJson(Map<String, dynamic> json) {
    return Skills(
      softSkills: (json['soft_skills'] as List?)
          ?.where((e) => e != null)
          .map((e) => e.toString())
          .toList(),
      technicalSkills: (json['technical_skills'] as List?)
          ?.where((e) => e != null)
          .map((e) => e.toString())
          .toList(),
      toolsAndSoftware: (json['tools_and_software'] as List?)
          ?.where((e) => e != null)
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soft_skills': softSkills,
      'technical_skills': technicalSkills,
      'tools_and_software': toolsAndSoftware,
    };
  }
}
