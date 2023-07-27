class ApplicantData {
  final List<Applicant>? content;
  final int pageNumber;
  final int pageSize;
  final int total;

  ApplicantData({
    this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.total,
  });

  factory ApplicantData.fromJson(Map<String, dynamic> json) {
    return ApplicantData(
      content: (json['content'] as List<dynamic>?)
          ?.map((applicantJson) => Applicant.fromJson(applicantJson))
          .toList(),
      pageNumber: json['pageNumber'] as int,
      pageSize: json['pageSize'] as int,
      total: json['total'] as int,
    );
  }
}

class Applicant {
  final String isExperienced;
  final String companyName;
  final String salary;
  final String workLocation;
  final String naturOfWork;
  final String status;
  final String resume;
  final String dateofbirth;
  final String qualification;
  final int uid;
  final String level;
  final int id;
  final int contactNo;
  final String process;
  final int spoc;
  final int jobId;
  final int alternateNo;
  final int sourceId;
  final String applicantName;

  Applicant({
    required this.isExperienced,
    required this.companyName,
    required this.salary,
    required this.workLocation,
    required this.qualification,
    required this.naturOfWork,
    required this.status,
    required this.dateofbirth,
    required this.resume,
    required this.uid,
    required this.level,
    required this.id,
    required this.contactNo,
    required this.process,
    required this.spoc,
    required this.jobId,
    required this.alternateNo,
    required this.sourceId,
    required this.applicantName,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      isExperienced: json['is_experienced'] as String? ?? '',
      companyName: json['company_name'] as String? ?? '',
      salary: json['total_salary'] as String? ?? '',
      workLocation: json['work_location'] as String? ?? '',
      naturOfWork: json['natur_of_work'] as String? ?? '',
      qualification: json['qualification'] as String? ?? '',
      dateofbirth: json['dateofbirth'] as String? ?? '',
      status: json['status'] as String? ?? '',
      resume: json['resume'] as String? ?? '',
      uid: json['uid'] as int? ?? 0,
      level: json['level'] as String? ?? '',
      id: json['id'] as int? ?? 0,
      contactNo: json['contact_no'] as int? ?? 0,
      process: json['process'] as String? ?? '',
      spoc: json['spoc'] as int? ?? 0,
      jobId: json['jobid'] as int? ?? 0,
      alternateNo: json['alternate_no'] as int? ?? 0,
      sourceId: json['source_id'] as int? ?? 0,
      applicantName: json['applicant_name'] as String? ?? '',
    );
  }
}




/* class Applicant {
  final String companyName;
  final int statusId;
  final String status;
  final String process;
  final String appliedDate;
  final String rolename;
  final String? lastUpdate;
  final int jobid;
  final String? completeStatus;
  final String applicantName;
  final String? doj;

  Applicant({
    required this.companyName,
    required this.statusId,
    required this.status,
    required this.process,
    required this.appliedDate,
    required this.rolename,
    this.lastUpdate,
    required this.jobid,
    this.completeStatus,
    required this.applicantName,
    this.doj,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      companyName: json['company_name'] as String? ?? '',
      statusId: json['status_id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      process: json['process'] as String? ?? '',
      appliedDate: json['applied_date'] as String? ?? '',
      rolename: json['rolename'] as String? ?? '',
      lastUpdate: json['last_update'] as String?,
      jobid: json['jobid'] as int? ?? 0,
      completeStatus: json['complete_status'] as String?,
      applicantName: json['applicant_name'] as String? ?? '',
      doj: json['doj'] as String?,
    );
  }
}
 */