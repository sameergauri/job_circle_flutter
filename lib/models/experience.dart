// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart';

class ExperienceSep {
  int? id;
  dynamic userId;
  String? job_title;
  String? company_name;
  String? company_location;
  String? company_website;
  String? work_type;
  bool? ismonthly;
  bool? isworking;
  String? salary;
  DateTime? joining_date;
  DateTime? last_working_date;
  dynamic availability;
  String? appointment_letter;
  String? salary_slip;
  String? bank_statement;
  String? experience_letter;
  List<String>? skills_exp;
  String? working;

  ExperienceSep({
    this.id,
    this.userId,
    this.job_title,
    this.company_name,
    this.company_location,
    this.company_website,
    this.work_type,
    this.ismonthly,
    this.isworking,
    this.salary,
    this.joining_date,
    this.last_working_date,
    this.availability,
    this.appointment_letter,
    this.salary_slip,
    this.bank_statement,
    this.experience_letter,
    this.skills_exp,
    this.working,
  });

  factory ExperienceSep.fromJson(String source) =>
      ExperienceSep.fromMap(json.decode(source));

  factory ExperienceSep.fromMap(Map<String, dynamic> map) {
    return ExperienceSep(
      id: map['id'],
      userId: map['userId'],
      job_title: map['job_title'],
      company_name: map['company_name'],
      company_location: map['company_location'],
      company_website: map['company_website'],
      work_type: map['work_type'],
      ismonthly: map['ismonthly'],
      isworking: map['isworking'],
      salary: map['salary'],
      joining_date: map['joining_date'] != null
          ? DateTime.parse(map['joining_date'])
          : null,
      last_working_date: map['last_working_date'] != null
          ? DateTime.parse(map['last_working_date'])
          : null,
      availability: map['availability'],
      appointment_letter: map['appointment_letter'],
      salary_slip: map['salary_slip'],
      bank_statement: map['bank_statement'],
      experience_letter: map['experience_letter'],
      skills_exp: List<String>.from(map['skills_exp']),
      working: map['working'],
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'job_title': job_title,
      'company_name': company_name,
      'company_location': company_location,
      'company_website': company_website,
      'work_type': work_type,
      'ismonthly': ismonthly,
      'isworking': isworking,
      'salary': salary,
      'joining_date': joining_date?.toIso8601String(),
      'last_working_date': last_working_date?.toIso8601String(),
      'availability': availability,
      'appointment_letter': appointment_letter,
      'salary_slip': salary_slip,
      'bank_statement': bank_statement,
      'experience_letter': experience_letter,
      'skills_exp': skills_exp,
      'working': working,
    };
  }

  @override
  String toString() {
    return 'ExperienceSep(id: $id, userId: $userId, job_title: $job_title, company_name: $company_name, company_location: $company_location, company_website: $company_website, work_type: $work_type, ismonthly: $ismonthly, isworking: $isworking, salary: $salary, joining_date: $joining_date, last_working_date: $last_working_date, availability: $availability, appointment_letter: $appointment_letter, salary_slip: $salary_slip, bank_statement: $bank_statement, experience_letter: $experience_letter, skills_exp: $skills_exp, working: $working)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExperienceSep &&
        other.id == id &&
        other.userId == userId &&
        other.job_title == job_title &&
        other.company_name == company_name &&
        other.company_location == company_location &&
        other.company_website == company_website &&
        other.work_type == work_type &&
        other.ismonthly == ismonthly &&
        other.isworking == isworking &&
        other.salary == salary &&
        other.joining_date == joining_date &&
        other.last_working_date == last_working_date &&
        other.availability == availability &&
        other.appointment_letter == appointment_letter &&
        other.salary_slip == salary_slip &&
        other.bank_statement == bank_statement &&
        other.experience_letter == experience_letter &&
        listEquals(other.skills_exp, skills_exp) &&
        other.working == working;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        job_title.hashCode ^
        company_name.hashCode ^
        company_location.hashCode ^
        company_website.hashCode ^
        work_type.hashCode ^
        ismonthly.hashCode ^
        isworking.hashCode ^
        salary.hashCode ^
        joining_date.hashCode ^
        last_working_date.hashCode ^
        availability.hashCode ^
        appointment_letter.hashCode ^
        salary_slip.hashCode ^
        bank_statement.hashCode ^
        experience_letter.hashCode ^
        skills_exp.hashCode ^
        working.hashCode;
  }
}
