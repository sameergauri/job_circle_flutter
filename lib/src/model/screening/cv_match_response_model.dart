// --- STEP 1: EXTRACTION MODELS ---

class CvExtractResponse {
  final String resultKey;
  final CvProfileData? resultData;
  final String? code;
  final String? errorMessage;

  CvExtractResponse({
    required this.resultKey,
    this.resultData,
    this.code,
    this.errorMessage,
  });

  factory CvExtractResponse.fromJson(Map<String, dynamic> json) {
    return CvExtractResponse(
      resultKey: json['resultKey'] ?? '',
      resultData: json['resultData'] != null
          ? CvProfileData.fromJson(json['resultData'])
          : null,
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }
}

class CvProfileData {
  String fileName;
  String name;
  String email;
  String? gender;
  String? dateOfBirth;
  String? locationCity;
  String? locationLocality;
  List<String> educationText;
  List<EducationItem> education; // Naya structured field
  List<String> languages;
  List<String> certificationNames;
  List<String> candidateSkills;
  List<WorkHistoryItem> workHistory;
  int validExperienceMonths;
  String track;
  int disqualifiedRowCount;
  List<int>? jobIds;

  CvProfileData({
    required this.fileName,
    required this.name,
    required this.email,
    this.gender,
    this.dateOfBirth,
    this.locationCity,
    this.locationLocality,
    required this.educationText,
    required this.education,
    required this.languages,
    required this.certificationNames,
    required this.candidateSkills,
    required this.workHistory,
    required this.validExperienceMonths,
    required this.track,
    required this.disqualifiedRowCount,
    this.jobIds,
  });

