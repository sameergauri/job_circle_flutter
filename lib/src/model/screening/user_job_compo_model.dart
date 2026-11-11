class RecomputeRecommendationResponse {
  final String resultKey;
  final List<RecomputedJobItem> resultData;
  final RecomputeDebugInfo? debug;
  final String? code;
  final String? errorMessage;

  RecomputeRecommendationResponse({
    required this.resultKey,
    required this.resultData,
    this.debug,
    this.code,
    this.errorMessage,
  });

  factory RecomputeRecommendationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['resultData'];
    List<RecomputedJobItem> results = [];
    RecomputeDebugInfo? debugInfo;

    if (data is Map<String, dynamic>) {
      // debug=true shape: resultData = { results: [...], debug: {...} }
      results = List<RecomputedJobItem>.from(
        (data['results'] as List? ?? []).map(
          (x) => RecomputedJobItem.fromJson(x),
        ),
      );
      debugInfo = data['debug'] != null
          ? RecomputeDebugInfo.fromJson(data['debug'] as Map<String, dynamic>)
          : null;
    } else if (data is List) {
      // debug=false shape: resultData is the plain list of matches.
      results = List<RecomputedJobItem>.from(
        data.map((x) => RecomputedJobItem.fromJson(x)),
      );
    }

    return RecomputeRecommendationResponse(
      resultKey: json['resultKey'] ?? '',
      resultData: results,
      debug: debugInfo,
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }
}

class RecomputedJobItem {
  final int userId;
  final int jobId;
  final double matchPercentage;
  final String screeningStatus;
  final String matchLabel;
  final List<String> matchReasons;
  final List<String> whyMatched;
  final List<String> missingRequirements;
  final String recruiterSummary;
  final List<String> actionableSuggestions;
  final String workStatus; // 🎯 Added
  final SeniorityAnalysisModel? seniorityAnalysis; // 🎯 Added

  RecomputedJobItem({
    required this.userId,
    required this.jobId,
    required this.matchPercentage,
    required this.screeningStatus,
    required this.matchLabel,
    required this.matchReasons,
    required this.whyMatched,
    required this.missingRequirements,
    required this.recruiterSummary,
    required this.actionableSuggestions,
    required this.workStatus,
    this.seniorityAnalysis,
  });

