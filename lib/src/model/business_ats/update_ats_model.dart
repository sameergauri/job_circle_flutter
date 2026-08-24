class UpdateAtsModel {
  int? alternateNo;
  String? applicantName;
  String? attrStatus;
  int? billableCtc;
  String? billingNotes;
  int? clientAmount;
  String? clientBillingStatus;
  String? clientInvoiceNo;
  String? clientPaymentStatus;
  String? clientEmail;
  String? clientResumeId;
  String? commercialGender;
  int? commericialId;
  String? companyName;
  int? completeStatus;
  int? contactNo;
  int? crpfId;
  DateTime? dateOfInterview;
  List<String>? documentList;
  String? documentRemark;
  String? documentStatus;
  DateTime? doj;
  DateTime? dol;
  DateTime? dor;
  DateTime? dot;
  String? empId;
  int? expMax;
  int? expMin;
  String? feedback;
  int? hrStatusId;
  int? interviewBay;
  String? interviewRounds;
  DateTime? invoiceDate;
  String? invoiceRemark;
  int? isCvDownload;
  int? isDisplayToCandidate;
  int? isExp;
  int? isJoinSubmitted;
  int? isRef;
  int? isExperienced;
  int? isNotice;
  int? jobid;
  String? lastName;
  DateTime? lastWorkingDate;
  String? level;
  int? levelId;
  int? modeDocument;
  String? naturOfWork;
  int? naturofworkId;
  String? notes;
  String? pAmount;
  DateTime? paidInvoiceDate;
  String? partnerBillingStatus;
  String? partnerInvoice;
  String? partnerInvoiceNo;
  String? partnerPayoutMode;
  //int? partnerTotalAmount;
  String? paymentClause;
  int? payout;
  String? process;
  int? processId;
  String? qualification;
  String? referralSource;
  String? remark;
  String? resume;
  int? rid;
  int? salary;
  int? shortListFor;
  int? sourceId;
  String? sourceName;
  String? spInvNo;
  String? spPaymentStatus;
  int? spPayout;
  int? spoc;
  String? status;
  int? statusId;
  String? subSource;
  String? subStatus;
  String? transactionNo;
  int? uid;
  // ignore: non_constant_identifier_names
  String? attr_status2;
  DateTime? callBackDateTime;


  UpdateAtsModel({
    this.alternateNo,
    this.applicantName,
    this.attrStatus,
    this.billableCtc,
    this.billingNotes,
    this.clientAmount,
    this.clientBillingStatus,
    this.clientInvoiceNo,
    this.clientPaymentStatus,
    this.clientEmail,
    this.clientResumeId,
    this.commercialGender,
    this.commericialId,
    this.companyName,
    this.completeStatus,
    this.contactNo,
    this.crpfId,
    this.dateOfInterview,
    this.documentList,
    this.documentRemark,
    this.documentStatus,
    this.doj,
    this.dol,
    this.dor,
    this.dot,
    this.empId,
    this.expMax,
    this.expMin,
    this.feedback,
    this.hrStatusId,
    this.interviewBay,
    this.interviewRounds,
    this.invoiceDate,
    this.invoiceRemark,
    this.isCvDownload,
    this.isDisplayToCandidate,
    this.isExp,
    this.isJoinSubmitted,
    this.isRef,
    this.isExperienced,
    this.isNotice,
    this.jobid,
    this.lastName,
    this.lastWorkingDate,
    this.level,
    this.levelId,
    this.modeDocument,
    this.naturOfWork,
    this.naturofworkId,
    this.notes,
    this.pAmount,
    this.paidInvoiceDate,
    this.partnerBillingStatus,
    this.partnerInvoice,
    this.partnerInvoiceNo,
    this.partnerPayoutMode,
    //  this.partnerTotalAmount,
    this.paymentClause,
    this.payout,
    this.process,
    this.processId,
    this.qualification,
    this.referralSource,
    this.remark,
    this.resume,
    this.rid,
    this.salary,
    this.shortListFor,
    this.sourceId,
    this.sourceName,
    this.spInvNo,
    this.spPaymentStatus,
    this.spPayout,
    this.spoc,
    this.status,
    this.statusId,
    this.subSource,
    this.subStatus,
    this.transactionNo,
    this.uid,
    // ignore: non_constant_identifier_names
    this.attr_status2,
    this.callBackDateTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'alternate_no': alternateNo,
      'applicant_name': applicantName,
      'attr_status': attrStatus,
      'billableCtc': billableCtc,
      'billingNotes': billingNotes,
      'clientAmount': clientAmount,
      'clientBillingStatus': clientBillingStatus,
      'clientInvoiceNo': clientInvoiceNo,
      'clientPaymentStatus': clientPaymentStatus,
      'client_email': clientEmail,
      'client_resume_id': clientResumeId,
      'commercialGender': commercialGender,
      'commericialId': commericialId,
      'company_name': companyName,
      'complete_status': completeStatus,
      'contact_no': contactNo,
      'crpfId': crpfId,
      'dateOfInterview': dateOfInterview?.toIso8601String(),
      'document_list': documentList,
      'document_remark': documentRemark,
      'document_status': documentStatus,
      'doj': doj?.toIso8601String(),
      'dol': dol?.toIso8601String(),
      'dor': dor?.toIso8601String(),
      'dot': dot?.toIso8601String(),
      'emp_id': empId,
      'exp_max': expMax,
      'exp_min': expMin,
      'feedback': feedback,
      'hrStatusId': hrStatusId,
      'interview_bay': interviewBay,
      'interview_rounds': interviewRounds,
      'invoiceDate': invoiceDate?.toIso8601String(),
      'invoiceRemark': invoiceRemark,
      'isCvDownload': isCvDownload,
      'isDisplayToCandidate': isDisplayToCandidate,
      'isExp': isExp,
      'isJoinSubmitted': isJoinSubmitted,
      'isRef': isRef,
      'is_experienced': isExperienced,
      'is_notice': isNotice,
      'jobid': jobid,
      'last_name': lastName,
      'last_working_date': lastWorkingDate?.toIso8601String(),
      'level': level,
      'level_id': levelId,
      'mode_document': modeDocument,
      'natur_of_work': naturOfWork,
      'naturofwork_id': naturofworkId,
      'notes': notes,
      'p_amount': pAmount,
      'paidInvoiceDate': paidInvoiceDate?.toIso8601String(),
      'partnerBillingStatus': partnerBillingStatus,
      'partnerInvoice': partnerInvoice,
      'partnerInvoiceNo': partnerInvoiceNo,
      'partnerPayoutMode': partnerPayoutMode,
      //   'partnerTotalAmount': partnerTotalAmount,
      'payment_clause': paymentClause,
      'payout': payout,
      'process': process,
      'process_id': processId,
      'qualification': qualification,
      'referral_source': referralSource,
      'remark': remark,
      'resume': resume,
      'rid': rid,
      'salary': salary,
      'short_list_for': shortListFor,
      'source_id': sourceId,
      'source_name': sourceName,
      'sp_inv_no': spInvNo,
      'sp_payment_status': spPaymentStatus,
      'sp_payout': spPayout,
      'spoc': spoc,
      'status': status,
      'statusId': statusId,
      'sub_source': subSource,
      'sub_status': subStatus,
      'transactionNo': transactionNo,
      'uid': uid,
      'attr_status2': attr_status2,
      'callBackDateTime': callBackDateTime?.toIso8601String(),
    };
  }
}
