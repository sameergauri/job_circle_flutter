import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/faq/faq_model.dart';

class FaqService {
  Future<List<FaqItem>> fetchFaqs({String appType = 'JOBSEEKER'}) async {
    final uri = Uri.parse('${GlobalConstants.faqurl}?appType=$appType');

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
}
