// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:job_circle/models/serachable.dart';

class ProfileSummaryModel with Searchable {
  int? id;
  String? first_name;
  String? middle_name;
  String? last_name;
  String? gender;
  String? email;
  String? martial_status;
  String? dateofbirth;
  String? user_location;
  List<dynamic>? languages;
  List<String>? skills;
  String? cv_link;
  String? profile_pic;
  String? cv_upladted_date;
  int? partner_request;
  int? mobile;
  int? alternate_no;
  String? user_zone;
  String? vaccination_certificate;
  String? blood_group;
  bool? vaccination;
  String? user_locality;
  String? education;
  String? experience;
  String? updated_date;
  String? createdon;
  int? report_to;
  // bool? isActive; // Add this field to represent active status
  // DateTime? lastActiveDate;
  bool isVisible; // Add this field to store last active date
  String? cover_pic;
  String? bio;

  ProfileSummaryModel({
    this.id,
    this.first_name,
    this.middle_name,
    this.last_name,
    this.gender,
    this.email,
    this.martial_status,
    this.dateofbirth,
    this.user_location,
    this.languages,
    this.skills,
    this.cv_link,
    this.profile_pic,
    this.cv_upladted_date,
    this.partner_request,
    this.mobile,
    this.alternate_no,
    this.user_zone,
    this.vaccination_certificate,
    this.blood_group,
    this.vaccination,
    this.user_locality,
    this.education,
    this.experience,
    this.updated_date,
    this.createdon,
    // this.isActive,
    // this.lastActiveDate,
    this.isVisible = true,
    this.cover_pic,
    this.bio,
    this.report_to,
  });

  factory ProfileSummaryModel.fromJson(Map<String, dynamic> json) {
    try {
      List<String>? languagesList;
      if (json['languages'] is String) {
        try {
          languagesList = List<String>.from(jsonDecode(json['languages']));
        } catch (e) {
          // Handle JSON decoding error if needed
        }
      } else if (json['languages'] is List) {
        languagesList = List<String>.from(json['languages']);
      }
      return ProfileSummaryModel(
        id: json['id'],
        first_name: json['first_name'],
        middle_name: json['middle_name'],
        last_name: json['last_name'],
        gender: json['gender'],
        email: json['email'],
        martial_status: json['martial_status'],
        dateofbirth: json['dateofbirth'],
        user_location: json['user_location'],
        languages: languagesList,
        /*  languages: List<String>.from(
              json['languages'] != null ? jsonDecode(json['languages']) : []), */
        skills: List<String>.from(json['skills'] ?? []),
        cv_link: json['cv_link'],
        profile_pic: json['profile_pic'],
        cv_upladted_date: json['cv_upladted_date'],
        partner_request: json['partner_request'],
        mobile: json['mobile'],
        alternate_no: json['alternate_no'],
        user_zone: json['user_zone'],
        vaccination_certificate: json['vaccination_certificate'],
        blood_group: json['blood_group'],
        vaccination: json['vaccination'],
        user_locality: json['user_locality'],
        education: json['education'],
        experience: json['experience'],
        updated_date: json['updated_date'],
        createdon: json['createdon'],
        // isActive: json['active'],
        // lastActiveDate: json["lastActive"]
        cover_pic: json['cover_pic'],
        bio: json['bio'],
        report_to: json['report_to'],
      );
    } catch (e) {
      print("Error parsing JSON: $e");
      return ProfileSummaryModel(); // Return a default instance or handle the error accordingly
    }
  }
  /*  factory ProfileSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProfileSummaryModel(
        id: json['id'],
        first_name: json['first_name'],
        middle_name: json['middle_name'],
        last_name: json['last_name'],
        gender: json['gender'],
        email: json['email'],
        martial_status: json['martial_status'],
        dateofbirth: json['dateofbirth'],
        user_location: json['user_location'],
        languages: List<String>.from(json['languages'] ?? []),
        skills: List<String>.from(json['skills'] ?? []),
        cv_link: json['cv_link'],
        profile_pic: json['profile_pic'],
        cv_upladted_date: json['cv_upladted_date'],
        partner_request: json['partner_request'],
        mobile: json['mobile'],
        alternate_no: json['alternate_no'],
        user_zone: json['user_zone'],
        vaccination_certificate: json['vaccination_certificate'],
        blood_group: json['blood_group'],
        vaccination: json['vaccination'],
        user_locality: json['user_locality'],
        education: json['education'],
        experience: json['experience'],
        updated_date: json['updated_date'],
        createdon: json['createdon'],
        // isActive: json['active'],
        // lastActiveDate: json["lastActive"]
        cover_pic: json['cover_pic'],
        bio: json['bio']);
  } */

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': first_name,
      'middle_name': middle_name,
      'last_name': last_name,
      'gender': gender,
      'email': email,
      'martial_status': martial_status,
      'dateofbirth': dateofbirth,
      'user_location': user_location,
      'languages': languages,
      'skills': skills,
      'cv_link': cv_link,
      'profile_pic': profile_pic,
      'cv_upladted_date': cv_upladted_date,
      'partner_request': partner_request,
      'mobile': mobile,
      'alternate_no': alternate_no,
      'user_zone': user_zone,
      'vaccination_certificate': vaccination_certificate,
      'blood_group': blood_group,
      'vaccination': vaccination,
      'user_locality': user_locality,
      'education': education,
      'experience': experience,
      'updated_date': updated_date,
      'createdon': createdon,
      // 'active': isActive,
      // 'lastActive': lastActiveDate
      'cover_pic': cover_pic,
      'bio': bio,
      'report_to': report_to,
    };
  }

  @override
  bool containsQuery(String query) {
    return first_name!.toLowerCase().contains(query) ||
        last_name!.toLowerCase().contains(query) ||
        user_location!.toLowerCase().contains(query) ||
        skills!.any((skill) => skill.toLowerCase().contains(query));
    // Add more relevant fields as necessary.
  }

  @override
  Map<String, dynamic> getSearchData() {
    return {
      'profile': toJson(),
      'education': education,
      'experience': experience,
      // Include other relevant data related to the profile
      // For example, additional fields from the education and experience models
    };
  }
}

