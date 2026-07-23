// ignore_for_file: avoid_print

import 'dart:async';

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
}
