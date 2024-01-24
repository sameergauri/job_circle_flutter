class ViewAndGenerateBillingModel {
  final String? doj;
  final double? partnerPayout;
  final String? shortCode;
  final String? lastName;
  final String? companyName;
  final int? id;
  final String? attrStatus;
  final String? process;
  final String? applicantName;
  final int? rid;
  final String? subStatus;

  ViewAndGenerateBillingModel({
    required this.doj,
    required this.partnerPayout,
    required this.shortCode,
    required this.lastName,
    required this.companyName,
    required this.id,
    required this.attrStatus,
    required this.process,
    required this.applicantName,
    required this.rid,
    required this.subStatus,
  });

  factory ViewAndGenerateBillingModel.fromJson(Map<String, dynamic> json) {
    return ViewAndGenerateBillingModel(
      doj: json['doj'],
      partnerPayout: json['partner_payout'],
      shortCode: json['short_code'],
      lastName: json['last_name'],
      companyName: json['company_name'],
      id: json['id'],
      attrStatus: json['attr_status'],
      process: json['process'],
      applicantName: json['applicant_name'],
      rid: json['rid'],
      subStatus: json['sub_status'],
    );
  }
}