class Education with Searchable {
  final int? id;
  String? level;
  final String? board;
  final String? university;
  final String? fieldOfStudy;
  final int? firstYear;
  final String? marksheet;
  final int? passingYear;
  final int? userId;
  final String? degree_spc;
  final int? university_id;
  final int? degree_id;
  final int? fieldofstudy_id;
  final String? icon;
  final String? subvalue;

  Education({
    this.id,
    this.level,
    this.board,
    this.university,
    this.fieldOfStudy,
    this.firstYear,
    this.marksheet,
    this.passingYear,
    this.userId,
    this.degree_spc,
    this.degree_id,
    this.fieldofstudy_id,
    this.university_id,
    this.icon,
    this.subvalue,
  });

  factory Education.fromMap(Map<String, dynamic> map) {
    return Education(
      id: map['id'] as int?,
      level: map['level'] as String?,
      board: map['board'] as String?,
      university: map['university'] as String?,
      fieldOfStudy: map['fieldOfStudy'] as String?,
      firstYear: map['firstYear'] as int?,
      marksheet: map['marksheet'] as String?,
      passingYear: map['passingYear'] as int?,
      userId: map['userId'] as int?,
      degree_spc: map['degree_spc'] as String?,
      degree_id: map['degreeId'] as int?,
      fieldofstudy_id: map['fieldId'] as int?,
      university_id: map['universityId'] as int?,
      icon: map['icon'] as String?,
      subvalue: map['subvalue'] as String?,
    );
  }

