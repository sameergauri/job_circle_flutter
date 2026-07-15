
// Job Applicant Model
class ReferAddResumeModel {
  final int? alternateNo;
  final String? applicantName;
  final String? companyName;
  final int? contactNo;
  final String? interviewRounds;
  final int? isExperienced;
  final int? jobId;
  final String? lastName;
  final String? level;
  final String? naturofwork;
  final String? process;
  final String? qualification;
  final String? resume;
  final int? shortListFor;
  final int? spoc;
  final int? uid;
  final String? payoutMode;
  final String? email;
  final String? gender;
  final DateTime? dob;
  final int? isLinup;
  final DateTime? interviewDate;
  final int? workSpaceId;
  final int? workSpaceSourceId;
  final Map<String, dynamic>? screeningAnswer;

  ReferAddResumeModel({
    this.alternateNo,
    this.applicantName,
    this.companyName,
    this.contactNo,
    this.interviewRounds,
    this.isExperienced,
    this.jobId,
    this.lastName,
    this.level,
    this.naturofwork,
    this.process,
    this.qualification,
    this.resume,
    this.shortListFor,
    this.spoc,
    this.uid,
    this.payoutMode,
    this.email,
    this.gender,
    this.dob,
    this.isLinup,
    this.interviewDate,
    this.workSpaceId,
    this.workSpaceSourceId,
    this.screeningAnswer,
  });

  ReferAddResumeModel copyWithScreeningAnswer(
      Map<String, dynamic> screeningAnswer) {
    return ReferAddResumeModel(
      alternateNo: alternateNo,
      applicantName: applicantName,
      companyName: companyName,
      contactNo: contactNo,
      interviewRounds: interviewRounds,
      isExperienced: isExperienced,
      jobId: jobId,
      lastName: lastName,
      level: level,
      naturofwork: naturofwork,
      process: process,
      qualification: qualification,
      resume: resume,
      shortListFor: shortListFor,
      spoc: spoc,
      uid: uid,
      payoutMode: payoutMode,
      email: email,
      gender: gender,
      dob: dob,
      isLinup: isLinup,
      interviewDate: interviewDate,
      workSpaceId: workSpaceId,
      workSpaceSourceId: workSpaceSourceId,
      screeningAnswer: screeningAnswer,
    );
  }

  factory ReferAddResumeModel.fromJson(Map<String, dynamic> json) {
    return ReferAddResumeModel(
      alternateNo: json['alternateNo'],
      applicantName: json['applicantName'],
      companyName: json['companyName'],
      contactNo: json['contactNo'],
      interviewRounds: json['interviewRounds'],
      isExperienced: json['isExperienced'],
      jobId: json['jobId'],
      lastName: json['lastName'],
      level: json['level'],
      naturofwork: json['naturofwork'],
      process: json['process'],
      qualification: json['qualification'],
      resume: json['resume'],
      shortListFor: json['shortListFor'],
      spoc: json['spoc'],
      uid: json['uid'],
      payoutMode: json['payoutMode'],
      email: json['email'],
      gender: json['gender'],
      dob: json['dob'] != null ? DateTime.parse(json['dob']) : null,
      isLinup: json['isLinup'],
      interviewDate: json['interviewDate'] != null
          ? DateTime.parse(json['interviewDate'])
          : null,
      workSpaceId: json['workSpaceId'],
      workSpaceSourceId: json['workSpaceSourceId'],
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'alternateNo': alternateNo,
      'applicantName': applicantName,
      'companyName': companyName,
      'contactNo': contactNo,
      'interviewRounds': interviewRounds,
      'isExperienced': isExperienced,
      'jobId': jobId,
      'lastName': lastName,
      'level': level,
      'naturofwork': naturofwork,
      'process': process,
      'qualification': qualification,
      'resume': resume,
      'shortListFor': shortListFor,
      'spoc': spoc,
      'uid': uid,
      'payoutMode': payoutMode,
      'email': email,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'isLinup': isLinup,
      'interviewDate': interviewDate?.toIso8601String(),
      'workSpaceId': workSpaceId,
      'workSpaceSourceId': workSpaceSourceId,
    };
    if (screeningAnswer != null) map['screeningAnswer'] = screeningAnswer;
    return map;
  }
}
