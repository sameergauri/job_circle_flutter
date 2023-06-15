import 'dart:convert';

import 'package:http/http.dart' as http;

class JobPostApiService {
  static Future<void> postDataToApi(Map<String, dynamic> jsonData) async {
    String apiUrl = 'http://192.168.1.110:9090/jobs/v1';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        print('Data posted successfully');
      } else {
        // Request failed
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
