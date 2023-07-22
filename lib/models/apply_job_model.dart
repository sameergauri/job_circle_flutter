import 'dart:convert';
import 'package:http/http.dart' as http;

class JobApply {
  final String resultKey;
  final String resultData;
  final String code;
  final String errorMessage;

  JobApply({
    required this.resultKey,
    required this.resultData,
    required this.code,
    required this.errorMessage,
  });

  factory JobApply.fromJson(Map<String, dynamic> json) {
    return JobApply(
      resultKey: json['resultKey'] ?? '',
      resultData: json['resultData'] ?? '',
      code: json['code'] ?? '',
      errorMessage: json['errorMessage'] ?? '',
    );
  }
}
