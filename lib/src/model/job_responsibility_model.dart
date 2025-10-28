class ResponsibilityAiModel {
  final bool? success;
  final List<String>? responsibilities;
  final List<String>? skills;
  final String? message;

  ResponsibilityAiModel({
    this.success,
    this.responsibilities,
    this.skills,
    this.message,
  });

  factory ResponsibilityAiModel.fromJson(Map<String, dynamic> json) {
    return ResponsibilityAiModel(
      success: json['success'] ?? false,
      responsibilities:
          (json['responsibilities'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
      skills:
          (json['skills'] as List?)
              ?.where((e) => e != null)
              .map((e) => e.toString())
              .toList() ??
          [],
      message: json['message'] ?? "",
    );
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

