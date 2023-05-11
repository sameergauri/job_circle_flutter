import 'dart:convert';

import 'package:flutter/foundation.dart';

class Job {
  final int active;
  final int age_group;
  final String boundarylimits;
  final String category;
  final String client_payout;
  final int commercial;
  final int compnayid;
  final String created_date;
  final String ctcdesc;
  final List<String> education;
  final String eligibility;
  final String emptype;
  final int experience;
  final String gender;
  final int id;
  final List<String> inteviewrounds;
  final List<String> job_benifits;
  final List<String> key_responsible;
  final List<String> languageknown;
  final int locationid;
  final int maxctc;
  final int minctc;
  final String more_details;
  final int naturofworkid;
  final int no_of_vacancy;
  final String paymentclause;
  final String payout;
  final String process;
  final String rolename;
  final String search_keywords;
  final String shiftdesc;
  final List<String> shifttime;
  final List<String> skills;
  final int spoc;
  final String updated_date;
  final List<int> work_location;
  Job({
    required this.active,
    required this.age_group,
    required this.boundarylimits,
    required this.category,
    required this.client_payout,
    required this.commercial,
    required this.compnayid,
    required this.created_date,
    required this.ctcdesc,
    required this.education,
    required this.eligibility,
    required this.emptype,
    required this.experience,
    required this.gender,
    required this.id,
    required this.inteviewrounds,
    required this.job_benifits,
    required this.key_responsible,
    required this.languageknown,
    required this.locationid,
    required this.maxctc,
    required this.minctc,
    required this.more_details,
    required this.naturofworkid,
    required this.no_of_vacancy,
    required this.paymentclause,
    required this.payout,
    required this.process,
    required this.rolename,
    required this.search_keywords,
    required this.shiftdesc,
    required this.shifttime,
    required this.skills,
    required this.spoc,
    required this.updated_date,
    required this.work_location,
  });

