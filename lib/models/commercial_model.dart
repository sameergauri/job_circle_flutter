class Commercial {
  double? amount;
  int? commercialActive;
  int? companyId;
  double? ctcPercent;
  DateTime? endDate;
  String? endMonth;
  int? id;
  int? isConfirm;
  int? isPartner;
  int? jobActive;
  String? natureOfWork;
  double? partnerPercent;
  double? partnerAmount;
  String? partnerPayoutType;
  String? paymentClause;
  String? payoutType;
  String? process;
  String? roleName;
  double? specialPaymentAmount;
  String? specialPaymentClause;
  DateTime? startDate;
  String? startMonth;

  Commercial({
    this.amount,
    this.commercialActive,
    this.companyId,
    this.ctcPercent,
    this.endDate,
    this.endMonth,
    this.id,
    this.isConfirm,
    this.isPartner,
    this.jobActive,
    this.natureOfWork,
    this.partnerPercent,
    this.partnerAmount,
    this.partnerPayoutType,
    this.paymentClause,
    this.payoutType,
    this.process,
    this.roleName,
    this.specialPaymentAmount,
    this.specialPaymentClause,
    this.startDate,
    this.startMonth,
  });

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "commercial_active": commercialActive,
      "company_id": companyId,
      "ctcprecent": ctcPercent,
      "end_date": endDate?.toIso8601String(),
      "end_month": endMonth,
      "id": id,
      "isConfirm": isConfirm,
      "is_partner": isPartner,
      "jobActive": jobActive,
      "naturofwork": natureOfWork,
      "partenrPrecent": partnerPercent,
      "partnerAmount": partnerAmount,
      "partner_payout_type": partnerPayoutType,
      "payment_clause": paymentClause,
      "payout_type": payoutType,
      "process": process,
      "rolename": roleName,
      "spl_payment_amount": specialPaymentAmount,
      "spl_payment_cluase": specialPaymentClause,
      "start_date": startDate?.toIso8601String(),
      "start_month": startMonth,
    };
  }
}

class Slab {
  int? commercialId;
  int? id;
  int? isCtcSlab;
  int? isFresher;
  int? isPercent;
  String? maxCount;
  int? minCount;
  String? partnerMaxCount;
  int? partnerMinCount;
  int? partnerSlabAmount;
  int? slabAmount;

  Slab({
    this.commercialId,
    this.id,
    this.isCtcSlab,
    this.isFresher,
    this.isPercent,
    this.maxCount,
    this.minCount,
    this.partnerMaxCount,
    this.partnerMinCount,
    this.partnerSlabAmount,
    this.slabAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      "commericialId": commercialId,
      "id": id,
      "isCtcSlab": isCtcSlab,
      "isFresher": isFresher,
      "isPrecent": isPercent,
      "maxcount": maxCount,
      "mincount": minCount,
      "partnerMaxcount": partnerMaxCount,
      "partnerMincount": partnerMinCount,
      "partnerSlab_amount": partnerSlabAmount,
      "slab_amount": slabAmount,
    };
  }
}

class CommmercialAddModel {
  Commercial commercial;
  List<Slab> slab;

  CommmercialAddModel({
    required this.commercial,
    required this.slab,
  });

  Map<String, dynamic> toJson() {
    return {
      "commercial": commercial.toJson(),
      "slab": slab.map((s) => s.toJson()).toList(),
    };
  }
}
