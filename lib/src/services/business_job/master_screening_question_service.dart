import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/business_job/master_screening_question.dart';

class MasterScreeningQuestionService {
  Future<List<MasterScreeningQuestion>> getAllMasterQuestions() async {
    try {
      final response = await http.get(
        Uri.parse(GlobalConstants.getMasterQuestionForScreening),
        headers: {
          'Content-Type': 'application/json',
          // Agar token lagta hai to yahan add karo:
          // 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        final List<dynamic> dataList =
            jsonResponse['resultData']?['data'] ?? [];

        return dataList
            .map((json) => MasterScreeningQuestion.fromJson(json))
            .toList()
            .reversed // Reverses the elements (last becomes first)
            .toList(); // Converts back to a List
      } else {
        throw Exception('Failed to load questions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching master questions: $e');
      rethrow;
    }
  }
}
