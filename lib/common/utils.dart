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

  static setPreference(String key, dynamic value) async{
    SharedPreferences pref = await Utils.getSharedPreferences();
    switch (value.runtimeType) {
      case String:
        pref.setString(key, value);
        break;
      case bool:
        pref.setBool(key, value);
        break;
      case int:
        pref.setInt(key, value);
        break;
      case double:
        pref.setDouble(key, value);
        break;
      default:
    }
  }

  static dynamic getPreferencesValue(String key) async {
    SharedPreferences pref = await Utils.getSharedPreferences();
    return pref.get(key);
  }
}
