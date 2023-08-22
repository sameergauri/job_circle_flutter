import 'dart:convert';

class InterviewResult {
  final String resultKey;
  final ResultData resultData;
  final String code;
  final String errorMessage;

  InterviewResult({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory InterviewResult.fromJson(Map<String, dynamic> json) {
    return InterviewResult(
      resultKey: json['resultKey'],
      resultData: ResultData.fromJson(json['resultData']),
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }
}

class ResultData {
  final int jobId;
  final int uId;
  final List<String> interviewRounds;
  final int leadId;

  ResultData({
    required this.jobId,
    required this.uId,
    required this.interviewRounds,
    required this.leadId,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    List<dynamic> roundsList = jsonDecode(json['interview_rounds']);
    List<String> interviewRounds =
        roundsList.map((round) => round.toString()).toList();

    return ResultData(
      jobId: json['jobId'],
      uId: json['uId'],
      interviewRounds: interviewRounds,
      leadId: json['leadId'],
    );
  }
}
