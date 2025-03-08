// ignore_for_file: unused_local_variable, use_build_context_synchronously
// ignore_for_file: todo
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/themes/colors.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  checkSession() async {
    try {
      // await verifySession();

      var userId = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_id.name);
      if (_isConnected) {
        if (userId != null) {
          var userRawData = await Utils.getPreferencesValue(
              null, ESharedPreferences.user_rawData.name);
          
          if (userRawData != null) {
            var data = jsonDecode(userRawData);
            Timer(const Duration(seconds: 2),
                () => Utils.gotoScreen(context, data, ""));
          } else {
            gotoLogin();
          }
        } else {
          gotoLogin();
        }
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const NoInternet()));
      }
    } catch (e) {
      gotoLogin();
    } finally {}
  }

  gotoLogin() {
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushNamedAndRemoveUntil(
            context, ERoute.login.name, (Route<dynamic> route) => false)
        // Navigator.pushNamedAndRemoveUntil(
        //     context, ERoute.login.name, (Route<dynamic> route) => false)
        );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Constants.themeBgColor,
          child: const Icon(Icons.refresh_outlined),
          onPressed: () {
            check();
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: kTextTabBarHeight,
          ),
          Image.asset(
            "assets/images/internet.png",
            height: height / 4.h,
          ),
          Text(
            "Connection Error",
            style: GoogleFonts.varela(
                fontWeight: FontWeight.bold, fontSize: 22.sp),
          ),
          SizedBox(
            height: height / 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "It seems you aren't connected to the internet. Try checking your connection or switching between Wi-Fi and cellular data.",
              softWrap: true,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
              style: GoogleFonts.varela(),
            ),
          )
        ],
      ),
    );
  }
}
