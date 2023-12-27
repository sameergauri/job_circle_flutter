// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../themes/colors.dart';

class CustomFieldBlock extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String buttonText;
  final Color? iconColor; // Added an optional parameter for icon color
  final VoidCallback? onPressed;

  const CustomFieldBlock({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.buttonText,
    this.iconColor, // Made the iconColor optional
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
      padding: const EdgeInsets.only(right: 5, top: 5),
      // width: 270,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade400,
              //  blurRadius: 10,
              blurRadius: 15.0,
              offset: const Offset(1, 1))
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Container for Image with background color
          Padding(
            padding: EdgeInsets.only(bottom: 6.h, left: 6.w, right: 6.w),
            // child: Container(
            // width: 67, // Adjust the width as needed
            // height: 67, // Match the height with the right column
            // decoration: BoxDecoration(
            //   color: iconColor,
            //   borderRadius: BorderRadius.circular(10),
            // ),
            child: Center(
              child: Image.network(
                imageUrl,
                height: 50.h,
                fit: BoxFit.contain,
              ),
            ),
            // ),
          ),
          // SizedBox(width: 6),
          // Right Column for Description and Button
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                  width: 200.w,
                child: Text(
                  description,
                  style: GoogleFonts.varela(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: onPressed,
                    style: ElevatedButton.styleFrom(
                      // Remove the vertical padding to reduce the height between button and text
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 0),
                      backgroundColor: const Color(0xFF43533d),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                        // side: BorderSide(color: Constants.themeBgColor),
                      ),
                      elevation: 0, // Remove the elevation to get a flat button
                      minimumSize: const Size(
                          0, 30), // Set the background color to olive green
                      // primary: Color(0xFF3C312B) // BROWN SHADE,
                      alignment:
                          Alignment.center, // Center the text within the button
                    ),
                    child: Text(
                      buttonText,
                      style: GoogleFonts.varela(
                        // fontSize: 14,
                        color: Constants.bgColorWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
