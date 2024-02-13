class MetchingCommercialModel {
  final String? icon;
  final DateTime? endDate;
  final int? id;
  final int? ctcPercent;
  final int? isExpCtc;
  final int? jobActive;
  final String? paymentClause;
  final String? companyName;
  final int? fresherPay;
  final String? partnerPayoutType;
  final double? amount;
  final double? partnerAmount;
  final String? process;
  final String? roleName;
  final int? commercialActive;
  final DateTime? startDate;

  MetchingCommercialModel({
    this.icon,
    this.endDate,
    this.id,
    this.ctcPercent,
    this.isExpCtc,
    this.jobActive,
    this.paymentClause,
    this.companyName,
    this.fresherPay,
    this.partnerPayoutType,
    this.amount,
    this.partnerAmount,
    this.process,
    this.roleName,
    this.commercialActive,
    this.startDate,
  });

  factory MetchingCommercialModel.fromJson(Map<String, dynamic> json) {
    return MetchingCommercialModel(
      icon: json['icon'],
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      id: json['id'],
      ctcPercent: json['ctcprecent'],
      isExpCtc: json['is_exp_ctc'],
      jobActive: json['jobactive'],
      paymentClause: json['payment_clause'],
      companyName: json['companyname'],
      fresherPay: json['fresher_pay'],
      partnerPayoutType: json['partner_payout_type'],
      amount: json['amount'],
      partnerAmount: json['partner_amount'],
      process: json['process'],
      roleName: json['rolename'],
      commercialActive: json['commercial_active'],
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
    );
  }
}
