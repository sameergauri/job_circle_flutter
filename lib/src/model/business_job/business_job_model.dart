import 'package:job_circle/src/model/job_model/job_detail_page_model.dart'
    show JobDetailScreeningQuestion;
import 'package:job_circle/src/model/location_model.dart';

class BusinessJobDetailResponse {
  final String resultKey;
  final BusinessJobPostModel? jobData;
  final String code;
  final String errorMessage;

  BusinessJobDetailResponse({
    required this.resultKey,
    this.jobData,
    required this.code,
    required this.errorMessage,
  });

  factory BusinessJobDetailResponse.fromJson(Map<String, dynamic> json) {
    BusinessJobPostModel? parsedJob;
    if (json['resultData'] != null && json['resultData'] is Map) {
      final resData = Map<String, dynamic>.from(json['resultData']);
      final jobMap = resData['job'] != null
          ? Map<String, dynamic>.from(resData['job'])
          : <String, dynamic>{};
      final questionsList =
          resData['screeningQuestions'] as List<dynamic>? ?? [];

      // Attach screening questions list directly to the job map
      jobMap['screeningQuestions'] = questionsList;
      parsedJob = BusinessJobPostModel.fromJson(jobMap);
    }

    return BusinessJobDetailResponse(
      resultKey: json['resultKey']?.toString() ?? '',
      jobData: parsedJob,
      code: json['code']?.toString() ?? '',
      errorMessage: json['errorMessage']?.toString() ?? '',
    );
  }
}

class BusinessJobPostModel {
  final String? roleName;
  final int? businessCompanyId;
  final String? jobHeadline;
  final String? jobSummary;
  final String? process;
  final String? industry;
  final String? workMode;
  final String? empType;
  final String? levelOfHiring;
  final String? experienceRequired;
  final String? minexperience;
  final String? maxexperience;
  final double? minSalary;
  final double? maxSalary;
  final String? perMonth;
  final int? noOfVacancy;
  final int? jobPostType;
  final int? postVisbility;
  final String? shiftTime;
  final String? weekOff;
  final String? genderPreference;
  final int? minAge;
  final int? maxAge;
  final String? qualifications;
  final String? englishComsRating;
  final String? functionalOfArea;
  final List<String>? skills;
  final List<String>? languageRequired;
  final List<String>? jobBenifits;
  final String? hiringFor;
  final bool? showHiringForToCandidate;
  final String? reasonNotShowHiringFor;
  final String? roleForBusinessHiring;
  final String? functionalAreaForBusinessHiring;
  final List<String>? keyResponsibities;
  final List<String>? additionalDetails;
  final List<String>? eligibility;
  final List<String>? eligibility2;
  final List<String>? boundryLimits;
  final List<CertificateModel>? certification;
  final List<int>? jobLocationInt;
  final List<String>? jobLocationString;
  final List<JobDetailScreeningQuestion>? screeningQuestions;

  BusinessJobPostModel({
    this.roleName,
    this.businessCompanyId,
    this.jobHeadline,
    this.jobSummary,
    this.process,
    this.industry,
    this.workMode,
    this.empType,
    this.levelOfHiring,
    this.experienceRequired,
    this.minexperience,
    this.maxexperience,
    this.minSalary,
    this.maxSalary,
    this.perMonth,
    this.noOfVacancy,
    this.jobPostType,
    this.postVisbility,
    this.shiftTime,
    this.weekOff,
    this.genderPreference,
    this.minAge,
    this.maxAge,
    this.qualifications,
    this.englishComsRating,
    this.functionalOfArea,
    this.skills,
    this.languageRequired,
    this.jobBenifits,
    this.hiringFor,
    this.showHiringForToCandidate,
    this.reasonNotShowHiringFor,
    this.roleForBusinessHiring,
    this.functionalAreaForBusinessHiring,
    this.additionalDetails,
    this.boundryLimits,
    this.eligibility,
    this.eligibility2,
    this.keyResponsibities,
    this.certification,
    this.screeningQuestions,
    this.jobLocationInt,
    this.jobLocationString,
  });

