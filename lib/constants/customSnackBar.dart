// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/themes/colors.dart';

class CustomSnackbarfinal extends SnackBar {
  CustomSnackbarfinal({
    super.key,
    required String title,
    required bool error,
  }) : super(
          elevation: 1.0,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
          backgroundColor: Constants.themeBgColorLight,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 8), // Remove shadow
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
                      color: Constants.themeBgColor,
                      height: 15.h,
                    ),
              const SizedBox(width: 8.0), // Add spacing between icon and text
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black, // Text color
                    fontSize: 14.0, // Text size
                  ),
                ),
              ),
            ],
          ),
        );
}
