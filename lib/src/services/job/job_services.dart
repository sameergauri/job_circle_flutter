// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/job_model/job_filter_model.dart';
import 'package:job_circle/src/model/job_model/job_home_page_model.dart';

class JobServices {
  Future<Map<String, dynamic>> fetchJobs({
    required bool applyCityFilter,
    String? selectedCity,
    required String userId,
  }) async {
    final userid = userId;

    final queryParams = {
      'pageNumber': '1',
      'pageSize': '1000',
      'userId': userid.toString(),
    };

    if (applyCityFilter && selectedCity != null && selectedCity.isNotEmpty) {
      queryParams['cities'] = selectedCity;
    }

    final url = Uri.parse(
      GlobalConstants.getAllJobsUrl,
    ).replace(queryParameters: queryParams);

    print('Fetching jobs with URL: $url');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final model = JobHomePageModel.fromJson(jsonData);
        final jobs = model.resultData?.allJobs?.pageResponse?.content ?? [];
        final availableFilters = JobfilterModel.fromJson(
          jsonData['resultData']["All Jobs"] ?? {},
        );
        final userData = availableFilters.userData;

        print('Fetched ${jobs.length} jobs');
        for (var job in jobs) {
          print('Job ID: ${job.id}, Languages: ${job.languages}');
        }

        return {
          'jobs': jobs,
          'availableFilters': availableFilters,
          'userData': userData,
        };
      } else {
        print(
          'Failed to fetch jobs. Status Code: ${response.statusCode}, Response: ${response.body}',
        );
        return {};
      }
    } catch (e) {
      print('Error fetching jobs: $e');
      return {};
    }
  }

  Future<bool> saveFavoriteJob({
    required int userId,
    required int jobId,
  }) async {
    final url = Uri.parse('${GlobalConstants.savefavjob}$userId/$jobId');

    try {
      print('Saving favorite job: userId=$userId, jobId=$jobId');
      final response = await http.post(url);

      if (response.statusCode == 200) {
        print('Favorite job saved successfully');
        return true;
      } else {
        print(
          'Failed to save job. Status Code: ${response.statusCode}, Response: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error saving job: $e');
      return false;
    }
  }

  Future<bool> removeFavoriteJob({required int favId}) async {
    final url = Uri.parse('${GlobalConstants.savefavjob}$favId');

    try {
      print('Removing favorite job: favId=$favId');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        print('Favorite job removed successfully');
        return true;
      } else {
        print(
          'Failed to remove job. Status Code: ${response.statusCode}, Response: ${response.body}',
        );
        return false;
      }
    } catch (e) {
      print('Error removing job: $e');
      return false;
    }
  }
}
