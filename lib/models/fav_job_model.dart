// To parse this JSON data, do
//
//     final favJobModel = favJobModelFromJson(jsonString);

import 'dart:convert';

class FavJobModel {
  final int id;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isFav;
  final JobDetails jobDetails;

  FavJobModel({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.isFav,
    required this.jobDetails,
  });

  FavJobModel copyWith({
    int? id,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isFav,
    JobDetails? jobDetails,
  }) =>
      FavJobModel(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        isFav: isFav ?? this.isFav,
        jobDetails: jobDetails ?? this.jobDetails,
      );

  factory FavJobModel.fromRawJson(String str) =>
      FavJobModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory FavJobModel.fromJson(Map<String, dynamic> json) => FavJobModel(
        id: json["id"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        isFav: json["isFav"],
        jobDetails: JobDetails.fromJson(json["jobDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "isFav": isFav,
        "jobDetails": jobDetails.toJson(),
      };
}

class JobDetails {
  final int id;
  final String location;
  final int minexperience;
  final int maxexperience;
  final int minctc;
  final int maxctc;
  final dynamic companyname;
  final String process;
  final String rolename;
  final String skills;
  final String naturofwork;
  final dynamic workType;

  JobDetails({
    required this.id,
    required this.location,
    required this.minexperience,
    required this.maxexperience,
    required this.minctc,
    required this.maxctc,
    required this.companyname,
    required this.process,
    required this.rolename,
    required this.skills,
    required this.naturofwork,
    required this.workType,
  });

  JobDetails copyWith({
    int? id,
    String? location,
    int? minexperience,
    int? maxexperience,
    int? minctc,
    int? maxctc,
    dynamic companyname,
    String? process,
    String? rolename,
    String? skills,
    String? naturofwork,
    dynamic workType,
  }) =>
      JobDetails(
        id: id ?? this.id,
        location: location ?? this.location,
        minexperience: minexperience ?? this.minexperience,
        maxexperience: maxexperience ?? this.maxexperience,
        minctc: minctc ?? this.minctc,
        maxctc: maxctc ?? this.maxctc,
        companyname: companyname ?? this.companyname,
        process: process ?? this.process,
        rolename: rolename ?? this.rolename,
        skills: skills ?? this.skills,
        naturofwork: naturofwork ?? this.naturofwork,
        workType: workType ?? this.workType,
      );

  factory JobDetails.fromRawJson(String str) =>
      JobDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory JobDetails.fromJson(Map<String, dynamic> json) => JobDetails(
        id: json["id"],
        location: json["location"],
        minexperience: json["minexperience"],
        maxexperience: json["maxexperience"],
        minctc: json["minctc"],
        maxctc: json["maxctc"],
        companyname: json["companyname"],
        process: json["process"],
        rolename: json["rolename"],
        skills: json["skills"],
        naturofwork: json["naturofwork"],
        workType: json["work_type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "location": location,
        "minexperience": minexperience,
        "maxexperience": maxexperience,
        "minctc": minctc,
        "maxctc": maxctc,
        "companyname": companyname,
        "process": process,
        "rolename": rolename,
        "skills": skills,
        "naturofwork": naturofwork,
        "work_type": workType,
      };
}
