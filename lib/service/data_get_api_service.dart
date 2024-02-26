// ignore_for_file: unused_local_variable, avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/cooling.dart';
import 'package:job_circle/models/cooling_p_model.dart';
import 'package:job_circle/models/get_banking_detail_model.dart';

import '../models/application_status_model.dart';
import '../models/get_user_for_add_Resume.dart';
import '../models/interview_rounds_model.dart';

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

  Future<List<CoolingModel>> fetchCoolingData() async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host}/leads/v1/getAllLeadsForCoolingPeriod?page=1&size=10000'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      final List<dynamic> content = jsonData['resultData']['content'];

      List<CoolingModel> coolingList = [];
      for (var data in content) {
        coolingList.add(CoolingModel.fromJson(data));
      }
      return coolingList;
    } else {
      throw Exception('Failed to load cooling data');
    }
  }

  Future<List<UserDataForAddResumeModelResultData>> getUserForAddResume(
      int number) async {
    final url =
        Uri.parse("http://${GlobalConstants.API_Host}/users/v1/user/$number");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonBody = json.decode(response.body);

      if (jsonBody != null) {
        final userDataModel = UserDataForAddResumeModel.fromJson(jsonBody);

        return [userDataModel.resultData];
      }

      // If jsonBody is null or resultData is null, return an empty list
      final userDataModel = UserDataForAddResumeModel.fromJson(jsonBody);
      return [];
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<InterviewResult> fetchInterviewResult(int jobId, int leadId) async {
    final response = await http.get(Uri.parse(
        'http://${GlobalConstants.API_Host}/leads/v1/getInterviewRounds?jobId=$jobId&leadId=$leadId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return InterviewResult.fromJson(jsonData);
    } else {
      throw Exception('Failed to load interview result');
    }
  }

  /* Future<List<UserDataForAddResumeModelResultData>> getUserForAddResume(
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
        final staticData = UserDataForAddResumeModelResultData(
          // Fill in properties with static data
          // For example:
          id: 0,
          firstName: "Static",
          lastName: "Data",
          // ...
        );
        return [staticData];
      }
    } else {
      throw Exception('Failed to load data');
    }
  } */
  static Future<CoolingForApply> getStatusAndDolOfUser({
    required int companyId,
    required String process,
    required String role,
    required String now,
  }) async {
    final userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);

    final number = await Utils.getPreferencesValue(
        null, ESharedPreferences.user_mobile.name);

    final Uri apiUrl = Uri.parse(
        'http://${GlobalConstants.API_Host}/leads/v1/getStatusAndDolOfUser?uid=$userid&mobile=$number&companyId=$companyId&process=$process&role=$role&now=$now');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final jsonBody = json.decode(response.body);
        final Map<String, dynamic> data = jsonBody['resultData'];
        return CoolingForApply.fromJson(data);
      } else {
        throw Exception(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  static Future<List<GetBankingModel>> fetchBankingDataForBankDetail() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final url = Uri.parse(
        'http://${GlobalConstants.API_Host_one}/bankDetails/v1/getBankingDetailsOfUserByUserId?uid=$userid&pageNumber=1&pageSize=10');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List<dynamic> contentList = jsonData['resultData']['content'];

        // Convert the list of Map to a list of Applicant objects
        List<GetBankingModel> applicants =
            contentList.map((json) => GetBankingModel.fromJson(json)).toList();
        return applicants;
      } else {
        print(
            'Failed to fetch banking data. Status Code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error while fetching data: $e');
      return [];
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