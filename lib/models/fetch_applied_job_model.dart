class Applicant {
  final String companyName;
  final int statusId;
  final String status;
  final String process;
  final String appliedDate;
  final String rolename;
  final String? lastUpdate;
  final int jobid;
  final String? completeStatus;
  final String applicantName;
  final String? doj;

  Applicant({
    required this.companyName,
    required this.statusId,
    required this.status,
    required this.process,
    required this.appliedDate,
    required this.rolename,
    this.lastUpdate,
    required this.jobid,
    this.completeStatus,
    required this.applicantName,
    this.doj,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      companyName: json['company_name'] as String? ?? '',
      statusId: json['status_id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      process: json['process'] as String? ?? '',
      appliedDate: json['applied_date'] as String? ?? '',
      rolename: json['rolename'] as String? ?? '',
      lastUpdate: json['last_update'] as String?,
      jobid: json['jobid'] as int? ?? 0,
      completeStatus: json['complete_status'] as String?,
      applicantName: json['applicant_name'] as String? ?? '',
      doj: json['doj'] as String?,
    );
  }
}
