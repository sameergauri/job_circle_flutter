// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

class EducationSep {
  final int? id;
  final dynamic level;
  final dynamic board;
  final dynamic university;
  final dynamic fieldOfStudy;
  final int? firstYear;
  final String? marksheet;
  final int? passingYear;
  final dynamic userId;
  final dynamic degree_spc;

  EducationSep({
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
  });

  EducationSep copyWith({
    int? id,
    dynamic level,
    dynamic board,
    dynamic university,
    dynamic fieldOfStudy,
    int? firstYear,
    String? marksheet,
    int? passingYear,
    dynamic userId,
    dynamic degree_spc,
  }) {
    return EducationSep(
      id: id ?? this.id,
      level: level ?? this.level,
      board: board ?? this.board,
      university: university ?? this.university,
      fieldOfStudy: fieldOfStudy ?? this.fieldOfStudy,
      firstYear: firstYear ?? this.firstYear,
      marksheet: marksheet ?? this.marksheet,
      passingYear: passingYear ?? this.passingYear,
      userId: userId ?? this.userId,
      degree_spc: degree_spc ?? this.degree_spc,
    );
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
    };
  }

  factory EducationSep.fromMap(Map<String, dynamic> map) {
    return EducationSep(
      id: map['id'] as int?,
      level: map['level'],
      board: map['board'],
      university: map['university'],
      fieldOfStudy: map['fieldOfStudy'],
      firstYear: map['firstYear'] as int?,
      marksheet: map['marksheet'] as String?,
      passingYear: map['passingYear'] as int?,
      userId: map['userId'],
      degree_spc: map['degree_spc'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EducationSep.fromJson(String source) =>
      EducationSep.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EducationSep(id: $id, level: $level, board: $board, university: $university, fieldOfStudy: $fieldOfStudy, firstYear: $firstYear, marksheet: $marksheet, passingYear: $passingYear, userId: $userId, degree_spc: $degree_spc)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EducationSep &&
        other.id == id &&
        other.level == level &&
        other.board == board &&
        other.university == university &&
        other.fieldOfStudy == fieldOfStudy &&
        other.firstYear == firstYear &&
        other.marksheet == marksheet &&
        other.passingYear == passingYear &&
        other.userId == userId &&
        other.degree_spc == degree_spc;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        level.hashCode ^
        board.hashCode ^
        university.hashCode ^
        fieldOfStudy.hashCode ^
        firstYear.hashCode ^
        marksheet.hashCode ^
        passingYear.hashCode ^
        userId.hashCode ^
        degree_spc.hashCode;
  }
}
