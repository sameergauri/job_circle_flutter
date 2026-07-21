import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job_circle/main.dart';
import 'package:job_circle/src/constants/theme_color_as_per_theme.dart';
import 'package:job_circle/src/provider/app_theme_provider.dart/app_theme_provider.dart';
import 'package:job_circle/src/screen/splash_screen.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/stream_config.dart';
import 'package:job_circle/web/web_job_apply_form.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 🌟 CROSS-PLATFORM SAFE EXTRACTION (NO DART:HTML NEEDED)
  String _getWebShareCode() {
    if (!kIsWeb) return "";
    try {
      final Uri uri = Uri.base;

      // 1. Direct browser string check (Sabse safe tarika path parameters ke liye)
      final String fullPath = uri.toString();
      if (fullPath.contains('/share/')) {
        final parts = fullPath.split('/share/');
        if (parts.length > 1 && parts[1].isNotEmpty) {
          // Agar URL me query parameters hain (?code=), toh unhe alag karo
          final cleanCode = parts[1].split('?').first;
          if (cleanCode.trim().isNotEmpty) {
            return cleanCode;
          }
        }
      }

      // 2. Fallback check path segments ke liye
      if (uri.pathSegments.isNotEmpty) {
        // Agar 'share' ke baad koi segment hai
        final shareIndex = uri.pathSegments.indexOf('share');
        if (shareIndex != -1 && shareIndex + 1 < uri.pathSegments.length) {
          return uri.pathSegments[shareIndex + 1];
        }
        // Agar 'share' segment list me nahi hai par last segment hi aapka code hai
        return uri.pathSegments.last;
      }

      // 3. Fallback check query parameter ke liye
      if (uri.queryParameters.containsKey('code')) {
        return uri.queryParameters['code'] ?? "";
      }
    } catch (e) {
      debugPrint("Error fetching web url parameter: $e");
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final String extractedCode = _getWebShareCode();
    return MaterialApp(
      builder: (context, child) {
        return StreamChat(
          client: StreamConfig.client,
          child: SafeArea(top: false, bottom: true, child: child!),
        );
      },
      scaffoldMessengerKey: scaffoldMessengerKey,
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Job Circle',
      themeMode:
          themeProvider.themeMode, // Yaha se control hoga light/dark/system
      theme: lightThemeData,
      darkTheme: darkThemeData,
      /* theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Constants.white),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Constants.white,
          modalBarrierColor: Constants.white,
          modalBackgroundColor: Constants.white,
        ),
        canvasColor: Constants.white,
      ), */
      home: kIsWeb
          ? WebJobApplyFormPage(shareCode: extractedCode)
          : const SplashScreen(),
    );
  }
}