  static List<Education> fromList(List<dynamic> list) {
    List<Education> educationList = [];
    for (var item in list) {
      educationList.add(Education.fromMap(item));
    }
    return educationList;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'level': level,
      'board': board,
      'university': university,
      'fieldOfStudy': fieldOfStudy,
      'firstYear': firstYear,
      'marksheet': marksheet,
      'passingYear': passingYear,
      'userId': userId,
      'degree_spc': degree_spc,
      'fieldofstudy_id': fieldofstudy_id,
      'degree_id': degree_id,
      'university_id': university_id,
      'icon': icon,
      'subvalue': subvalue,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
        id: json['id'],
        level: json['level'],
        board: json['board'],
        university: json['university'],
        fieldOfStudy: json['fieldOfStudy'],
        firstYear: json['firstYear'],
        marksheet: json['marksheet'],
        passingYear: json['passingYear'],
        userId: json['userId'],
        degree_spc: json['degree_spc'],
        degree_id: json['degreeId'],
        fieldofstudy_id: json['fieldId'],
        university_id: json['universityId'],
        icon: json['icon'],
        subvalue: json['subvalue']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'board': board,
      'university': university,
      'fieldOfStudy': fieldOfStudy,
      'firstYear': firstYear,
      'marksheet': marksheet,
      'passingYear': passingYear,
      'userId': userId,
      'degree_spc': degree_spc,
      'fieldofstudy_id': fieldofstudy_id,
      'degree_id': degree_id,
      'university_id': university_id,
      'icon': icon,
      'subvalue': subvalue
    };
  }

  @override
  String toString() {
    return 'Education(id: $id, level: $level, board: $board, university: $university, fieldOfStudy: $fieldOfStudy, firstYear: $firstYear, marksheet: $marksheet, passingYear: $passingYear, userId: $userId, degree_spc: $degree_spc,icon:$icon,subvalue:$subvalue)';
  }

  @override
  bool containsQuery(String query) {
    return level != null && level!.toLowerCase().contains(query) ||
        university != null && university!.toLowerCase().contains(query) ||
        // Add other relevant fields for the search
        false;
  }

  @override
  Map<String, dynamic> getSearchData() {
    return {
      'education': toMap(),
      // Include other relevant data related to education
      // For example, profile data, experience data, etc.
    };
  }
}

class Experience with Searchable {
  final int? id;
  final dynamic userId;
  String? job_title;
  String? company_name;
  int? isCurrent;
  String? description;
  List<String>? skills_exp;
  String? work_type;
  String? company_location;
  String? emptype;
  DateTime? joining_date;
  DateTime? last_working_date;
  String? salary;
  int? ismonthly;
  String? offer_letter;
  String? appointment_letter;
  String? salary_slip;
  String? experience_lettter;
  String? increment_letter;
  String? availability;
  String? shortname;
  String? icon;
  int? companyid;
  int? jobid;
  int? city_id;

  Experience({
    this.id,
    this.userId,
    this.job_title,
    this.company_name,
    this.isCurrent,
    this.description,
    this.skills_exp,
    this.work_type,
    this.company_location,
    this.emptype,
    this.joining_date,
    this.last_working_date,
    this.salary,
    this.ismonthly,
    this.offer_letter,
    this.appointment_letter,
    this.salary_slip,
    this.experience_lettter,
    this.increment_letter,
    this.availability,
    this.shortname,
    this.icon,
    this.companyid,
    this.jobid,
    this.city_id,
  });

  static Experience fromMap(Map<String, dynamic> map) {
    return Experience(
        id: map['id'] as int?,
        userId: map['userId'],
        job_title: map['job_title'] as String?,
        company_name: map['company_name'] as String?,
        company_location: map['company_location'] as String?,
        work_type: map['work_type'] as String?,
        ismonthly: map['ismonthly'] as int?,
        salary: map['salary'] as String?,
        joining_date: map['joining_date'] != null
            ? DateTime.parse(map['joining_date'] as String)
            : null,
        last_working_date: map['last_working_date'] != null
            ? DateTime.parse(map['last_working_date'] as String)
            : null,
        availability: map['availability'],
        appointment_letter: map['appointment_letter'] as String?,
        salary_slip: map['salary_slip'] as String?,
        experience_lettter: map['experience_lettter'] as String?,
        skills_exp: List<String>.from(map['skills_exp'] ?? []),
        description: map['description'],
        emptype: map['emptype'],
        increment_letter: map['increment_letter'],
        isCurrent: map['isCurrent'],
        offer_letter: map['offer_letter'],
        shortname: map['shortname'],
        companyid: map['companyid'] as int?,
        icon: map['icon'],
        jobid: map['jobid'] as int?,
        city_id: map['city_id'] as int?);
  }

