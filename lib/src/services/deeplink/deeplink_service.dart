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

  /// Initialize Deep Links
  Future<void> initDeepLinks() async {
    // Handle initial link (Cold Start)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      print("Error getting initial link: $e");
    }

    // Listen to new links (when app is in background)
    _appLinks.uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri);
      }
    });
  }

void _handleDeepLink(Uri uri) {
    print("Deep Link Intercepted: $uri");

    // Host aur scheme check strict official standard ke hisab se
    if ((uri.scheme == "https" || uri.scheme == "http") &&
        (uri.host == "jobcircle.co.in" || uri.host == "jobcast.co.in")) {
      // Path parameters check (e.g., /share/JOB-EZ29T7)
      if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'share') {
        final shareCode = uri.pathSegments.last;

        if (shareCode.isNotEmpty && shareCode != 'share') {
          print("Validated Share Code Found: $shareCode");
          _navigateToSharedJob(shareCode);
        }
      }
    }
  }

  Future<void> _navigateToSharedJob(String shareCode) async {
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
      } else {
        print("Invalid share code: $shareCode");
      }
    } catch (e) {
      print("Error navigating to shared job: $e");
    }
  }
}
