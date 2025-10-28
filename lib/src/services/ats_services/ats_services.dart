import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/ats/ats_applied_page_model.dart';
import 'package:job_circle/src/model/ats/ats_referal_page_model.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class ATSServices {
  static Future<AppliedJobModel> fetchAppliedJobs() async {
    int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    try {
      final uri = Uri.parse('${GlobalConstants.getAppliedJobDataUrl}$userid');

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return AppliedJobModel.fromJson(jsonData['resultData']);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<ATSReferalPageModel> fetchReferalJobs() async {
    int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    try {
      final uri = Uri.parse('${GlobalConstants.getReferalJobDataUrl}$userid');

      final response = await http.post(uri);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return ATSReferalPageModel.fromJson(jsonData['resultData']);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
