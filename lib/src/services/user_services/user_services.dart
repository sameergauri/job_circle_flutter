// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/model/user_profile/user_model.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class UserServices {
  static Future<ProfileModel> getUserDetailById() async {
    var userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);

    final response = await http.get(
      Uri.parse("${GlobalConstants.getUserDetailUsinguid}$userid"),
    );
    if (response.statusCode == 200) {
      final parsedResponse = json.decode(response.body);
      if (parsedResponse.containsKey("data")) {
        return ProfileModel.fromJson(parsedResponse["data"]);
      } else {
        throw Exception('Failed to load user data');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> postUserInfo(CreateNewUserModel jsonData) async {
    var userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
    final updateJson = CreateNewUserModel(
      certificationsRequest: jsonData.certificationsRequest,
      experienceRequest: jsonData.experienceRequest,
      educationRequest: jsonData.educationRequest,
      userProjectRequest: jsonData.userProjectRequest,
      userRequest: jsonData.userRequest!.copyWith(userId: userid),
    );
    String apiUrl = GlobalConstants.postAndUpdateUser;
    // var token = SharedPrefsHelper.getString(ESharedPreferences.user_token);

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': token, // <-- add token if required
        },
        body: json.encode(updateJson), // <-- important
      );

      if (response.statusCode == 200) {
        print("Data posted successfully ✅");
        print(response.body);
        return true;
      } else {
        print("Error: ${response.statusCode}");
        print(response. body);
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  static Future<bool> DeleteExpEduCertProj(int id, String type) async {
    String apiUrl = '${GlobalConstants.deletUserExpEduCerPro}$id&type=$type';
    try {
      var response = await http.delete(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        print("$type deleted successfully ✅");
        print(response.body);
        return true;
      } else {
        print("Error: ${response.statusCode}");
        print(response.body);
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
