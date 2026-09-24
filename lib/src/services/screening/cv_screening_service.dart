import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/screening/cv_match_response_model.dart';
import 'package:job_circle/src/model/screening/user_job_compo_model.dart';

class CvScreeningService {
  // Step 1: Upload multipart file to extract data
  Future<CvExtractResponse> extractCvData(String filePath) async {
    final uri = Uri.parse(GlobalConstants.extract_cv_for_screening);
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({'Accept': '*/*'});
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return CvExtractResponse.fromJson(body);
    } else {
      throw Exception(
        'Failed to extract CV details. Code: ${response.statusCode}',
      );
    }
  }

  // Active Jobs API for Selection
  Future<ActiveJobsResponse> getActiveJobs() async {
    final uri = Uri.parse(GlobalConstants.get_list_of_active_jobs);
    final response = await http.get(uri, headers: {'Accept': '*/*'});

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return ActiveJobsResponse.fromJson(body);
    } else {
      throw Exception(
        'Failed to fetch active jobs. Code: ${response.statusCode}',
      );
    }
  }

  // Step 2: Post verified/edited JSON to fetch matched recommendations
  Future<CvMatchResponse> getRecommendations(CvProfileData profile) async {
    final uri = Uri.parse(GlobalConstants.get_reccomended_job_for_screening);
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return CvMatchResponse.fromJson(body);
    } else {
      throw Exception(
        'Failed to get job recommendations. Code: ${response.statusCode}',
      );
    }
  }

  // Recompute Recommendations API (POST /api/v1/recommendations/recompute/user/{userId}/jobs)
  Future<RecomputeRecommendationResponse> recomputeUserJobs({
    required int userId,
    required List<int> jobIds,
  }) async {
    final uri = Uri.parse('${GlobalConstants.recompute_user_jobs}$userId/jobs');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json', 'Accept': '*/*'},
      body: jsonEncode(jobIds), // Request body: [329, ...]
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return RecomputeRecommendationResponse.fromJson(body);
    } else {
      throw Exception(
        'Failed to recompute jobs. Status: ${response.statusCode}, Body: ${response.body}',
      );
    }
  }
}
