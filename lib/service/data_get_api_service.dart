 import 'dart:convert';

import 'package:job_circle/constants/gobal.dart';

import '../models/application_status_model.dart';
 import 'package:http/http.dart' as http;
 

class ApplicationAPI {
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
