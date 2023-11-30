import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'age__group.dart';
import 'gender.dart';
import 'isfresher.dart';
import 'ismonthly.dart';
import 'job__benifits.dart';
import 'languageknown.dart';
import 'maxctc.dart';
import 'maxexperience.dart';
import 'minctc.dart';
import 'minexperience.dart';
import 'more__details_1.dart';
import 'skills.dart';

class Job {
  final int id;
  final int compnayid;
  final String rolename;
  final String process;
  final int naturofworkid;
  final String key_responsible;
  final String client_payout;
  final String eligibility;
  final int locationid;
  final List<int> work_location;
  final Minctc minctc;
  final Maxctc maxctc;
  final Ismonthly ismonthly;
  final String ctcdesc;
  final Minexperience minexperience;
  final Maxexperience maxexperience;
  final Isfresher isfresher;
  final Skills skills;
  final List<String> inteviewrounds;
  final String payout;
  final String education;
  final String shifttime;
  final String shiftdesc;
  final String paymentclause;
  final int active;
  final int commercial;
  final int spoc;
  final String emptype;
  final Languageknown languageknown;
  final String category;
  final String boundarylimits;
  final String created_date;
  final String updated_date;
  final String search_keywords;
  final Gender gender;
  final Age_group age_group;
  final Job_benifits job_benifits;
  final More_details more_details;
  final int no_of_vacancy;
  Job({
    required this.id,
    required this.compnayid,
    required this.rolename,
    required this.process,
    required this.naturofworkid,
    required this.key_responsible,
    required this.client_payout,
    required this.eligibility,
    required this.locationid,
    required this.work_location,
    required this.minctc,
    required this.maxctc,
    required this.ismonthly,
    required this.ctcdesc,
    required this.minexperience,
    required this.maxexperience,
    required this.isfresher,
    required this.skills,
    required this.inteviewrounds,
    required this.payout,
    required this.education,
    required this.shifttime,
    required this.shiftdesc,
    required this.paymentclause,
    required this.active,
    required this.commercial,
    required this.spoc,
    required this.emptype,
    required this.languageknown,
    required this.category,
    required this.boundarylimits,
    required this.created_date,
    required this.updated_date,
    required this.search_keywords,
    required this.gender,
    required this.age_group,
    required this.job_benifits,
    required this.more_details,
    required this.no_of_vacancy,
  });

