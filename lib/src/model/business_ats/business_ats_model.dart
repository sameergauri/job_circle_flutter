import 'dart:convert';

class AtsResponseModel {
  final String resultKey;
  final AtsResultData? resultData;
  final String code;
  final String errorMessage;

  AtsResponseModel({
    required this.resultKey,
    this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory AtsResponseModel.fromJson(Map<String, dynamic> json) {
    return AtsResponseModel(
      resultKey: json['resultKey'] ?? '',
      resultData: json['resultData'] != null
          ? AtsResultData.fromJson(json['resultData'])
          : null,
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}

class AtsResultData {
  // Structure: Status Tab Name -> List of Applicants
  final Map<String, List<AtsApplicant>> atsData;
  final List<dynamic> teamMembers;
  final String? userRole;

  AtsResultData({
    required this.atsData,
    required this.teamMembers,
    this.userRole,
  });

  factory AtsResultData.fromJson(Map<String, dynamic> json) {
    final Map<String, List<AtsApplicant>> parsedAtsData = {};

    if (json['atsData'] != null && json['atsData'] is Map) {
      final rawAtsData = json['atsData'] as Map<String, dynamic>;

      rawAtsData.forEach((statusKey, applicantsList) {
        if (applicantsList is List) {
          parsedAtsData[statusKey] = applicantsList
              .map(
                (item) => AtsApplicant.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        }
      });
    }

    return AtsResultData(
      atsData: parsedAtsData,
      teamMembers: json['teamMembers'] ?? [],
      userRole: json['userRole']?.toString(),
    );
  }
}

class AtsApplicant {
  final int? leadId;
  final int? userId;
  final int? jobId;
  final String? applicantName;
  final String? lastName;
  final String? status;
  final String? subStatus;
  final int? contactNo;
  final int? alternateNo;
  final String? gender;
  final String? qualification;
  final String? experience;
  final String? resume;
  final String? dolFormatted;
  final String? dotFormatted;
  final String? dojFormatted;
  final String? doiFormatted;
  final String? notes;
  final String? remark;
  final int? statusId;
  final int? businessCompanyId;
  final String? businessCompanyName;
  final String? hiringFor;
  final String? roleForBusinessHiring;
  final String? functionalAreaForBusinessHiring;
  final CandidateInfoDto? candidateInfoDto;
  final ScreeningAnswersDto? screeningAnswers;
  final String? call_back_date_time;

  AtsApplicant({
    this.leadId,
    this.userId,
    this.jobId,
    this.applicantName,
    this.lastName,
    this.status,
    this.subStatus,
    this.contactNo,
    this.alternateNo,
    this.gender,
    this.qualification,
    this.experience,
    this.resume,
    this.dolFormatted,
    this.dotFormatted,
    this.dojFormatted,
    this.doiFormatted,
    this.notes,
    this.remark,
    this.statusId,
    this.businessCompanyId,
    this.businessCompanyName,
    this.hiringFor,
    this.roleForBusinessHiring,
    this.functionalAreaForBusinessHiring,
    this.candidateInfoDto,
    this.screeningAnswers,
    this.call_back_date_time,
  });

  String get fullName {
    if (candidateInfoDto?.candidateName != null &&
        candidateInfoDto!.candidateName!.trim().isNotEmpty) {
      return candidateInfoDto!.candidateName!.trim();
    }
    return '${applicantName ?? ''} ${lastName ?? ''}'.trim();
  }

  factory AtsApplicant.fromJson(Map<String, dynamic> json) {
    final leadDetail = json['lead_detail'] as Map<String, dynamic>? ?? {};
    final profileInfo = json['profile_info'] as Map<String, dynamic>? ?? {};

    return AtsApplicant(
      // Lead Detail fields
      leadId: leadDetail['lead_id'] as int?,
      jobId: leadDetail['jobid'] as int?,
      resume: leadDetail['resume']?.toString(),
      notes: leadDetail['notes']?.toString(),
      remark: leadDetail['remark']?.toString(),
      status: leadDetail['status']?.toString(),
      statusId: leadDetail['status_id'] as int?,
      contactNo: leadDetail['contactNo'] as int?,
      alternateNo: leadDetail['alternateNo'] as int?,
      dolFormatted: leadDetail['dolFormatted']?.toString(),
      dotFormatted: leadDetail['dotFormatted']?.toString(),
      dojFormatted: leadDetail['dojFormatted']?.toString(),
      doiFormatted: leadDetail['doiFormatted']?.toString(),
      businessCompanyId: leadDetail['business_company_id'] as int?,
      businessCompanyName: leadDetail['business_company_name']?.toString(),
      hiringFor: leadDetail['hiring_for']?.toString(),
      roleForBusinessHiring: leadDetail['role_for_business_hiring']?.toString(),
      functionalAreaForBusinessHiring:
          leadDetail['functional_area_for_business_hiring']?.toString(),
      screeningAnswers: leadDetail['screening_answers'] != null
          ? ScreeningAnswersDto.fromJson(
              leadDetail['screening_answers'] as Map<String, dynamic>,
            )
          : null,
          call_back_date_time: leadDetail['call_back_date_time']?.toString(),

      // Profile Info fields
      userId: profileInfo['userid'] as int?,
      applicantName: profileInfo['candidate_name']?.toString(),
      gender: profileInfo['gender']?.toString(),
      qualification: profileInfo['qualification']?.toString(),
      experience: profileInfo['experience']?.toString(),
      candidateInfoDto: CandidateInfoDto.fromJson(profileInfo),
    );
  }
}

class CandidateInfoDto {
  final String? candidateName;
  final String? highestQualification;
  final String? workStatus;
  final String? location;
  final String? gender;
  final String? experience;
  final int? age;
  final int? userId;
  final String? profileIcon;
  final List<String> skills;

  CandidateInfoDto({
    this.candidateName,
    this.highestQualification,
    this.workStatus,
    this.location,
    this.gender,
    this.experience,
    this.age,
    this.userId,
    this.profileIcon,
    this.skills = const [],
  });

  factory CandidateInfoDto.fromJson(Map<String, dynamic> json) {
    return CandidateInfoDto(
      candidateName: json['candidate_name']?.toString(),
      highestQualification: json['qualification']?.toString(),
      workStatus: json['work_status']?.toString(),
      location: json['location']?.toString(),
      gender: json['gender']?.toString(),
      experience: json['experience']?.toString(),
      age: json['age'] as int?,
      userId: json['userid'] as int?,
      profileIcon: json['profile_pic']?.toString(),
      skills:
          (json['skills'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}

class ScreeningAnswersDto {
  final int? correctCount;
  final int? totalQuestions;
  final bool? isPass;
  final List<AnswerItemDto> answers;

  ScreeningAnswersDto({
    this.correctCount,
    this.totalQuestions,
    this.isPass,
    required this.answers,
  });

  factory ScreeningAnswersDto.fromJson(Map<String, dynamic> json) {
    return ScreeningAnswersDto(
      correctCount: json['correct_count'] as int?,
      totalQuestions: json['total_questions'] as int?,
      isPass: json['is_pass'] as bool?,
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map((e) => AnswerItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class AnswerItemDto {
  final String? questionText;
  final String? questionType;
  final bool? isRequired;
  final bool? isCorrect;
  final int? orderNumber;
  final double? numericAnswer;
  final List<String> selectedOptions;
  final List<String> selectedOptionTexts;
  final List<String> correctOptions;

  AnswerItemDto({
    this.questionText,
    this.questionType,
    this.isRequired,
    this.isCorrect,
    this.orderNumber,
    this.numericAnswer,
    this.selectedOptions = const [],
    this.selectedOptionTexts = const [],
    this.correctOptions = const [],
  });

  factory AnswerItemDto.fromJson(Map<String, dynamic> json) {
    return AnswerItemDto(
      questionText: json['question_text']?.toString(),
      questionType: json['question_type']?.toString(),
      isRequired: json['is_required'] as bool?,
      isCorrect: json['is_correct'] as bool?,
      orderNumber: json['order_number'] as int?,
      numericAnswer: json['numeric_answer'] != null
          ? (json['numeric_answer'] as num).toDouble()
          : null,
      selectedOptions:
          (json['selected_options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      selectedOptionTexts:
          (json['selected_option_texts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      correctOptions:
          (json['correct_options'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