  /// Safe helper to parse dynamic lists to List<String>
  static List<String>? _parseStringList(dynamic list) {
    if (list == null || list is! List) return null;
    return list
        .where((e) => e != null)
        .map((e) => e.toString().trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  static List<int>? _parseIntList(dynamic list) {
    if (list == null || list is! List) return null;
    return list
        .where((e) => e != null)
        .map((e) => int.tryParse(e.toString()))
        .whereType<int>()
        .toList();
  }

  factory BusinessJobPostModel.fromJson(Map<String, dynamic> json) {
    return BusinessJobPostModel(
      roleName: json['roleName']?.toString(),
      businessCompanyId: json['businessCompanyId'] as int?,
      jobHeadline: json['jobHeadline']?.toString(),
      jobSummary: json['jobSummary']?.toString(),
      process: json['process']?.toString(),
      industry: json['industry']?.toString(),
      workMode: json['workMode']?.toString(),
      empType: json['empType']?.toString(),
      levelOfHiring: json['levelOfHiring']?.toString(),
      experienceRequired: json['experienceRequired']?.toString(),
      minexperience: json['minexperience']?.toString(),
      maxexperience: json['maxexperience']?.toString(),
      minSalary: json['minSalary'] != null
          ? (json['minSalary'] as num).toDouble()
          : null,
      maxSalary: json['maxSalary'] != null
          ? (json['maxSalary'] as num).toDouble()
          : null,
      perMonth: json['perMonth']?.toString(),
      noOfVacancy: json['noOfVacancy'] as int?,
      jobPostType: json['jobPostType'] as int?,
      postVisbility: json['postVisbility'] as int?,
      shiftTime: json['shiftTime']?.toString(),
      weekOff: json['weekOff']?.toString(),
      genderPreference: json['genderPreference']?.toString(),
      minAge: json['min_age'] as int?,
      maxAge: json['max_age'] as int?,
      qualifications: json['qualifications']?.toString(),
      englishComsRating: json['englishComsRating']?.toString(),
      functionalOfArea: json['functionalOfArea']?.toString(),
      skills: _parseStringList(json['skills']),
      languageRequired: _parseStringList(json['languageRequired']),
      jobBenifits: _parseStringList(json['jobBenifits']),
      eligibility: _parseStringList(json['eligibility']),
      eligibility2: _parseStringList(json['eligibility2']),
      hiringFor: json['hiringFor']?.toString(),
      showHiringForToCandidate: json['showHiringForToCandidate'] as bool?,
      reasonNotShowHiringFor: json['reasonNotShowHiringFor']?.toString(),
      roleForBusinessHiring: json['roleForBusinessHiring']?.toString(),
      functionalAreaForBusinessHiring: json['functionalAreaForBusinessHiring']
          ?.toString(),
      additionalDetails: _parseStringList(json['additionalDetails']),
      boundryLimits: _parseStringList(json['boundryLimits']),
      keyResponsibities: _parseStringList(json['keyResponsibities']),
      certification: json['certification'],
      jobLocationInt: _parseIntList(json['jobLocation']),
      jobLocationString: _parseStringList(json['jobLocationName']),
      screeningQuestions:
          json['screeningQuestions'] != null &&
              json['screeningQuestions'] is List
          ? (json['screeningQuestions'] as List)
                .where((e) => e != null)
                .map(
                  (e) => JobDetailScreeningQuestion.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleName': roleName,
      'businessCompanyId': businessCompanyId,
      'jobHeadline': jobHeadline,
      'jobSummary': jobSummary,
      'process': process,
      'industry': industry,
      'workMode': workMode,
      'empType': empType,
      'levelOfHiring': levelOfHiring,
      'experienceRequired': experienceRequired,
      'minexperience': minexperience,
      'maxexperience': maxexperience,
      'minSalary': minSalary,
      'maxSalary': maxSalary,
      'perMonth': perMonth,
      'noOfVacancy': noOfVacancy,
      'jobPostType': jobPostType,
      'postVisbility': postVisbility,
      'shiftTime': shiftTime,
      'weekOff': weekOff,
      'genderPreference': genderPreference,
      'min_age': minAge,
      'max_age': maxAge,
      'qualifications': qualifications,
      'englishComsRating': englishComsRating,
      'functionalOfArea': functionalOfArea,
      'skills': skills,
      'languageRequired': languageRequired,
      'jobBenifits': jobBenifits,
      'hiringFor': hiringFor,
      'showHiringForToCandidate': showHiringForToCandidate,
      'reasonNotShowHiringFor': reasonNotShowHiringFor,
      'roleForBusinessHiring': roleForBusinessHiring,
      'functionalAreaForBusinessHiring': functionalAreaForBusinessHiring,
      'screeningQuestions': screeningQuestions?.map((e) => e.toJson()).toList(),
      'boundryLimits': boundryLimits,
      'eligibility2': eligibility2,
      'eligibility': eligibility,
      'additionalDetails': additionalDetails,
      'jobLocation': jobLocationInt,
      'certification': certification,
      'keyResponsibities': keyResponsibities,
    };
  }
}
