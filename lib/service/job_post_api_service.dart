import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';

class JobPostApiService {
  static Future<void> postDataToApi(Map<String, dynamic> jsonData) async {
    String apiUrl = 'http://${GlobalConstants.API_Host_one}/jobs/v1';

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

  static Future<void> jobInActive(Map<String, dynamic> jsonData, int id) async {
    String apiUrl = 'http://${GlobalConstants.API_Host_one}/jobs/v1/$id';

    try {
      var response = await http.put(Uri.parse(apiUrl),
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
