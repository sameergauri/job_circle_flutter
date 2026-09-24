class RecomputeRecommendationResponse {
  final String resultKey;
  final List<RecomputedJobItem> resultData;
  final String? code;
  final String? errorMessage;

  RecomputeRecommendationResponse({
    required this.resultKey,
    required this.resultData,
    this.code,
    this.errorMessage,
  });

  factory RecomputeRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return RecomputeRecommendationResponse(
      resultKey: json['resultKey'] ?? '',
      resultData: json['resultData'] != null
          ? List<RecomputedJobItem>.from(
              (json['resultData'] as List).map(
                (x) => RecomputedJobItem.fromJson(x),
              ),
            )
          : [],
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
    );
  }
}
