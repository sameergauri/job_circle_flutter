import 'dart:convert';

class JobDetails {
  final String resultKey;
  final List<JobData> resultData;
  final String code;
  final String errorMessage;

  JobDetails({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory JobDetails.fromJson(Map<String, dynamic> json) {
    return JobDetails(
      resultKey: json['resultKey'],
      resultData: List<JobData>.from(json['resultData'].map((data) => JobData.fromJson(data))),
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }
}

class JobData {
  final dynamic shiftTime;
  final int spoc;
  final String maxExperience;
  final dynamic rating;
  final String eligibility;
  final dynamic reasonInActive;
  final dynamic jobSkills;
  final List<dynamic> jobBenefits;
  final String isFresher;
  final int maxAge;
  final String industry;
  final String empType;
  final dynamic shiftDesc;
  final int noOfVacancy;
  final dynamic reasonSpocChange;
  final int minCtc;
  final String minExperience;
  final List<dynamic> languageKnown;
  final String education;
  final int workCity;
  final String totalSalary;
  final int natureOfWorkId;
  final String roleName;
  final int id;
  final dynamic keyResponsible;
  final int companyId;
  final dynamic textResponsible;
  final dynamic active;
  final String totalExperience;
  final String boundaryLimits;
  final int minAge;
  final List<dynamic> workLocation;
  final String process;
  final dynamic functionalArea;
  final String moreDetails;
  final int spocInactive;
  final String isMonthly;
  final int maxCtc;

  JobData({
    required this.shiftTime,
    required this.spoc,
    required this.maxExperience,
    required this.rating,
    required this.eligibility,
    required this.reasonInActive,
    required this.jobSkills,
    required this.jobBenefits,
    required this.isFresher,
    required this.maxAge,
    required this.industry,
    required this.empType,
    required this.shiftDesc,
    required this.noOfVacancy,
    required this.reasonSpocChange,
    required this.minCtc,
    required this.minExperience,
    required this.languageKnown,
    required this.education,
    required this.workCity,
    required this.totalSalary,
    required this.natureOfWorkId,
    required this.roleName,
    required this.id,
    required this.keyResponsible,
    required this.companyId,
    required this.textResponsible,
    required this.active,
    required this.totalExperience,
    required this.boundaryLimits,
    required this.minAge,
    required this.workLocation,
    required this.process,
    required this.functionalArea,
    required this.moreDetails,
    required this.spocInactive,
    required this.isMonthly,
    required this.maxCtc,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    return JobData(
      shiftTime: json['shifttime'],
      spoc: json['spoc'],
      maxExperience: json['maxexperience'],
      rating: json['rating'],
      eligibility: json['eligibility'],
      reasonInActive: json['reason_in_active'],
      jobSkills: json['job_skills'],
      jobBenefits: json['job_benifits'] != null ? List<dynamic>.from(json['job_benifits']) : [],
      isFresher: json['isfresher'],
      maxAge: json['max_age'],
      industry: json['industry'],
      empType: json['emptype'],
      shiftDesc: json['shiftdesc'],
      noOfVacancy: json['no_of_vacancy'],
      reasonSpocChange: json['reason_spoc_change'],
      minCtc: json['minctc'],
      minExperience: json['minexperience'],
      languageKnown: json['languageknown'] != null ? List<dynamic>.from(json['languageknown']) : [],
      education: json['education'],
      workCity: json['work_city'],
      totalSalary: json['total_salary'],
      natureOfWorkId: json['naturofworkid'],
      roleName: json['rolename'],
      id: json['id'],
      keyResponsible: json['key_responsible'],
      companyId: json['compnayid'],
      textResponsible: json['text_responsible'],
      active: json['active'],
      totalExperience: json['total_experience'],
      boundaryLimits: json['boundarylimits'],
      minAge: json['min_age'],
      workLocation: json['work_location'] != null ? List<dynamic>.from(json['work_location']) : [],
      process: json['process'],
      functionalArea: json['functional_area'],
      moreDetails: json['more_details'],
      spocInactive: json['spoc_inactive'],
      isMonthly: json['ismonthly'],
      maxCtc: json['maxctc'],
    );
  }
}

// Usage example
void main() {
  String json = '''
    {
      "resultKey": "SUCCESS",
      "resultData": [
        {
          "shifttime": null,
          "spoc": 0,
          "maxexperience": "8",
          "rating": null,
          "eligibility": "",
          "reason_in_active": null,
          "job_skills": null,
          "job_benifits": "[]",
          "isfresher": " ",
          "max_age": 32,
          "industry": "IT - Software",
          "emptype": " ",
          "shiftdesc": null,
          "no_of_vacancy": 36,
          "reason_spoc_change": null,
          "minctc": 74565,
          "minexperience": "7",
          "languageknown": "[]",
          "education": "Under-Graduate",
          "work_city": 0,
          "total_salary": "74,565.00-968,665.00 per month",
          "naturofworkid": 418,
          "rolename": "AR Associate",
          "id": 188,
          "key_responsible": null,
          "compnayid": 1,
          "text_responsible": null,
          "active": null,
          "total_experience": "7Yrs-8Yrs",
          "boundarylimits": "",
          "min_age": 23,
          "work_location": "[]",
          "process": "ABM",
          "functional_area": null,
          "more_details": "",
          "spoc_inactive": 0,
          "ismonthly": "Per Month",
          "maxctc": 968665
        }
      ],
      "code": "",
      "errorMessage": ""
    }
  ''';

  Map<String, dynamic> jsonData = jsonDecode(json);
  JobDetails jobDetails = JobDetails.fromJson(jsonData);
  print(jobDetails.resultData[0].industry);
}
