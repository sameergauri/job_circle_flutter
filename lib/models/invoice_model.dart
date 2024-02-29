// ignore_for_file: non_constant_identifier_names

class InvoiceModel {
  final String? referralName;
  final dynamic ifscCode;
  final dynamic accountNumber;
  final dynamic accountType;
  final String? candidateName;
  final int? userId;
  final DateTime? doj;
  final dynamic bankName;
  final double? candidateAmount;
  final String? process;
  final String? companyName;
  final String? short_code;
  final String? attr_status;
  final int? id;

  InvoiceModel(
      {this.referralName,
      this.ifscCode,
      this.accountNumber,
      this.accountType,
      this.candidateName,
      this.userId,
      this.doj,
      this.bankName,
      this.candidateAmount,
      this.process,
      this.companyName,
      this.short_code,
      this.id,
      this.attr_status});

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
        referralName: json['referralName'],
        ifscCode: json['ifsc_code'],
        accountNumber: json['account_number'],
        accountType: json['account_type'],
        candidateName: json['candidateName'],
        userId: json['userId'],
        doj: json['doj'] != null ? DateTime.parse(json['doj']) : null,
        bankName: json['bank_name'],
        candidateAmount: json['candidateAmount'],
        process: json['process'],
        companyName: json['company_name'],
        short_code: json['short_code'],
        id: json['id'],
        attr_status: json['attr_status']);
  }
}
