// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/model/career_preference_model.dart';

class CareerPreferenceService {
  // -----------------------------
  // FETCH
  // -----------------------------
  static Future<CareerPreferenceModel?> fetchCareerPreference(
    int userId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse("${GlobalConstants.getjobpreferencebyuserid}$userId"),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return CareerPreferenceModel.fromJson(jsonData);
      } else {
        print("Fetch Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Fetch Exception: $e");
      return null;
    }
  }

  // -----------------------------
  // SAVE
  // -----------------------------
  static Future<bool> saveJobPreference(CareerPreferenceModel model) async {
    try {
      final response = await http.post(
        Uri.parse(GlobalConstants.savejobpreference),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toJson()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Save Error: $e");
      return false;
    }
  }

  // -----------------------------
  // UPDATE
  // -----------------------------
  static Future<bool> updateJobPreference(CareerPreferenceModel model) async {
    try {
      final response = await http.put(
        Uri.parse(GlobalConstants.updatejobpreference),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(model.toJsonForUpdate()),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("Update Error: $e");
      return false;
    }
  }

  // -----------------------------
  // DELETE
  // -----------------------------
  static Future<bool> deleteJobPreference(int id) async {
    try {
      final response = await http.delete(
        Uri.parse("${GlobalConstants.deletejobpreferencebyid}$id"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 204) {
        print("Delete Success: ${response.body}");
        return true;
      } else {
        print("Delete Failed: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Delete Error: $e");
      return false;
    }
  }
}
