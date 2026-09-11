// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/job_model/job_filter_model.dart';
import 'package:job_circle/src/model/job_model/job_home_page_model.dart';

class JobServices {
  Future<Map<String, dynamic>> fetchJobs({
    required bool applyCityFilter,
    // String? selectedCity,
    required String userId,
  }) async {
    String userid = userId;

    final queryParams = {
      'pageNumber': '1',
      'pageSize': '1000',
      'userId': userid.toString(),
    };

    /*   if (applyCityFilter && selectedCity != null && selectedCity.isNotEmpty) {  // selectedCity passed from outside
      queryParams['cities'] = selectedCity;
    } */

    Uri url = Uri.parse(
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

  /* Future<RecommendJobModel?> fetchRecomendJob(int userId,) async { 
    var locaton = SharedPrefsHelper.getString(
      ESharedPreferences.user_selected_lcoation,
    );
    final url = Uri.parse(
      "${GlobalConstants.recomendedJobUrl}$userId/jobs?locations=$locaton",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return RecommendJobModel.fromJson(jsonData);
      } else {
        print("❌ Failed to load data. Status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error fetching job recommendations: $e");
      return null;
    }
  } */
  // Nayi API se recommended job IDs fetch karne ka logic
  Future<List<int>> fetchRecommendedJobIds({
    required String userId,
    int page = 0,
    int size = 20,
    int minScore = 30,
  }) async {
    final queryParams = {
      'userId': userId,
      'page': page.toString(),
      'size': size.toString(),
      'minScore': minScore.toString(),
    };

    // Note: GlobalConstants me base URL check kar lein
    // e.g., 'http://localhost:9090/api/v1/recommendations/jobs' ya IP address
    final uri = Uri.parse(
      GlobalConstants.fetchNewRecmendJob,
    ).replace(queryParameters: queryParams);

    print('Fetching recommended job IDs: $uri');

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final List content = jsonData['resultData']?['content'] ?? [];

        // Response se saari jobId extract kar ke int list banana
        final List<int> jobIds = content
            .map<int?>((item) => item['jobId'] as int?)
            .whereType<int>()
            .toList();

        return jobIds;
      } else {
        print('Failed to fetch recommendations: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching recommended job IDs: $e');
      return [];
    }
  }

  // AI Settings check karne ka method
  Future<bool> checkAiSettings() async {
    final url = Uri.parse(GlobalConstants.checkAISettig);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final bool isOverallEnabled =
            jsonData['resultData']?['overAllEnable'] ?? false;
        print('AI Settings overAllEnable: $isOverallEnabled');
        return isOverallEnabled;
      }
      return false;
    } catch (e) {
      print('Error checking AI settings: $e');
      return false;
    }
  }
}