  Job copyWith({
    int? active,
    int? age_group,
    String? boundarylimits,
    String? category,
    String? client_payout,
    int? commercial,
    int? compnayid,
    String? created_date,
    String? ctcdesc,
    List<String>? education,
    String? eligibility,
    String? emptype,
    int? experience,
    String? gender,
    int? id,
    List<String>? inteviewrounds,
    List<String>? job_benifits,
    List<String>? key_responsible,
    List<String>? languageknown,
    int? locationid,
    int? maxctc,
    int? minctc,
    String? more_details,
    int? naturofworkid,
    int? no_of_vacancy,
    String? paymentclause,
    String? payout,
    String? process,
    String? rolename,
    String? search_keywords,
    String? shiftdesc,
    List<String>? shifttime,
    List<String>? skills,
    int? spoc,
    String? updated_date,
    List<int>? work_location,
  }) {
    return Job(
      active: active ?? this.active,
      age_group: age_group ?? this.age_group,
      boundarylimits: boundarylimits ?? this.boundarylimits,
      category: category ?? this.category,
      client_payout: client_payout ?? this.client_payout,
      commercial: commercial ?? this.commercial,
      compnayid: compnayid ?? this.compnayid,
      created_date: created_date ?? this.created_date,
      ctcdesc: ctcdesc ?? this.ctcdesc,
      education: education ?? this.education,
      eligibility: eligibility ?? this.eligibility,
      emptype: emptype ?? this.emptype,
      experience: experience ?? this.experience,
      gender: gender ?? this.gender,
      id: id ?? this.id,
      inteviewrounds: inteviewrounds ?? this.inteviewrounds,
      job_benifits: job_benifits ?? this.job_benifits,
      key_responsible: key_responsible ?? this.key_responsible,
      languageknown: languageknown ?? this.languageknown,
      locationid: locationid ?? this.locationid,
      maxctc: maxctc ?? this.maxctc,
      minctc: minctc ?? this.minctc,
      more_details: more_details ?? this.more_details,
      naturofworkid: naturofworkid ?? this.naturofworkid,
      no_of_vacancy: no_of_vacancy ?? this.no_of_vacancy,
      paymentclause: paymentclause ?? this.paymentclause,
      payout: payout ?? this.payout,
      process: process ?? this.process,
      rolename: rolename ?? this.rolename,
      search_keywords: search_keywords ?? this.search_keywords,
      shiftdesc: shiftdesc ?? this.shiftdesc,
      shifttime: shifttime ?? this.shifttime,
      skills: skills ?? this.skills,
      spoc: spoc ?? this.spoc,
      updated_date: updated_date ?? this.updated_date,
      work_location: work_location ?? this.work_location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'active': active,
      'age_group': age_group,
      'boundarylimits': boundarylimits,
      'category': category,
      'client_payout': client_payout,
      'commercial': commercial,
      'compnayid': compnayid,
      'created_date': created_date,
      'ctcdesc': ctcdesc,
      'education': education,
      'eligibility': eligibility,
      'emptype': emptype,
      'experience': experience,
      'gender': gender,
      'id': id,
      'inteviewrounds': inteviewrounds,
      'job_benifits': job_benifits,
      'key_responsible': key_responsible,
      'languageknown': languageknown,
      'locationid': locationid,
      'maxctc': maxctc,
      'minctc': minctc,
      'more_details': more_details,
      'naturofworkid': naturofworkid,
      'no_of_vacancy': no_of_vacancy,
      'paymentclause': paymentclause,
      'payout': payout,
      'process': process,
      'rolename': rolename,
      'search_keywords': search_keywords,
      'shiftdesc': shiftdesc,
      'shifttime': shifttime,
      'skills': skills,
      'spoc': spoc,
      'updated_date': updated_date,
      'work_location': work_location,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      active: map['active']?.toInt() ?? 0,
      age_group: map['age_group']?.toInt() ?? 0,
      boundarylimits: map['boundarylimits'] ?? '',
      category: map['category'] ?? '',
      client_payout: map['client_payout'] ?? '',
      commercial: map['commercial']?.toInt() ?? 0,
      compnayid: map['compnayid']?.toInt() ?? 0,
      created_date: map['created_date'] ?? '',
      ctcdesc: map['ctcdesc'] ?? '',
      education: List<String>.from(map['education']),
      eligibility: map['eligibility'] ?? '',
      emptype: map['emptype'] ?? '',
      experience: map['experience']?.toInt() ?? 0,
      gender: map['gender'] ?? '',
      id: map['id']?.toInt() ?? 0,
      inteviewrounds: List<String>.from(map['inteviewrounds']),
      job_benifits: List<String>.from(map['job_benifits']),
      key_responsible: List<String>.from(map['key_responsible']),
      languageknown: List<String>.from(map['languageknown']),
      locationid: map['locationid']?.toInt() ?? 0,
      maxctc: map['maxctc']?.toInt() ?? 0,
      minctc: map['minctc']?.toInt() ?? 0,
      more_details: map['more_details'] ?? '',
      naturofworkid: map['naturofworkid']?.toInt() ?? 0,
      no_of_vacancy: map['no_of_vacancy']?.toInt() ?? 0,
      paymentclause: map['paymentclause'] ?? '',
      payout: map['payout'] ?? '',
      process: map['process'] ?? '',
      rolename: map['rolename'] ?? '',
      search_keywords: map['search_keywords'] ?? '',
      shiftdesc: map['shiftdesc'] ?? '',
      shifttime: List<String>.from(map['shifttime']),
      skills: List<String>.from(map['skills']),
      spoc: map['spoc']?.toInt() ?? 0,
      updated_date: map['updated_date'] ?? '',
      work_location: List<int>.from(map['work_location']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Job.fromJson(String source) => Job.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Job(active: $active, age_group: $age_group, boundarylimits: $boundarylimits, category: $category, client_payout: $client_payout, commercial: $commercial, compnayid: $compnayid, created_date: $created_date, ctcdesc: $ctcdesc, education: $education, eligibility: $eligibility, emptype: $emptype, experience: $experience, gender: $gender, id: $id, inteviewrounds: $inteviewrounds, job_benifits: $job_benifits, key_responsible: $key_responsible, languageknown: $languageknown, locationid: $locationid, maxctc: $maxctc, minctc: $minctc, more_details: $more_details, naturofworkid: $naturofworkid, no_of_vacancy: $no_of_vacancy, paymentclause: $paymentclause, payout: $payout, process: $process, rolename: $rolename, search_keywords: $search_keywords, shiftdesc: $shiftdesc, shifttime: $shifttime, skills: $skills, spoc: $spoc, updated_date: $updated_date, work_location: $work_location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Job &&
      other.active == active &&
      other.age_group == age_group &&
      other.boundarylimits == boundarylimits &&
      other.category == category &&
      other.client_payout == client_payout &&
      other.commercial == commercial &&
      other.compnayid == compnayid &&
      other.created_date == created_date &&
      other.ctcdesc == ctcdesc &&
      listEquals(other.education, education) &&
      other.eligibility == eligibility &&
      other.emptype == emptype &&
      other.experience == experience &&
      other.gender == gender &&
      other.id == id &&
      listEquals(other.inteviewrounds, inteviewrounds) &&
      listEquals(other.job_benifits, job_benifits) &&
      listEquals(other.key_responsible, key_responsible) &&
      listEquals(other.languageknown, languageknown) &&
      other.locationid == locationid &&
      other.maxctc == maxctc &&
      other.minctc == minctc &&
      other.more_details == more_details &&
      other.naturofworkid == naturofworkid &&
      other.no_of_vacancy == no_of_vacancy &&
      other.paymentclause == paymentclause &&
      other.payout == payout &&
      other.process == process &&
      other.rolename == rolename &&
      other.search_keywords == search_keywords &&
      other.shiftdesc == shiftdesc &&
      listEquals(other.shifttime, shifttime) &&
      listEquals(other.skills, skills) &&
      other.spoc == spoc &&
      other.updated_date == updated_date &&
      listEquals(other.work_location, work_location);
  }

  @override
  int get hashCode {
    return active.hashCode ^
      age_group.hashCode ^
      boundarylimits.hashCode ^
      category.hashCode ^
      client_payout.hashCode ^
      commercial.hashCode ^
      compnayid.hashCode ^
      created_date.hashCode ^
      ctcdesc.hashCode ^
      education.hashCode ^
      eligibility.hashCode ^
      emptype.hashCode ^
      experience.hashCode ^
      gender.hashCode ^
      id.hashCode ^
      inteviewrounds.hashCode ^
      job_benifits.hashCode ^
      key_responsible.hashCode ^
      languageknown.hashCode ^
      locationid.hashCode ^
      maxctc.hashCode ^
      minctc.hashCode ^
      more_details.hashCode ^
      naturofworkid.hashCode ^
      no_of_vacancy.hashCode ^
      paymentclause.hashCode ^
      payout.hashCode ^
      process.hashCode ^
      rolename.hashCode ^
      search_keywords.hashCode ^
      shiftdesc.hashCode ^
      shifttime.hashCode ^
      skills.hashCode ^
      spoc.hashCode ^
      updated_date.hashCode ^
      work_location.hashCode;
  }
}