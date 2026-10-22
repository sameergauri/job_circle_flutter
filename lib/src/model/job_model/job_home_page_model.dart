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
  final String? job_updated_on;
  //
  final String? postedByType;
  final String? hiringFor;
  final bool? showHiringForToCandidate;
  final int? businessCompanyId;
  final String? functionalAreaForBusinessHiring;
  final String? roleForBusinessHiring;
  final String? reasonNotShowHiringFor;
  final String? businessCompanyName;
  final String? businessCompanyIcon;
  final String? businessCompanyCity;
  final String? businessCompanyIndustry;
  final int? spoc;
  final String? jobStatus;
  final SearchKeywords? search_keywords;
  final ScreeningKeywords? screening_keywords;
  final CategorizedSkills? categorizedSkills;

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
    this.postedByType,
    this.hiringFor,
    this.showHiringForToCandidate,
    this.businessCompanyId,
    this.functionalAreaForBusinessHiring,
    this.roleForBusinessHiring,
    this.reasonNotShowHiringFor,
    this.businessCompanyName,
    this.businessCompanyIcon,
    this.businessCompanyCity,
    this.businessCompanyIndustry,
    this.spoc,
    this.job_updated_on,
    this.jobStatus,
    this.screening_keywords,
    this.search_keywords,
    this.categorizedSkills,
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
      postedByType: json['postedByType'],
      hiringFor: json['hiringFor'],
      showHiringForToCandidate: json['showHiringForToCandidate'],
      businessCompanyId: json['businessCompanyId'],
      functionalAreaForBusinessHiring: json['functionalAreaForBusinessHiring'],
      roleForBusinessHiring: json['roleForBusinessHiring'],
      reasonNotShowHiringFor: json['reasonNotShowHiringFor'],
      businessCompanyName: json['businessCompanyName'],
      businessCompanyIcon: json['businessCompanyIcon'],
      businessCompanyCity: json['businessCompanyCity'],
      businessCompanyIndustry: json['businessCompanyIndustry'],
      spoc: json['spoc'],
      job_updated_on: json['job_updated_on'],
      jobStatus: json['jobStatus'],
      search_keywords: json['search_keywords'] != null
          ? SearchKeywords.fromJson(json['search_keywords'])
          : null,
      screening_keywords: json['screening_keywords'] != null
          ? ScreeningKeywords.fromJson(json['screening_keywords'])
          : null,
      categorizedSkills: json['categorizedSkills'] != null
          ? CategorizedSkills.fromJson(json['categorizedSkills'])
          : null,
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
    String? postedByType,
    String? hiringFor,
    bool? showHiringForToCandidate,
    int? businessCompanyId,
    String? functionalAreaForBusinessHiring,
    String? roleForBusinessHiring,
    String? reasonNotShowHiringFor,
    String? businessCompanyName,
    String? businessCompanyIcon,
    String? businessCompanyCity,
    String? businessCompanyIndustry,
    String? job_updated_on,
    int? spoc,
    String? jobStatus,
    SearchKeywords? search_keywords,
    ScreeningKeywords? screening_keywords,
    CategorizedSkills? categorizedSkills,
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
      postedByType: postedByType ?? this.postedByType,
      hiringFor: hiringFor ?? this.hiringFor,
      showHiringForToCandidate:
          showHiringForToCandidate ?? this.showHiringForToCandidate,
      businessCompanyId: businessCompanyId ?? this.businessCompanyId,
      functionalAreaForBusinessHiring:
          functionalAreaForBusinessHiring ??
          this.functionalAreaForBusinessHiring,
      roleForBusinessHiring:
          roleForBusinessHiring ?? this.roleForBusinessHiring,
      reasonNotShowHiringFor:
          reasonNotShowHiringFor ?? this.reasonNotShowHiringFor,
      businessCompanyName: businessCompanyName ?? this.businessCompanyName,
      businessCompanyIcon: businessCompanyIcon ?? this.businessCompanyIcon,
      businessCompanyCity: businessCompanyCity ?? this.businessCompanyCity,
      businessCompanyIndustry:
          businessCompanyIndustry ?? this.businessCompanyIndustry,
      spoc: spoc ?? this.spoc,
      job_updated_on: job_updated_on ?? this.job_updated_on,
      jobStatus: jobStatus ?? this.jobStatus,
      search_keywords: search_keywords ?? this.search_keywords,
      screening_keywords: screening_keywords ?? this.screening_keywords,
      categorizedSkills: categorizedSkills ?? this.categorizedSkills,
    );
  }
}

class SearchKeywords {
  final List<String> roleAndTitleTags;
  final List<String> hardSkillTags;
  final List<String> domainAndIndustryTags;
  final List<String> seniorityTags;

