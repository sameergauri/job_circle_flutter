import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:job_circle/common/app_utils.dart';
import 'package:job_circle/common/utils.dart';
import 'package:job_circle/enums/enums.dart';
import 'package:job_circle/interceptors/no_internet.dart';
import 'package:job_circle/models/api_response.dart';
import 'package:job_circle/service/UserDataService.dart';

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
        if (userId != null) {
          var userRawData = await Utils.getPreferencesValue(
              null, ESharedPreferences.user_rawData.name);
          if (userRawData != null) {
            var data = jsonDecode(userRawData);
            Timer(const Duration(seconds: 2),
                () => {Utils.gotoScreen(context, data, "")});
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
        () => {
              Navigator.pushNamedAndRemoveUntil(
                  context, ERoute.login.name, (Route<dynamic> route) => false)
              // Navigator.pushNamedAndRemoveUntil(
              //     context, ERoute.login.name, (Route<dynamic> route) => false)
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 250.0,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60),
                      bottomRight: Radius.circular(60)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(color: Colors.white, spreadRadius: 3),
                  ],
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              RichText(
                text: TextSpan(
                    text: "JOB",
                    style: GoogleFonts.varela(
                      fontSize: 40,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "CIRCLE",
                        style: GoogleFonts.varela(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.none,
                        ),
                      )
                    ]),
              ),
              /* Text(
                "JOB CIRCLE",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ), */
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'MADE IN ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                  color: Colors.black87),
                            ),
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
                            const Text(
                              ' WITH ',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.none,
                                  color: Colors.black87),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            Image.asset(
                              "./assets/images/heart.png",
                              height: 22,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          '@ All rights reserved - 2023-24',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              decoration: TextDecoration.none,
                              color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 190,
                height: 170,
                child: Container(
                  height: 170,
                  width: 170,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset(
                      "assets/images/job-logo.png",
                      height: 100,
                      width: 100,
                    ),
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, -6),
                          color: Color(0xffce3538),
                          spreadRadius: 2,
                          blurStyle: BlurStyle.inner,
                          blurRadius: 10),
                    ],
                  ),
                ),
              )
            ],
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
