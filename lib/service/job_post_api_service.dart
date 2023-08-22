import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customDialogue.dart';
import 'package:job_circle/constants/dialogue_for_add_resume.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/screens/home.dart';
import 'package:job_circle/screens/partnerhome.dart';

class JobPostApiService {
  static Future<void> postDataToApi(
      Map<String, dynamic> jsonData, BuildContext context) async {
    String apiUrl = 'http://${GlobalConstants.API_Host_one}/jobs/v1';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        print('Data posted successfully');
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialog(
              fetchDataFromApi: () {},
              isFisrt: false,
              onClose: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const PartnerHomeScreen()),
                    (Route<dynamic> route) => false);
              },
              title: "Success",
              subtitle: "Submitted successfully!",
            );
          },
        );
      } else {
        // Request failed
        print('Error: ${response.statusCode}');
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialog(
              fetchDataFromApi: () {},
              isFisrt: false,
              onClose: () {
                Navigator.pop(context);
              },
              title: "Failed",
              subtitle: "Failed while posting!",
            );
          },
        );
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
          'TP1', // Assuming 'status' is always '1' based on the provided URL.
    };

    try {
      final response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        // Post request was successful, handle the response data here if needed.
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                fetchDataFromApi: () {},
                onClose: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false);
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

  static Future<void> changeStatus(
      Map<String, dynamic> jsonData, int id) async {
    String apiUrl =
        'http://${GlobalConstants.API_Host_one}/leads/v1/$id/status/sourceId';

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

  static Future<void> addResume(
      Map<String, dynamic> jsonData, BuildContext context) async {
    final apiUrl = Uri.parse('http://${GlobalConstants.API_Host}/leads/v1');

    try {
      final response = await http.post(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print('Response Data: $responseData');

        final resultKey = responseData['resultKey'] as String?;
        if (resultKey == 'SUCCESS') {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CustomDialogueForAddResume(
                onClose: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const PartnerHomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                },
                subtitle: "Submitted successfully!",
              );
            },
          );
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CustomDialogueForAddResume(
                onClose: () {
                  Navigator.pop(context);
                },
                subtitle: "Failed while posting!",
              );
            },
          );
        }
      } else {
        print('Error: ${response.statusCode}');
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialogueForAddResume(
              onClose: () {
                Navigator.pop(context);
              },
              subtitle: "Failed while posting!",
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return CustomDialogueForAddResume(
            onClose: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => const PartnerHomeScreen()),
                (Route<dynamic> route) => false,
              );
            },
            subtitle: "An error occurred!",
          );
        },
      );
    }
  }
}
