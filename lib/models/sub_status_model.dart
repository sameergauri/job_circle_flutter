class SubStatusModel {
  final String? hrStatus;
  final int? id;
  final String? hrSubStatus;
  final int? statusId;

  SubStatusModel({
    this.hrStatus,
    this.id,
    this.hrSubStatus,
    this.statusId,
  });

  factory SubStatusModel.fromJson(Map<String, dynamic> json) {
    return SubStatusModel(
      hrStatus: json['hr_status'],
      id: json['id'],
      hrSubStatus: json['hr_sub_status'],
      statusId: json['status_id'],
    );
  }
}

class SpocModel {
  final int? id;
  final String? lastName;
  final String? role;
  final String? firstName;

  SpocModel({
    this.id,
    this.lastName,
    this.role,
    this.firstName,
  });

  factory SpocModel.fromJson(Map<String, dynamic> json) {
    return SpocModel(
      id: json['id'],
      lastName: json['last_name'],
      role: json['role'],
      firstName: json['first_name'],
    );
  }
}
