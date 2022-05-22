import 'dart:convert';

class ProfileSummaryModel {
  int? id;
  String? first_name;
  String? last_name;
  String? job_location_city;
  int? mobile;
  String? job_title;
  String? univercity;
  String? experience;
  String? gender;
  String? work_experience;
  String? degree_spc;
  String? email;
  String? education;

  ProfileSummaryModel({
    this.id,
    this.first_name,
    this.last_name,
    this.job_location_city,
    this.mobile,
    this.job_title,
    this.univercity,
    this.experience,
    this.gender,
    this.work_experience,
    this.degree_spc,
    this.email,
    this.education,
  });

  factory ProfileSummaryModel.fromMap(Map<String, dynamic> map) {
    return ProfileSummaryModel(
      id: map['id']?.toInt(),
      first_name: map['first_name'],
      last_name: map['last_name'],
      job_location_city: map['job_location_city'],
      mobile: map['mobile']?.toInt(),
      job_title: map['job_title'],
      univercity: map['univercity'],
      experience: map['experience'],
      gender: map['gender'],
      work_experience: map['work_experience'],
      degree_spc: map['degree_spc'],
      email: map['email'],
      education: map['education'],
    );
  }
}
