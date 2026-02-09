import 'package:flutter/material.dart';
import 'package:job_circle/main.dart';
import 'package:job_circle/src/constants/theme_color_as_per_theme.dart';
import 'package:job_circle/src/provider/app_theme_provider.dart/app_theme_provider.dart';
import 'package:job_circle/src/screen/splash_screen.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/stream_config.dart';
import 'package:provider/provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
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
      title: 'Consultancy App',
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
      home: const SplashScreen(),
    );
  }
}
