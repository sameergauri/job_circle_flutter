// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, use_super_parameters

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/interceptors/no_internet.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/service/UserDataService.dart';
import 'package:job_circle/themes/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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

  checkSession() async {
    try {
      // await verifySession();

      var userId = await Utils.getPreferencesValue(
          null, ESharedPreferences.user_id.name);

      if (_isConnected) {
        if (userId != null && userId != "0") {
          var userRawData = await Utils.getPreferencesValue(
              null, ESharedPreferences.user_rawData.name);
          if (userRawData != null) {
            var data = jsonDecode(userRawData);
            Timer(const Duration(seconds: 2),
                () => Utils.gotoScreen(context, data, ""));
            /*   () => Navigator.push(       //TODO:: For job posting...
                    context,
                    MaterialPageRoute(
                        builder: (context) => const JobPostOneType()))); */
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
        const Duration(seconds: 1),
        () => Navigator.pushNamedAndRemoveUntil(
            context, ERoute.login.name, (Route<dynamic> route) => false)
        // Navigator.pushNamedAndRemoveUntil(
        //     context, ERoute.login.name, (Route<dynamic> route) => false)
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 6),
              width: MediaQuery.of(context).size.width / 1.8,
              color: Colors.white,
              child: Image.asset(
                "assets/images/jclogo.png",
                fit: BoxFit.cover,
              )),
          Expanded(
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const customTextForWeather(
                            title: 'Made in',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87),
                        const SizedBox(
                          width: 7,
                        ),
                        Image.asset(
                          "./assets/images/india.png",
                          height: 22,
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        const customTextForWeather(
                            title: 'with',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87),
                        const SizedBox(
                          width: 7,
                        ),
                        /*   const Icon(
                          Icons.favorite,
                          color: Constants.red,
                        ), */
                        Image.asset(
                          "./assets/images/heart.png",
                          height: 22,
                          //  color: Constants.red,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customTextForMonst(
                            title: '@ All rights reserved - 2025-26',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Constants.black),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  verifySession() async {
    var uid =
        await Utils.getPreferencesValue(null, ESharedPreferences.user_id.name);
    if (uid == null) {
      return "";
    }

    var result = await UserDataService().verifySession({"uid": uid});
    Map resultData = jsonDecode(result.body);
    RequestResult res = RequestResult(
        resultData["code"],
        resultData["resultKey"],
        resultData["errorMessage"],
        resultData["resultData"]);

    if (res.resultKey == 'SUCCESS') {
      if (res.resultData['val'] == 1) {
        await AppUtils.clearSession();
      }
    }
    return "";
  }
}
