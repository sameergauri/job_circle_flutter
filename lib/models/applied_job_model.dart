class AppliedJobModel {
  final Map<String, List<AppliedApplicant>> applicationData;

  AppliedJobModel({required this.applicationData});

  factory AppliedJobModel.fromJson(Map<String, dynamic> json) {
    final applicationData = <String, List<AppliedApplicant>>{};

    if (json['atsData'] != null) {
      final atsData = json['atsData'] as Map<String, dynamic>;
      atsData.forEach((key, value) {
        if (value is List) {
          applicationData[key] =
              value.map((e) => AppliedApplicant.fromJson(e)).toList();
        }
      });
    }

    return AppliedJobModel(applicationData: applicationData);
  }
}

class AppliedApplicant {
  final String? applicantName;
  final String? lastName;
  final String? level;
  final String? process;
  final String? natureOfWork;
  final String? status;
  final String? subStatus;
  final String? companyName;
  final String? appliesTab;
  final String? applyFeedback1;
  final String? applyFeedback2;
  final String? jobSalary;
  final String? resume;
  final int? leadId;
  final int? contactNo;
  final String? profilePic;
  final String? remark;
  final String? notes;
  final String? gender;
  final int? crpfId;
  final int? jobId;
  final int? reportTo;
  final String? companyLogo;
  final List<dynamic>? jobLocation;
  final int? sourcecontactNo;

  AppliedApplicant({
    this.applicantName,
    this.lastName,
    this.level,
    this.process,
    this.natureOfWork,
    this.status,
    this.subStatus,
    this.companyName,
    this.appliesTab,
    this.applyFeedback1,
    this.applyFeedback2,
    this.jobSalary,
    this.resume,
    this.leadId,
    this.contactNo,
    this.profilePic,
    this.remark,
    this.notes,
    this.gender,
    this.crpfId,
    this.jobId,
    this.reportTo,
    this.companyLogo,
    this.jobLocation,
    this.sourcecontactNo,
  });

  factory AppliedApplicant.fromJson(Map<String, dynamic> json) {
    return AppliedApplicant(
      applicantName: json['applicantName'] as String?,
      lastName: json['lastName'] as String?,
      level: json['level'] as String?,
      process: json['process'] as String?,
      natureOfWork: json['natureOfWork'] as String?,
      status: json['status'] as String?,
      subStatus: json['subStatus'] as String?,
      companyName: json['companyName'] as String?,
      appliesTab: json['appliesTab'] as String?,
      applyFeedback1: json['applyFeedback1'] as String?,
      applyFeedback2: json['applyFeedback2'] as String?,
      jobSalary: json['jobSalary'] as String?,
      resume: json['resume'] as String?,
      leadId: json['leadId'] as int?,
      contactNo: json['contactNo'] as int?,
      profilePic: json['profilePic'] as String?,
      remark: json['remark'] as String?,
      notes: json['notes'] as String?,
      gender: json['gender'] as String?,
      crpfId: json['crpfId'] as int?,
      jobId: json['jobId'] as int?,
      reportTo: json['reportTo'] as int?,
      companyLogo: json['companyLogo'] as String?,
      jobLocation: json['jobLocation'],
      sourcecontactNo: json['sourcecontactNo'] as int?,
    );
  }
}
