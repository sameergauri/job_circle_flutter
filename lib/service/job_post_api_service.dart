import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customDialogue.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/home.dart';

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

  static Future<void> postJobApply(
      {required int jobId,
      required int userId,
      required BuildContext context}) async {
    final url =
        Uri.parse('http://${GlobalConstants.API_Host_one}/leads/v1/applyJob');
    final body = {
      'jobId': jobId.toString(),
      'userId': userId.toString(),
      'status':
          '1', // Assuming 'status' is always '1' based on the provided URL.
    };

    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        // Post request was successful, handle the response data here if needed.
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                onClose: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(),), (route) => false);
                },
                isFisrt: false,
                title: "Job Apply succesfully",
                subtitle: "Wait our recruiter will connect you shortly");
          },
        );
        print(response.body);
      } else {
        // Post request failed, handle the error here if needed.
        print('Post request failed with status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (e) {
      // Error occurred during the post request, handle the error here.
      print('Error occurred during post request: $e');
    }
  }
}
