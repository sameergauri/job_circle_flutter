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
  String? leadLevel;
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
  String? referral_name;
  String? spoc_name;

  Applicant(
      {this.showRejectTextField,
      this.spocContactNo,
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
      this.leadLevel,
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
      this.referral_name,
      this.spoc_name});

  factory Applicant.fromJson(Map<String, dynamic> json) {
    return Applicant(
      spocContactNo: json['spoc_contact_no'],
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
      leadLevel: json['lead_level'],
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
      company_resumeId: json['company_resumeId'],
      dol: json['dol'] != null ? DateTime.parse(json['dol']) : null,
      referral_name: json['referral_name'],
      spoc_name: json['spoc_name'],
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
      'lead_level': leadLevel,
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
      'mode_document': mode_document,
      'document_status': document_status,
      'short_list_for': short_list_for,
      'is_ref': is_ref,
      'last_name': last_name,
      'source_name': source_name,
      'company_resumeId': company_resumeId,
      'dol': dol,
      'referral_name': referral_name,
      'spoc_name': spoc_name,
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
