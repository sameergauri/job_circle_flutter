// ignore_for_file: avoid_print, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/job_responsibility_model.dart';
import 'package:job_circle/src/model/user_profile/cv_parse_model.dart';
import 'package:job_circle/src/model/user_profile/onboarding_cv_parse_model.dart';
import 'package:job_circle/src/model/user_profile/refer_cv_parse_model.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class ResumeService {
  static Future<CvParseModel> uploadPdfAndGetData(File pdfFile) async {
    final url = Uri.parse(GlobalConstants.parsecvurl);

    var request = http.MultipartRequest("POST", url);

    // Add PDF file
    request.files.add(await http.MultipartFile.fromPath("file", pdfFile.path));

    // Send request
    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);

      // ✅ Model me convert karke return
      return CvParseModel.fromJson(data);
    } else {
      throw Exception("❌ Failed: ${response.statusCode}");
    }
  }

  static Future<OnBoardCvParseModel> onboardingCvParse({
    required File pdfFile,
    String? contactno,
  }) async {
    String contact =
        contactno ??
        SharedPrefsHelper.getInt(ESharedPreferences.user_mobile).toString();
    final url = Uri.parse(GlobalConstants.onboardingparsecvProurl);

    var request = http.MultipartRequest("POST", url);

    // ✅ Add async field
    request.fields['async'] = 'false'; // or 'true' depending on your need

    // ✅ Add mobile field (required per Swagger)
    request.fields['mobile'] = contact;

    // ✅ Add PDF file (field name must match what API expects, here it's "file")
    request.files.add(
      await http.MultipartFile.fromPath(
        "file", // must be exactly "file" (confirm with API docs if needed)
        pdfFile.path,
        contentType: MediaType(
          'application',
          'pdf',
        ), // <-- important for some APIs
      ),
    );

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      dynamic decoded;
      try {
        decoded = jsonDecode(respStr);
      } catch (_) {
        decoded = null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(respStr);
        return OnBoardCvParseModel.fromJson(data);
      } else {
        // Extract readable message
        final errorMessage =
            decoded?['message'] ?? 'Something went wrong, please try again.';

        throw Exception(errorMessage); // 👈 throw the actual message
      }
    } catch (e, stack) {
      throw Exception("❌ Exception while calling API: $e\nStack: $stack");
    }
  }

  static Future<ReferResumeParseModel> referAddResumeCVParsing({
    required File pdfFile,
  }) async {
    final url = Uri.parse(GlobalConstants.referAndAddResumeParseUrl);

    var request = http.MultipartRequest("POST", url);

    /*  // ✅ Add async field
    request.fields['async'] = 'false'; // or 'true' depending on your need */

    // ✅ Add PDF file (field name must match what API expects, here it's "file")
    request.files.add(
      await http.MultipartFile.fromPath(
        "file", // must be exactly "file" (confirm with API docs if needed)
        pdfFile.path,
        contentType: MediaType(
          'application',
          'pdf',
        ), // <-- important for some APIs
      ),
    );

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      dynamic decoded;
      try {
        decoded = jsonDecode(respStr);
      } catch (_) {
        decoded = null;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(respStr);
        return ReferResumeParseModel.fromJson(data);
      } else {
        // Extract readable message
        final errorMessage =
            decoded?['message'] ?? 'Something went wrong, please try again.';

        throw Exception(errorMessage); // 👈 throw the actual message
      }
    } catch (e, stack) {
      throw Exception("❌ Exception while calling API: $e\nStack: $stack");
    }
  }

  static Future<ResponsibilityAiModel?> generateResponsibilitiesUsingAI({
    required String functionalArea,
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
          'functionalArea': functionalArea,
          "industry": industry,
          "jobTitle": jobTitle,
          "levelOfHiring": levelOfHiring,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ResponsibilityAiModel.fromJson(data);
      } else {
        print(
          "Failed to generate responsibilities. Status: ${response.statusCode}",
        );
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error generating responsibilities: $e");
    }

    return null;
  }

  static Future<ProfileSummaryModel?> generateSummaryUsingAi() async {
    int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    final url = Uri.parse('${GlobalConstants.genereteSummaryUsingAI}$userid');

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return ProfileSummaryModel.fromJson(data);
      } else {
        print(
          "Failed to generate responsibilities. Status: ${response.statusCode}",
        );
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error generating responsibilities: $e");
    }

    return null;
  }
}
