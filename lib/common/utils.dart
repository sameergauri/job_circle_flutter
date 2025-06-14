// ignore_for_file: depend_on_referenced_packages
// ignore_for_file: todo

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:job_circle/constants/gobal.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/screens/home.dart';
import 'package:job_circle/screens/onboarding/add_intoduction.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/api_response.dart';

class Utils {
  static final dynamic mimTypes = jsonDecode(
      '{".pdf":"application/pdf", ".jpg":"image/jpeg", ".jpeg":"image/jpeg", ".png": "image/png", ".doc":"application/msword", ".docx":"application/vnd.openxmlformats-officedocument.wordprocessingml.document"}');

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
    var s = pref1.get(key);
    return s;
  }

  static clearAllSharedPreferences() async {
    SharedPreferences pref = await Utils.getSharedPreferences();
    pref.remove(ESharedPreferences.user_data.name);
    pref.remove(ESharedPreferences.user_id.name);
    pref.remove(ESharedPreferences.user_mobile.name);
    pref.remove(ESharedPreferences.user_type.name);
  }

  static clearAllSharedPreference(SharedPreferences? pref, String key) async {
    SharedPreferences pref1 = (pref ?? await Utils.getSharedPreferences());
    return pref1.remove(key);
  }

  static resolveImage(img) {
    return GlobalConstants.ASSET_URL + (img ?? '');
  }

  static getMimType(fileName) {
    var extention = p.extension(fileName);
    return mimTypes[extention];
  }

  static getExtention(fileName) {
    return p.extension(fileName);
  }

  static getFileName(fileName) {
    //fileName = 'cv/IMG_20220412_WA0001_1655577229796.jpg';
    if (fileName == null) return "";
    var fileNamea = "";
    var extention = "";
    try {
      var index = fileName.lastIndexOf("_");
      fileNamea = fileName.substring(fileName.lastIndexOf("/") + 1, index);
      extention = Utils.getExtention(fileName);
      // ignore: empty_catches
    } catch (ex) {}
    return fileNamea + extention;
  }

  static hideLoaderDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static showLoaderDialog(BuildContext context, String message) {
    // const spinkit = SpinKitRotatingCircle(
    //   color: Colors.white,
    //   size: 50.0,
    // );
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(
            color: Constants.darkBlue,
          ),
          Container(
              margin: const EdgeInsets.only(left: 7),
              child: Text(message == "" ? "Loading..." : message)),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showLoaderDialogWithWidget(
      BuildContext context, Widget widget, int timeout) {
    // const spinkit = SpinKitRotatingCircle(
    //   color: Colors.white,
    //   size: 50.0,
    // );
    AlertDialog alert = AlertDialog(content: widget);
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static gotoScreen(
    context,
    data,
    String? primNumber,
  ) async {
    var id =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
         var msg =
        await Utils.getPreferencesValue(null, ESharedPreferences.msg.name);
    
    bool isNew = msg.toString().contains("New User")?true:false;
    int? userid = int.tryParse(id.toString());

    // ignore: unnecessary_null_comparison

    if (userid != null && userid != 0||isNew) {
      if (data['firstName'] == null || data['firstName'] == "") {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AddIntoduction()),
            (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(
            //TODO:: Existing candidate
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, ERoute.login.name, (Route<dynamic> route) => false);
    }
  }

  static void setCacheData(String key, dynamic value) async {
    var prefs = await Utils.getSharedPreferences();

    var userRawData = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_rawData.name);
    var rawdata = jsonDecode(userRawData);
    rawdata[key] = value;
    await Utils.setPreference(
        prefs, ESharedPreferences.user_rawData.name, jsonEncode(rawdata));
  }

  static dynamic getCacheData(String key) async {
    var prefs = await Utils.getSharedPreferences();

    var userRawData = await Utils.getPreferencesValue(
        prefs, ESharedPreferences.user_rawData.name);
    var rawdata = jsonDecode(userRawData);
    return rawdata[key];
  }
}

String convertToTitleCase(String text) {
  // ignore: unnecessary_null_comparison
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
