class CoolingForApply {
  final String status;
  final String? subStatus;
  final String dol;

  CoolingForApply({
    required this.status,
    required this.subStatus,
    required this.dol,
  });

  factory CoolingForApply.fromJson(Map<String, dynamic> json) {
    return CoolingForApply(
      status: json['status'] ?? '',
      subStatus: json['sub_status'] ?? '',
      dol: json['dol'] ?? '',
    );
  }
}
