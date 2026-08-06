class DigilockerStatusModel {
  final String resultKey;
  final List<ResultData> dataList;
  final String code;
  final String errorMessage;

  DigilockerStatusModel({
    required this.resultKey,
    required this.dataList,
    required this.code,
    required this.errorMessage,
  });

  /// Active verification (active == true)
  ResultData? get activeData {
    try {
      return dataList.firstWhere((e) => e.active);
    } catch (_) {
      return dataList.isNotEmpty ? dataList.first : null;
    }
  }

  /// Backward compatible — active item return karega
  ResultData? get resultData => activeData;

  factory DigilockerStatusModel.fromJson(Map<String, dynamic> json) {
    final List<ResultData> list = [];

    final raw = json['resultData'];

    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          list.add(ResultData.fromJson(item));
        }
      }
    } else if (raw is Map<String, dynamic>) {
      // purana single-object format (safety)
      list.add(ResultData.fromJson(raw));
    }

    return DigilockerStatusModel(
      resultKey: json['resultKey']?.toString() ?? '',
      dataList: list,
      code: json['code']?.toString() ?? '',
      errorMessage: json['errorMessage']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'resultKey': resultKey,
      'resultData': dataList.map((e) => e.toJson()).toList(),
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
  final String deletedAt;
  final bool active;

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
    required this.active,
    required this.deletedAt,
  });

  factory ResultData.fromJson(Map<String, dynamic> json) {
    return ResultData(
      userId: json['userId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      documentType: json['documentType']?.toString() ?? '',
      documentNumber: json['documentNumber']?.toString() ?? '',
      verifiedAt: json['verifiedAt']?.toString() ?? '',
      photoUrl: json['photoUrl']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      active: json['active'] == true,
      deletedAt: json['deletedAt']?.toString() ?? '',
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
      'active': active,
      'deletedAt': deletedAt,
    };
  }
}
