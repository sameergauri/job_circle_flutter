import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/job_model/job_detail_page_model.dart';
import 'package:job_circle/src/model/user_profile/refer_cv_parse_model.dart';

/// Web-safe service — uses Uint8List bytes instead of dart:io File,
/// so it works on Flutter Web where dart:io is unavailable.
class WebApplyService {
  /// Fetch screening questions for a job. Returns empty list on any failure.
  static Future<List<JobDetailScreeningQuestion>> fetchScreeningQuestions(
    int jobId,
  ) async {
    try {
      final url = '${GlobalConstants.getJobDetailUrl}jobId=$jobId&userId=0';
      debugPrint('[WebApplyService] fetchScreeningQuestions → jobId=$jobId url=$url');
      final response = await http.post(Uri.parse(url));
      debugPrint('[WebApplyService] status=${response.statusCode} body=${response.body}');
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['resultKey'] == 'SUCCESS') {
          final resultData = json['resultData'];
          final list =
              (resultData is Map ? resultData['screeningQuestions'] : null)
                  as List<dynamic>? ?? [];
          debugPrint('[WebApplyService] screeningQuestions count=${list.length}');
          return list
              .map(
                (q) =>
                    JobDetailScreeningQuestion.fromJson(q as Map<String, dynamic>),
              )
              .toList();
        } else {
          debugPrint('[WebApplyService] resultKey=${json['resultKey']}');
        }
      }
    } catch (e, st) {
      debugPrint('[WebApplyService] fetchScreeningQuestions ERROR: $e\n$st');
    }
    return [];
  }

  /// Parse CV from raw bytes and return extracted candidate info.
  static Future<ReferResumeParseModel> parseCVFromBytes({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final url = Uri.parse(GlobalConstants.referAndAddResumeParseUrl);
    final request = http.MultipartRequest('POST', url);

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName,
        contentType: MediaType('application', 'pdf'),
      ),
    );
    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ReferResumeParseModel.fromJson(jsonDecode(respStr));
    } else {
      final msg = jsonDecode(respStr)?['message'] ?? 'CV parse failed';
      throw Exception(msg);
    }
  }

  /// Upload CV bytes to server and return the stored file name.
  static Future<String?> uploadCVFromBytes({
    required Uint8List bytes,
    required String fileName,
  }) async {
    final url = Uri.parse('${GlobalConstants.fileuploadurl}?folder=resume');
    final request = http.MultipartRequest('POST', url);

    request.files.add(
      http.MultipartFile.fromBytes(
        'files',
        bytes,
        filename: fileName,
        contentType: MediaType('application', 'pdf'),
      ),
    );

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(respStr);
        if (data['resultKey'] == 'SUCCESS' &&
            data['resultData']?['files'] != null &&
            (data['resultData']['files'] as List).isNotEmpty) {
          return data['resultData']['files'][0]['fileName'] as String?;
        }
      }
    } catch (e) {
      debugPrint('CV upload error: $e');
    }
    return null;
  }
}
