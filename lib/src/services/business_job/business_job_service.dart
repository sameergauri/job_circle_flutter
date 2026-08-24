import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/business_job/business_job_model.dart';
import 'package:job_circle/src/model/job_responsibility_model.dart';
import 'package:job_circle/src/model/location_model.dart';

class BusinessJobService {
  /// Create Job API
  Future<bool> createJob({
    required int userId,
    required BusinessJobPostModel jobData,
  }) async {
    final uri = Uri.parse(
      GlobalConstants.jobPostApiUrl,
    ).replace(queryParameters: {'userId': userId.toString()});

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jobData.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to post job: ${response.body}');
    }
  }

  /// Update Job API
  Future<bool> updateJob({
    required int jobId,
    required int userId,
    required BusinessJobPostModel jobData,
  }) async {
    final uri = Uri.parse(
      '${GlobalConstants.jobUpdateApiUrl}$jobId',
    ).replace(queryParameters: {'userId': userId.toString()});

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jobData.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to update job: ${response.body}');
    }
  }

  /// Generic Master Data Fetch by Group
  Future<List<String>> fetchMasterByGroup(String groupName) async {
    final url =
        'http://${GlobalConstants.API_Host_one}/master/v1/getByGroup?groupName=$groupName&pageNumber=1&pageSize=100';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> content = data['resultData']['content'];
      final Set<String> uniqueValues = {};
      final emojiRegex = RegExp(
        r'[\u{1F300}-\u{1F6FF}|\u{1F900}-\u{1F9FF}|\u{1F1E0}-\u{1F1FF}|\u{2600}-\u{26FF}|\u{2700}-\u{27BF}]',
        unicode: true,
      );
      for (var entry in content) {
        String? val = entry['value']?.toString();
        if (val != null) {
          String cleaned = val.replaceAll(emojiRegex, '').trim();
          if (cleaned.isNotEmpty) {
            uniqueValues.add(cleaned);
          }
        }
      }
      return uniqueValues.toList();
    } else {
      throw Exception('Failed to fetch group $groupName');
    }
  }

  /// Fetch Skills Master Data
  Future<List<String>> fetchMasterSkills() async {
    final url =
        '${GlobalConstants.fetchmasterdatasuggestionurl}Skills&pageNumber=1&pageSize=1000';
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> content = data['resultData']["masterData"]['content'];
      final Set<String> uniqueValues = {};

      for (var entry in content) {
        String? val = entry['value']?.toString();
        if (val != null) uniqueValues.add(val);
      }
      return uniqueValues.toList();
    } else {
      throw Exception('Failed to fetch skills');
    }
  }

  /// Fetch Certificates Master Data
  Future<List<CertificateModel>> fetchMasterCertificates() async {
    final url =
        '${GlobalConstants.fetchmasterdatasuggestionurl}certificate&pageNumber=1&pageSize=1000';
    final response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> content = data['resultData']["masterData"]['content'];
      final List<CertificateModel> certificates = [];
      final Set<int> uniqueIds = {};

      for (var entry in content) {
        int? id = entry['id'];
        String? val = entry['value']?.toString();
        if (id != null && val != null && !uniqueIds.contains(id)) {
          uniqueIds.add(id);
          certificates.add(CertificateModel(id: id, value: val));
        }
      }
      return certificates;
    } else {
      throw Exception('Failed to fetch certificates');
    }
  }

  /// Generate Responsibilities & AI Skills using AI
  Future<ResponsibilityAiModel?> generateResponsibilitiesUsingAI({
    required String industry,
    required String jobTitle,
    required String levelOfHiring,
  }) async {
    final url = Uri.parse(GlobalConstants.generateResponsibilityUsingAiUrl);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "industry": industry,
          "jobTitle": jobTitle,
          "levelOfHiring": levelOfHiring,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ResponsibilityAiModel.fromJson(data);
      } else {
        throw Exception(
          "Failed to generate responsibilities: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error generating responsibilities: $e");
    }
  }

  /// Generate Job Summary using AI
  Future<String?> generateJobSummaryUsingAI({
    required List<String> responsibilities,
  }) async {
    final url = Uri.parse(GlobalConstants.generateSummaryUsingAiUrl);

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"responsibilities": responsibilities}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Returns summary string from response
        return data['resultData']?['summary'] ?? data['summary'];
      } else {
        throw Exception(
          "Failed to generate job summary: ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception("Error generating job summary: $e");
    }
  }

  /// Fetch Single Job Detail by Job ID
  Future<BusinessJobPostModel?> getJobDetailById(int jobId) async {
    final url = '${GlobalConstants.fetchbusinessJobDetailUrl}$jobId';
    // If running on an Android emulator, use 10.0.2.2 instead of localhost:
    // final url = 'http://10.0.2.2:9090/api/v1/jobseeker/jobs/$jobId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final result = BusinessJobDetailResponse.fromJson(jsonResponse);

        if (result.resultKey == 'SUCCESS' && result.jobData != null) {
          return result.jobData;
        } else {
          throw Exception(
            result.errorMessage.isNotEmpty
                ? result.errorMessage
                : "Failed to load job details",
          );
        }
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching job details: $e");
    }
  }
  Future<void> closeJob(int id) async {
    final url = Uri.parse("${GlobalConstants.closeJob}$id");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json", // Set the content type to JSON
        },
      );

      // Check the response status code
      if (response.statusCode == 200) {
        jsonDecode(response.body);
      } else {
        print("Failed to save job post. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error saving job post: $e");
    }
  }
}
