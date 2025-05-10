// models/job_detail_model.dart

class JobDetailPageModel {
  final int? id;
  final String? companyName;
  final String? roleName;
  final String? jobHeadline;
  final String? salaryRange;
  final double? minCtc;
  final double? maxCtc;
  final String? requiredEducation;
  final String? requiredExperience;
  final String? workMode;
  final String? shiftTime;
  final String? weekOff;
  final String? englishComsRating;
  final String? employmentType;
  final int? minAge;
  final int? maxAge;
  final int? noOfVacancy;
  final int? companyid;
  final int? spocid;
  final String? postedDate;
  final String? postedBy;
  final String? process;
  final String? industry;
  final String? functionalArea;
  final List<String>? jobBenefits;
  final List<String>? eligibility;
  final List<String>? eligibility2;
  final List<String>? skills;
  final List<String>? jobResponsibilities;
  final List<String>? locations;
  final List<String>? language;
  final List<String>? additionalDetails;
  final List<String>? boundryLimits;

  JobDetailPageModel(
      {this.id,
      this.companyName,
      this.roleName,
      this.jobHeadline,
      this.salaryRange,
      this.minCtc,
      this.maxCtc,
      this.requiredEducation,
      this.requiredExperience,
      this.workMode,
      this.shiftTime,
      this.weekOff,
      this.englishComsRating,
      this.employmentType,
      this.minAge,
      this.maxAge,
      this.noOfVacancy,
      this.postedDate,
      this.postedBy,
      this.process,
      this.industry,
      this.functionalArea,
      this.jobBenefits,
      this.eligibility,
      this.eligibility2,
      this.skills,
      this.jobResponsibilities,
      this.locations,
      this.language,
      this.additionalDetails,
      this.boundryLimits,
      this.companyid,
      this.spocid});

  factory JobDetailPageModel.fromJson(Map<String, dynamic> json) {
    return JobDetailPageModel(
        id: json['id'] ?? 0,
        companyName: json['companyName'] ?? '',
        roleName: json['roleName'] ?? '',
        jobHeadline: json['jobHeadline'] ?? '',
        salaryRange: json['salaryRange'] ?? '',
        minCtc: json['minctc'] ?? 0,
        maxCtc: json['maxctc'] ?? 0,
        requiredEducation: json['requiredEducation'] ?? '',
        requiredExperience: json['requiredExperience'] ?? '',
        workMode: json['workMode'] ?? '',
        shiftTime: json['shiftTime'] ?? '',
        weekOff: json['weekOff'] ?? '',
        englishComsRating: json['englishComsRating'] ?? '',
        employmentType: json['emptype'] ?? '',
        minAge: json['min_age'] ?? 0,
        maxAge: json['max_age'] ?? 0,
        noOfVacancy: json['noOfVacancy'] ?? 0,
        postedDate: json['postedDate'] ?? '',
        postedBy: json['postedBy'] ?? '',
        process: json['process'] ?? '',
        industry: json['industry'] ?? '',
        functionalArea: json['FunctionalArea'] ?? '',
        jobBenefits: List<String>.from(json['jobBenifits'] ?? []),
        eligibility: List<String>.from(json['eligibility'] ?? []),
        eligibility2: List<String>.from(json['eligibility2'] ?? []),
        skills: List<String>.from(json['skills'] ?? []),
        jobResponsibilities: List<String>.from(json['jobResponsibility'] ?? []),
        locations: List<String>.from(json['location'] ?? []),
        language: List<String>.from(json['language'] ?? []),
        additionalDetails: List<String>.from(json['additionalDetails'] ?? []),
        boundryLimits: List<String>.from(json['boundryLimits'] ?? []),
        companyid: json['companyid'] ?? 0,
        spocid: json['spoc'] ?? 0);
  }
}
