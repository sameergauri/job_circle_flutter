import 'dart:convert';

class ResponsibilityAiModel {
  final String? seniorityLevel;
  final String? seniorityRationale;
  final JobPosting? jobPosting;
  final SearchKeywords? searchKeywords;
  final ScreeningKeywords? screeningKeywords;

  ResponsibilityAiModel({
    this.seniorityLevel,
    this.seniorityRationale,
    this.jobPosting,
    this.searchKeywords,
    this.screeningKeywords,
  });

  factory ResponsibilityAiModel.fromJson(Map<String, dynamic> json) {
    return ResponsibilityAiModel(
      seniorityLevel: json['seniority_level'] as String? ?? '',
      seniorityRationale: json['seniority_rationale'] as String? ?? '',
      jobPosting: json['job_posting'] != null
          ? JobPosting.fromJson(json['job_posting'] as Map<String, dynamic>)
          : null,
      searchKeywords: json['search_keywords'] != null
          ? SearchKeywords.fromJson(
              json['search_keywords'] as Map<String, dynamic>,
            )
          : null,
      screeningKeywords: json['screening_keywords'] != null
          ? ScreeningKeywords.fromJson(
              json['screening_keywords'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'seniority_level': seniorityLevel,
      'seniority_rationale': seniorityRationale,
      'job_posting': jobPosting?.toJson(),
      'search_keywords': searchKeywords?.toJson(),
      'screening_keywords': screeningKeywords?.toJson(),
    };
  }

  factory ResponsibilityAiModel.fromRawJson(String str) =>
      ResponsibilityAiModel.fromJson(jsonDecode(str) as Map<String, dynamic>);

  String toRawJson() => jsonEncode(toJson());
}

class JobPosting {
  final String? jobTitle;
  final List<String> responsibilities;

  JobPosting({this.jobTitle, required this.responsibilities});

  factory JobPosting.fromJson(Map<String, dynamic> json) {
    return JobPosting(
      jobTitle: json['job_title'] as String? ?? '',
      responsibilities:
          (json['responsibilities'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {'job_title': jobTitle, 'responsibilities': responsibilities};
  }
}

class SearchKeywords {
  final List<String> roleAndTitleTags;
  final List<String> hardSkillTags;
  final List<String> domainAndIndustryTags;
  final List<String> seniorityTags;

  SearchKeywords({
    required this.roleAndTitleTags,
    required this.hardSkillTags,
    required this.domainAndIndustryTags,
    required this.seniorityTags,
  });

  factory SearchKeywords.fromJson(Map<String, dynamic> json) {
    return SearchKeywords(
      roleAndTitleTags:
          (json['role_and_title_tags'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
      hardSkillTags:
          (json['hard_skill_tags'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
      domainAndIndustryTags:
          (json['domain_and_industry_tags'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
      seniorityTags:
          (json['seniority_tags'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role_and_title_tags': roleAndTitleTags,
      'hard_skill_tags': hardSkillTags,
      'domain_and_industry_tags': domainAndIndustryTags,
      'seniority_tags': seniorityTags,
    };
  }
}

class ScreeningKeywords {
  final List<String> mustHaveScreeningKeywords;
  final List<String> niceToHaveScreeningKeywords;

  ScreeningKeywords({
    required this.mustHaveScreeningKeywords,
    required this.niceToHaveScreeningKeywords,
  });

  factory ScreeningKeywords.fromJson(Map<String, dynamic> json) {
    return ScreeningKeywords(
      mustHaveScreeningKeywords:
          (json['must_have_screening_keywords'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
      niceToHaveScreeningKeywords:
          (json['nice_to_have_screening_keywords'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'must_have_screening_keywords': mustHaveScreeningKeywords,
      'nice_to_have_screening_keywords': niceToHaveScreeningKeywords,
    };
  }
}

class ProfileSummaryModel {
  bool? success;
  String? profileResponse;
  String? message;

  ProfileSummaryModel({this.success, this.profileResponse, this.message});

  factory ProfileSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProfileSummaryModel(
      success: json['success'] as bool?,
      profileResponse: json['profileResponse'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'profileResponse': profileResponse,
      'message': message,
    };
  }
}

class JobSummaryAiModel {
  final bool? success;
  final String? summary;
  final String? message;

  JobSummaryAiModel({this.success, this.summary, this.message});

  factory JobSummaryAiModel.fromJson(Map<String, dynamic> json) {
    return JobSummaryAiModel(
      success: json['success'] ?? false,
      summary: json['summary'] ?? "",
      message: json['message'] ?? "",
    );
  }
}

class SkillFetchResponse {
  final bool success;
  final List<String> skills;
  final String seniorityLevel;
  final String message;

  SkillFetchResponse({
    required this.success,
    required this.skills,
    required this.seniorityLevel,
    required this.message,
  });

  factory SkillFetchResponse.fromJson(Map<String, dynamic> json) {
    return SkillFetchResponse(
      success: json['success'] as bool? ?? false,
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      seniorityLevel: json['seniorityLevel'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}

class GenerateSkillsRequest {
  final String jobTitle;
  final String industry;
  final String functionalArea;
  final List<String> responsibilities;

  GenerateSkillsRequest({
    required this.jobTitle,
    required this.industry,
    required this.functionalArea,
    required this.responsibilities,
  });

  Map<String, dynamic> toJson() {
    return {
      'jobTitle': jobTitle,
      'industry': industry,
      'functionalArea': functionalArea,
      'responsibilities': responsibilities,
    };
  }
}
