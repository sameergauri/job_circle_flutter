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
      // Flutter ka dynamic system foundation direct link return karega browser engine se
      final Uri uri = Uri.base;
      // 1. Agar path parameters me hai: jobcircle.co.in/share/XYZ123
      if (uri.pathSegments.isNotEmpty && uri.pathSegments.contains('share')) {
        final shareIndex = uri.pathSegments.indexOf('share');
        if (shareIndex + 1 < uri.pathSegments.length) {
          return uri.pathSegments[shareIndex + 1];
        }
      }
      // 2. Fallback check agar aap query parameter use karo: jobcircle.co.in/share?code=XYZ123
      if (uri.queryParameters.containsKey('code')) {
        return uri.queryParameters['code'] ?? "";
      }
    } catch (e) {
      print("Error fetching web url parameter: $e");
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
