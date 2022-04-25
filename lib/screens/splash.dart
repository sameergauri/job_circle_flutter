import 'dart:async';

import 'package:flutter/material.dart';
import 'package:job_circle/screens/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
            (Route<dynamic> route) => false));
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
                  color: Colors.redAccent,
                  boxShadow: [
                    BoxShadow(color: Colors.red, spreadRadius: 3),
                  ],
                ),
              ),
              const SizedBox(
                height: 120,
              ),
              const Text(
                "JOB CIRCLE",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.none,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: SizedBox(
                    height: 100,
                    child: Column(
                      children: const [
                        Text(
                          'MADE IN INDIA',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                              color: Colors.black87),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '@ All rights reserved - 2022-23',
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
                child: Image.asset("assets/images/job-logo.png"),
              )
            ],
          ),
        ],
      ),
    );
  }
}
