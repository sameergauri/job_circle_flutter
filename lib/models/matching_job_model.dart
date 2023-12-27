// ignore_for_file: non_constant_identifier_names, avoid_print

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
    List<dynamic> jsonData = json['resultData'];
    if (jsonData.isNotEmpty) {
      Map<String, dynamic> jobDataJson = jsonData[0];
      return JobDetails(
        resultKey: json['resultKey'],
        resultData: [JobData.fromJson(jobDataJson)],
        code: json['code'],
        errorMessage: json['errorMessage'],
      );
    } else {
      return JobDetails(
        resultKey: json['resultKey'],
        resultData: [],
        code: json['code'],
        errorMessage: json['errorMessage'],
      );
    }
  }
}

class JobData {
  final dynamic shiftTime;
  final int spoc;
  final int crpf_id;
  final String? city;
  final String maxExperience;
  final dynamic rating;
  final List<dynamic> eligible;
  final dynamic reasonInActive;
  final dynamic jobSkills;
  final List<dynamic> skills;
  final List<dynamic> jobBenefits;
  final List<int> inteviewrounds;
  final List<String> string_interviewrounds;
  final List<Location> location;
  final String isFresher;
  final int maxAge;
  final String industry;
  final String empType;
  final dynamic shiftDesc;
  final int noOfVacancy;
  final dynamic reasonSpocChange;
  final double minctc;
  final String minExperience;
  final List<dynamic> languageKnown;
  final String education;
  final int workCity;
  final String totalSalary;
  final int natureOfWorkId;
  final String roleName;
  final int id;
  final List<dynamic> key_responsible;
  final int companyId;
  final dynamic textResponsible;
  final dynamic
      active; //isme? yes wapas flow start kr isme line by line dekhte haiok
  final String totalExperience;
  final List<dynamic> boundry_limits;
  final int minAge;
  final List<dynamic> workLocation;
  final String process;
  final dynamic functionalArea;
  final List<dynamic> moredetails;
  final int spocInactive;
  final int is_graduate;
  final String isMonthly;
  final double maxctc;
  final String gender;
  final int commercial_id;
  final int isCampus;
  final int isSupportStaff;

  JobData({
    required this.shiftTime,
    required this.spoc,
    required this.crpf_id,
    required this.gender,
    required this.maxExperience,
    required this.rating,
    required this.eligible,
    required this.reasonInActive,
    required this.jobSkills,
    required this.skills,
    required this.jobBenefits,
    required this.inteviewrounds,
    required this.string_interviewrounds,
    required this.isFresher,
    required this.maxAge,
    required this.industry,
    required this.city,
    required this.empType,
    required this.shiftDesc,
    required this.noOfVacancy,
    required this.reasonSpocChange,
    required this.minctc,
    required this.minExperience,
    required this.languageKnown,
    required this.education,
    required this.workCity,
    required this.totalSalary,
    required this.natureOfWorkId,
    required this.roleName,
    required this.id,
    required this.key_responsible,
    required this.companyId,
    required this.textResponsible,
    required this.active,
    required this.totalExperience,
    required this.boundry_limits,
    required this.location,
    required this.minAge,
    required this.workLocation,
    required this.process,
    required this.functionalArea,
    required this.moredetails,
    required this.spocInactive,
    required this.is_graduate,
    required this.isMonthly,
    required this.maxctc,
    required this.commercial_id,
    required this.isCampus,
    required this.isSupportStaff,
  });

