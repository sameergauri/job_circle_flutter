class ProcessModel {
  int id;
  String process;

  ProcessModel({required this.id, required this.process});

  factory ProcessModel.fromJson(Map<String, dynamic> json) {
    return ProcessModel(
      id: json['id'] ?? json['id'], // Handle both property orders
      process:
          json['process'] ?? json['process'], // Handle both property orders
    );
  }
}

class ProcessResponseModel {
  String resultKey;
  Map<String, dynamic> resultData;
  String code;
  String errorMessage;

  ProcessResponseModel({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory ProcessResponseModel.fromJson(Map<String, dynamic> json) {
    return ProcessResponseModel(
      resultKey: json['resultKey'],
      resultData: json['resultData'],
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }

  List<ProcessModel> getRoles() {
    List<ProcessModel> roles = [];
    List<dynamic> contentList = resultData['content'];

    for (var content in contentList) {
      roles.add(ProcessModel.fromJson(content));
    }

    return roles;
  }
}
