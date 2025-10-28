// ignore_for_file: todo
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';

class LoginService {
  Future<Map<String, dynamic>> generateOTP(String mobileNumber) async {
    Uri url = Uri.parse('${GlobalConstants.generateOtp}$mobileNumber');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      var response = await http.post(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("HTTP Error: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      throw Exception("Error in generateOTP: $e");
    }
  }
  Future<Map<String, dynamic>> validateOtp({
    required String mobile,
    required String otp,
  }) async {
    String baseUrl = GlobalConstants.API_Host_one;
    String endpoint = "/api/otp/v1/validate";

    Uri url = Uri.http(baseUrl, endpoint, {"mobile": mobile, "otp": otp});

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  }
}
