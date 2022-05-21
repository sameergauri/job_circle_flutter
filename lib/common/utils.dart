import 'dart:convert';
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
}
