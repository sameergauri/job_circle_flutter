// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/constants/enum.dart';
import 'package:job_circle/src/screen/no_internet_screen.dart';
import 'package:job_circle/src/services/cache_clear_and_app_version/cache_clear_and_app_version_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/utils/shared_preference/shared_preference.dart';
import 'package:job_circle/src/utils/utils.dart';
import 'package:job_circle/src/widgets/custom_footer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    // Logic to check if we are in dark mode
    // This works regardless of whether the user chose "System" or "Dark"
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Constants.white, // Status bar color same as Scaffold
        statusBarIconBrightness:
            Brightness.dark, // Icons black (for light backgrounds)
      ),
      child: Scaffold(
        backgroundColor: colors.bgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 6,
              ),
              width: MediaQuery.of(context).size.width / 1.8,
              color: colors.bgColor,
              child: Image.asset(
                isDarkMode
                    ? CustomAssetUrl
                          .jcLogoForDark // Image for Dark Theme
                    : CustomAssetUrl.jclogoicon, // Image for Light Theme
                fit: BoxFit.cover,
              ),
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: SafeArea(child: CustomFooter()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    check();
  }

  void check() async {
    await _checkInternetConnectivity();
    checkSession();
  }

  bool _isConnected = false;
  Future<void> _checkInternetConnectivity() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      if (response.statusCode == 200) {
        setState(() {
          _isConnected = true;
        });
      } else {
        setState(() {
          _isConnected = false;
        });
      }
    } catch (e) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  void gotoLogin() {
    Timer(const Duration(seconds: 1), () {
      // NavigationService.pushAndRemoveUntil(const LoginSignup());
      NavigationService.pushAndRemoveUntil(const Scaffold());
    });
  }

  Future<void> checkSession() async {
    try {
      // await verifySession();

      int userid = SharedPrefsHelper.getInt(ESharedPreferences.user_id);
      int usertype = SharedPrefsHelper.getInt(ESharedPreferences.user_type);
      String firstName = SharedPrefsHelper.getString(
        ESharedPreferences.user_firstName,
      );
      String msg = SharedPrefsHelper.getString(ESharedPreferences.msg);

      if (_isConnected) {
        await CacheClearAppVersionService.clearCache();
        Timer(const Duration(seconds: 2), () {
          Utils.gotoScreen(
            context: context,
            empid: userid,
            firstname: firstName,
            usertype: usertype,
            msg: msg,
            from: "splash",
          );
        });
      } else {
        NavigationService.pushReplacement(NoInternet());
      }
    } catch (e) {
      gotoLogin();
    } finally {}
  }
}
