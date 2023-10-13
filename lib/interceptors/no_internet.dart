import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
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
