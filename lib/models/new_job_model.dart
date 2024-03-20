// ignore_for_file: non_constant_identifier_names, avoid_print

import 'dart:convert';

class JobsModel {
  final int? id;
  final int? companyId;
  final String? roleName;
  final String? companyName;
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
  final List<String>? languagesKnown;
  final String? natureOfWork;
  final String? isMonthly;
  final int? spoc;
  final String? city;
  final DateTime? dol;
  final int? isFav;
  final int? favJobId;
  final int? userId;
  final String? payoutType;
  late final int? active;
  late final String? payment_clause;
  late final int? is_campus;
  late final int? is_support_staff;
  final List<dynamic>? interviewrounds;
  final int? sponsored_position;
  

  JobsModel({
    this.id,
    this.companyId,
    this.roleName,
    this.companyName,
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
    this.languagesKnown,
    this.natureOfWork,
    this.isMonthly,
    this.spoc,
    this.city,
    this.dol,
    this.isFav,
    this.favJobId,
    this.userId,
    this.payoutType,
    this.active,
    this.payment_clause,
    this.is_campus,
    this.is_support_staff,
    this.interviewrounds,
    this.sponsored_position,
  });

  factory JobsModel.fromJson(Map<String, dynamic> json) {
    return JobsModel(
      id: json['id'],
      companyId: json['compnayid'],
      roleName: json['rolename'],
      companyName: json['name'],
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
      languagesKnown: _parseSkills(json['languageknown'] ?? []),
      natureOfWork: json['naturofwork'],
      isMonthly: json['ismonthly'],
      spoc: json['spoc'],
      city: json['city'],
      dol: json['dol'] != null ? DateTime.parse(json['dol']) : null,
      isFav: json['is_fav'],
      favJobId: json['favJobId'],
      userId: json['userId'],
      payoutType: json['payout_type'],
      active: json['active'],
      payment_clause: json['payment_clause'],
      is_campus: json['is_campus'],
      is_support_staff: json['is_support_staff'],
      interviewrounds: _parseSkills(
        json['interviewrounds'],
      ),
      sponsored_position: json['sponsored_position'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'compnayid': companyId,
      'rolename': roleName,
      'companyname': companyName,
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
      'languageknown': languagesKnown,
      'naturofwork': natureOfWork,
      'ismonthly': isMonthly,
      'spoc': spoc,
      'city': city,
      'dol': dol?.toIso8601String(),
      'is_fav': isFav,
      'favJobId': favJobId,
      'userId': userId,
      'payout_type': payoutType,
      'active': active,
      'payment_clause': payment_clause,
      'is_support_staff': is_support_staff,
      'is_campus': is_campus,
      'interviewrounds': interviewrounds,
      'sponsored_position': sponsored_position
    };
  }

  factory JobsModel.fromMap(Map<String, dynamic> map) {
    return JobsModel(
      id: map['id'],
      companyId: map['compnayid'],
      roleName: map['rolename'],
      companyName: map['companyname'],
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
      languagesKnown: List<String>.from(map['languageknown'] ?? []),
      natureOfWork: map['naturofwork'],
      isMonthly: map['ismonthly'],
      spoc: map['spoc'],
      city: map['city'],
      dol: map['dol'] != null ? DateTime.parse(map['dol']) : null,
      isFav: map['is_fav'],
      favJobId: map['favJobId'],
      userId: map['userId'],
      payoutType: map['payout_type'],
      active: map['active'],
      payment_clause: map['payment_clause'],
      is_support_staff: map['is_support_staff'],
      is_campus: map['is_campus'],
      interviewrounds: map['interviewrounds'],
      sponsored_position: map['sponsored_position'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'compnayid': companyId,
      'rolename': roleName,
      'companyname': companyName,
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
      'languageknown': languagesKnown,
      'naturofwork': natureOfWork,
      'ismonthly': isMonthly,
      'spoc': spoc,
      'city': city,
      'dol': dol?.toIso8601String(),
      'is_fav': isFav,
      'favJobId': favJobId,
      'userId': userId,
      'payout_type': payoutType,
      'active': active,
      'payment_clause': payment_clause,
      'is_support_staff': is_support_staff,
      'is_campus': is_campus,
      'interviewrounds': interviewrounds,
      'sponsored_position': sponsored_position
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
