// digilocker_status_model.dart
class DigilockerStatusModel {
  final String resultKey;
  final ResultData? resultData;
  final String code;
  final String errorMessage;

  DigilockerStatusModel({
    required this.resultKey,
    this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory DigilockerStatusModel.fromJson(Map<String, dynamic> json) {
    return DigilockerStatusModel(
      resultKey: json['resultKey'] ?? '',
      resultData: json['resultData'] != null
          ? ResultData.fromJson(json['resultData'])
          : null,
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultKey': resultKey,
      'resultData': resultData?.toJson(),
      'code': code,
      'errorMessage': errorMessage,
    };
  }
}

class ResultData {
  final String userId;
  final String status;
  final String name;
  final String dob;
  final String gender;
  final String documentType;
  final String documentNumber;
  final String verifiedAt;
  final String photoUrl;
  final String mobile;

  ResultData({
    required this.userId,
    required this.status,
    required this.name,
    required this.dob,
    required this.gender,
    required this.documentType,
    required this.documentNumber,
    required this.verifiedAt,
    required this.photoUrl,
    required this.mobile,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      userId: json['userId']?.toString() ?? '',
      status: json['status'] ?? '',
      name: json['name'] ?? '',
      dob: json['dob'] ?? '',
      gender: json['gender'] ?? '',
      documentType: json['documentType'] ?? '',
      documentNumber: json['documentNumber'] ?? '',
      verifiedAt: json['verifiedAt'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      mobile: json['mobile'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'status': status,
      'name': name,
      'dob': dob,
      'gender': gender,
      'documentType': documentType,
      'documentNumber': documentNumber,
      'verifiedAt': verifiedAt,
      'photoUrl': photoUrl,
      'mobile': mobile,
    };
  }
}
