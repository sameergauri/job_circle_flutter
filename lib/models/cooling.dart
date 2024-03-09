class CoolingForApply {
  final String status;
  final String? subStatus;
  final String dol;
  final int jobid;

  CoolingForApply({
    required this.status,
    required this.subStatus,
    required this.dol,
    required this.jobid
  });

  factory CoolingForApply.fromJson(Map<String, dynamic> json) {
    return CoolingForApply(
      status: json['status'] ?? '',
      subStatus: json['sub_status'] ?? '',
      dol: json['dol'] ?? '',
      jobid: json['jobid']??0,
    );
  }
}