  factory RecomputedJobItem.fromJson(Map<String, dynamic> json) {
    return RecomputedJobItem(
      userId: json['userId'] ?? 0,
      jobId: json['jobId'] ?? 0,
      matchPercentage: json['matchPercentage'] ?? 0,
      screeningStatus: json['screeningStatus'] ?? '',
      matchLabel: json['matchLabel'] ?? '',
      matchReasons: List<String>.from(json['matchReasons'] ?? []),
      whyMatched: List<String>.from(json['whyMatched'] ?? []),
      missingRequirements: List<String>.from(json['missingRequirements'] ?? []),
      recruiterSummary: json['recruiterSummary'] ?? '',
      actionableSuggestions: List<String>.from(
        json['actionableSuggestions'] ?? [],
      ),
      workStatus: json['workStatus'] as String? ?? 'FRESHER',
      seniorityAnalysis: json['seniorityAnalysis'] != null
          ? SeniorityAnalysisModel.fromJson(
              json['seniorityAnalysis'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class SeniorityAnalysisModel {
  final String userSeniority;
  final String targetJobSeniority;
  final bool isSeniorityMatched;

  SeniorityAnalysisModel({
    required this.userSeniority,
    required this.targetJobSeniority,
    required this.isSeniorityMatched,
  });

  factory SeniorityAnalysisModel.fromJson(Map<String, dynamic> json) {
    return SeniorityAnalysisModel(
      userSeniority: json['userSeniority'] as String? ?? '',
      targetJobSeniority: json['targetJobSeniority'] as String? ?? '',
      isSeniorityMatched: json['isSeniorityMatched'] as bool? ?? false,
    );
  }
}

// ======================= Debug mode (?debug=true) =======================
// Populated only when the recompute call is made with debug enabled; shows
// exactly why each requested job did or didn't match the candidate.

class RecomputeDebugInfo {
  final int userId;
  final List<int> requestedJobIds;
  final RecomputeDebugUser? user;
  final RecomputeDebugSettings? settings;
  final String summary;
  final List<RecomputeDebugJob> jobs;

  RecomputeDebugInfo({
    required this.userId,
    required this.requestedJobIds,
    this.user,
    this.settings,
    required this.summary,
    required this.jobs,
  });

  factory RecomputeDebugInfo.fromJson(Map<String, dynamic> json) {
    return RecomputeDebugInfo(
      userId: json['userId'] ?? 0,
      requestedJobIds: List<int>.from(json['requestedJobIds'] ?? []),
      user: json['user'] != null
          ? RecomputeDebugUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      settings: json['settings'] != null
          ? RecomputeDebugSettings.fromJson(
              json['settings'] as Map<String, dynamic>,
            )
          : null,
      summary: json['summary'] ?? '',
      jobs: List<RecomputeDebugJob>.from(
        (json['jobs'] as List? ?? []).map((x) => RecomputeDebugJob.fromJson(x)),
      ),
    );
  }
}

class RecomputeDebugUser {
  final String track;
  final bool jobPreferenceEnabled;
  final String gender;
  final int age;
  final String currentLocation;
  final String currentLocality;
  final String? permanentLocation;
  final List<String> educationLevels;
  final List<String> languages;
  final double totalExperienceMonths;
  final List<int> validCertificateIds;
  final List<String> skills;
  final int currentSeniorityLevel;
  final List<RecomputeDebugExperience> experiences;

  RecomputeDebugUser({
    required this.track,
    required this.jobPreferenceEnabled,
    required this.gender,
    required this.age,
    required this.currentLocation,
    required this.currentLocality,
    this.permanentLocation,
    required this.educationLevels,
    required this.languages,
    required this.totalExperienceMonths,
    required this.validCertificateIds,
    required this.skills,
    required this.currentSeniorityLevel,
    required this.experiences,
  });

  factory RecomputeDebugUser.fromJson(Map<String, dynamic> json) {
    return RecomputeDebugUser(
      track: json['track'] ?? '',
      jobPreferenceEnabled: json['jobPreferenceEnabled'] ?? false,
      gender: json['gender'] ?? '',
      age: json['age'] ?? 0,
      currentLocation: json['currentLocation'] ?? '',
      currentLocality: json['currentLocality'] ?? '',
      permanentLocation: json['permanentLocation'],
      educationLevels: List<String>.from(json['educationLevels'] ?? []),
      languages: List<String>.from(json['languages'] ?? []),
      totalExperienceMonths: json['totalExperienceMonths'] ?? 0.0,
      validCertificateIds: List<int>.from(json['validCertificateIds'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      currentSeniorityLevel: json['currentSeniorityLevel'] ?? 0,
      // Backend key literally contains "(newest first)".
      experiences: List<RecomputeDebugExperience>.from(
        (json['experiences (newest first)'] as List? ?? []).map(
          (x) => RecomputeDebugExperience.fromJson(x),
        ),
      ),
    );
  }
}

class RecomputeDebugExperience {
  final String title;
  final bool current;
  final double durationMonths;
  final bool tenureExempt;
  final String aiTier;
  final int level;
  final String levelSource;
  final String functionalArea;
  final String industry;
  final List<String> skills;

  RecomputeDebugExperience({
    required this.title,
    required this.current,
    required this.durationMonths,
    required this.tenureExempt,
    required this.aiTier,
    required this.level,
    required this.levelSource,
    required this.functionalArea,
    required this.industry,
    required this.skills,
  });

  factory RecomputeDebugExperience.fromJson(Map<String, dynamic> json) {
    return RecomputeDebugExperience(
      title: json['title'] ?? '',
      current: json['current'] ?? false,
      durationMonths: json['durationMonths'] ?? 0.0,
      tenureExempt: json['tenureExempt'] ?? false,
      aiTier: json['aiTier'] ?? '',
      level: json['level'] ?? 0,
      levelSource: json['levelSource'] ?? '',
      functionalArea: json['functionalArea'] ?? '',
      industry: json['industry'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
    );
  }
}

class RecomputeDebugSettings {
  final bool aiEnabled;
  final int minStructuredScoreForAi;
  final int aiTopK;
  final int recommendedThreshold;

  RecomputeDebugSettings({
    required this.aiEnabled,
    required this.minStructuredScoreForAi,
    required this.aiTopK,
    required this.recommendedThreshold,
  });

  factory RecomputeDebugSettings.fromJson(Map<String, dynamic> json) {
    return RecomputeDebugSettings(
      aiEnabled: json['aiEnabled'] ?? false,
      minStructuredScoreForAi: json['minStructuredScoreForAi'] ?? 0,
      aiTopK: json['aiTopK'] ?? 0,
      // Backend key literally contains "(minScore)".
      recommendedThreshold: json['recommendedThreshold (minScore)'] ?? 0,
    );
  }
}

class RecomputeDebugJob {
  final int jobId;
  final RecomputeDebugJobDetail? job;
  final List<RecomputeDebugHardFilter> hardFilters;
  final RecomputeDebugResult? result;

  RecomputeDebugJob({
    required this.jobId,
    this.job,
    required this.hardFilters,
    this.result,
  });

  factory RecomputeDebugJob.fromJson(Map<String, dynamic> json) {
    return RecomputeDebugJob(
      jobId: json['jobId'] ?? 0,
      job: json['job'] != null
          ? RecomputeDebugJobDetail.fromJson(
              json['job'] as Map<String, dynamic>,
            )
          : null,
      hardFilters: List<RecomputeDebugHardFilter>.from(
        (json['hardFilters'] as List? ?? []).map(
          (x) => RecomputeDebugHardFilter.fromJson(x),
        ),
      ),
      result: json['result'] != null
          ? RecomputeDebugResult.fromJson(
              json['result'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class RecomputeDebugJobDetail {
  final String jobStatus;
  final String roleName;
  final String functionalArea;
  final String industry;
  final String levelOfHiring;
  final String workMode;
  final List<int> jobLocationIds;
  final List<String> locationNames;
  final String experienceRequired;
  final double? minExperienceYears;
  final double? maxExperienceYears;
  final String ageRange;
  final String genderPreference;
  final List<String> requiredLanguages;
  final List<int> mandatoryCertificateIds;
  final List<String> skills;

  RecomputeDebugJobDetail({
    required this.jobStatus,
    required this.roleName,
    required this.functionalArea,
    required this.industry,
    required this.levelOfHiring,
    required this.workMode,
    required this.jobLocationIds,
    required this.locationNames,
    required this.experienceRequired,
    this.minExperienceYears,
    this.maxExperienceYears,
    required this.ageRange,
    required this.genderPreference,
    required this.requiredLanguages,
    required this.mandatoryCertificateIds,
    required this.skills,
  });

  factory RecomputeDebugJobDetail.fromJson(Map<String, dynamic> json) {
    return RecomputeDebugJobDetail(
      jobStatus: json['jobStatus'] ?? '',
      roleName: json['roleName'] ?? '',
      functionalArea: json['functionalArea'] ?? '',
      industry: json['industry'] ?? '',
      levelOfHiring: json['levelOfHiring'] ?? '',
      workMode: json['workMode'] ?? '',
      jobLocationIds: List<int>.from(json['jobLocationIds'] ?? []),
      locationNames: List<String>.from(json['locationNames'] ?? []),
      experienceRequired: json['experienceRequired'] ?? '',
      minExperienceYears: (json['minExperienceYears'] as num?)?.toDouble(),
      maxExperienceYears: (json['maxExperienceYears'] as num?)?.toDouble(),
      ageRange: json['ageRange'] ?? '',
      genderPreference: json['genderPreference'] ?? '',
      requiredLanguages: List<String>.from(json['requiredLanguages'] ?? []),
      mandatoryCertificateIds: List<int>.from(
        json['mandatoryCertificateIds'] ?? [],
      ),
      skills: List<String>.from(json['skills'] ?? []),
    );
  }
}

class RecomputeDebugHardFilter {
  final String filter;
  final String result; // e.g. "PASS" / "FAIL"
  final String rule;
  final String jobSide;
  final String candidateSide;

  RecomputeDebugHardFilter({
    required this.filter,
    required this.result,
    required this.rule,
    required this.jobSide,
    required this.candidateSide,
  });

  bool get passed => result.toUpperCase() == 'PASS';

  factory RecomputeDebugHardFilter.fromJson(Map<String, dynamic> json) {
    return RecomputeDebugHardFilter(
      filter: json['filter'] ?? '',
      result: json['result'] ?? '',
      rule: json['rule'] ?? '',
      jobSide: json['jobSide']?.toString() ?? '',
      candidateSide: json['candidateSide']?.toString() ?? '',
    );
  }
}

class RecomputeDebugResult {
  final String status;
  final String? droppedAt;
  final String? reason;

  RecomputeDebugResult({required this.status, this.droppedAt, this.reason});

  factory RecomputeDebugResult.fromJson(Map<String, dynamic> json) {
    return RecomputeDebugResult(
      status: json['status'] ?? '',
      droppedAt: json['droppedAt'],
      reason: json['reason'],
    );
  }
}