  factory CvProfileData.fromJson(Map<String, dynamic> json) {
    return CvProfileData(
      fileName: json['fileName'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'],
      dateOfBirth: json['dateOfBirth'],
      locationCity: json['locationCity'],
      locationLocality: json['locationLocality'],
      educationText: List<String>.from(json['educationText'] ?? []),
      education: (json['education'] as List? ?? [])
          .map((e) => EducationItem.fromJson(e))
          .toList(),
      languages: List<String>.from(json['languages'] ?? []),
      certificationNames: List<String>.from(json['certificationNames'] ?? []),
      candidateSkills: List<String>.from(json['candidateSkills'] ?? []),
      workHistory: (json['workHistory'] as List? ?? [])
          .map((e) => WorkHistoryItem.fromJson(e))
          .toList(),
      validExperienceMonths: json['validExperienceMonths'] ?? 0,
      track: json['track'] ?? 'FRESHER',
      disqualifiedRowCount: json['disqualifiedRowCount'] ?? 0,
      jobIds: json['jobIds'] != null ? List<int>.from(json['jobIds']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'name': name,
      'email': email,
      'gender': gender,
      'dateOfBirth': dateOfBirth,
      'locationCity': locationCity,
      'locationLocality': locationLocality,
      'educationText': educationText,
      'education': education.map((e) => e.toJson()).toList(),
      'languages': languages,
      'certificationNames': certificationNames,
      'candidateSkills': candidateSkills,
      'workHistory': workHistory.map((e) => e.toJson()).toList(),
      'validExperienceMonths': validExperienceMonths,
      'track': track,
      'disqualifiedRowCount': disqualifiedRowCount,
      'jobIds': jobIds,
    };
  }
}

class EducationItem {
  String? courseName;
  String? fieldOfStudy;
  String? universityInstitute;
  String? passingYear;

  EducationItem({
    this.courseName,
    this.fieldOfStudy,
    this.universityInstitute,
    this.passingYear,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      courseName: json['courseName'],
      fieldOfStudy: json['fieldOfStudy'],
      universityInstitute: json['universityInstitute'],
      passingYear: json['passingYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseName': courseName,
      'fieldOfStudy': fieldOfStudy,
      'universityInstitute': universityInstitute,
      'passingYear': passingYear,
    };
  }
}

class WorkHistoryItem {
  String? title;
  String? companyName;
  String? empType;
  String? workMode;
  String? location;
  List<String> responsibilities;
  List<String> skills;
  String? startDate;
  String? endDate;
  bool current;
  int durationMonths;
  bool disqualified;

  WorkHistoryItem({
    this.title,
    this.companyName,
    this.empType,
    this.workMode,
    this.location,
    required this.responsibilities,
    required this.skills,
    this.startDate,
    this.endDate,
    required this.current,
    required this.durationMonths,
    required this.disqualified,
  });

  factory WorkHistoryItem.fromJson(Map<String, dynamic> json) {
    return WorkHistoryItem(
      title: json['title'],
      companyName: json['companyName'],
      empType: json['empType'],
      workMode: json['workMode'],
      location: json['location'],
      responsibilities: List<String>.from(json['responsibilities'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      startDate: json['startDate'],
      endDate: json['endDate'],
      current: json['current'] ?? false,
      durationMonths: json['durationMonths'] ?? 0,
      disqualified: json['disqualified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'companyName': companyName,
      'empType': empType,
      'workMode': workMode,
      'location': location,
      'responsibilities': responsibilities,
      'skills': skills,
      'startDate': startDate,
      'endDate': endDate,
      'current': current,
      'durationMonths': durationMonths,
      'disqualified': disqualified,
    };
  }
}

// --- STEP 2: RECOMMENDATION RESULT MODELS ---

class CvMatchResponse {
  final String resultKey;
  final List<CvJobMatchItem> resultData;
  final String? code;
  final String? errorMessage;

  CvMatchResponse({
    required this.resultKey,
    required this.resultData,
    this.code,
    this.errorMessage,
  });

  factory CvMatchResponse.fromJson(Map<String, dynamic> json) {
    return CvMatchResponse(
      resultKey: json['resultKey'] ?? '',
      resultData: (json['resultData'] as List? ?? [])
          .map((item) => CvJobMatchItem.fromJson(item))
          .toList(),
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }
}

class CvJobMatchItem {
  final int id;
  final String batchId;
  final String fileName;
  final String candidateName;
  final String candidateEmail;
  final String candidateTrack;
  final int validExperienceMonths;
  final int jobId;
  final String? jobTitle;
  final String? companyName;
  final double matchPercentage;
  final String screeningStatus;
  final List<String> whyMatched;
  final List<String> missingRequirements;

  CvJobMatchItem({
    required this.id,
    required this.batchId,
    required this.fileName,
    required this.candidateName,
    required this.candidateEmail,
    required this.candidateTrack,
    required this.validExperienceMonths,
    required this.jobId,
    this.jobTitle,
    this.companyName,
    required this.matchPercentage,
    required this.screeningStatus,
    required this.whyMatched,
    required this.missingRequirements,
  });

  factory CvJobMatchItem.fromJson(Map<String, dynamic> json) {
    return CvJobMatchItem(
      id: json['id'] ?? 0,
      batchId: json['batchId'] ?? '',
      fileName: json['fileName'] ?? '',
      candidateName: json['candidateName'] ?? 'Candidate',
      candidateEmail: json['candidateEmail'] ?? '',
      candidateTrack: json['candidateTrack'] ?? 'FRESHER',
      validExperienceMonths: json['validExperienceMonths'] ?? 0,
      jobId: json['jobId'] ?? 0,
      jobTitle: json['jobTitle'] ?? 'Job Role Not Specified',
      companyName: json['companyName'] ?? 'Direct Employer',
      matchPercentage: (json['matchPercentage'] as num?)?.toDouble() ?? 0.0,
      screeningStatus: json['screeningStatus'] ?? 'NOT_RECOMMENDED',
      whyMatched: List<String>.from(json['whyMatched'] ?? []),
      missingRequirements: List<String>.from(json['missingRequirements'] ?? []),
    );
  }
}

class ActiveJobsResponse {
  final String resultKey;
  final List<ActiveJobItem> resultData;
  final String? code;
  final String? errorMessage;

  ActiveJobsResponse({
    required this.resultKey,
    required this.resultData,
    this.code,
    this.errorMessage,
  });

  factory ActiveJobsResponse.fromJson(Map<String, dynamic> json) {
    return ActiveJobsResponse(
      resultKey: json['resultKey'] ?? '',
      resultData: (json['resultData'] as List? ?? [])
          .map((e) => ActiveJobItem.fromJson(e))
          .toList(),
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }
}

class ActiveJobItem {
  final int jobId;
  final String? jobHeadline;
  final String? role;
  final String? industry;
  final String? functionalArea;
  final String? companyName;
  final String? process;

  ActiveJobItem({
    required this.jobId,
    this.jobHeadline,
    this.role,
    this.industry,
    this.functionalArea,
    this.companyName,
    this.process,
  });

  factory ActiveJobItem.fromJson(Map<String, dynamic> json) {
    return ActiveJobItem(
      jobId: json['jobId'] ?? 0,
      jobHeadline: json['jobHeadline'],
      role: json['role'],
      industry: json['industry'],
      functionalArea: json['functionalArea'],
      companyName: json['companyName'],
      process: json['process'],
    );
  }
}
