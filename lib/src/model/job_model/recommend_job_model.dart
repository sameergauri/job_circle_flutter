import 'dart:convert';

class RecommendJobModel {
  Data? data;

  RecommendJobModel({this.data});

  factory RecommendJobModel.fromJson(Map<String, dynamic> json) {
    return RecommendJobModel(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }
}

class Data {
  int? userId;
  List<Recommendation>? recommendations;

  Data({this.userId, this.recommendations});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['userId'] as int?,
      recommendations: (json['recommendations'] as List<dynamic>?)
          ?.map((e) => Recommendation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Recommendation {
  int? id;
  int? companyId;
  int? jobPostType;
  int? isCampus;
  int? isFavorite;
  int? favJobId;
  List<String>? locations;
  String? location;
  String? locationWithWorkType;
  String? city;
  String? process;
  String? functionalArea;
  String? shifttime;
  String? levelOfHiring;
  String? companyName;
  String? companyIcon;
  String? userProfilePic;
  String? userGender;
  String? userName;
  String? jobHeadline;
  String? rolename;
  String? requiredExperience;
  String? salaryRange;
  List<String>? skills;
  List<String>? languages;
  String? industry;
  String? postedDate;
  String? jobDescription;
  bool? isFeatured;
  bool? isUrgent;
  double? aiScore;
  double? skillsMatchScore;
  double? experienceMatchScore;
  double? locationMatchScore;
  double? salaryMatchScore;
  double? educationMatchScore;
  List<String>? matchReasons;
  String? matchStrength;
  int? popularityScore;
  List<String>? benefits;
  double? companyCultureScore;
  double? careerGrowthScore;
  double? learningOpportunityScore;

  Recommendation({
    this.id,
    this.companyId,
    this.jobPostType,
    this.isCampus,
    this.isFavorite,
    this.favJobId,
    this.locations,
    this.location,
    this.locationWithWorkType,
    this.city,
    this.process,
    this.functionalArea,
    this.shifttime,
    this.levelOfHiring,
    this.companyName,
    this.companyIcon,
    this.userProfilePic,
    this.userGender,
    this.userName,
    this.jobHeadline,
    this.rolename,
    this.requiredExperience,
    this.salaryRange,
    this.skills,
    this.languages,
    this.industry,
    this.postedDate,
    this.jobDescription,
    this.isFeatured,
    this.isUrgent,
    this.aiScore,
    this.skillsMatchScore,
    this.experienceMatchScore,
    this.locationMatchScore,
    this.salaryMatchScore,
    this.educationMatchScore,
    this.matchReasons,
    this.matchStrength,
    this.popularityScore,
    this.benefits,
    this.companyCultureScore,
    this.careerGrowthScore,
    this.learningOpportunityScore,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) {
    List<String>? parseStringList(dynamic data) {
      if (data == null) return [];
      if (data is String) {
        try {
          final parsed = List<String>.from(jsonDecode(data));
          return parsed;
        } catch (_) {
          return [data];
        }
      }
      if (data is List) {
        return data.map((e) => e.toString()).toList();
      }
      return [];
    }

    return Recommendation(
      id: json['id'] as int?,
      companyId: json['companyId'] as int?,
      jobPostType: json['jobPostType'] as int?,
      isCampus: json['isCampus'] as int?,
      isFavorite: json['isFavorite'] as int?,
      favJobId: json['favJobId'] as int?,
      locations: parseStringList(json['locations']),
      location: json['location'] as String?,
      locationWithWorkType: json['locationWithWorkType'] as String?,
      city: json['city'] as String?,
      process: json['process'] as String?,
      functionalArea: json['functionalArea'] as String?,
      shifttime: json['shifttime'] as String?,
      levelOfHiring: json['level_of_hiring'] as String?,
      companyName: json['companyName'] as String?,
      companyIcon: json['companyIcon'] as String?,
      userProfilePic: json['userProfilePic'] as String?,
      userGender: json['userGender'] as String?,
      userName: json['userName'] as String?,
      jobHeadline: json['jobHeadline'] as String?,
      rolename: json['rolename'] as String?,
      requiredExperience: json['requiredExperience'] as String?,
      salaryRange: json['salaryRange'] as String?,
      skills: parseStringList(json['skills']),
      languages: parseStringList(json['languages']),
      industry: json['industry'] as String?,
      postedDate: json['postedDate'] as String?,
      jobDescription: json['jobDescription'] as String?,
      isFeatured: json['isFeatured'] as bool?,
      isUrgent: json['isUrgent'] as bool?,
      aiScore: (json['aiScore'] as num?)?.toDouble(),
      skillsMatchScore: (json['skillsMatchScore'] as num?)?.toDouble(),
      experienceMatchScore: (json['experienceMatchScore'] as num?)?.toDouble(),
      locationMatchScore: (json['locationMatchScore'] as num?)?.toDouble(),
      salaryMatchScore: (json['salaryMatchScore'] as num?)?.toDouble(),
      educationMatchScore: (json['educationMatchScore'] as num?)?.toDouble(),
      matchReasons: parseStringList(json['matchReasons']),
      matchStrength: json['matchStrength'] as String?,
      popularityScore: json['popularityScore'] as int?,
      benefits: parseStringList(json['benefits']),
      companyCultureScore: (json['companyCultureScore'] as num?)?.toDouble(),
      careerGrowthScore: (json['careerGrowthScore'] as num?)?.toDouble(),
      learningOpportunityScore: (json['learningOpportunityScore'] as num?)
          ?.toDouble(),
    );
  }
}
