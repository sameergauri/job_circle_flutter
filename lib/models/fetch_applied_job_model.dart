// ignore_for_file: non_constant_identifier_names, avoid_print, camel_case_types

class FetchAppliedJobModel {
  String resultKey;
  ResultData resultData;
  String code;
  String errorMessage;

  FetchAppliedJobModel({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory FetchAppliedJobModel.fromJson(Map<String, dynamic> json) {
    return FetchAppliedJobModel(
      resultKey: json['resultKey'] ?? '',
      resultData: ResultData.fromJson(json['resultData'] ?? {}),
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}

class ResultData {
  List<Applicant> content;
  int pageNumber;
  int pageSize;
  int total;

  ResultData({
    required this.content,
    required this.pageNumber,
    required this.pageSize,
    required this.total,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      content: (json['content'] as List<dynamic>?)
              ?.map((item) => Applicant.fromJson(item))
              .toList() ??
          [],
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class Applicant {
  bool? showRejectTextField = false;
  int? spocContactNo;
  int? rid;
  String? emp_id;
  String? companyName;
  String? remark;
  String? short_name;
  String? role_code;
  String? sub_code;
  String? interview_rounds;
  String? natureOfWork;
  String? sub_status;
  String? availabilityRecent;
  String? status;
  String? totalSalary;
  String? status_code;
  String? jobTitlePrevious;
  int? contactNo;
  String? jobTitleRecent;
  String? companyNamePrevious;
  int? spoc;
  List<String>? skills;
  String? salaryPrevious;
  String? lead_level;
  String? joiningDatePrevious;
  String? salaryRecent;
  int? id;
  String? educationLevel;
  String? university;
  String? workLocation;
  String? profilePic;
  String? lastWorkingDatePrevious;
  String? applicantName;
  String? qualification;
  String? userLocality;
  String? resume;
  String? joiningDateRecent;
  int? passingYear;
  String? companyNameRecent;
  String? process;
  String? isExperienced;
  String? dateOfBirth;
  int? jobId;
  int? uid;
  String? userLocation;
  int? alternateNo;
  int? sourceId;
  List<String>? languages;
  List<String>? inteviewrounds;
  String? availabilityPrevious;
  String? lastWorkingDateRecent;
  DateTime? doj;
  int? mode_document;
  String? document_status;
  int? short_list_for;
  int? is_ref;
  String? last_name;
  String? source_name;
  String? company_resumeId;
  DateTime? dol;
  String? gender;
  String? sub_source;
  String? hr_status;
  String? apply_status;
  String? referral_status;
  String? hr_sub_status;
  int? status_remark;
  String? apply_icon;
  String? referral_icon;
  String? apply_feedback1;
  String? apply_feedback2;
  String? referral_feedback1;
  String? referral_feedback2;
  int? status_id;
  int? detail_id;
  int? hr_status_id;
  int? dd_hr_status_id;
  String? s2HrStatus;
  String? s2ApplyStatus;
  String? s2ReferralStatus;
  String? s2HrSubStatus;
  int? s2StatusRemark;
  String? s2ApplyIcon;
  String? s2ReferralIcon;
  String? s2ApplyFeedback1;
  String? s2ApplyFeedback2;
  String? s2ReferralFeedback1;
  String? s2ReferralFeedback2;
  int? s2DdStatusId;
  int? s2DdHrStatusId;
  int? s2DetailId;
  int? company_salary;
  int? company_gender;
  int? company_workstatus;
  int? empCID;
  String? notes;
  double? salary;
  int? is_exp;
  String? company_icon;
  int? is_ctc_pay;
  int? is_work_pay;
  int? is_status_hide;
  int? s2_is_status_hide;
  int? isCvDownload;
  int? is_join_submitted;
  String? executive_icon;
  String? executive_feedback1;
  String? executive_feedback2;
  String? executive_status;
  String? s2ExecutiveIcon;
  String? s2ExecutiveFeedback1;
  String? s2ExecutiveFeedback2;
  String? s2ExecutiveStatus;

  Applicant({
    this.showRejectTextField,
    this.spocContactNo,
    this.rid,
    this.emp_id,
    this.companyName,
    this.remark,
    this.short_name,
    this.role_code,
    this.sub_code,
    this.interview_rounds,
    this.natureOfWork,
    this.sub_status,
    this.status_code,
    this.availabilityRecent,
    this.status,
    this.totalSalary,
    this.jobTitlePrevious,
    this.contactNo,
    this.jobTitleRecent,
    this.companyNamePrevious,
    this.spoc,
    this.skills,
    this.salaryPrevious,
    this.lead_level,
    this.joiningDatePrevious,
    this.salaryRecent,
    this.id,
    this.educationLevel,
    this.university,
    this.workLocation,
    this.profilePic,
    this.lastWorkingDatePrevious,
    this.applicantName,
    this.qualification,
    this.userLocality,
    this.resume,
    this.joiningDateRecent,
    this.passingYear,
    this.companyNameRecent,
    this.process,
    this.isExperienced,
    this.dateOfBirth,
    this.jobId,
    this.uid,
    this.userLocation,
    this.alternateNo,
    this.sourceId,
    this.languages,
    this.inteviewrounds,
    this.availabilityPrevious,
    this.lastWorkingDateRecent,
    this.doj,
    this.mode_document,
    this.document_status,
    this.short_list_for,
    this.is_ref,
    this.last_name,
    this.source_name,
    this.company_resumeId,
    this.dol,
    this.gender,
    this.sub_source,
    this.apply_feedback1,
    this.apply_feedback2,
    this.apply_icon,
    this.apply_status,
    this.detail_id,
    this.hr_status,
    this.hr_sub_status,
    this.referral_feedback1,
    this.referral_feedback2,
    this.referral_icon,
    this.referral_status,
    this.status_id,
    this.status_remark,
    this.hr_status_id,
    this.dd_hr_status_id,
    this.s2HrStatus,
    this.s2ApplyStatus,
    this.s2ReferralStatus,
    this.s2HrSubStatus,
    this.s2StatusRemark,
    this.s2ApplyIcon,
    this.s2ReferralIcon,
    this.s2ApplyFeedback1,
    this.s2ApplyFeedback2,
    this.s2ReferralFeedback1,
    this.s2ReferralFeedback2,
    this.s2DdStatusId,
    this.s2DdHrStatusId,
    this.s2DetailId,
    this.company_gender,
    this.company_salary,
    this.company_workstatus,
    this.empCID,
    this.notes,
    this.salary,
    this.is_exp,
    this.company_icon,
    this.is_ctc_pay,
    this.is_work_pay,
    this.is_status_hide,
    this.s2_is_status_hide,
    this.isCvDownload,
    this.is_join_submitted,
    this.executive_icon,
    this.executive_status,
    this.executive_feedback1,
    this.executive_feedback2,
    this.s2ExecutiveFeedback1,
    this.s2ExecutiveFeedback2,
    this.s2ExecutiveIcon,
    this.s2ExecutiveStatus,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      spocContactNo: json['spoc_contact_no'],
      rid: json['rid'],
      emp_id: json['emp_id'],
      skills: _parseSkills(json['skills']),
      status_code: json['status_code'],
      companyName: json['company_name'],
      remark: json['remark'],
      short_name: json['short_name'],
      role_code: json['role_code'],
      sub_code: json['sub_code'],
      interview_rounds: json['interview_rounds'],
      sub_status: json['sub_status'],
      natureOfWork: json['natur_of_work'],
      availabilityRecent: json['availability_recent'],
      status: json['status'],
      totalSalary: json['total_salary'],
      jobTitlePrevious: json['job_title_previous'],
      contactNo: json['contact_no'],
      jobTitleRecent: json['job_title_recent'],
      companyNamePrevious: json['company_name_previous'],
      spoc: json['spoc'],
      salaryPrevious: json['salary_previous'],
      lead_level: json['lead_level'],
      joiningDatePrevious: json['joining_date_previous'],
      salaryRecent: json['salary_recent'],
      id: json['id'],
      educationLevel: json['education_level'],
      university: json['university'],
      workLocation: json['work_location'],
      profilePic: json['profile_pic'],
      lastWorkingDatePrevious: json['last_working_date_previous'],
      applicantName: json['applicant_name'],
      qualification: json['qualification'],
      userLocality: json['user_locality'],
      resume: json['resume'],
      joiningDateRecent: json['joining_date_recent'],
      passingYear: json['passing_year'],
      companyNameRecent: json['company_name_recent'],
      process: json['process'],
      isExperienced: json['is_experienced'],
      dateOfBirth: json['dateofbirth'],
      jobId: json['jobid'],
      uid: json['uid'],
      userLocation: json['user_location'],
      alternateNo: json['alternate_no'],
      sourceId: json['source_id'],
      languages: _parseSkills(json['languages']),
      inteviewrounds: _parseSkills(json['inteviewrounds']),
      availabilityPrevious: json['availability_previous'],
      lastWorkingDateRecent: json['last_working_date_recent'],
      doj: json['doj'] != null ? DateTime.parse(json['doj']) : null,
      mode_document: json['mode_document'],
      document_status: json['document_status'],
      short_list_for: json['short_list_for'],
      is_ref: json['is_ref'],
      last_name: json['last_name'],
      source_name: json['source_name'],
      company_resumeId: json['z'],
      dol: json['dol'] != null ? DateTime.parse(json['dol']) : null,
      gender: json['gender'],
      sub_source: json['sub_source'],
      apply_feedback1: json['apply_feedback1'],
      apply_feedback2: json['apply_feedback2'],
      apply_icon: json['apply_icon'],
      detail_id: json['detail_id'],
      hr_status: json['hr_status'],
      apply_status: json['apply_status'],
      hr_sub_status: json['hr_sub_status'],
      referral_feedback1: json['referral_feedback1'],
      referral_feedback2: json['referral_feedback2'],
      referral_icon: json['referral_icon'],
      referral_status: json['referral_status'],
      status_id: json['status_id'],
      status_remark: json['status_remark'],
      showRejectTextField: json['showRejectedTextField'],
      hr_status_id: json['hr_status_id'],
      dd_hr_status_id: json['dd_hr_status_id'],
      s2HrStatus: json['s2_hr_status'],
      s2ApplyStatus: json['s2_apply_status'],
      s2ReferralStatus: json['s2_referral_status'],
      s2HrSubStatus: json['s2_hr_sub_status'],
      s2StatusRemark: json['s2_status_remark'],
      s2ApplyIcon: json['s2_apply_icon'],
      s2ReferralIcon: json['s2_referral_icon'],
      s2ApplyFeedback1: json['s2_apply_feedback1'],
      s2ApplyFeedback2: json['s2_apply_feedback2'],
      s2ReferralFeedback1: json['s2_referral_feedback1'],
      s2ReferralFeedback2: json['s2_referral_feedback2'],
      s2DdStatusId: json['s2_dd_status_id'],
      s2DdHrStatusId: json['s2_dd_hr_status_id'],
      s2DetailId: json['s2_detail_id'],
      company_gender: json['company_gender'],
      company_salary: json['company_salary'],
      company_workstatus: json['company_workstatus'],
      empCID: json['empCID'],
      notes: json['notes'],
      salary: json['salary'],
      is_exp: json['is_exp'],
      company_icon: json['company_icon'],
      is_ctc_pay: json['is_ctc_pay'],
      is_work_pay: json['is_work_pay'],
      is_status_hide: json['is_status_hide'] ?? json['s2_is_status_hide'],
      s2_is_status_hide: json['s2_is_status_hide'],
      isCvDownload: json['isCvDownload'],
      is_join_submitted: json['is_join_submitted'],
      executive_feedback1: json['executive_feedback1'],
      executive_feedback2: json['executive_feedback2'],
      executive_icon: json['executive_icon'],
      executive_status: json['executive_status'],
      s2ExecutiveFeedback1: json['s2_executive_feedback1'],
      s2ExecutiveFeedback2: json['s2_executive_feedback2'],
      s2ExecutiveIcon: json['s2_executive_icon'],
      s2ExecutiveStatus: json['s2_executive_status'],
    );
  }



  get interviewrounds => null;
  static List<String>? _parseSkills(dynamic jsonSkills) {
    try {
      if (jsonSkills == null) {
        return null;
      } else if (jsonSkills is String) {
        // Remove the square brackets and escape characters, then split by comma
        final cleanedString = jsonSkills.replaceAll(RegExp(r'[[]\"]'), '');
        final List<String> rounds =
            cleanedString.split(',').map((e) => e.trim()).toList();
        return rounds;
      } else if (jsonSkills is List<dynamic>) {
        // If 'skills' is already a list, cast it to List<String> and return.
        return jsonSkills.cast<String>();
      } else {
        // If 'skills' has an unexpected format, return null or handle it as appropriate.
        return null;
      }
    } catch (e) {
      print('Error parsing skills: $e');
      return null;
    }
  }
  /*  static List<String>? _parseSkills(dynamic jsonSkills) {
    if (jsonSkills == null) {
      return null; // Return null if 'skills' is null in the JSON data.
    } else if (jsonSkills is String) {
      // If 'skills' is a single string, wrap it in a list and return.
      return [jsonSkills];
    } else if (jsonSkills is List<dynamic>) {
      // If 'skills' is already a list, cast it to List<String> and return.
      return jsonSkills.cast<String>();
    } else {
      // If 'skills' has an unexpected format, return null or handle it as appropriate.
      return null;
    }
  } */

  Map<String, dynamic> toJson() {
    return {
      'spoc_contact_no': spocContactNo,
      'rid': rid,
      'emp_id': emp_id,
      'company_name': companyName,
      'remark': remark,
      'short_name': short_name,
      'sub_code': sub_code,
      'role_code': role_code,
      'interview_rounds': interview_rounds,
      'natur_of_work': natureOfWork,
      'sub_status': sub_status,
      'availability_recent': availabilityRecent,
      'status': status,
      'status_code': status_code,
      'total_salary': totalSalary,
      'job_title_previous': jobTitlePrevious,
      'contact_no': contactNo,
      'job_title_recent': jobTitleRecent,
      'company_name_previous': companyNamePrevious,
      'spoc': spoc,
      'skills': skills, // Assuming skills is already a List<String>
      'salary_previous': salaryPrevious,
      'lead_level': lead_level,
      'joining_date_previous': joiningDatePrevious,
      'salary_recent': salaryRecent,
      'id': id,
      'education_level': educationLevel,
      'university': university,
      'work_location': workLocation,
      'profile_pic': profilePic,
      'last_working_date_previous': lastWorkingDatePrevious,
      'applicant_name': applicantName,
      'qualification': qualification,
      'user_locality': userLocality,
      'resume': resume,
      'joining_date_recent': joiningDateRecent,
      'passing_year': passingYear,
      'company_name_recent': companyNameRecent,
      'process': process,
      'is_experienced': isExperienced,
      'dateofbirth': dateOfBirth,
      'jobid': jobId,
      'uid': uid,
      'user_location': userLocation,
      'alternate_no': alternateNo,
      'source_id': sourceId,
      'languages': languages,
      'inteviewrounds': inteviewrounds,
      // Assuming languages is already a List<String>
      'availability_previous': availabilityPrevious,
      'last_working_date_recent': lastWorkingDateRecent,
      'doj': doj?.toIso8601String(),
      'dol': dol?.toIso8601String(),
      'mode_document': mode_document,
      'document_status': document_status,
      'short_list_for': short_list_for,
      'is_ref': is_ref,
      'last_name': last_name,
      'source_name': source_name,
      'company_resumeId': company_resumeId,
      'gender': gender,
      'sub_source': sub_source,
      'hr_status': hr_status,
      'apply_status': apply_status,
      'referral_status': referral_status,
      'hr_sub_status': hr_sub_status,
      'status_remark': status_remark,
      'apply_icon': apply_icon,
      'refferal_ICO': referral_icon,
      'apply_feedback1': apply_feedback1,
      'apply_feedback2': apply_feedback2,
      'referral_feedBw': referral_feedback1,
      'status_id': status_id,
      'detail_id': detail_id,
      'hr_status_id': hr_status_id,
      'dd_hr_status_id': dd_hr_status_id,
      's2_hr_status': s2HrStatus,
      's2_apply_status': s2ApplyStatus,
      's2_referral_status': s2ReferralStatus,
      's2_hr_sub_status': s2HrSubStatus,
      's2_status_remark': s2StatusRemark,
      's2_apply_icon': s2ApplyIcon,
      's2_referral_icon': s2ReferralIcon,
      's2_apply_feedback1': s2ApplyFeedback1,
      's2_apply_feedback2': s2ApplyFeedback2,
      's2_referral_feedback1': s2ReferralFeedback1,
      's2_referral_feedback2': s2ReferralFeedback2,
      's2_dd_status_id': s2DdStatusId,
      's2_dd_hr_status_id': s2DdHrStatusId,
      's2_detail_id': s2DetailId,
      'company_gender': company_gender,
      'company_salary': company_salary,
      'company_workstatus': company_workstatus,
      'empCID': empCID,
      'notes': notes,
      'salary': salary,
      'is_exp': is_exp,
      'company_icon': company_icon,
      'is_work_pay': is_work_pay,
      'is_ctc_pay': is_ctc_pay,
      'is_status_hide': is_status_hide,
      's2_is_status_hide': s2_is_status_hide,
      'isCvDownload': isCvDownload,
      'is_join_submitted': is_join_submitted,
      'executive_feedback1': executive_feedback1,
      'executive_feedback2': executive_feedback2,
      'executive_icon': executive_icon,
      'executive_status': executive_status,
      's2ExecutiveFeedback1': s2ExecutiveFeedback1,
      's2ExecutiveFeedback2': s2ExecutiveFeedback2,
      's2ExecutiveIcon': s2ExecutiveIcon,
      's2ExecutiveStatus': s2ExecutiveStatus,
    };
  }
}

/* class ApplicantData {
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
 */ */

class JobInteractionModel {
  final bool showRejectTextField;
  final String rejectionReason;

  JobInteractionModel({
    required this.showRejectTextField,
    required this.rejectionReason,
  });
}

class toggle {
  // ... other fields ...

  bool switchValue;

  toggle({
    // ... other constructor parameters ...
    required this.switchValue,
  });
}
