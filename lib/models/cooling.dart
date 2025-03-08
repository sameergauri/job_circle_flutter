import 'package:intl/intl.dart';

class CoolingForApply {
  final String status;
  final String? subStatus;
  final String dol;
  final int jobid;

  CoolingForApply(
      {required this.status,
      required this.subStatus,
      required this.dol,
      required this.jobid});

  factory CoolingForApply.fromJson(Map<String, dynamic> json) {
    String dol = json['dol'] != null
        ? DateFormat('yyyy-MM-dd')
            .format(DateTime.fromMicrosecondsSinceEpoch(json['dol']))
        : "N/A";
    return CoolingForApply(
      status: json['status'] ?? '',
      subStatus: json['sub_status'] ?? '',
      dol: dol,
      jobid: json['jobid'] ?? 0,
    );
  }
}
