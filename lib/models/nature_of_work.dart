// ignore_for_file: non_constant_identifier_names, avoid_print

class NatureOfWorkModel {
  int? id;
  String? functional_area;
  String? spoc_fname;
  int? spoc;
  String? spoc_lname;
  List<String>? interview_rounds;

  NatureOfWorkModel(
      {this.id,
      this.functional_area,
      this.spoc,
      this.spoc_fname,
      this.spoc_lname,
      this.interview_rounds
      });

  factory NatureOfWorkModel.fromJson(Map<String, dynamic> json) {
    return NatureOfWorkModel(
        id: json['id'] ?? json['id'], // Handle both property orders
        functional_area: json['functional_area'] ?? json['functional_area'],
        spoc_fname: json['spoc_fname'] ?? "",
        spoc_lname: json['spoc_lname'] ?? '',
        spoc: json['spoc'] ?? 0,
        interview_rounds: _parseSkills(json['inteviewrounds']),
        // Handle both property orders
        );
  }
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
