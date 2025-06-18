import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/models/view_and_generate_model.dart';

class JoinersService {
  Future<JoinersResponseModel?> fetchJoinersData() async {
    var userid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    final String url =
        'http://${GlobalConstants.API_Host_one}/leads/v1/getRefrralsCandidates?referralId=$userid';

    try {
      final response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonBody = jsonDecode(response.body);
        return JoinersResponseModel.fromJson(jsonBody);
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return null;
  }
}
