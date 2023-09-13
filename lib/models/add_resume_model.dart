class JobApplicationModel {
  final int? alternateNo;
  final String? applicantName;
  final String? attrStatus;
  final int? clientResumeId;
  final String? companyName;
  final int? completeStatus;
  final int? contactNo;
  final DateTime? doj;
  final DateTime? dos;
  final int? empId;
  final int? expMax;
  final int? expMin;
  final int? isRef;
  final String? flag;
  final int? id;
  final int? interviewBay;
  final int? isExperienced;
  final int? jobid;
  final String? lastName;
  final String? level;
  final int? levelId;
  final String? naturofwork;
  final int? naturofworkId;
  final String? notes;
  final String? paymentClause;
  final int? payout;
  final String? process;
  final int? processId;
  final String? qualification;
  final String? remark;
  final String? resume;
  final String? role;
  final int? shortListFor;
  final int? sourceId;
  final String? sourceName;
  final String? spInvNo;
  final String? spPaymentStatus;
  final int? spPayout;
  final int? spoc;
  final String? status;
  final String? subStatus;
  final int? uid;
  final String? userType;
  final String? interview_rounds;

  JobApplicationModel({
    this.alternateNo,
    this.applicantName,
    this.attrStatus,
    this.isRef,
    this.clientResumeId,
    this.companyName,
    this.completeStatus,
    this.contactNo,
    this.doj,
    this.dos,
    this.empId,
    this.expMax,
    this.expMin,
    this.flag,
    this.id,
    this.interviewBay,
    this.isExperienced,
    this.jobid,
    this.lastName,
    this.level,
    this.levelId,
    this.naturofwork,
    this.naturofworkId,
    this.notes,
    this.paymentClause,
    this.payout,
    this.process,
    this.processId,
    this.qualification,
    this.remark,
    this.resume,
    this.role,
    this.shortListFor,
    this.sourceId,
    this.sourceName,
    this.spInvNo,
    this.spPaymentStatus,
    this.spPayout,
    this.spoc,
    this.status,
    this.subStatus,
    this.uid,
    this.userType,
    this.interview_rounds,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      alternateNo: json['alternate_no'],
      applicantName: json['applicant_name'],
      attrStatus: json['attr_status'],
      clientResumeId: json['client_resume_id'],
      companyName: json['company_name'],
      completeStatus: json['complete_status'],
      contactNo: json['contact_no'],
      doj: json['doj'] != null ? DateTime.parse(json['doj']) : null,
      dos: json['dos'] != null ? DateTime.parse(json['dos']) : null,
      empId: json['emp_id'],
      expMax: json['exp_max'],
      expMin: json['exp_min'],
      flag: json['flag'],
      id: json['id'],
      interviewBay: json['interview_bay'],
      isExperienced: json['is_experienced'],
      jobid: json['jobid'],
      lastName: json['last_name'],
      level: json['level'],
      levelId: json['level_id'],
      naturofwork: json['natur_of_work'],
      naturofworkId: json['naturofwork_id'],
      notes: json['notes'],
      paymentClause: json['payment_clause'],
      payout: json['payout'],
      process: json['process'],
      processId: json['process_id'],
      qualification: json['qualification'],
      remark: json['remark'],
      resume: json['resume'],
      role: json['role'],
      shortListFor: json['short_list_for'],
      sourceId: json['source_id'],
      sourceName: json['source_name'],
      spInvNo: json['sp_inv_no'],
      spPaymentStatus: json['sp_payment_status'],
      spPayout: json['sp_payout'],
      spoc: json['spoc'],
      isRef: json['isRef'],
      status: json['status'],
      subStatus: json['sub_status'],
      uid: json['uid'],
      userType: json['user_type'],
      interview_rounds:json['interview_rounds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alternate_no': alternateNo,
      'applicant_name': applicantName,
      'attr_status': attrStatus,
      'client_resume_id': clientResumeId,
      'company_name': companyName,
      'complete_status': completeStatus,
      'contact_no': contactNo,
      'doj': doj?.toIso8601String(),
      'dos': dos?.toIso8601String(),
      'emp_id': empId,
      'exp_max': expMax,
      'exp_min': expMin,
      'flag': flag,
      'id': id,
      'interview_bay': interviewBay,
      'is_experienced': isExperienced,
      'jobid': jobid,
      'last_name': lastName,
      'level': level,
      'level_id': levelId,
      'natur_of_work': naturofwork,
      'naturofwork_id': naturofworkId,
      'notes': notes,
      'payment_clause': paymentClause,
      'payout': payout,
      'process': process,
      'process_id': processId,
      'qualification': qualification,
      'remark': remark,
      'resume': resume,
      'role': role,
      'short_list_for': shortListFor,
      'source_id': sourceId,
      'source_name': sourceName,
      'sp_inv_no': spInvNo,
      'sp_payment_status': spPaymentStatus,
      'sp_payout': spPayout,
      'spoc': spoc,
      'isRef': isRef,
      'status': status,
      'sub_status': subStatus,
      'uid': uid,
      'user_type': userType,
      'interview_rounds': interview_rounds,
    };
  }
}