  factory JobData.fromJson(Map<String, dynamic> json) {
    /* List<String> decodeListString(String jsonString) {
      if (jsonString.isNotEmpty) {
        final List<dynamic> decodedList = jsonDecode(jsonString);
        return List<String>.from(decodedList);
      }
      return [];
    } */

    return JobData(
        shiftTime: json['shifttime'] ?? '',
        spoc: json['spoc'] ?? '',
        crpf_id: json['crpf_id'] ?? 0,
        maxExperience: json['maxexperience'] ?? '',
        gender: json['gender'] ?? '',
        rating: json['rating'] ?? '',
        // location: decodeListString(json['location']),
        /*  location: json['location'] != null && json['location'] != ''
            ? List<String>.from(jsonDecode(json['location']).map((loc) => loc))
            : [], */
        location: List<Location>.from(
            json['location'].map((data) => Location.fromJson(data))),
        eligible: json['eligible'] != null && json['eligible'] != ''
            ? List<String>.from(
                jsonDecode(json['eligible']).map((eligible) => eligible))
            : [],
        reasonInActive: json['reason_in_active'] ?? '',
        jobSkills: json['job_skills'] != null
            ? List<String>.from(
                jsonDecode(json['job_skills']).map((skill) => skill))
            : [],
        skills: json['skills'] != null
            ? List<String>.from(
                jsonDecode(json['skills']).map((skill) => skill))
            : [],
        process: json['process'] ?? '',
        city: json['city'] ?? '',
        jobBenefits: json['job_benifits'] != null
            ? List<String>.from(
                jsonDecode(json['job_benifits']).map((benefit) => benefit))
            : [],
        inteviewrounds: json['inteviewrounds'] != null
            ? List<int>.from(
                jsonDecode(json['inteviewrounds']).map((rounds) => rounds))
            : [],
        string_interviewrounds:json['string_interviewrounds']!=null?List<String>.from(jsonDecode(json['string_interviewrounds']).map((rounds)=>rounds)):[],
        isFresher: json['isfresher'] ?? '',
        maxAge: json['max_age'] != null ? json['max_age'].toInt() : 0,
        industry: json['industry'] ?? '',
        empType: json['emptype'] ?? '',
        shiftDesc: json['shiftdesc'] ?? '',
        noOfVacancy: json['no_of_vacancy'] ?? 0,
        reasonSpocChange: json['reason_spoc_change'] ?? '',
        minctc: (json['minctc'] ?? 0.0),
        minExperience: json['minexperience'] ?? '',
        languageKnown: json['languageknown'] != null
            ? List<String>.from(
                jsonDecode(json['languageknown']).map((language) => language))
            : [],
        education: json['education'] ?? '',
        workCity: json['work_city'] != null ? json['work_city'].toInt() : 0,
        totalSalary: json['total_salary'] ?? '',
        natureOfWorkId:
            json['naturofworkid'] != null ? json['naturofworkid'].toInt() : 0,
        roleName: json['rolename'] ?? '',
        id: json['id'] != null ? json['id'].toInt() : 0,
        key_responsible:
            json['key_responsible'] != null && json['key_responsible'] != ''
                ? List<String>.from(jsonDecode(json['key_responsible']).map((loc) => loc))
                : [],
        companyId: json['compnayid'] != null ? json['compnayid'].toInt() : 0,
        textResponsible: json['text_responsible'] ?? '',
        active: json['active'] ?? 0,
        totalExperience: json['total_experience'] ?? '',
        boundry_limits: json['boundry_limits'] != null && json['boundry_limits'] != '' ? List<String>.from(jsonDecode(json['boundry_limits']).map((limit) => limit)) : [],
        minAge: json['min_age'] != null ? json['min_age'].toInt() : 0,
        workLocation: json['work_location'] != null ? List<int>.from(jsonDecode(json['work_location']).map((location) => location)) : [],
        functionalArea: json['functional_area'] != null && json['functional_area'] != '' ? List<String>.from(jsonDecode(json['functional_area']).map((area) => area)) : [],
        moredetails: json['moredetails'] != null && json['moredetails'] != '' ? List<String>.from(jsonDecode(json['moredetails']).map((detail) => detail)) : [],
        spocInactive: json['spoc_inactive'] != null ? json['spoc_inactive'].toInt() : 0,
        is_graduate: json['is_graduate'] != null ? json['is_graduate'].toInt() : 0,
        isMonthly: json['ismonthly'] ?? '',
        maxctc: (json['maxctc'] ?? 0.0),
        commercial_id: json['commercial_id'] != null ? json['commercial_id'].toInt() : 0,
        isCampus: json['is_campus'] ?? 0,
        isSupportStaff: json['is_support_staff'] ?? 0);
    // maxCtc: json['maxctc'] ?? 0.0);
  }

