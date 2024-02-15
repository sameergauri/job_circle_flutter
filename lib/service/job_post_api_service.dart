// ignore_for_file: avoid_print, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/constants/customDialogue.dart';
import 'package:job_circle/constants/dialogue_for_add_resume.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/models/role_model.dart';
import 'package:job_circle/screens/partnerhome.dart';

class JobPostApiService {
  static Future<void> postDataToApi(
      Map<String, dynamic> jsonData, BuildContext context, bool isEdit) async {
    String apiUrl = 'http://${GlobalConstants.API_Host_one}/jobs/v1';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        isEdit
            ? showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return CustomDialog(
                    fetchDataFromApi: () {},
                    isFisrt: false,
                    onClose: () {
                      /*  Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const PartnerHomeScreen()),
                          (Route<dynamic> route) => false); */
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    title: "Success",
                    subtitle: "Job Posted Successfully!",
                  );
                },
              )
            : print('Data posted successfully');
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

  static Future<void> postDataSaveAsDraft(
      Map<String, dynamic> jsonData, BuildContext context) async {
    String apiUrl = 'http://${GlobalConstants.API_Host_one}/jobs/v1';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialog(
              fetchDataFromApi: () {},
              isFisrt: false,
              onClose: () {
                /*  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const PartnerHomeScreen()),
                    (Route<dynamic> route) => false); */
                Navigator.of(context).popUntil((route) => route.isFirst);
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

  static Future<void> updateLanguages(
      Map<String, dynamic> jsonData, int id) async {
    String apiUrl = 'http://${GlobalConstants.API_Host}/users/v1/$id/languges';

    try {
      var response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200) {
        // Successful request
        // print('Data posted successfully');
      } else {
        // Request failed
        // print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error: $e');
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

      /// 'status':'TP1',
      // Assuming 'status' is always '1' based on the provided URL.
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
                  Navigator.pop(context);
                  /*  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false); */
                },
                isFisrt: false,
                title: "Application Submitted",
                subtitle: "Recruiter will connect you shortly");
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

  static Future<void> NewchangeStatus(
      Map<String, dynamic> jsonData, int id) async {
    String apiUrl =
        'http://${GlobalConstants.API_Host_one}/leads/v1/$id/statusId';

    try {
      var response = await http.put(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        // print(response.body);
        print('Status Updated Successfully');
      } else {
        // Request failed
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
  static Future<void> CvDowloadDone(
      Map<String, dynamic> jsonData, int id) async {
    String apiUrl =
        'http://${GlobalConstants.API_Host_one}/leads/v1/$id/cvDownload';

    try {
      var response = await http.put(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        // print(response.body);
        print('Status Updated Successfully');
      } else {
        // Request failed
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> AddBankingDetails(
      Map<String, dynamic> jsonData, BuildContext context) async {
    /*  var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name); */
    String apiUrl = 'http://${GlobalConstants.API_Host_one}/bankDetails/v1';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        // print(response.body);
        print('Banking Details posted successfully');
        showDialog(
          context: context,
          builder: (context) {
            return CustomDialog(
                fetchDataFromApi: () {},
                onClose: () {
                  Navigator.pop(context);
                  /*  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (route) => false); */
                },
                isFisrt: false,
                title: "Bank Detail Added",
                subtitle: "Wait till the verification done");
          },
        );
      } else {
        // Request failed
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> NewChangeCRPF(
      Map<String, dynamic> jsonData, int id) async {
    String apiUrl =
        'http://${GlobalConstants.API_Host_one}/leads/v1/$id/updateCrpf';

    try {
      var response = await http.put(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        print('Status Updated Successfully');
      } else {
        // Request failed
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> saveJobRole(BuildContext context, String role) async {
    // Generate a random code
    String randomCode = generateRandomCode();

    RoleModel groupNameModel = RoleModel(
      id: 0,
      active: 1,
      code: randomCode,
      groupName: "job_role",
      value: role,
      urlSlug: null,
      deleted: 0,
      orderno: 0,
    );

    // Convert the groupNameModel to a JSON representation
    Map<String, dynamic> requestBody = groupNameModel.toJson();

    try {
      final response = await http.post(
        Uri.parse('http://${GlobalConstants.API_Host}/master/v1'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print("new job title saved");
        /* ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Master saved successfully')),
        ); */
        /*   Navigator.pop(context); */
      } // Inside the else if block
      else if (response.statusCode == 500) {
        // If status code is 500, generate a new code and retry
        randomCode = generateRandomCode();
        groupNameModel.code = randomCode;
        requestBody = groupNameModel.toJson();
        // Retry the request
        final retryResponse = await http.post(
          Uri.parse('http://${GlobalConstants.API_Host}/master/v1'),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(requestBody),
        );
        if (retryResponse.statusCode == 200) {
          print("new job title saved");
          /*  ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Master saved successfully on retry')),
          );
          Navigator.pop(context); */
        } else {
          print("new job title not saved");
          /*  ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save master on retry')),
          ); */
        }
      }
    } catch (e) {
      if (e is http.Response) {
        print("Error while saving job title");
      } else {
        //    print('Unexpected error: $e');
        print("unexoected error while saving job title");
      }
    }
  }

  static Future<void> addResume(Map<String, dynamic> jsonData,
      BuildContext context, bool fromDialog) async {
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
        if (resultKey == 'SUCCESS' && fromDialog == false) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CustomDialogueForAddResume(
                error: false,

                onClose: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                subtitle: "Submitted successfully!",
              );
            },
          );
        } else if (fromDialog == false) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return CustomDialogueForAddResume(
                error: false,
                onClose: () {
                  Navigator.pop(context);
                },
                subtitle: "Failed while posting!",
              );
            },
          );
        } else {}
      } else {
        print('Error: ${response.statusCode}');
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialogueForAddResume(
              error: true,
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
            error: true,
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

  static String generateRandomCode() {
    Random random = Random();
    // You can adjust the length and characters based on your requirements
    const String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return "R${List.generate(3, (index) => chars[random.nextInt(chars.length)]).join()}";
  }

  static Future<void> PostUserInfo(Map<dynamic, dynamic> jsonData) async {
    String apiUrl = 'http://${GlobalConstants.API_Host}/users/v1/saveStages';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        print("data posted succesully");
      } else {
        // Request failed
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> PostUserExperience(
      Map<dynamic, dynamic> jsonData, BuildContext context) async {
    String apiUrl = 'http://${GlobalConstants.API_Host}/exp/v1';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        print("Ecxperience data posted succesfully");
      } else {
        // Request failed
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) {
            return CustomDialogueForAddResume(
              error:  true,
              onClose: () {
                Navigator.pop(context);
              },
              subtitle:
                  "Due to some technical error your experience is not added. please wait for next update.",
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> postEducation(Map<dynamic, dynamic> jsonData) async {
    String apiUrl = 'http://${GlobalConstants.API_Host}/edu/v1';

    try {
      var response = await http.post(Uri.parse(apiUrl),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(jsonData));

      if (response.statusCode == 200) {
        // Successful request
        print("data posted succesully");
      } else {
        // Request failed
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> DeletExperience(
      int id, BuildContext context, String urlcode) async {
    String apiurl =
        'http://${GlobalConstants.API_Host}/$urlcode/v1/delete?id=$id';
    try {
      var respopnse = await http.delete(
        Uri.parse(apiurl),
      );
      if (respopnse.statusCode == 200) {
        print('Data deleted successfully.');
        Navigator.pop(context);
      } else {
        print('Failed to delete data. Status code: ${respopnse.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error: $e');
    }
  }

  static Future<void> AddCompanytoMom(String name) async {
    final apiUrl = Uri.parse('http://${GlobalConstants.API_Host}/company/v1');

    // Define the data you want to send as a Map
    final requestData = {
      "active": 0,
      "id": 0,
      "isClient": 0,
      "name": name,
    };

    try {
      // Make the POST request
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        // Request was successful, you can handle the response here
        print('Data sent successfully!');
        print('Response: ${response.body}');
      } else {
        // Request failed
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error sending data: $e');
    }
  }

  static Future<void> updateFreelancerActivity(int data, int id) async {
    final apiUrl = Uri.parse(
        "http://${GlobalConstants.API_Host_one}/users/v1/$id/freelanceActivity");

    final Map<String, dynamic> jsonData = {"isFreelancer": data};

    try {
      final response = await http.put(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        print(response.body);
        print("User Type Updated successfully");
      } else {
        print("PUT request failed with status code ${response.statusCode}");
        print(response.body);
      }
    } catch (e) {
      print("An error occurred: $e");
    }
  }
}
