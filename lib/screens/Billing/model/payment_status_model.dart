class PaymentStatusModel {
  final String resultKey;
  final ResultData resultData;
  final String code;
  final String errorMessage;

  PaymentStatusModel({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory PaymentStatusModel.fromJson(Map<String, dynamic> json) {
    return PaymentStatusModel(
      resultKey: json['resultKey'] ?? '',
      resultData: ResultData.fromJson(json['resultData']),
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}

class ResultData {
  final List<InvoiceSent> invoiceSent;
  final List<InvoiceSent> validation;
  final List<InvoiceSent> paidData;
  final List<InvoiceSent> rejectData;

  ResultData({
    required this.invoiceSent,
    required this.validation,
    required this.paidData,
    required this.rejectData,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      invoiceSent: (json['invoiceSent'] as List<dynamic>)
          .map((e) => InvoiceSent.fromJson(e))
          .toList(),
      validation: (json['validation'] as List<dynamic>)
          .map((e) => InvoiceSent.fromJson(e))
          .toList(),
      paidData: (json['paidData'] as List<dynamic>)
          .map((e) => InvoiceSent.fromJson(e))
          .toList(),
           rejectData: (json['rejectData'] as List<dynamic>)
          .map((e) => InvoiceSent.fromJson(e))
          .toList(),
    );
  }
}

class InvoiceSent {
  final String invoiceNo;
  final String invoiceSubmitDate;
  final String invoicePaidDate;
  final String? transcationNo;
  final String? invoiceRemark;
  final String invoiceMonth;
  final int totalCandidates;
  final double invoiceAmount;
  final String bankName;
  final String accountType;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String? invoiceStatus;
  final String paymentStatus;
  final String orgizationName;
  final String orgizationAddress;
  final List<Candidate> candidates;
  final String? invoicePaymentReciept;

  InvoiceSent({
    required this.invoiceNo,
    required this.invoiceSubmitDate,
    required this.invoicePaidDate,
    this.transcationNo,
    this.invoiceRemark,
    required this.invoiceMonth,
    required this.totalCandidates,
    required this.invoiceAmount,
    required this.bankName,
    required this.accountType,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    this.invoiceStatus,
    required this.paymentStatus,
    required this.orgizationName,
    required this.orgizationAddress,
    required this.candidates,
    this.invoicePaymentReciept,
  });


  factory InvoiceSent.fromJson(Map<String, dynamic> json) {
    return InvoiceSent(
      invoiceNo: json['invoiceNo'] ?? '',
      invoiceSubmitDate: json['invoiceSubmitDate'] ?? '',
      invoicePaidDate: json['invoicePaidDate'] ?? '',
      transcationNo: json['transcationNo'],
      invoiceRemark: json['invoiceRemark'],
      invoiceMonth: json['invoiceMonth'] ?? '',
      totalCandidates: json['totalCandidates'] ?? 0,
      invoiceAmount: json['invoiceAmount'] ?? 0,
      bankName: json['bankName'] ?? '',
      accountType: json['accountType'] ?? '',
      accountHolderName: json['accountHolderName'] ?? '',
      accountNumber: json['accountNumber'] ?? '',
      ifscCode: json['ifscCode'] ?? '',
      invoiceStatus: json['invoiceStatus'],
      paymentStatus: json['paymentStatus'] ?? '',
      orgizationName: json['orgizationName'] ?? '',
      orgizationAddress: json['orgizationAddress'] ?? '',
      invoicePaymentReciept: json['invoicePaymentReciept'],
      candidates: (json['candidates'] as List<dynamic>)
          .map((e) => Candidate.fromJson(e))
          .toList(),
    );
  }
}

class Candidate {
  final int id;
  final String name;
  final String process;
  final String level;
  final String doj;
  final double payoutAmount;
  final String? crpfId;
  final String? companyShortName;

  Candidate(
      {required this.id,
      required this.name,
      required this.process,
      required this.level,
      required this.doj,
      required this.payoutAmount,
      this.crpfId,
      this.companyShortName});

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      process: json['process'] ?? '',
      level: json['level'] ?? '',
      doj: json['doj'] ?? '',
      payoutAmount: json['payoutAmount'] ?? 0,
      crpfId: json['crpfId'],
      companyShortName: json['companyShortName'],
    );
  }
}
