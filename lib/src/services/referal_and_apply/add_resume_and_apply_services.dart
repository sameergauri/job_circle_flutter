// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/referal_model/add_resume_model.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class AddResumeAndApplyService {
  static Future<String> referAndAddResume({
    required ReferAddResumeModel jsonData,
    required int refId,
  }) async {
    final url = Uri.parse('${GlobalConstants.refercvUrl}$refId');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData.toJson()),
      );
      if (response.statusCode == 200) {
        return '200';
      } else {
        print('API Error: ${response.body}');
        return response.statusCode.toString();
      }
    } catch (e, stackTrace) {
      print('HTTP Error: $e\nStackTrace: $stackTrace');
      rethrow;
    }
  }

  static Future<String> postJobApply({
    required int jobId,
    required int userId,
    required List<Map<String, dynamic>> screeningAnswers,
    required bool isEligible,
    int? refid,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        "answers": screeningAnswers,
        "isEligible": isEligible,
      };

      final response = await http.post(
        refid != null
            ? Uri.parse(
                '${GlobalConstants.applyUrl}?jobId=$jobId&userId=$userId&refId=$refid',
              )
            : Uri.parse(
                '${GlobalConstants.applyUrl}?jobId=$jobId&userId=$userId',
              ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final String codeValue = jsonData['code'] ?? "";
        final String resultKey = jsonData["resultKey"] ?? "";

        if (resultKey == "ERROR") {
          return codeValue.replaceAll(" within the last 30 days", "");
        } else {
          return "Application Submitted Successfully!";
        }
      } else {
        return "Request failed with status: ${response.statusCode}";
      }
    } catch (e) {
      return "Error applying job: $e";
    }
  }

  static Future<Map<String, dynamic>> validateShareCode(
    String shareCode,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${GlobalConstants.validatesharejob}$shareCode',
        ),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"success": false, "message": "Invalid link"};
      }
    } catch (e) {
      return {"success": false, "message": "Network error"};
    }
  }

  /* static Future<String> postJobApply({
    required int jobId,
    required int userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${GlobalConstants.applyUrl}?jobId=$jobId&userId=$userId'),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final String codeValue = jsonData['code'] ?? "";
        final String resultKey = jsonData["resultKey"] ?? "";

        if (resultKey == "ERROR") {
          return codeValue.replaceAll(" within the last 30 days", "");
        } else {
          return "Application Submitted Successfully!";
        }
      } else {
        return "Request failed with status: ${response.statusCode}";
      }
    } catch (e) {
      return "Error applying job: $e";
    }
  } */
}
