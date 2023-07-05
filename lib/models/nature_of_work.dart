class NatureOfWorkModel {
  int id;
  String functional_area;

  NatureOfWorkModel({required this.id, required this.functional_area});

  factory NatureOfWorkModel.fromJson(Map<String, dynamic> json) {
    return NatureOfWorkModel(
      id: json['id'] ?? json['id'], // Handle both property orders
      functional_area: json['functional_area'] ??
          json['functional_area'], // Handle both property orders
    );
  }
}

class NatureOfWorkResponseModel {
  String resultKey;
  Map<String, dynamic> resultData;
  String code;
  String errorMessage;

  NatureOfWorkResponseModel({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory NatureOfWorkResponseModel.fromJson(Map<String, dynamic> json) {
    return NatureOfWorkResponseModel(
      resultKey: json['resultKey'],
      resultData: json['resultData'],
      code: json['code'],
      errorMessage: json['errorMessage'],
    );
  }

  List<NatureOfWorkModel> getRoles() {
    List<NatureOfWorkModel> roles = [];
    List<dynamic> contentList = resultData['content'];

    for (var content in contentList) {
      roles.add(NatureOfWorkModel.fromJson(content));
    }

    return roles;
  }
}
