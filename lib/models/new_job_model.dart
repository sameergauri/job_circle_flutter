import 'dart:convert';

class JobsModel {
  final int? id;
  final int? companyId;
  final String? roleName;
  final String? companyName;
  final String? icon;
  final String? location;
  final String? process;
  final List<String>? skills;
  final double? minCTC;
  final double? maxCTC;
  final String? minExperience;
  final String? maxExperience;
  final String? isFresher;
  final String? totalExperience;
  final String? totalSalary;
  final String? shiftTime;
  final String? shiftDesc;
  final String? education;
  final List<String>? languagesKnown;
  final String? natureOfWork;
  final String? isMonthly;
  final int? spoc;
  final String? city;
  final DateTime? dol;
  final int? isFav;
  final int? favJobId;
  final int? userId;
  final String? status;
  final String? sLocation;
  final int? uid;
  final List<String>? eligibility;
  final String? payoutType;
  late final int? active;

  JobsModel({
    this.id,
    this.companyId,
    this.roleName,
    this.companyName,
    this.icon,
    this.location,
    this.process,
    this.skills,
    this.minCTC,
    this.maxCTC,
    this.minExperience,
    this.maxExperience,
    this.isFresher,
    this.totalExperience,
    this.totalSalary,
    this.shiftTime,
    this.shiftDesc,
    this.education,
    this.languagesKnown,
    this.natureOfWork,
    this.isMonthly,
    this.spoc,
    this.city,
    this.dol,
    this.isFav,
    this.favJobId,
    this.userId,
    this.status,
    this.sLocation,
    this.uid,
    this.eligibility,
    this.payoutType,
    this.active,
  });

  factory JobsModel.fromJson(Map<String, dynamic> json) {
    return JobsModel(
      id: json['id'],
      companyId: json['compnayid'],
      roleName: json['rolename'],
      companyName: json['name'],
      icon: json['icon'],
      location: json['location'],
      process: json['process'],
      skills: _parseSkills(json['skills'] ?? []),
      minCTC: json['minctc']?.toDouble(),
      maxCTC: json['maxctc']?.toDouble(),
      minExperience: json['minexperience'],
      maxExperience: json['maxexperience'],
      isFresher: json['isfresher'],
      totalExperience: json['total_experience'],
      totalSalary: json['total_salary'],
      shiftTime: json['shifttime'],
      shiftDesc: json['shiftdesc'],
      education: json['education'],
      languagesKnown: _parseSkills(json['languageknown'] ?? []),
      natureOfWork: json['naturofwork'],
      isMonthly: json['ismonthly'],
      spoc: json['spoc'],
      city: json['city'],
      dol: json['dol'] != null ? DateTime.parse(json['dol']) : null,
      isFav: json['is_fav'],
      favJobId: json['favJobId'],
      status: json['status'],
      sLocation: json['s_location'],
      userId: json['userId'],
      uid: json['uid'],
      eligibility: _parseSkills(json['eligibility'] ?? []),
      payoutType: json['payout_type'],
      active:json['active']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'compnayid': companyId,
      'rolename': roleName,
      'companyname': companyName,
      'icon': icon,
      'location': location,
      'process': process,
      'skills': skills,
      'minctc': minCTC,
      'maxctc': maxCTC,
      'minexperience': minExperience,
      'maxexperience': maxExperience,
      'isfresher': isFresher,
      'total_experience': totalExperience,
      'total_salary': totalSalary,
      'shifttime': shiftTime,
      'shiftdesc': shiftDesc,
      'education': education,
      'languageknown': languagesKnown,
      'naturofwork': natureOfWork,
      'ismonthly': isMonthly,
      'spoc': spoc,
      'city': city,
      'dol': dol?.toIso8601String(),
      'is_fav': isFav,
      'favJobId': favJobId,
      'userId': userId,
      'status': status,
      's_location': sLocation,
      'uid': uid,
      'eligibility': eligibility,
      'payout_type': payoutType,
      'active': active,
    };
  }

  factory JobsModel.fromMap(Map<String, dynamic> map) {
    return JobsModel(
      id: map['id'],
      companyId: map['compnayid'],
      roleName: map['rolename'],
      companyName: map['companyname'],
      icon: map['icon'],
      location: map['location'],
      process: map['process'],
      skills: List<String>.from(map['skills'] ?? []),
      minCTC: map['minctc']?.toDouble(),
      maxCTC: map['maxctc']?.toDouble(),
      minExperience: map['minexperience'],
      maxExperience: map['maxexperience'],
      isFresher: map['isfresher'],
      totalExperience: map['total_experience'],
      totalSalary: map['total_salary'],
      shiftTime: map['shifttime'],
      shiftDesc: map['shiftdesc'],
      education: map['education'],
      languagesKnown: List<String>.from(map['languageknown'] ?? []),
      natureOfWork: map['naturofwork'],
      isMonthly: map['ismonthly'],
      spoc: map['spoc'],
      city: map['city'],
      dol: map['dol'] != null ? DateTime.parse(map['dol']) : null,
      isFav: map['is_fav'],
      favJobId: map['favJobId'],
      userId: map['userId'],
      status: map['status'],
      sLocation: map['s_location'],
      uid: map['uid'],
      eligibility: List<String>.from(map['eligibility'] ?? []),
      payoutType: map['payout_type'],
      active: map['active'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'compnayid': companyId,
      'rolename': roleName,
      'companyname': companyName,
      'icon': icon,
      'location': location,
      'process': process,
      'skills': skills,
      'minctc': minCTC,
      'maxctc': maxCTC,
      'minexperience': minExperience,
      'maxexperience': maxExperience,
      'isfresher': isFresher,
      'total_experience': totalExperience,
      'total_salary': totalSalary,
      'shifttime': shiftTime,
      'shiftdesc': shiftDesc,
      'education': education,
      'languageknown': languagesKnown,
      'naturofwork': natureOfWork,
      'ismonthly': isMonthly,
      'spoc': spoc,
      'city': city,
      'dol': dol?.toIso8601String(),
      'is_fav': isFav,
      'favJobId': favJobId,
      'userId': userId,
      'status': status,
      's_location': sLocation,
      'uid': uid,
      'eligibility': eligibility,
      'payout_type': payoutType,
      'active': active,
    };
  }

  static List<String>? _parseSkills(dynamic jsonSkills) {
    try {
      if (jsonSkills == null) {
        return null;
      } else if (jsonSkills is String) {
        final List<dynamic> skillsList = json.decode(jsonSkills);
        final List<String> skills =
            skillsList.map((e) => e.toString()).toList();
        return skills;
      } else if (jsonSkills is List<dynamic>) {
        return jsonSkills.cast<String>();
      } else {
        return null;
      }
    } catch (e) {
      print('Error parsing skills: $e');
      return null;
    }
  }
}
