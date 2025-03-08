import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/main.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';

class CustomSnackbar {
 
  static void show(String title, bool error) {
    final snackBar = SnackBar(
      elevation: 1.0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      backgroundColor: Colors.white, // Change as needed
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      content: Row(
        children: [
          error
              ? Icon(
                  Icons.error_outline_outlined,
                  color: Colors.red,
                  size: 15.h,
                )
              : Image.asset(
                  "assets/images/check.png",
                  color: Colors.green, // Change color as needed
                  height: 15.h,
                ),
          const SizedBox(width: 8.0),
          Expanded(
            child: customTextForWeather(
              title: title,

              // Text color
              fontSize: 14.0, // Text size
            ),
          ),
        ],
      ),
    );

    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
