// ignore_for_file: non_constant_identifier_names

class ListOfInvoiceModel {
  final String referralName;
  final double total_amount;
  final DateTime invoice_date;
  final String invoice_no;
  final String bank_name;
  final String ifsc_code;
  final int account_number;
  final String account_type;
  final String payment_status;
 // final String invoice_remark;
  final List<Candidate> candidates;

  ListOfInvoiceModel(
      {required this.referralName,
      required this.total_amount,
      required this.invoice_date,
      required this.invoice_no,
      required this.bank_name,
      required this.ifsc_code,
      required this.account_number,
      required this.account_type,
      required this.candidates,
   //   required this.invoice_remark,
      required this.payment_status});

  factory ListOfInvoiceModel.fromJson(Map<String, dynamic> json) {
    DateTime? nullableDateTime = json['invoice_date'] != null
        ? DateTime.parse(json['invoice_date'])
        : null;
    DateTime invoiceDate = nullableDateTime ?? DateTime.now();
    var candidateList = json['candidates'] as List?;
    List<Candidate> candidates =
        candidateList?.map((e) => Candidate.fromJson(e)).toList() ?? [];
    return ListOfInvoiceModel(
      referralName: json['referralName'] ?? "",
      total_amount: json['total_amount'] ?? 0.0,
      invoice_date: invoiceDate,
   //   invoice_remark: json['invoice_remark']??'',
      invoice_no: json['invoice_no'] ?? "",
      bank_name: json['bank_name'] ?? '',
      ifsc_code: json['ifsc_code'] ?? "",
      account_number: json['account_number'] ?? "",
      account_type: json['account_type'] ?? '',
      payment_status: json['payment_status'] ?? "",
      candidates: candidates,
    );
  }
}

class Candidate {
  final int id;
  final String candidateName;
  final String companyName;
  final String process;
  final String shortCode;
  final double candidateAmount;
  final DateTime doj;

  Candidate({
    required this.id,
    required this.candidateName,
    required this.companyName,
    required this.process,
    required this.shortCode,
    required this.candidateAmount,
    required this.doj,
  });

  factory Candidate.fromJson(Map<String, dynamic> json) {
    DateTime? nullableDateTime =
        json['doj'] != null ? DateTime.parse(json['doj']) : null;
    DateTime doj = nullableDateTime ?? DateTime.now();
    return Candidate(
      id: json['id'],
      candidateName: json['candidateName'],
      companyName: json['company_name'],
      process: json['process'],
      shortCode: json['short_code'],
      candidateAmount: json['candidateAmount'],
      doj: doj,
    );
  }
}