  Job copyWith({
    int? id,
    int? compnayid,
    String? rolename,
    String? process,
    int? naturofworkid,
    String? key_responsible,
    String? client_payout,
    String? eligibility,
    int? locationid,
    List<int>? work_location,
    Minctc? minctc,
    Maxctc? maxctc,
    Ismonthly? ismonthly,
    String? ctcdesc,
    Minexperience? minexperience,
    Maxexperience? maxexperience,
    Isfresher? isfresher,
    Skills? skills,
    List<String>? inteviewrounds,
    String? payout,
    String? education,
    String? shifttime,
    String? shiftdesc,
    String? paymentclause,
    int? active,
    int? commercial,
    int? spoc,
    String? emptype,
    Languageknown? languageknown,
    String? category,
    String? boundarylimits,
    String? created_date,
    String? updated_date,
    String? search_keywords,
    Gender? gender,
    Age_group? age_group,
    Job_benifits? job_benifits,
    More_details? more_details,
    int? no_of_vacancy,
  }) {
    return Job(
      id: id ?? this.id,
      compnayid: compnayid ?? this.compnayid,
      rolename: rolename ?? this.rolename,
      process: process ?? this.process,
      naturofworkid: naturofworkid ?? this.naturofworkid,
      key_responsible: key_responsible ?? this.key_responsible,
      client_payout: client_payout ?? this.client_payout,
      eligibility: eligibility ?? this.eligibility,
      locationid: locationid ?? this.locationid,
      work_location: work_location ?? this.work_location,
      minctc: minctc ?? this.minctc,
      maxctc: maxctc ?? this.maxctc,
      ismonthly: ismonthly ?? this.ismonthly,
      ctcdesc: ctcdesc ?? this.ctcdesc,
      minexperience: minexperience ?? this.minexperience,
      maxexperience: maxexperience ?? this.maxexperience,
      isfresher: isfresher ?? this.isfresher,
      skills: skills ?? this.skills,
      inteviewrounds: inteviewrounds ?? this.inteviewrounds,
      payout: payout ?? this.payout,
      education: education ?? this.education,
      shifttime: shifttime ?? this.shifttime,
      shiftdesc: shiftdesc ?? this.shiftdesc,
      paymentclause: paymentclause ?? this.paymentclause,
      active: active ?? this.active,
      commercial: commercial ?? this.commercial,
      spoc: spoc ?? this.spoc,
      emptype: emptype ?? this.emptype,
      languageknown: languageknown ?? this.languageknown,
      category: category ?? this.category,
      boundarylimits: boundarylimits ?? this.boundarylimits,
      created_date: created_date ?? this.created_date,
      updated_date: updated_date ?? this.updated_date,
      search_keywords: search_keywords ?? this.search_keywords,
      gender: gender ?? this.gender,
      age_group: age_group ?? this.age_group,
      job_benifits: job_benifits ?? this.job_benifits,
      more_details: more_details ?? this.more_details,
      no_of_vacancy: no_of_vacancy ?? this.no_of_vacancy,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'compnayid': compnayid,
      'rolename': rolename,
      'process': process,
      'naturofworkid': naturofworkid,
      'key_responsible': key_responsible,
      'client_payout': client_payout,
      'eligibility': eligibility,
      'locationid': locationid,
      'work_location': work_location,
      'minctc': minctc,
      'maxctc': maxctc,
      'ismonthly': ismonthly,
      'ctcdesc': ctcdesc,
      'minexperience': minexperience,
      'maxexperience': maxexperience,
      'isfresher': isfresher,
      'skills': skills,
      'inteviewrounds': inteviewrounds,
      'payout': payout,
      'education': education,
      'shifttime': shifttime,
      'shiftdesc': shiftdesc,
      'paymentclause': paymentclause,
      'active': active,
      'commercial': commercial,
      'spoc': spoc,
      'emptype': emptype,
      'languageknown': languageknown,
      'category': category,
      'boundarylimits': boundarylimits,
      'created_date': created_date,
      'updated_date': updated_date,
      'search_keywords': search_keywords,
      'gender': gender,
      'age_group': age_group,
      'job_benifits': job_benifits,
      'more_details': more_details,
      'no_of_vacancy': no_of_vacancy,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id']?.toInt() ?? 0,
      compnayid: map['compnayid']?.toInt() ?? 0,
      rolename: map['rolename'] ?? '',
      process: map['process'] ?? '',
      naturofworkid: map['naturofworkid']?.toInt() ?? 0,
      key_responsible: map['key_responsible'] ?? '',
      client_payout: map['client_payout'] ?? '',
      eligibility: map['eligibility'] ?? '',
      locationid: map['locationid']?.toInt() ?? 0,
      work_location: List<int>.from(map['work_location']),
      minctc: map['minctc'],
      maxctc: map['maxctc'],
      ismonthly: map['ismonthly'],
      ctcdesc: map['ctcdesc'] ?? '',
      minexperience: map['minexperience'],
      maxexperience: map['maxexperience'],
      isfresher: map['isfresher'],
      skills: map['skills'],
      inteviewrounds: map['inteviewrounds'],
      payout: map['payout'] ?? '',
      education: map['education'] ?? '',
      shifttime: map['shifttime'] ?? '',
      shiftdesc: map['shiftdesc'] ?? '',
      paymentclause: map['paymentclause'] ?? '',
      active: map['active']?.toInt() ?? 0,
      commercial: map['commercial']?.toInt() ?? 0,
      spoc: map['spoc']?.toInt() ?? 0,
      emptype: map['emptype'] ?? '',
      languageknown:map['languageknown'],
      category: map['category'] ?? '',
      boundarylimits: map['boundarylimits'] ?? '',
      created_date: map['created_date'] ?? '',
      updated_date: map['updated_date'] ?? '',
      search_keywords: map['search_keywords'] ?? '',
      gender: map['gender'],
      age_group: map['age_group'],
      job_benifits: map['job_benifits'],
      more_details: map['more_details'],
      no_of_vacancy: map['no_of_vacancy']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Job.fromJson(String source) => Job.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Job(id: $id, compnayid: $compnayid, rolename: $rolename, process: $process, naturofworkid: $naturofworkid, key_responsible: $key_responsible, client_payout: $client_payout, eligibility: $eligibility, locationid: $locationid, work_location: $work_location, minctc: $minctc, maxctc: $maxctc, ismonthly: $ismonthly, ctcdesc: $ctcdesc, minexperience: $minexperience, maxexperience: $maxexperience, isfresher: $isfresher, skills: $skills, inteviewrounds: $inteviewrounds, payout: $payout, education: $education, shifttime: $shifttime, shiftdesc: $shiftdesc, paymentclause: $paymentclause, active: $active, commercial: $commercial, spoc: $spoc, emptype: $emptype, languageknown: $languageknown, category: $category, boundarylimits: $boundarylimits, created_date: $created_date, updated_date: $updated_date, search_keywords: $search_keywords, gender: $gender, age_group: $age_group, job_benifits: $job_benifits, more_details: $more_details, no_of_vacancy: $no_of_vacancy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Job &&
      other.id == id &&
      other.compnayid == compnayid &&
      other.rolename == rolename &&
      other.process == process &&
      other.naturofworkid == naturofworkid &&
      other.key_responsible == key_responsible &&
      other.client_payout == client_payout &&
      other.eligibility == eligibility &&
      other.locationid == locationid &&
      listEquals(other.work_location, work_location) &&
      other.minctc == minctc &&
      other.maxctc == maxctc &&
      other.ismonthly == ismonthly &&
      other.ctcdesc == ctcdesc &&
      other.minexperience == minexperience &&
      other.maxexperience == maxexperience &&
      other.isfresher == isfresher &&
      other.skills == skills &&
      listEquals(other.inteviewrounds, inteviewrounds) &&
      other.payout == payout &&
      other.education == education &&
      other.shifttime == shifttime &&
      other.shiftdesc == shiftdesc &&
      other.paymentclause == paymentclause &&
      other.active == active &&
      other.commercial == commercial &&
      other.spoc == spoc &&
      other.emptype == emptype &&
      other.languageknown == languageknown &&
      other.category == category &&
      other.boundarylimits == boundarylimits &&
      other.created_date == created_date &&
      other.updated_date == updated_date &&
      other.search_keywords == search_keywords &&
      other.gender == gender &&
      other.age_group == age_group &&
      other.job_benifits == job_benifits &&
      other.more_details == more_details &&
      other.no_of_vacancy == no_of_vacancy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      compnayid.hashCode ^
      rolename.hashCode ^
      process.hashCode ^
      naturofworkid.hashCode ^
      key_responsible.hashCode ^
      client_payout.hashCode ^
      eligibility.hashCode ^
      locationid.hashCode ^
      work_location.hashCode ^
      minctc.hashCode ^
      maxctc.hashCode ^
      ismonthly.hashCode ^
      ctcdesc.hashCode ^
      minexperience.hashCode ^
      maxexperience.hashCode ^
      isfresher.hashCode ^
      skills.hashCode ^
      inteviewrounds.hashCode ^
      payout.hashCode ^
      education.hashCode ^
      shifttime.hashCode ^
      shiftdesc.hashCode ^
      paymentclause.hashCode ^
      active.hashCode ^
      commercial.hashCode ^
      spoc.hashCode ^
      emptype.hashCode ^
      languageknown.hashCode ^
      category.hashCode ^
      boundarylimits.hashCode ^
      created_date.hashCode ^
      updated_date.hashCode ^
      search_keywords.hashCode ^
      gender.hashCode ^
      age_group.hashCode ^
      job_benifits.hashCode ^
      more_details.hashCode ^
      no_of_vacancy.hashCode;
  }
}