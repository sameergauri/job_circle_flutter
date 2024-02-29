class CoolingModel {
  final int id;
  final String status;
  final String? subStatus;
  final int contactNo;
  final DateTime? dol;

  CoolingModel({
    required this.id,
    required this.status,
    this.subStatus,
    required this.contactNo,
    this.dol,
  });

  factory CoolingModel.fromJson(Map<String, dynamic> json) {
    return CoolingModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? "",
      subStatus: json['sub_status'] ?? "",
      contactNo: json['contact_no'] ?? "",
      dol: json['dol'] != null ? DateTime.parse(json['dol']) : null,
    );
  }
}
