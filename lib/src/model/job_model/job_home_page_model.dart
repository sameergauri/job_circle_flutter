// ignore_for_file: non_constant_identifier_names

class JobHomePageModel {
  final String? resultKey;
  final ResultData? resultData;

  const JobHomePageModel({this.resultKey, this.resultData});

  factory JobHomePageModel.fromJson(Map<String, dynamic> json) {
    return JobHomePageModel(
      resultKey: json['resultKey'],
      resultData: json['resultData'] != null
          ? ResultData.fromJson(json['resultData'])
          : null,
    );
  }

  JobHomePageModel copyWith({String? resultKey, ResultData? resultData}) {
    return JobHomePageModel(
      resultKey: resultKey ?? this.resultKey,
      resultData: resultData ?? this.resultData,
    );
  }
}

class ResultData {
  final AllJobs? allJobs;

  const ResultData({this.allJobs});

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      allJobs: json['All Jobs'] != null
          ? AllJobs.fromJson(json['All Jobs'])
          : null,
    );
  }

  ResultData copyWith({AllJobs? allJobs}) {
    return ResultData(allJobs: allJobs ?? this.allJobs);
  }
}

class AllJobs {
  final PageResponse? pageResponse;

  const AllJobs({this.pageResponse});

  factory AllJobs.fromJson(Map<String, dynamic> json) {
    return AllJobs(
      pageResponse: json['pageResponse'] != null
          ? PageResponse.fromJson(json['pageResponse'])
          : null,
    );
  }

  AllJobs copyWith({PageResponse? pageResponse}) {
    return AllJobs(pageResponse: pageResponse ?? this.pageResponse);
  }
}

class PageResponse {
  final List<JobContent>? content;

  const PageResponse({this.content});

  factory PageResponse.fromJson(Map<String, dynamic> json) {
    return PageResponse(
      content: json['content'] != null
          ? List<JobContent>.from(
              json['content'].map((x) => JobContent.fromJson(x)),
            )
          : null,
    );
  }

  PageResponse copyWith({List<JobContent>? content}) {
    return PageResponse(content: content ?? this.content);
  }
}

class JobContent {
  final int? jobPostType;
  final String? experienceRequired;
  final String? location;
  final String? city;
  final String? languages;
  final String? rolename;
  final String? process;
  final String? functionalArea;
  final String? locations;
  final int? isCampus;
  final int? companyId;
  final String? salaryRange;
  final int? id;
  final String? skills;
  final String? companyName;
  final bool? isFavorite;
  final String? shifttime;
  final String? jobHeadline;
  final int? favJobId;
  final String? companyIcon;
  final String? level_of_hiring;
  final String? locationWithWorkType;
  final bool? jobPreferenceMatch;
  final int? activePayouts;

  const JobContent({
    this.jobPostType,
    this.experienceRequired,
    this.location,
    this.city,
    this.languages,
    this.rolename,
    this.process,
    this.functionalArea,
    this.locations,
    this.isCampus,
    this.companyId,
    this.salaryRange,
    this.id,
    this.skills,
    this.companyName,
    this.isFavorite,
    this.shifttime,
    this.jobHeadline,
    this.favJobId,
    this.companyIcon,
    this.level_of_hiring,
    this.locationWithWorkType,
    this.jobPreferenceMatch,
    this.activePayouts,
  });

  factory JobContent.fromJson(Map<String, dynamic> json) {
    return JobContent(
      jobPostType: json['jobPostType'],
      experienceRequired: json['requiredExperience'],
      location: json['location'],
      city: json['city'],
      languages: json['languages'],
      rolename: json['rolename'],
      process: json['process'],
      functionalArea: json['functionalArea'],
      locations: json['locations'],
      isCampus: json['isCampus'],
      companyId: json['companyId'],
      salaryRange: json['salaryRange'],
      id: json['id'],
      skills: json['skills'],
      companyName: json['companyName'],
      isFavorite: json['isFavorite'],
      shifttime: json['shifttime'],
      jobHeadline: json['jobHeadline'],
      favJobId: json['favJobId'],
      companyIcon: json['companyIcon'],
      level_of_hiring: json['level_of_hiring'],
      locationWithWorkType: json['locationWithWorkType'],
      jobPreferenceMatch: json['jobPreferenceMatch'],
      activePayouts: json['activePayouts'],
    );
  }

  JobContent copyWith({
    int? jobPostType,
    String? experienceRequired,
    String? location,
    String? city,
    String? languages,
    String? rolename,
    String? process,
    String? functionalArea,
    String? locations,
    int? isCampus,
    int? companyId,
    String? salaryRange,
    int? id,
    String? skills,
    String? companyName,
    bool? isFavorite,
    String? shifttime,
    String? jobHeadline,
    int? favJobId,
    String? companyIcon,
    String? level_of_hiring,
    String? locationWithWorkType,
    bool? jobPreferenceMatch,
    int? activePayouts,
  }) {
    return JobContent(
      jobPostType: jobPostType ?? this.jobPostType,
      experienceRequired: experienceRequired ?? this.experienceRequired,
      location: location ?? this.location,
      city: city ?? this.city,
      languages: languages ?? this.languages,
      rolename: rolename ?? this.rolename,
      process: process ?? this.process,
      functionalArea: functionalArea ?? this.functionalArea,
      locations: locations ?? this.locations,
      isCampus: isCampus ?? this.isCampus,
      companyId: companyId ?? this.companyId,
      salaryRange: salaryRange ?? this.salaryRange,
      id: id ?? this.id,
      skills: skills ?? this.skills,
      companyName: companyName ?? this.companyName,
      isFavorite: isFavorite ?? this.isFavorite,
      shifttime: shifttime ?? this.shifttime,
      jobHeadline: jobHeadline ?? this.jobHeadline,
      favJobId: favJobId ?? this.favJobId,
      companyIcon: companyIcon ?? this.companyIcon,
      level_of_hiring: level_of_hiring ?? this.level_of_hiring,
      locationWithWorkType: locationWithWorkType ?? this.locationWithWorkType,
      jobPreferenceMatch: jobPreferenceMatch ?? this.jobPreferenceMatch,
      activePayouts: activePayouts ?? this.activePayouts,
    );
  }
}