  /* factory JobData.fromJson(Map<String, dynamic> json) {
    print("Job Data from JSON");
    print(json);
    return JobData(
      shiftTime: json['shifttime'] ?? '',
      spoc: json['spoc'] ?? '',
      maxExperience: json['maxexperience'] ?? '',
      gender: json['gender'] ?? '',
      rating: json['rating'] ?? '',
      // eligible: json['eligible'] ?? '',
      location: json['location'] != null && json['location'] != ''
          ? List<String>.from(jsonDecode(json['location']).map((loc) => loc))
          : [],
      eligible: json['eligible'] != null && json['eligible'] != ''
          ? List<String>.from(
              jsonDecode(json['eligible']).map((eligible) => eligible))
          : [],
      reasonInActive: json['reason_in_active'] ?? '',
      jobSkills: json['job_skills'] != null
          ? List<String>.from(
              jsonDecode(json['job_skills']).map((skill) => skill))
          : [],
      skills: json['skills'] != null
          ? List<String>.from(jsonDecode(json['skills']).map((skill) => skill))
          : [],
      process: json['process'] ?? '',
      city: json['city'] ?? '',
      jobBenefits: json['job_benifits'] != null
          ? List<String>.from(
              jsonDecode(json['job_benifits']).map((benefit) => benefit))
          : [],
      inteviewrounds: json['inteviewrounds'] != null
          ? List<String>.from(
              jsonDecode(json['inteviewrounds']).map((rounds) => rounds))
          : [],
      isFresher: json['isfresher'] ?? '',
      maxAge: json['max_age'] != null ? json['max_age'].toInt() : 0,
      industry: json['industry'] ?? '',
      empType: json['emptype'] ?? '',
      shiftDesc: json['shiftdesc'] ?? '',
      noOfVacancy: json['no_of_vacancy'] ?? 0,
      reasonSpocChange: json['reason_spoc_change'] ?? '',
      minCtc: json['minctc'] != null
          ? (json['minctc'] is double ? json['minctc'].toInt() : json['minctc'])
          : 0,
      minExperience: json['minexperience'] ?? '',
      languageKnown: json['languageknown'] != null
          ? List<String>.from(
              jsonDecode(json['languageknown']).map((language) => language))
          : [],
      education: json['education'] ?? '',
      workCity: json['work_city'] != null ? json['work_city'].toInt() : 0,
      totalSalary: json['total_salary'] ?? '',
      natureOfWorkId:
          json['naturofworkid'] != null ? json['naturofworkid'].toInt() : 0,
      roleName: json['rolename'] ?? '',
      id: json['id'] != null ? json['id'].toInt() : 0,
      keyResponsible: json['key_responsible'] ?? '',
      companyId: json['compnayid'] != null ? json['compnayid'].toInt() : 0,
      textResponsible: json['text_responsible'] ?? '',
      active: json['active'] ?? 0,
      totalExperience: json['total_experience'] ?? '',
      boundary_limits:
          json['boundary_limits'] != null && json['boundary_limits'] != ''
              ? List<String>.from(
                  jsonDecode(json['boundary_limits']).map((limit) => limit))
              : [],
      minAge: json['min_age'] != null ? json['min_age'].toInt() : 0,
      workLocation: json['work_location'] != null
          ? List<int>.from(
              jsonDecode(json['work_location']).map((location) => location))
          : [],
      functionalArea:
          json['functional_area'] != null && json['functional_area'] != ''
              ? List<String>.from(
                  jsonDecode(json['functional_area']).map((area) => area))
              : [],
      moredetails: json['moredetails'] != null && json['moredetails'] != ''
          ? List<String>.from(
              jsonDecode(json['moredetails']).map((detail) => detail))
          : [],
      spocInactive:
          json['spoc_inactive'] != null ? json['spoc_inactive'].toInt() : 0,
      isMonthly: json['ismonthly'] ?? '',
      maxCtc: json['maxctc'] != null
          ? (json['maxctc'] is double ? json['maxctc'].toInt() : json['maxctc'])
          : 0,
    );
  } */

