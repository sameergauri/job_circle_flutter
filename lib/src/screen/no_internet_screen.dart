// ignore_for_file: unused_local_variable
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/screen/login_and_signup/login/login.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    checkInternetConnectivity();
  }

  Future<void> checkInternetConnectivity() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      setState(() {
        _isConnected = response.statusCode == 200;
      });
    } catch (_) {
      setState(() {
        _isConnected = false;
      });
    }
    checkSession();
  }

  void checkSession() {
    // Assuming userId and userRawData are retrieved from shared preferences
    // Replace with actual logic to retrieve userId
    String? userId; // Placeholder for userId retrieval logic
    if (_isConnected) {
      gotoLogin();
    } else {
      NavigationService.pushReplacement(NoInternet());
    }
  }

  void gotoLogin() {
    Timer(
      const Duration(seconds: 2),
      () => NavigationService.pushReplacement(LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'btn5',
        backgroundColor: Constants.darkBlue,
        onPressed: checkInternetConnectivity,
        child: const Icon(Icons.refresh_outlined),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: kTextTabBarHeight),
          Image.asset(CustomAssetUrl.interneticon, height: height / 4),
          Text(
            "Connection Error",
            style: GoogleFonts.varela(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          SizedBox(height: height / 25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "It seems you aren't connected to the internet. Try checking your connection or switching between Wi-Fi and cellular data.",
              softWrap: true,
              textAlign: TextAlign.center,
              style: GoogleFonts.varela(),
            ),
          ),
        ],
      ),
    );
  }
}
