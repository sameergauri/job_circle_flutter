import 'dart:convert';

import 'job.dart';

class Favouritejobmodel {
  final int id;
  final Job job;
  Favouritejobmodel({
    required this.id,
    required this.job,
  });

  Favouritejobmodel copyWith({
    int? id,
    Job? job,
  }) {
    return Favouritejobmodel(
      id: id ?? this.id,
      job: job ?? this.job,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'job': job.toMap(),
    };
  }

  factory Favouritejobmodel.fromMap(Map<String, dynamic> map) {
    return Favouritejobmodel(
      id: map['id']?.toInt() ?? 0,
      job: Job.fromMap(map['job']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Favouritejobmodel.fromJson(String source) => Favouritejobmodel.fromMap(json.decode(source));

  @override
  String toString() => 'Favouritejobmodel(id: $id, job: $job)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Favouritejobmodel &&
      other.id == id &&
      other.job == job;
  }

  @override
  int get hashCode => id.hashCode ^ job.hashCode;
}