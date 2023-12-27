

// ignore_for_file: file_names

import 'package:job_circle/models/serachable.dart';

class UserDetail with Searchable {
  int? id;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  String? userLocation;
  List<dynamic>? languages;
  List<String>? skills;
  String? cvLink;
  String? profilePic;
  int? mobile;
  int? alternateNo;
  String? userLocality;
  String? education;
  String? experience;
  String? updatedDate;
  String? createdOn;
  String? lastActive;
  String? level;
  String? university;
  int? passingYear;
  String? jobTitleRecent;
  String? companyNameRecent;
  String? salaryRecent;
  DateTime? joiningDateRecent;
  DateTime? lastWorkingDateRecent;
  String? availabilityRecent;
  String? jobTitlePrevious;
  String? companyNamePrevious;
  String? salaryPrevious;
  DateTime? joiningDatePrevious;
  DateTime? lastWorkingDatePrevious;
  String? availabilityPrevious;
  bool? active;
  bool isVisible; // Add this field to store last active date

  UserDetail({
    this.id,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.languages,
    this.mobile,
    this.alternateNo,
    this.education,
    this.experience,
    this.createdOn,
    this.active,
    this.userLocation,
    this.skills,
    this.cvLink,
    this.profilePic,
    this.userLocality,
    this.updatedDate,
    this.lastActive,
    this.level,
    this.university,
    this.passingYear,
    this.jobTitleRecent,
    this.companyNameRecent,
    this.salaryRecent,
    this.joiningDateRecent,
    this.lastWorkingDateRecent,
    this.availabilityRecent,
    this.jobTitlePrevious,
    this.companyNamePrevious,
    this.salaryPrevious,
    this.joiningDatePrevious,
    this.lastWorkingDatePrevious,
    this.availabilityPrevious,
    this.isVisible = true,
  });

