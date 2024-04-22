// ignore_for_file: non_constant_identifier_names

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
  final String? attr_status;
  final double? client_payout;
  final String? spoc_name;
  final int? contact_no;
  final String? emp_id;
  final double? salary;
  final double? partner_payout;
  final String? level;

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
    this.attr_status,
    this.client_payout,
    this.spoc_name,
    this.contact_no,
    this.emp_id,
    this.salary,
    this.partner_payout,
    this.level,
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
      attr_status: json['attr_status'],
      client_payout: json['client_payout'],
      spoc_name: json['spoc_name'],
      contact_no: json['contact_no'],
      emp_id: json['emp_id'],
      salary: json['salary'],
      partner_payout: json['partner_payout'],
      level:json['level'],
    );
  }
}