  static List<Experience> fromList(List<dynamic> list) {
    List<Experience> experienceList = [];
    for (var item in list) {
      experienceList.add(Experience.fromMap(item));
    }
    return experienceList;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'job_title': job_title,
      'company_name': company_name,
      'company_location': company_location,
      'work_type': work_type,
      'ismonthly': ismonthly,
      'salary': salary,
      'joining_date': joining_date?.toIso8601String(),
      'last_working_date': last_working_date?.toIso8601String(),
      'availability': availability,
      'appointment_letter': appointment_letter,
      'salary_slip': salary_slip,
      'experience_lettter': experience_lettter,
      'skills_exp': skills_exp,
      'description': description,
      'emptype': emptype,
      'increment_letter': increment_letter,
      'offer_letter': offer_letter,
      'isCurrent': isCurrent,
      'shortname': shortname,
      'icon': icon,
      'companyid': companyid,
      'jobid': jobid,
      'city_id': city_id,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
        id: json['id'] as int?,
        userId: json['userId'],
        job_title: json['job_title'] as String?,
        company_name: json['company_name'] as String?,
        company_location: json['company_location'] as String?,
        work_type: json['work_type'] as String?,
        ismonthly: json['ismonthly'] as int?,
        salary: json['salary'] as String?,
        joining_date: json['joining_date'] != null
            ? DateTime.parse(json['joining_date'] as String)
            : null,
        last_working_date: json['last_working_date'] != null
            ? DateTime.parse(json['last_working_date'] as String)
            : null,
        availability: json['availability'],
        appointment_letter: json['appointment_letter'] as String?,
        salary_slip: json['salary_slip'] as String?,
        experience_lettter: json['experience_lettter'] as String?,
        skills_exp: List<String>.from(json['skills_exp'] ?? []),
        description: json['description'],
        emptype: json['emptype'],
        increment_letter: json['increment_letter'],
        isCurrent: json['isCurrent'],
        offer_letter: json['offer_letter'],
        shortname: json['shortname'],
        companyid: json['companyid'] as int?,
        icon: json['icon'],
        jobid: json['jobid'] as int?,
        city_id: json['city_id'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'job_title': job_title,
      'company_name': company_name,
      'company_location': company_location,
      'work_type': work_type,
      'ismonthly': ismonthly,
      'salary': salary,
      'joining_date': joining_date?.toIso8601String(),
      'last_working_date': last_working_date?.toIso8601String(),
      'availability': availability,
      'appointment_letter': appointment_letter,
      'salary_slip': salary_slip,
      'experience_lettter': experience_lettter,
      'skills_exp': skills_exp,
      'description': description,
      'emptype': emptype,
      'increment_letter': increment_letter,
      'offer_letter': offer_letter,
      'isCurrent': isCurrent,
      'shortname': shortname,
      'icon': icon,
      'companyid': companyid,
      'jobid': jobid,
      'city_id': city_id,
    };
  }

  @override
  String toString() {
    return 'Experience(companyid:$companyid,id: $id, userId: $userId, job_title: $job_title, company_name: $company_name, company_location: $company_location,ismonthly: $ismonthly,  salary: $salary, joining_date: $joining_date, last_working_date: $last_working_date, availability: $availability, appointment_letter: $appointment_letter, salary_slip: $salary_slip,  experience_lettter: $experience_lettter, skills_exp: $skills_exp,work_type:$work_type,description:$description,emptype:$emptype,increment_letter:$increment_letter,offer_letter:$offer_letter,isCurrent:$isCurrent)';
  }

  @override
  bool containsQuery(String query) {
    return job_title != null && job_title!.toLowerCase().contains(query) ||
        company_name != null && company_name!.toLowerCase().contains(query) ||
        // Add other relevant fields for the search
        false;
  }

  @override
  Map<String, dynamic> getSearchData() {
    return {
      'experience': toMap(),
      // Include other relevant data related to experience
      // For example, profile data, education data, etc.
    };
  }
}
