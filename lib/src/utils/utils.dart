// ignore_for_file: avoid_print, depend_on_referenced_packages, type_literal_in_constant_pattern, prefer_const_constructors, unnecessary_null_comparison, strict_top_level_inference
// ignore_for_file: todo

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/provider/career_preference_provider.dart';
import 'package:job_circle/src/provider/job_provider/job_page_provider.dart';
import 'package:job_circle/src/screen/home_page.dart';
import 'package:job_circle/src/screen/login_and_signup/login/login.dart';
import 'package:job_circle/src/screen/login_and_signup/signup/signup_resume_parse_page.dart';
import 'package:job_circle/src/services/deeplink/deeplink_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/stream_config.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat/stream_chat.dart';

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
  }) async {
    final provider = Provider.of<JobProvider>(context, listen: false);
    var usercontact = SharedPrefsHelper.getInt(ESharedPreferences.user_mobile);
    bool isNew = msg.toLowerCase().contains("new user");

    // --- HELPER FUNCTION TO CONNECT CHAT SAFELY ---
    Future<void> connectChatSafely() async {
      try {
        final client = StreamConfig.client;

        // Check if already connected to avoid errors
        if (client.wsConnectionStatus == ConnectionStatus.connected) {
          // Already connected, do nothing
          return;
        }

        // Agar user id valid hai tabhi connect karo
        if (usercontact != 0) {
          await client.connectUser(
            User(id: usercontact.toString(), name: firstname),
            client.devToken(usercontact.toString()).rawValue,
          );
        }
      } catch (e) {
        print("⚠️ Chat Connection Failed: $e");
        // Error ignore kar rahe hain taaki App na ruke
      }
    }
    // ---------------------------------------------

    // --- HELPER FUNCTION FOR DEEP LINK ROUTING ---
    void checkAndTriggerDeepLink() {
      // ============================================
      // 1. Share Deep Link (existing)
      // ============================================
      if (DeepLinkService().pendingShareCode != null) {
        final code = DeepLinkService().pendingShareCode!;

        // Pehle hi null kar do taaki koi aur widget isko dubara read na kare
        DeepLinkService().pendingShareCode = null;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          // Thoda delay badha kar 500ms kar do taaki HomeScreen poori tarah load ho kar shant ho jaye
          await Future.delayed(const Duration(milliseconds: 500));
          DeepLinkService().navigateToSharedJob(code);
        });
      }
      // ============================================
      // 2. DigiLocker Deep Link (new)
      // ============================================
      if (DeepLinkService().digilockerStatus != null) {
        final status = DeepLinkService().digilockerStatus!;
        final userId = DeepLinkService().digilockerUserId ?? "";

        // Clear immediately
        DeepLinkService().digilockerStatus = null;
        DeepLinkService().digilockerUserId = null;

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(const Duration(milliseconds: 500));
          // Yahan DigiLocker Result screen pe navigate karo
          // Example:
          /*
          NavigationService.push(
          DigiLockerResultScreen(
          status: status,
          userId: userId,
        ),
      );
          */
          // Temporary (jab tak Result screen nahi bani)
          print("DigiLocker Result → status: $status | userId: $userId");
        });
      }
    }
    // ---------------------------------------------

    if (from == "splash") {
      // ✅ Splash screen logic
      if (empid == null || empid == 0) {
        NavigationService.pushAndRemoveUntil(LoginPage());
      } else {
        provider.fetchJobs(
          applyCityFilter: true,
        ); // fetch jobs with city filter
        context.read<CareerPreferenceProvider>().fetchCareerPreference(
          true,
        ); // to check that career preference is set or not
        // 🔴 Safe Connection Call for chat
        await connectChatSafely();
        // Navigate to Home Screen
        NavigationService.pushAndRemoveUntil(HomeScreen());
        // 2. Ab check karo aur deep link screen push karo
        checkAndTriggerDeepLink();
      }
    } else if (from == "otp") {
      // ✅ OTP validation logic
      if (isNew) {
        NavigationService.pushAndRemoveUntil(ResumeParsePage());
      } else {
        provider.fetchJobs(
          applyCityFilter: false,
        ); // fetch jobs with city filter
        context.read<CareerPreferenceProvider>().fetchCareerPreference(
          true,
        ); // to check that career preference is set or not
        // 🔴 Safe Connection Call for chat
        await connectChatSafely();
        // Navigate to Home Screen
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
