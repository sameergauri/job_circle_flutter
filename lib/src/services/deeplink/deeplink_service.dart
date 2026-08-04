// ignore_for_file: avoid_print

// ignore_for_file: avoid_print

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/screen/Jobs/job_detail_page.dart';
import 'package:job_circle/src/screen/digi_locker/come_back_from_digilocker.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/services/referal_and_apply/add_resume_and_apply_services.dart';

// DigiLocker result screen (jab banaoge to uncomment kar dena)
// import 'package:job_circle/src/screen/digilocker/digilocker_result_screen.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();

  // Share code ke liye (original)
  String? pendingShareCode;

  // DigiLocker ke liye (new)
  String? digilockerStatus;
  String? digilockerUserId;

  Future<void> initDeepLinks() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      print("Error getting initial link: $e");
    }

    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri, isFromBackground: true);
      }
    });
  }

  void _handleDeepLink(Uri uri, {bool isFromBackground = false}) {
    print("Deep Link received → $uri");

    // ============================================
    // 1. DigiLocker Verification Deep Link (NEW)
    // ============================================
    if (uri.scheme == "jobcircle" && uri.host == "verification") {
      digilockerStatus = uri.queryParameters['status']; // SUCCESS / FAILED
      digilockerUserId = uri.queryParameters['userId'];

      print(
        "DigiLocker → status: $digilockerStatus | userId: $digilockerUserId",
      );

      if (isFromBackground && digilockerStatus != null) {
        navigateToDigiLockerResult();
      }
      return;
    }

    // ============================================
    // 2. Existing Share Deep Link (ORIGINAL - same as before)
    // ============================================
    if ((uri.scheme == "https" || uri.scheme == "http") &&
        (uri.host == "jobcircle.co.in" || uri.host == "jobcast.co.in")) {
      if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'share') {
        final shareCode = uri.pathSegments.last;

        if (shareCode.isNotEmpty && shareCode != 'share') {
          pendingShareCode = shareCode;

          // Agar app already background me chal raha tha
          if (isFromBackground) {
            // Aap chahein toh yahan turant navigate kar sakte hain
            // navigateToSharedJob(shareCode);
          }
        }
      }
    }
  }

  // ============================================
  // DigiLocker Result Navigation
  // ============================================
  void navigateToDigiLockerResult() {
    NavigationService.push(
      ComeBackFromDigiLocker(
        status: digilockerStatus ?? "",
        userid: digilockerUserId ?? "",
      ),
    );

    // Yahan apni DigiLocker Result screen pe navigate karo
    /*
    NavigationService.push(
      DigiLockerResultScreen(
        status: digilockerStatus!,
        userId: digilockerUserId ?? "",
      ),
    );
    */

    // Clear after use
    digilockerStatus = null;
    digilockerUserId = null;
  }

  // Public method - Splash/Home pe call kar sakte ho
  void handleDigiLockerResultIfPending() {
    if (digilockerStatus != null) {
      navigateToDigiLockerResult();
    }
  }

  // ============================================
  // Existing Share method (ORIGINAL - bilkul same)
  // ============================================
  Future<void> navigateToSharedJob(String shareCode) async {
    try {
      final result = await AddResumeAndApplyService.validateShareCode(
        shareCode,
      );

      if (result['success'] == true) {
        NavigationService.push(
          JobDetailPage(
            jobId: result['jobId'],
            referrerUserId: result['sharerUserId'],
            fromWhere: FromWhere.homePage,
            resume: "",
          ),
        );
      }
    } catch (e) {
      print("Error navigating to shared job: $e");
    }
  }
}

/* import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/screen/Jobs/job_detail_page.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/services/referal_and_apply/add_resume_and_apply_services.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();

  // Is variable me hum code store rakhenge
  String? pendingShareCode;

  Future<void> initDeepLinks() async {
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _extractShareCode(initialUri);
      }
    } catch (e) {
      print("Error getting initial link: $e");
    }

    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _extractShareCode(uri, isFromBackground: true);
      }
    });
  }

  void _extractShareCode(Uri uri, {bool isFromBackground = false}) {
    if ((uri.scheme == "https" || uri.scheme == "http") &&
        (uri.host == "jobcircle.co.in" || uri.host == "jobcast.co.in")) {
      if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'share') {
        final shareCode = uri.pathSegments.last;

        if (shareCode.isNotEmpty && shareCode != 'share') {
          pendingShareCode = shareCode;

          // Agar app already background me chal raha tha aur user home page par hi tha,
          // toh hum manually check karke turant trigger kar sakte hain.
          if (isFromBackground) {
            // Aap chahein toh ek chota check laga sakte hain, par abhi ke liye ise sirf save rehne dein
            // Taaki double trigger bilkul khatam ho jaye.
          }
        }
      }
    }
  }

  // Underscore '_' hata kar isko public rakha hai
  Future<void> navigateToSharedJob(String shareCode) async {
    try {
      final result = await AddResumeAndApplyService.validateShareCode(
        shareCode,
      );

      if (result['success'] == true) {
        NavigationService.push(
          JobDetailPage(
            jobId: result['jobId'],
            referrerUserId: result['sharerUserId'],
            fromWhere: FromWhere.homePage,
            resume: "",
          ),
        );
      }
    } catch (e) {
      print("Error navigating to shared job: $e");
    }
  }
} */
