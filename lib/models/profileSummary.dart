import 'dart:convert';

import 'package:intl/intl.dart';

class ProfileSummaryModel {
  int? id;
  String? first_name;
  String? last_name;
  String? job_location;
  int? mobile;
  String? job_title;
  String? univercity;
  String? experience;
  String? gender;
  String? work_experience;
  String? degree_spc;
  String? email;
  String? education;
  int? job_location_id;
  int? education_id;
  int? degree_spc_id;
  int? univercity_id;
  int? experience_id;
  int? job_title_id;
  int? work_experience_id;
  String? dateofbirth;
  String? companyName;
  List? languages;
  int? passing_year;
  String? job_location_city;
  int? has_experience;
  String? profile_pic;
  String? cv_link;
  String? cv_upladted_date;
  int? partner_request;

  ProfileSummaryModel(
      {this.id,
      this.first_name,
      this.last_name,
      this.job_location,
      this.mobile,
      this.job_title,
      this.univercity,
      this.experience,
      this.gender,
      this.work_experience,
      this.degree_spc,
      this.email,
      this.education,
      this.job_location_id,
      this.education_id,
      this.degree_spc_id,
      this.univercity_id,
      this.experience_id,
      this.job_title_id,
      this.work_experience_id,
      this.dateofbirth,
      this.companyName,
      this.languages,
      this.passing_year,
      this.job_location_city,
      this.has_experience,
      this.profile_pic,
      this.cv_link,
      this.cv_upladted_date,
      this.partner_request});

  factory ProfileSummaryModel.fromMap(Map<String, dynamic> map) {
    List languages = [];
    DateTime cv_updated_date = new DateTime.now();
    String FormatedDate = "";
    if (map['languages'] != null) {
      languages = jsonDecode(map['languages']);
    }

    if (map['cv_upladted_date'] != null) {
      DateFormat format = new DateFormat("yyyy-MM-ddThh:mm:ss.zzz");
      cv_updated_date = format
          .parse(map['cv_upladted_date'].toString().replaceAll("+00:00", ""));
      FormatedDate = DateFormat('MMM dd, yyyy').format(cv_updated_date);
    }

    return ProfileSummaryModel(
        id: map['id']?.toInt(),
        first_name: map['first_name'],
        last_name: map['last_name'],
        job_location: map['job_location'],
        mobile: map['mobile']?.toInt(),
        job_title: map['job_title'],
        univercity: map['univercity'],
        experience: map['experience'],
        gender: map['gender'],
        work_experience: map['work_experience'],
        degree_spc: map['degree_spc'],
        email: map['email'],
        education: map['education'],
        job_location_id: map['job_location_id'],
        education_id: map['education_id'],
        degree_spc_id: map['degree_spc_id'],
        univercity_id: map['univercity_id'],
        experience_id: map['experience_id'],
        job_title_id: map['job_title_id'],
        work_experience_id: map['work_experience_id'],
        dateofbirth: map['dateofbirth'] ?? '2000-01-01',
        companyName: map['company_name'],
        passing_year: map['passing_year'],
        languages: languages,
        job_location_city: map['job_location'],
        has_experience: map['has_experience'],
        profile_pic: map['profile_pic'],
        cv_link: map['cv_link'],
        cv_upladted_date: FormatedDate,
        partner_request: map['partner_request']);
  }
}
