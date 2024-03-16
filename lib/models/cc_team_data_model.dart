class CCTeamModel {
  final int? statusId;
  final int? hrStatusId;
  final String? sourceName;
  final String? shortCode;
  final String? companyName;
  final String? hrSubStatus;
  final String? referralSource;
  final int? id;
  final dynamic remark;
  final String? applicantName;
  final dynamic rid;
  final String? hrStatus;
  final DateTime? doj;
  final String? process;
  final int? sourceId;
  final String? lastName;
  final DateTime? dol;

  CCTeamModel({
    this.statusId,
    this.hrStatusId,
    this.sourceName,
    this.shortCode,
    this.companyName,
    this.hrSubStatus,
    this.referralSource,
    this.id,
    this.remark,
    this.applicantName,
    this.rid,
    this.hrStatus,
    this.doj,
    this.process,
    this.sourceId,
    this.lastName,
    this.dol,
  });

  factory CCTeamModel.fromJson(Map<String, dynamic> json) {
    return CCTeamModel(
      statusId: json['status_id'],
      hrStatusId: json['hr_status_id'],
      sourceName: json['source_name'],
      shortCode: json['short_code'],
      companyName: json['company_name'],
      hrSubStatus: json['hr_sub_status'],
      referralSource: json['referral_source'],
      id: json['id'],
      remark: json['remark'],
      applicantName: json['applicant_name'],
      rid: json['rid'],
      hrStatus: json['hr_status'],
      doj: json['doj'] != null ? DateTime.parse(json['doj']) : null,
      process: json['process'],
      sourceId: json['source_id'],
      lastName: json['last_name'],
      dol: json['dol'] != null ? DateTime.parse(json['dol']) : null,
    );
  }
}
