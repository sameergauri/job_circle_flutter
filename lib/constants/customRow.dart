import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../themes/colors.dart';

class CustomFieldBlock extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String buttonText;
  final Color? iconColor; // Added an optional parameter for icon color
  final VoidCallback? onPressed;

  CustomFieldBlock({
    required this.imageUrl,
    required this.description,
    required this.buttonText,
    this.iconColor, // Made the iconColor optional
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
      child: IntrinsicWidth(
        child: Container(
          width: 270,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Container for Image with background color
              Padding(
                padding: const EdgeInsets.only(top: 6, bottom: 6, left: 6),
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
                    width: 65,
                    height: 65,
                    fit: BoxFit.contain,
                  ),
                ),
                // ),
              ),
              // SizedBox(width: 6),
              // Right Column for Description and Button
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5, left: 5, top: 6),
                      child: Text(
                        description,
                        style: GoogleFonts.varela(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                        // Remove the vertical padding to reduce the height between button and text
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                          // side: BorderSide(color: Constants.themeBgColor),
                        ),
                        elevation:
                            0, // Remove the elevation to get a flat button
                        minimumSize:
                            Size(0, 30), // Reduce the height of the button
                        primary: Color(
                            0xFF43533d), // Set the background color to olive green
                        // primary: Color(0xFF3C312B) // BROWN SHADE,
                        alignment: Alignment
                            .center, // Center the text within the button
                      ),
                      child: Text(
                        buttonText,
                        style: GoogleFonts.varela(
                          // fontSize: 14,
                          color: Constants.bgColorWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