  factory UserDetail.fromMap(Map<String, dynamic> map) {
    return UserDetail(
      id: map['id'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      dateOfBirth: map['dateofbirth'],
      userLocation: map['user_location'],
      languages: List<String>.from(map['languages']),
      skills: map['skills'],
      cvLink: map['cv_link'],
      profilePic: map['profile_pic'],
      mobile: map['mobile'],
      alternateNo: map['alternate_no'],
      userLocality: map['user_locality'],
      education: map['education'],
      experience: map['experience'],
      updatedDate: map['updated_date'],
      createdOn: map['createdon'],
      lastActive: map['lastActive'],
      level: map['level'],
      university: map['university'],
      passingYear: map['passingYear'],
      jobTitleRecent: map['job_title_recent'],
      companyNameRecent: map['company_name_recent'],
      salaryRecent: map['salary_recent'],
      joiningDateRecent: map['joining_date_recent'],
      lastWorkingDateRecent: map['last_working_date_recent'],
      availabilityRecent: map['availability_recent'],
      jobTitlePrevious: map['job_title_previous'],
      companyNamePrevious: map['company_name_previous'],
      salaryPrevious: map['salary_previous'],
      joiningDatePrevious: map['joining_date_previous'],
      lastWorkingDatePrevious: map['last_working_date_previous'],
      availabilityPrevious: map['availability_previous'],
      active: map['active'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'dateofbirth': dateOfBirth,
      'user_location': userLocation,
      'languages': languages,
      'skills': skills,
      'cv_link': cvLink,
      'profile_pic': profilePic,
      'mobile': mobile,
      'alternate_no': alternateNo,
      'user_locality': userLocality,
      'education': education,
      'experience': experience,
      'updated_date': updatedDate,
      'createdon': createdOn,
      'lastActive': lastActive,
      'level': level,
      'university': university,
      'passingYear': passingYear,
      'job_title_recent': jobTitleRecent,
      'company_name_recent': companyNameRecent,
      'salary_recent': salaryRecent,
      'joining_date_recent': joiningDateRecent,
      'last_working_date_recent': lastWorkingDateRecent,
      'availability_recent': availabilityRecent,
      'job_title_previous': jobTitlePrevious,
      'company_name_previous': companyNamePrevious,
      'salary_previous': salaryPrevious,
      'joining_date_previous': joiningDatePrevious,
      'last_working_date_previous': lastWorkingDatePrevious,
      'availability_previous': availabilityPrevious,
      'active': active,
    };
  }

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    return UserDetail(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      dateOfBirth: json['dateofbirth'],
      userLocation: json['user_location'],
      languages: List<String>.from(json['languages'] ?? []),
      skills: List<String>.from(json['skills'] ?? []),
      cvLink: json['cv_link'],
      profilePic: json['profile_pic'],
      mobile: json['mobile'],
      alternateNo: json['alternate_no'],
      userLocality: json['user_locality'],
      education: json['education'],
      experience: json['experience'],
      updatedDate: json['updated_date'],
      createdOn: json['createdon'],
      lastActive: json['lastActive'],
      level: json['level'],
      university: json['university'],
      passingYear: json['passingYear'],
      jobTitleRecent: json['job_title_recent'],
      companyNameRecent: json['company_name_recent'],
      salaryRecent: json['salary_recent'],
      joiningDateRecent: json['joining_date_recent'] != null
          ? DateTime.parse(json['joining_date_recent'] as String)
          : null,
      lastWorkingDateRecent: json['last_working_date_recent'] != null
          ? DateTime.parse(json['last_working_date_recent'] as String)
          : null,
      /*  joiningDateRecent: json['joining_date_recent'],
      lastWorkingDateRecent: json['last_working_date_recent'], */
      availabilityRecent: json['availability_recent'],
      jobTitlePrevious: json['job_title_previous'],
      companyNamePrevious: json['company_name_previous'],
      salaryPrevious: json['salary_previous'],
      joiningDatePrevious: json['joining_date_previous'] != null
          ? DateTime.parse(json['joining_date_previous'] as String)
          : null,
      lastWorkingDatePrevious: json['last_working_date_previous'] != null
          ? DateTime.parse(json['last_working_date_previous'] as String)
          : null,
      /*   joiningDatePrevious: json['joining_date_previous'],
      lastWorkingDatePrevious: json['last_working_date_previous'], */
      availabilityPrevious: json['availability_previous'],
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'users': {
        'id': id,
        'first_name': firstName,
        'last_name': lastName,
        'dateofbirth': dateOfBirth,
        'user_location': userLocation,
        'languages': languages,
        'skills': skills,
        'cv_link': cvLink,
        'profile_pic': profilePic,
        'mobile': mobile,
        'alternate_no': alternateNo,
        'user_locality': userLocality,
        'education': education,
        'experience': experience,
        'updated_date': updatedDate,
        'createdon': createdOn,
        'lastActive': lastActive,
        'level': level,
        'university': university,
        'passingYear': passingYear,
        'job_title_recent': jobTitleRecent,
        'company_name_recent': companyNameRecent,
        'salary_recent': salaryRecent,
        'joining_date_recent': joiningDateRecent,
        'last_working_date_recent': lastWorkingDateRecent,
        'availability_recent': availabilityRecent,
        'job_title_previous': jobTitlePrevious,
        'company_name_previous': companyNamePrevious,
        'salary_previous': salaryPrevious,
        'joining_date_previous': joiningDatePrevious,
        'last_working_date_previous': lastWorkingDatePrevious,
        'availability_previous': availabilityPrevious,
        'active': active,
      }
    };
  }

  @override
  bool containsQuery(String query) {
    return firstName!.toLowerCase().contains(query) ||
        lastName!.toLowerCase().contains(query) ||
        userLocation!.toLowerCase().contains(query) ||
        skills!.any((skill) => skill.toLowerCase().contains(query));
    // Add more relevant fields as necessary.
  }

  @override
  Map<String, dynamic> getSearchData() {
    return {
      'profile': toJson()
      // 'education': education,
      // 'experience': experience,
      // Include other relevant data related to the profile
      // For example, additional fields from the education and experience models
    };
  }

  @override
  String toString() {
    return 'UserDetail{id: $id, firstName: $firstName, lastName: $lastName, dateOfBirth: $dateOfBirth, userLocation: $userLocation, languages: $languages, skills: $skills, cvLink: $cvLink, profilePic: $profilePic, mobile: $mobile, alternateNo: $alternateNo, userLocality: $userLocality, education: $education, experience: $experience, updatedDate: $updatedDate, createdOn: $createdOn, lastActive: $lastActive, level: $level, university: $university, passingYear: $passingYear, jobTitleRecent: $jobTitleRecent, companyNameRecent: $companyNameRecent, salaryRecent: $salaryRecent, joiningDateRecent: $joiningDateRecent, lastWorkingDateRecent: $lastWorkingDateRecent, availabilityRecent: $availabilityRecent, jobTitlePrevious: $jobTitlePrevious, companyNamePrevious: $companyNamePrevious, salaryPrevious: $salaryPrevious, joiningDatePrevious: $joiningDatePrevious, lastWorkingDatePrevious: $lastWorkingDatePrevious, availabilityPrevious: $availabilityPrevious, active: $active}';
  }
}
