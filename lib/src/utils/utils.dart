// ignore_for_file: depend_on_referenced_packages, type_literal_in_constant_pattern, prefer_const_constructors, unnecessary_null_comparison, strict_top_level_inference
// ignore_for_file: todo

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/screen/home_page.dart';
import 'package:job_circle/src/screen/login_and_signup/login/login.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/signup_resume_parse_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:provider/provider.dart';

class Utils {
  static final dynamic mimTypes = jsonDecode(
    '{".pdf":"application/pdf", ".jpg":"image/jpeg", ".jpeg":"image/jpeg", ".png": "image/png", ".doc":"application/msword", ".docx":"application/vnd.openxmlformats-officedocument.wordprocessingml.document"}',
  );

  static showLoaderDialog(BuildContext context, String message) {
    // const spinkit = SpinKitRotatingCircle(
    //   color: Colors.white,
    //   size: 50.0,
    // );
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(color: Constants.darkBlue),
          Container(
            margin: const EdgeInsets.only(left: 7),
            child: Text(message == "" ? "Loading..." : message),
          ),
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
    BuildContext context,
    Widget widget,
    int timeout,
  ) {
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

  static gotoScreen({
    required String firstname,
    required int? empid,
    required int usertype,
    required String msg,
    required String from,
    required BuildContext context, // 👈 identify caller (splash / otp)
  }) {
    final provider = Provider.of<JobProvider>(context, listen: false);
    bool isNew = msg.toLowerCase().contains("new user");

    if (from == "splash") {
      // ✅ Splash screen logic
      if (empid == null || empid == 0) {
        NavigationService.pushAndRemoveUntil(LoginPage());
      } else {
        provider.fetchJobs(applyCityFilter: true);
        NavigationService.pushAndRemoveUntil(HomeScreen());
      }
    } else if (from == "otp") {
      // ✅ OTP validation logic
      if (isNew) {
        NavigationService.pushAndRemoveUntil(ResumeParsePage());
      } else {
        provider.fetchJobs(applyCityFilter: false);
        NavigationService.pushAndRemoveUntil(HomeScreen());
      }
    }
  }

  static parseResponse(void res) {}
}

String convertToTitleCase(String text) {
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
