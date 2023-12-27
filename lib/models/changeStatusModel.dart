// ignore_for_file: equal_keys_in_map, file_names, non_constant_identifier_names

class ChangeStatusModel {
  int? alternateNo;
  String? applicantName;
  String? attrStatus;
  String? interview_rounds;
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
  String? emp_id;
  String? client_email;
  // List<String>? document_list;
  String? document_status;
  int? is_notice;
  int? mode_document;
  DateTime? last_working_date;
  DateTime? dol;

  ChangeStatusModel({
    this.alternateNo,
    this.applicantName,
    this.attrStatus,
    this.interview_rounds,
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
    this.client_email,
    this.last_working_date,
    this.dol,
    // this.document_list,
    this.document_status,
    this.emp_id,
    this.is_notice,
    this.mode_document,
  });

  factory ChangeStatusModel.fromJson(Map<String, dynamic> json) =>
      ChangeStatusModel(
        alternateNo: json['alternate_no'],
        applicantName: json['applicant_name'],
        attrStatus: json['attr_status'],
        interview_rounds: json['interview_rounds'],
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
        emp_id: json['emp_id'],
        client_email: json['client_email'],
        document_status: json['document_status'],
        is_notice: json['is_notice'],
        mode_document: json['mode_document'],
        last_working_date: json['last_working_date'] != null
            ? DateTime.parse(json['last_working_date'])
            : null,
        dol: json['dol'] != null ? DateTime.parse(json['dol']) : null,
      );

  Map<String, dynamic> toJson() => {
        'alternate_no': alternateNo,
        'applicant_name': applicantName,
        'is_notice': is_notice,
        'client_email': client_email,
        'mode_document': mode_document,
        'document_status': document_status,
        'emp_id': emp_id,
        'attr_status': attrStatus,
        'interview_rounds': interview_rounds,
        'clientAmount': clientAmount,
        'clientBillingStatus': clientBillingStatus,
        'clientInvoiceNo': clientInvoiceNo,
        'clientPaymentStatus': clientPaymentStatus,
        'client_resume_id': clientResumeId,
        'company_name': companyName,
        'complete_status': completeStatus,
        'contact_no': contactNo,
        'created_date': createdDate?.toIso8601String(),
        'last_working_date': last_working_date?.toIso8601String,
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
        'dol': dol?.toIso8601String(),
      };
}
