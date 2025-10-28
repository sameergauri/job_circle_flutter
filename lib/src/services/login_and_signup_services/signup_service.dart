// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:job_circle/global.dart';
import 'package:job_circle/src/constants/custom_snackbar.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/model/user_profile/create_user_model.dart';
import 'package:job_circle/src/screen/home_page.dart';
import 'package:job_circle/src/services/cache_clear_and_app_version/cache_clear_and_app_version_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';

class SignupService {
  static Future<bool> saveUserData(
    CreateNewUserModel requestBody,
    String token,
  ) async {
    String url = GlobalConstants.postAndUpdateUser + token;

    try {
      // Headers
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

      // Make the POST request
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      // Handle the response
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("User data saved successfully!");

        print("Response: ${response.body}");
        final parsedResponse = json.decode(response.body);
        print("User Body:$parsedResponse");

        final userData = parsedResponse['data'];

        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_mobile,
          userData['mobile'] ?? 0,
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_id,
          userData['id'] ?? 0,
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_firstName,
          userData['firstName'] ?? '',
        );
        /*  await SharedPrefsHelper.setPreference(
          ESharedPreferences.role,
          userData['role'] ?? 0,
        );
        await SharedPrefsHelper.setPreference(
          ESharedPreferences.user_type,
          userData['usertype'] ?? 0,
        ); */
        await CacheClearAppVersionService.clearCache();
        NavigationService.pushAndRemoveUntil(HomeScreen());
        return true; // ✅ success
      } else {
        print(requestBody);
        CustomSnackbar.show(
          'Error code : ${response.statusCode} Response : ${response.body}',
          true,
        );
        return false; // ❌ failure
      }
    } catch (e) {
      CustomSnackbar.show('Error $e', true);
      return false; // ❌ failure on exception
    }
  }
}
