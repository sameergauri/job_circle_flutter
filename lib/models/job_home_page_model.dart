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
}

class ResultData {
  final AllJobs? allJobs;

  const ResultData({this.allJobs});

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      allJobs:
          json['All Jobs'] != null ? AllJobs.fromJson(json['All Jobs']) : null,
    );
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
}

class PageResponse {
  final List<JobContent>? content;

  const PageResponse({this.content});

  factory PageResponse.fromJson(Map<String, dynamic> json) {
    return PageResponse(
      content: json['content'] != null
          ? List<JobContent>.from(
              json['content'].map((x) => JobContent.fromJson(x)))
          : null,
    );
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

  const JobContent(
      {this.jobPostType,
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
      this.jobHeadline});

  factory JobContent.fromJson(Map<String, dynamic> json) {
    return JobContent(
      jobPostType: json['jobPostType'],
      experienceRequired: json['experienceRequired'],
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
    );
  }
}