  /*
  
  Wapas se kar pura start se
   factory JobData.fromJson(Map<String, dynamic> json) {
    final jsonString = jsonEncode(json);

    if (jsonString.isNotEmpty) {
      // Perform JSON decoding
      final jsonData = jsonDecode(jsonString);
      return JobData(
        shiftTime: json['shifttime'] ?? '',
        spoc: json['spoc'] ?? '',
        maxExperience: json['maxexperience'] ?? '',
        rating: json['rating'] ?? '',
        eligible: json['eligible'] ?? '',
        reasonInActive: json['reason_in_active'] ?? '',
        jobSkills: json['job_skills'] != null
            ? List<String>.from(
                jsonDecode(json['job_skills']).map((skill) => skill))
            : [],
        process: json['process'] ?? '',
        jobBenefits: json['job_benifits'] != null
            ? List<String>.from(
                jsonDecode(json['job_benifits']).map((benefit) => benefit))
            : [],
        isFresher: json['isfresher'] ?? '',
        maxAge: json['max_age'] != null ? json['max_age'].toInt() : 0,
        industry: json['industry'] ?? '',
        empType: json['emptype'] ?? '',
        shiftDesc: json['shiftdesc'] ?? '',
        noOfVacancy:
            json['no_of_vacancy'] != null ? json['no_of_vacancy'].toInt() : 0,
        reasonSpocChange: json['reason_spoc_change'] ?? '',
        minCtc: json['minctc'] != null
            ? (json['minctc'] is double
                ? json['minctc'].toInt()
                : json['minctc'])
            : 0,
        minExperience: json['minexperience'] ?? '',
        languageKnown: json['languageknown'] != null
            ? List<String>.from(
                jsonDecode(json['languageknown']).map((language) => language))
            : [],
        education: json['education'] ?? '',
        workCity: json['work_city'] != null ? json['work_city'].toInt() : 0,
        totalSalary: json['total_salary'] ?? '',
        natureOfWorkId:
            json['naturofworkid'] != null ? json['naturofworkid'].toInt() : 0,
        roleName: json['rolename'] ?? '',
        id: json['id'] != null ? json['id'].toInt() : 0,
        keyResponsible: json['key_responsible'] ?? '',
        companyId: json['compnayid'] != null ? json['compnayid'].toInt() : 0,
        textResponsible: json['text_responsible'] ?? '',
        active: json['active'] ?? 0,
        totalExperience: json['total_experience'] ?? '',
        boundary_limits: json['boundary_limits'] != null
            ? List<String>.from(
                jsonDecode(json['boundary_limits']).map((limit) => limit))
            : [],
        minAge: json['min_age'] != null ? json['min_age'].toInt() : 0,
        workLocation: json['work_location'] != null
            ? List<int>.from(
                jsonDecode(json['work_location']).map((location) => location))
            : [],
        functionalArea: json['functional_area'] != null
            ? List<String>.from(
                jsonDecode(json['functional_area']).map((area) => area))
            : [],
        moreDetails: json['more_details'] != null
            ? List<String>.from(
                jsonDecode(json['more_details']).map((detail) => detail))
            : [],
        spocInactive:
            json['spoc_inactive'] != null ? json['spoc_inactive'].toInt() : 0,
        isMonthly: json['ismonthly'] ?? '',
        maxCtc: json['maxctc'] != null
            ? (json['maxctc'] is double
                ? json['maxctc'].toInt()
                : json['maxctc'])
            : 0,
      );
    } else {
      throw Exception('Empty JSON string encountered');
      // Or return a default instance:
      // return JobData();
    }
  } */
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
          "crpf_id":0,
          "maxexperience": "8",
          "gender':""
          "rating": null,
          "eligible": "[]",
          "location":"[]"
          "reason_in_active": null,
          "job_skills": null,
          "job_benifits": "[]",
          "skills":"[]",
          "inteviewrounds":"[]",
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
          "city": "[]
          "rolename": "AR Associate",
          "id": 188,
          "key_responsible": [],
          "compnayid": 1,
          "text_responsible": null,
          "active": null,
          "total_experience": "7Yrs-8Yrs",
          "boundry_limits": "[]",
          "min_age": 23,
          "work_location": "[]",
          "process": "ABM",
          "functional_area": null,
          "moredetails": "[]",
          "spoc_inactive": 0,
          "is_graduate":0,
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

class Location {
  int id;
  String value;

  Location({
    required this.id,
    required this.value,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0, // Replace 0 with your desired default value for 'id'
      value: json['value'] ??
          '', // Replace '' with your desired default value for 'value'
    );
  }
}
