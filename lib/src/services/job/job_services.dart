// ignore_for_file: avoid_print, unnecessary_null_comparison

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_model/job_filter_model.dart';
import 'package:job_circle/src/model/job_model/job_home_page_model.dart';
import 'package:job_circle/src/model/job_model/recommend_job_model.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class JobServices {
  Future<Map<String, dynamic>> fetchJobs({
    required bool applyCityFilter,
    // String? selectedCity,
    required String userId,
  }) async {
    final userid = userId;

    final queryParams = {
      'pageNumber': '1',
      'pageSize': '1000',
      'userId': userid.toString(),
    };

    /*   if (applyCityFilter && selectedCity != null && selectedCity.isNotEmpty) {  // selectedCity passed from outside
      queryParams['cities'] = selectedCity;
    } */

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
  Future<RecommendJobModel?> fetchRecomendJob({
    required int userId,
    List<String>? locations, // e.g., ["Thane", "Mumbai"]
    List<String>? industries, // e.g., ["Insurance", "BPO"]
    List<String>? workTypes, // e.g., ["Hybrid", "Remote"]
    String? salaryMin, // e.g., "100000"
    String? salaryMax, // e.g., "200000"
  }) async {
    // 1. Base URL creation
    // Result: .../api/v1/recommendations/users/1885/jobs
    String baseUrl = "${GlobalConstants.recomendedJobUrl}$userId/jobs";

    // 2. Prepare Query Parameters map
    Map<String, String> queryParams = {};

    // Add Locations (Join with ", " if list is not empty)
    if (locations != null && locations.isNotEmpty) {
      queryParams['locations'] = locations.join(', ');
    } else {
      // Fallback: Use SharedPrefs if no specific location passed
      var defaultLocation = SharedPrefsHelper.getString(
        ESharedPreferences.user_selected_lcoation,
      );
      if (defaultLocation != null && defaultLocation.isNotEmpty) {
        queryParams['locations'] = defaultLocation;
      }
    }

    // Add Industries
    if (industries != null && industries.isNotEmpty) {
      queryParams['industries'] = industries.join(', ');
    }

    // Add Work Types
    if (workTypes != null && workTypes.isNotEmpty) {
      queryParams['workType'] = workTypes.join(', ');
    }

    // Add Salary Range (Format: "min - max")
    if (salaryMin != null && salaryMax != null) {
      queryParams['salaryRange'] = "$salaryMin - $salaryMax";
    }

    // 3. Create the Final URI
    // Uri.parse handles the encoding (turning spaces into %20, commas into %2C)
    final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

    print("🚀 Calling API: $uri"); // Debug print to verify the URL

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        return RecommendJobModel.fromJson(jsonData);
      } else {
        print("❌ Failed to load data. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("⚠️ Error fetching job recommendations: $e");
      return null;
    }
  }
}
