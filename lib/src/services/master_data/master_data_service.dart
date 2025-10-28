
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';

class MasterDataService {
 static Future<List<String>> getSuggestions(String groupName) async {
    final response = await http.post(
      Uri.parse(
        '${GlobalConstants.fetchmasterdatasuggestionurl}$groupName&pageNumber=1&pageSize=1000',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> content = data['resultData']['masterData']['content'];
      // Sort by orderno
      content.sort((a, b) => (a['orderno'] ?? 0).compareTo(b['orderno'] ?? 0));
      return content.map((e) => e['value'].toString()).toList();
    } else {
      throw Exception('Failed to retrieve $groupName suggestions');
    }
  }

 static Future<List<String>> fetchMasterDataSuggestions(
    String groupName,
    String pattern,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(
          '${GlobalConstants.fetchmasterdatasuggestionurl}$groupName&pageNumber=1&pageSize=1000',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Set<String> uniqueValues = {};

        List<dynamic> content = data['resultData']['masterData']['content'];
        for (var entry in content) {
          String? value = entry['value']?.toString();
          if (value != null) {
            if (pattern.isEmpty ||
                value.toLowerCase().startsWith(pattern.toLowerCase())) {
              uniqueValues.add(value);
            }
          }
        }
        return uniqueValues.toList();
      } else {
        throw Exception('Failed to retrieve $groupName suggestions');
      }
    } catch (e) {
      throw Exception('Error fetching $groupName: $e');
    }
  }
}
