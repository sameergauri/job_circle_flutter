import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/business_page/company_memeber_model.dart';

class CompanyMembershipService {
  Future<List<CompanyMembershipModel>> fetchMembershipSummary({
    required int userId,
  }) async {
    final url = Uri.parse('${GlobalConstants.company_member_url}$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final parsedResponse = CompanyMembershipResponse.fromJson(data);

        if (parsedResponse.resultKey == 'SUCCESS') {
          return parsedResponse.resultData;
        } else {
          throw Exception(
            parsedResponse.errorMessage.isNotEmpty
                ? parsedResponse.errorMessage
                : 'Failed to fetch membership summary',
          );
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching membership summary: $e');
    }
  }
}
