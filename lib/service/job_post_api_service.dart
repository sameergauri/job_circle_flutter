import 'package:http/http.dart' as http;
import 'dart:convert';

class JobPostApiService{
  static Future<void> postDataToApi(Map<String, dynamic> jsonData) async {
    String apiUrl = 'http://192.168.2.111:9090/jobs/v1';

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