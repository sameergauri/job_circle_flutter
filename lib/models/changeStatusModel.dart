class ChangeStatusModel {
  int? alternateNo;
  String? applicantName;
  String? attrStatus;
  int? clientAmount;
  String? clientBillingStatus;
  String? clientInvoiceNo;
  String? clientPaymentStatus;
  int? clientResumeId;
  String? companyName;
  int? completeStatus;
  int? contactNo;
  DateTime? createdDate;
  DateTime? doj;
  DateTime? dos;
  int? empId;
  int? expMax;
  int? expMin;
  int? id;
  int? interviewBay;
  int? isRef;
  int? isExperienced;
  int? jobid;
  String? lastName;
  String? level;
  int? levelId;
  String? natureOfWork;
  int? natureOfWorkId;
  String? notes;
  String? pAmount;
  String? partnerBillingStatus;
  String? partnerInvoiceNo;
  String? partnerPaymentStatus;
  String? paymentClause;
  String? paymentclause;
  int? payout;
  String? process;
  int? processId;
  String? qualification;
  String? referralSource;
  String? remark;
  String? resume;
  double? salary;
  int? shortListFor;
  int? sourceId;
  String? sourceName;
  String? spInvNo;
  String? spPaymentStatus;
  double? spPayout;
  String? splPaymentCluase;
  int? spoc;
  String? status;
  String? subSource;
  String? subStatus;
  int? uid;
  DateTime? updatedDate;

  ChangeStatusModel({
    this.alternateNo,
    this.applicantName,
    this.attrStatus,
    this.clientAmount,
    this.clientBillingStatus,
    this.clientInvoiceNo,
    this.clientPaymentStatus,
    this.clientResumeId,
    this.companyName,
    this.completeStatus,
    this.contactNo,
    this.createdDate,
    this.doj,
    this.dos,
    this.empId,
    this.expMax,
    this.expMin,
    this.id,
    this.interviewBay,
    this.isRef,
    this.isExperienced,
    this.jobid,
    this.lastName,
    this.level,
    this.levelId,
    this.natureOfWork,
    this.natureOfWorkId,
    this.notes,
    this.pAmount,
    this.partnerBillingStatus,
    this.partnerInvoiceNo,
    this.partnerPaymentStatus,
    this.paymentClause,
    this.paymentclause,
    this.payout,
    this.process,
    this.processId,
    this.qualification,
    this.referralSource,
    this.remark,
    this.resume,
    this.salary,
    this.shortListFor,
    this.sourceId,
    this.sourceName,
    this.spInvNo,
    this.spPaymentStatus,
    this.spPayout,
    this.splPaymentCluase,
    this.spoc,
    this.status,
    this.subSource,
    this.subStatus,
    this.uid,
    this.updatedDate,
  });

  factory ChangeStatusModel.fromJson(Map<String, dynamic> json) =>
      ChangeStatusModel(
        alternateNo: json['alternate_no'],
        applicantName: json['applicant_name'],
        attrStatus: json['attr_status'],
        clientAmount: json['clientAmount'],
        clientBillingStatus: json['clientBillingStatus'],
        clientInvoiceNo: json['clientInvoiceNo'],
        clientPaymentStatus: json['clientPaymentStatus'],
        clientResumeId: json['client_resume_id'],
        companyName: json['company_name'],
        completeStatus: json['complete_status'],
        contactNo: json['contact_no'],
        createdDate: json['created_date'] != null
            ? DateTime.parse(json['created_date'])
            : null,
        doj: json['doj'] != null ? DateTime.parse(json['doj']) : null,
        dos: json['dos'] != null ? DateTime.parse(json['dos']) : null,
        empId: json['emp_id'],
        expMax: json['exp_max'],
        expMin: json['exp_min'],
        id: json['id'],
        interviewBay: json['interview_bay'],
        isRef: json['isRef'],
        isExperienced: json['is_experienced'],
        jobid: json['jobid'],
        lastName: json['last_name'],
        level: json['level'],
        levelId: json['level_id'],
        natureOfWork: json['natureofwork'],
        natureOfWorkId: json['naturofwork_id'],
        notes: json['notes'],
        pAmount: json['p_amount'],
        partnerBillingStatus: json['partnerBillingStatus'],
        partnerInvoiceNo: json['partnerInvoiceNo'],
        partnerPaymentStatus: json['partnerPaymentStatus'],
        paymentClause: json['payment_clause'],
        paymentclause: json['paymentclause'],
        payout: json['payout'],
        process: json['process'],
        processId: json['process_id'],
        qualification: json['qualification'],
        referralSource: json['referral_source'],
        remark: json['remark'],
        resume: json['resume'],
        salary: json['salary'],
        shortListFor: json['short_list_for'],
        sourceId: json['source_id'],
        sourceName: json['source_name'],
        spInvNo: json['sp_inv_no'],
        spPaymentStatus: json['sp_payment_status'],
        spPayout: json['sp_payout'],
        splPaymentCluase: json['splPaymentCluase'],
        spoc: json['spoc'],
        status: json['status'],
        subSource: json['sub_source'],
        subStatus: json['sub_status'],
        uid: json['uid'],
        updatedDate: json['updated_date'] != null
            ? DateTime.parse(json['updated_date'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'alternate_no': alternateNo,
        'applicant_name': applicantName,
        'attr_status': attrStatus,
        'clientAmount': clientAmount,
        'clientBillingStatus': clientBillingStatus,
        'clientInvoiceNo': clientInvoiceNo,
        'clientPaymentStatus': clientPaymentStatus,
        'client_resume_id': clientResumeId,
        'company_name': companyName,
        'complete_status': completeStatus,
        'contact_no': contactNo,
        'created_date': createdDate?.toIso8601String(),
        'doj': doj?.toIso8601String(),
        'dos': dos?.toIso8601String(),
        'emp_id': empId,
        'exp_max': expMax,
        'exp_min': expMin,
        'id': id,
        'interview_bay': interviewBay,
        'isRef': isRef,
        'is_experienced': isExperienced,
        'jobid': jobid,
        'last_name': lastName,
        'level': level,
        'level_id': levelId,
        'natureofwork': natureOfWork,
        'naturofwork_id': natureOfWorkId,
        'notes': notes,
        'p_amount': pAmount,
        'partnerBillingStatus': partnerBillingStatus,
        'partnerInvoiceNo': partnerInvoiceNo,
        'partnerPaymentStatus': partnerPaymentStatus,
        'payment_clause': paymentClause,
        'paymentclause': paymentclause,
        'payout': payout,
        'process': process,
        'process_id': processId,
        'qualification': qualification,
        'referral_source': referralSource,
        'remark': remark,
        'resume': resume,
        'salary': salary,
        'short_list_for': shortListFor,
        'source_id': sourceId,
        'source_name': sourceName,
        'sp_inv_no': spInvNo,
        'sp_payment_status': spPaymentStatus,
        'sp_payout': spPayout,
        'splPaymentCluase': splPaymentCluase,
        'spoc': spoc,
        'status': status,
        'sub_source': subSource,
        'sub_status': subStatus,
        'uid': uid,
        'updated_date': updatedDate?.toIso8601String(),
      };
}
