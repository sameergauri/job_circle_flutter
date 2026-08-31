import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/business_page/business_home_page_model.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class BusinessCompanyService {
  /// Get My Companies
  Future<List<BusinessCompany>> getMyCompanies() async {
    int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    final uri = Uri.parse('${GlobalConstants.fetchcompanyForHome}$userid');

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final result = BusinessHomeCompanyResponse.fromJson(jsonResponse);

        if (result.resultKey == 'SUCCESS') {
          return result.resultData;
        } else {
          throw Exception(
            result.errorMessage.isNotEmpty
                ? result.errorMessage
                : 'Failed to fetch companies',
          );
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Create / Update Company Payload Endpoint
 Future<int?> saveCompanyPayload({
    required int userId,
    required Map<String, dynamic> body,
    int? companyId,
  }) async {
    final isEdit = companyId != null && companyId != 0;
    final url = isEdit
        ? '${GlobalConstants.createcompanyForHome}$userId?companyId=$companyId'
        : '${GlobalConstants.createcompanyForHome}$userId';
    final uri = Uri.parse(url);

    try {
      final response = isEdit
          ? await http.put(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(body),
            )
          : await http.post(
              uri,
              headers: {'Content-Type': 'application/json'},
              body: json.encode(body),
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['resultKey'] == 'SUCCESS') {
          // Extracts ID from resultData (handles int ID or nested object)
          final resultData = jsonResponse['resultData'];
          if (resultData is Map && resultData['id'] != null) {
            return int.tryParse(resultData['id'].toString());
          } else if (resultData is int) {
            return resultData;
          }
          return companyId ?? 1; // Fallback success indicator
        } else {
          throw Exception(jsonResponse['errorMessage'] ?? 'Operation failed');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
  //===========================================================================================
  //======================= Email & Mobile verification and validation apis ============================
  //===========================================================================================

  Future<bool> sendEmailOtp({
    required String email,
    required String userName,
  }) async {
    final url = Uri.parse(GlobalConstants.emailOTPUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "userName": userName}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> verifyEmailOtp({required String email, required String otp}) async {
    final url = Uri.parse(GlobalConstants.verifyEmailUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );
    return response.statusCode == 200;
  }
  Future<bool> sendMobileOtp({
    required int mobile,
    required String userName,
  }) async {
    final url = Uri.parse(
      GlobalConstants.mobileOTPUrl,
    );
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"mobile": mobile, "userName": userName}),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> verifyMobileOtp({
    required int mobile,
    required String otp,
  }) async {
    final url = Uri.parse(
      GlobalConstants.verifyMobileUrl,
    );
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"mobile": mobile, "otp": otp}),
    );
    return response.statusCode == 200;
  }
}
