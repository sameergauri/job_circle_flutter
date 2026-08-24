import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/business_ats/business_ats_model.dart';
import 'package:job_circle/src/model/business_ats/update_ats_model.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class AtsService {
  Future<AtsResponseModel> fetchAtsData() async {
    int userId = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    final url = Uri.parse('${GlobalConstants.fetchBusinessATSData}$userId');

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AtsResponseModel.fromJson(data);
      } else {
        throw Exception('Failed to load ATS data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching ATS data: $e');
    }
  }
 Future<void> updateLead(UpdateAtsModel leadModel, int leadId) async {
    final String url = "${GlobalConstants.updateatsurl}$leadId";

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(leadModel.toJson()), // Convert model to JSON
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // ✅ Success Response
      print("Lead updated successfully: ${jsonDecode(response.body)}");
    } else {
      // ❌ Error Response - must throw so the caller doesn't treat this as success
      throw Exception(
        'Failed to update lead. Status Code: ${response.statusCode}. ${response.body}',
      );
    }
  }
}
