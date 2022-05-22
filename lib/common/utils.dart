import 'dart:convert';
import 'package:job_circle/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';

class Utils {
  static RequestResult parseResponse(response) {
    Map resultData = jsonDecode(response.body);
    return RequestResult(resultData["code"], resultData["resultKey"],
        resultData["errorMessage"], resultData["resultData"]);
  }

  static getSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  static setPreference(
      SharedPreferences? pref, String key, dynamic value) async {
    SharedPreferences pref1 = (pref ?? await Utils.getSharedPreferences());
    switch (value.runtimeType) {
      case String:
        pref1.setString(key, value);
        break;
      case bool:
        pref1.setBool(key, value);
        break;
      case int:
        pref1.setInt(key, value);
        break;
      case double:
        pref1.setDouble(key, value);
        break;
      default:
    }
  }

  static dynamic getPreferencesValue(
      SharedPreferences? pref, String key) async {
    SharedPreferences pref1 = (pref ?? await Utils.getSharedPreferences());
    return pref1.get(key);
  }

  static clearAllSharedPreference() async {
    SharedPreferences pref = await Utils.getSharedPreferences();
    pref.remove(ESharedPreferences.user_data.name);
    pref.remove(ESharedPreferences.user_id.name);
    pref.remove(ESharedPreferences.user_mobile.name);
    pref.remove(ESharedPreferences.user_type.name);
  }
}

String convertToTitleCase(String text) {
  if (text == null) {
    return "";
  }

  if (text.length <= 1) {
    return text.toUpperCase();
  }

  // Split string into multiple words
  final List<String> words = text.split(' ');

  // Capitalize first letter of each words
  final capitalizedWords = words.map((word) {
    if (word.trim().isNotEmpty) {
      final String firstLetter = word.trim().substring(0, 1).toUpperCase();
      final String remainingLetters = word.trim().substring(1);

      return '$firstLetter$remainingLetters';
    }
    return '';
  });

  // Join/Merge all words back to one String
  return capitalizedWords.join(' ');
}

extension CapitalizedStringExtension on String {
  String toTitleCase() {
    return convertToTitleCase(this);
  }
}
