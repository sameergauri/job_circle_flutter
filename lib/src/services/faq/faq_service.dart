import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/faq/faq_model.dart';

class FaqService {
  Future<List<FaqItem>> fetchFaqs({
    String appType = 'JOBSEEKER',
    required int userid,
  }) async {
    final uri = Uri.parse(
      '${GlobalConstants.faqurl}?appType=$appType&userId=$userid',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final faqResponse = FaqResponse.fromJson(jsonResponse);

        if (faqResponse.resultKey == 'SUCCESS') {
          return faqResponse.resultData;
        } else {
          throw Exception(
            faqResponse.errorMessage.isNotEmpty
                ? faqResponse.errorMessage
                : 'Failed to fetch FAQ data',
          );
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Like / Dislike / Reset FAQ
  ///
  /// Rules:
  /// - like = true  → LIKE
  /// - dislike = true → DISLIKE
  /// - both null or false → RESET (delete reaction)
  /// - both true → backend will return 400
  Future<bool> reactToFaq({
    required int faqId,
    required int userId,
    bool? like,
    bool? dislike,
  }) async {
    final uri = Uri.parse('${GlobalConstants.faqurl}/$faqId/reaction');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          // Agar token chahiye ho to yahan add karo
          // 'Authorization': 'Bearer $token',
        },
        body: json.encode({'userId': userId, 'like': like, 'dislike': dislike}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final errorBody = json.decode(response.body);
        throw Exception(
          errorBody['errorMessage'] ??
              errorBody['message'] ??
              'Failed to react to FAQ (${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
