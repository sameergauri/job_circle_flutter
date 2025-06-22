class SubmitInvoiceModel {
  final int invoiceAmount;
  final DateTime invoiceDate;
  final String invoiceNumber;
  final List<int> leadId;
  final int orgId;
  final String status;

  SubmitInvoiceModel({
    required this.invoiceAmount,
    required this.invoiceDate,
    required this.invoiceNumber,
    required this.leadId,
    required this.orgId,
    required this.status,
  });

  factory SubmitInvoiceModel.fromJson(Map<String, dynamic> json) {
    return SubmitInvoiceModel(
      invoiceAmount: json['invoiceAmount'] ?? 0,
      invoiceDate: DateTime.parse(json['invoiceDate']),
      invoiceNumber: json['invoiceNumber'] ?? '',
      leadId: List<int>.from(json['leadId'] ?? []),
      orgId: json['orgId'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceAmount': invoiceAmount,
      'invoiceDate': invoiceDate.toIso8601String(),
      'invoiceNumber': invoiceNumber,
      'leadId': leadId,
      'orgId': orgId,
      'status': status,
    };
  }
}
