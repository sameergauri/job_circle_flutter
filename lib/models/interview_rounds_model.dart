// ignore_for_file: non_constant_identifier_names

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
    int? jobId =
        json['jobId'] as int?; // Use 'as int?' to handle potential null
    int? uId = json['uId']; // Use 'as String?' to handle potential null

    final roundsListJson = json['interview_rounds'];
    List<String> interviewRounds = [];

    if (roundsListJson is List<dynamic>) {
      interviewRounds =
          roundsListJson.map((round) => round.toString()).toList();
    } else {
      // Handle the case where 'interview_rounds' is missing or not a list
      // You can provide a default value or take other error-handling measures
    }

    int? leadId =
        json['leadId'] as int?; // Use 'as int?' to handle potential null

    return ResultData(
      jobId: jobId ?? 0, // Provide a default value (e.g., 0) if jobId is null
      uId: uId ??
          0, // Provide a default value (e.g., an empty string) if uId is null
      interviewRounds: interviewRounds,
      leadId:
          leadId ?? 0, // Provide a default value (e.g., 0) if leadId is null
    );
  }

  /*  factory ResultData.fromJson(Map<String, dynamic> json) {
    List<dynamic> roundsList = jsonDecode(json['interview_rounds']);
    List<String> interviewRounds =
        roundsList.map((round) => round.toString()).toList();

    return ResultData(
      jobId: json['jobId'],
      uId: json['uId'],
      interviewRounds: interviewRounds,
      leadId: json['leadId'],
    );
  } */
}

class InterviewRoundModel {
  final int id;
  final String groupName;
  final String code;
  final String value;
  final int active;
  final int deleted;
  final String urlSlug;
  final int parentid;
  final String? parentname; // Use nullable type for fields that can be null
  final int? parent_id;
  final String? parent_name;
  final int orderno;
  final dynamic extra; // Use dynamic for fields with various types
  final dynamic icon;
  final dynamic subValue;
  final dynamic actionLine;

  InterviewRoundModel({
    required this.id,
    required this.groupName,
    required this.code,
    required this.value,
    required this.active,
    required this.deleted,
    required this.urlSlug,
    required this.parentid,
    this.parentname,
    this.parent_id,
    this.parent_name,
    required this.orderno,
    this.extra,
    this.icon,
    this.subValue,
    this.actionLine,
  });

 factory InterviewRoundModel.fromJson(Map<String, dynamic> json) {
    return InterviewRoundModel(
      id: json['id'] ?? 0, // Default to 0 if id is null
      groupName: json['group_name'] ?? '',
      code: json['code'] ?? '',
      value: json['value'] ?? '',
      active: json['active'] ?? 0,
      deleted: json['deleted'] ?? 0,
      urlSlug: json['url_slug'] ?? '',
      parentid: json['parentid'] ?? 0,
      parentname: json['parentname'],
      parent_id: json['parent_id'],
      parent_name: json['parent_name'],
      orderno: json['orderno'] ?? 0,
      extra: json['extra'],
      icon: json['icon'],
      subValue: json['sub_value'],
      actionLine: json['action_line'],
    );
  }

}