  const SearchKeywords({
    this.roleAndTitleTags = const [],
    this.hardSkillTags = const [],
    this.domainAndIndustryTags = const [],
    this.seniorityTags = const [],
  });

  factory SearchKeywords.fromJson(Map<String, dynamic> json) {
    return SearchKeywords(
      roleAndTitleTags: _toStringList(json['role_and_title_tags']),
      hardSkillTags: _toStringList(json['hard_skill_tags']),
      domainAndIndustryTags: _toStringList(json['domain_and_industry_tags']),
      seniorityTags: _toStringList(json['seniority_tags']),
    );
  }
  bool get isEmpty =>
      roleAndTitleTags.isEmpty &&
      hardSkillTags.isEmpty &&
      domainAndIndustryTags.isEmpty &&
      seniorityTags.isEmpty;

  List<String> get allKeywords => [
    ...roleAndTitleTags,
    ...hardSkillTags,
    ...domainAndIndustryTags,
    ...seniorityTags,
  ];

  static List<String> _toStringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  @override
  String toString() =>
      'SearchKeywords(role: ${roleAndTitleTags.length}, hard: ${hardSkillTags.length}, '
      'domain: ${domainAndIndustryTags.length}, seniority: ${seniorityTags.length})';
}

class ScreeningKeywords {
  final List<String> mustHaveScreeningKeywords;
  final List<String> niceToHaveScreeningKeywords;

  const ScreeningKeywords({
    this.mustHaveScreeningKeywords = const [],
    this.niceToHaveScreeningKeywords = const [],
  });

  factory ScreeningKeywords.fromJson(Map<String, dynamic> json) {
    return ScreeningKeywords(
      mustHaveScreeningKeywords: _toStringList(
        json['must_have_screening_keywords'],
      ),
      niceToHaveScreeningKeywords: _toStringList(
        json['nice_to_have_screening_keywords'],
      ),
    );
  }

  bool get isEmpty =>
      mustHaveScreeningKeywords.isEmpty && niceToHaveScreeningKeywords.isEmpty;

  List<String> get allKeywords => [
    ...mustHaveScreeningKeywords,
    ...niceToHaveScreeningKeywords,
  ];

  static List<String> _toStringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  @override
  String toString() =>
      'ScreeningKeywords(mustHave: ${mustHaveScreeningKeywords.length}, '
      'niceToHave: ${niceToHaveScreeningKeywords.length})';
}

class CategorizedSkills {
  final List<String> coreFunctionalSkills;
  final List<String> supportingSkills;
  final List<String> toolsTechnicalSkills;
  final List<String> domainSkills;
  final List<String> methodologiesAndProcessesSkills;

  const CategorizedSkills({
    this.coreFunctionalSkills = const [],
    this.supportingSkills = const [],
    this.toolsTechnicalSkills = const [],
    this.domainSkills = const [],
    this.methodologiesAndProcessesSkills = const [],
  });

  factory CategorizedSkills.fromJson(Map<String, dynamic> json) {
    return CategorizedSkills(
      coreFunctionalSkills: _toStringList(json['core_functional_skills']),
      supportingSkills: _toStringList(json['supporting_skills']),
      toolsTechnicalSkills: _toStringList(json['tools_technical_skills']),
      domainSkills: _toStringList(json['domain_skills']),
      methodologiesAndProcessesSkills: _toStringList(
        json['methodologies_and_processes_skills'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'core_functional_skills': coreFunctionalSkills,
      'supporting_skills': supportingSkills,
      'tools_technical_skills': toolsTechnicalSkills,
      'domain_skills': domainSkills,
      'methodologies_and_processes_skills': methodologiesAndProcessesSkills,
    };
  }

  bool get isEmpty =>
      coreFunctionalSkills.isEmpty &&
      supportingSkills.isEmpty &&
      toolsTechnicalSkills.isEmpty &&
      domainSkills.isEmpty &&
      methodologiesAndProcessesSkills.isEmpty;

  bool get isNotEmpty => !isEmpty;

  List<String> get allSkills => [
    ...coreFunctionalSkills,
    ...supportingSkills,
    ...toolsTechnicalSkills,
    ...domainSkills,
    ...methodologiesAndProcessesSkills,
  ];

  static List<String> _toStringList(dynamic value) {
    if (value == null) return const [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    return const [];
  }

  @override
  String toString() =>
      'CategorizedSkills(core: ${coreFunctionalSkills.length}, '
      'supporting: ${supportingSkills.length}, '
      'tools: ${toolsTechnicalSkills.length}, '
      'domain: ${domainSkills.length}, '
      'methodologies: ${methodologiesAndProcessesSkills.length})';
}
