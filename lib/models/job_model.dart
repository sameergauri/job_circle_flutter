import 'dart:convert';

class Job {
  final int id;
  final Job job;
  Job({
    required this.id,
    required this.job,
  });

  Job copyWith({
    int? id,
    Job? job,
  }) {
    return Job(
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

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id']?.toInt() ?? 0,
      job: Job.fromMap(map['job']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Job.fromJson(String source) => Job.fromMap(json.decode(source));

  @override
  String toString() => 'Job(id: $id, job: $job)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Job &&
      other.id == id &&
      other.job == job;
  }

  @override
  int get hashCode => id.hashCode ^ job.hashCode;
}