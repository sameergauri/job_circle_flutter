class NatureOfWorkModel {
  int? id;
  String? functional_area;
  String? spoc_fname;
  int? spoc;
  String? spoc_lname;

  NatureOfWorkModel(
      {this.id,
      this.functional_area,
      this.spoc,
      this.spoc_fname,
      this.spoc_lname});

  factory NatureOfWorkModel.fromJson(Map<String, dynamic> json) {
    return NatureOfWorkModel(
        id: json['id'] ?? json['id'], // Handle both property orders
        functional_area: json['functional_area'] ?? json['functional_area'],
        spoc_fname: json['spoc_fname'] ?? "",
        spoc_lname: json['spoc_lname'] ?? '',
        spoc: json['spoc'] ?? 0
        // Handle both property orders
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
