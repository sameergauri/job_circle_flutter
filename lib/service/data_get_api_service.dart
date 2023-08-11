import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/constants/gobal.dart';

import '../models/application_status_model.dart';
import '../models/get_user_for_add_Resume.dart';

class ApplicationAPI {
  Future<List<Application>> getApplicationStatusList() async {
    final url = Uri.parse(
        "http://${GlobalConstants.API_Host}/master/v1/getByGroups?groupName=appl_status&pageNumber=1&pageSize=100");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final applicationModel = ApplicationStatusModel.fromJson(jsonBody);

      if (applicationModel.resultData?.content != null) {
        // Filter the list based on the condition for application status text
        final filteredList = applicationModel.resultData!.content!
            .where((item) => item.code!.contains("."))
            .toList();
        return filteredList;
      } else {
        // If the content is null, return an empty list
        return [];
      }
    } else {
      // If the request fails, throw an exception or handle the error as needed
      throw Exception('Failed to load data');
    }
  }

  Future<List<UserDataForAddResumeModelResultData>> getUserForAddResume(
      int number) async {
    final url =
        Uri.parse("http://${GlobalConstants.API_Host}/users/v1/user/$number");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final userDataModel = UserDataForAddResumeModel.fromJson(jsonBody);

      if (userDataModel.resultData != null) {
        return [userDataModel.resultData];
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}




/* class ApplicationAPI {
   Future<List<Application>> getApplicationStatusList() async {
    final url = Uri.parse(
        "http://${GlobalConstants.API_Host}/master/v1/getByGroups?groupName=appl_status&pageNumber=1&pageSize=100");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);
      final applicationModel = ApplicationStatusModel.fromJson(jsonBody);

      if (applicationModel.resultData?.content != null) {
        return applicationModel.resultData!.content!;
      } else {
        // If the content is null, return an empty list
        return [];
      }
    } else {
      // If the request fails, throw an exception or handle the error as needed
      throw Exception('Failed to load data');
    }
  }
}
 */