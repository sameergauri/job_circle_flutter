class InterviewDetails {
  int? jobId;
  int? uId;
  int? leadId;
  List<String>? interviewRounds;

  InterviewDetails({
    this.jobId,
    this.uId,
    this.leadId,
    this.interviewRounds,
  });

  factory InterviewDetails.fromJson(Map<String, dynamic> json) {
    return InterviewDetails(
      jobId: json['jobId'],
      uId: json['uId'],
      leadId: json['leadId'],
      interviewRounds: _parseSkills(json['inteviewrounds']),
    );
  }

  static List<String>? _parseSkills(dynamic jsonSkills) {
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
  }

  Map<String, dynamic> toJson() {
    return {
      'jobId': jobId,
      'uId': uId,
      'leadId': leadId,
      'interview_rounds': interviewRounds,
    };
  }
}

class InterviewResponseModel {
  String resultKey;
  Map<String, dynamic> resultData;
  String code;
  String errorMessage;

  InterviewResponseModel({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory InterviewResponseModel.fromJson(Map<String, dynamic> json) {
    return InterviewResponseModel(
      resultKey: json['resultKey'],
      resultData: json['resultData'],
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }

  List<InterviewDetails> getRoles() {
    List<InterviewDetails> rounds = [];
    List<dynamic> contentList = resultData['content'];

    for (var content in contentList) {
      rounds.add(InterviewDetails.fromJson(content));
    }

    return rounds;
  }
}
