// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomFieldBlock extends StatelessWidget {
  final String description;
  final String buttonText;
  final VoidCallback? onPressed;
  const CustomFieldBlock({
    super.key,
    required this.description,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 8, top: 8, bottom: 8, right: 8),
      padding: const EdgeInsets.only(right: 10, top: 5, left: 10, bottom: 5),
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Constants.subtitleclr,
            //  blurRadius: 10,
            blurRadius: 3,
            offset: Offset(1, 1),
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customText(
            monst: true,
            textAlign: TextAlign.center,
            softwrap: true,
            title: description,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          // const Spacer(),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              // Remove the vertical padding to reduce the height between button and text
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              backgroundColor: Constants.darkBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
                // side: BorderSide(color: Constants.themeBgColor),
              ),
              elevation: 0, // Remove the elevation to get a flat button
              minimumSize: const Size(
                0,
                30,
              ), // Set the background color to olive green
              // primary: Color(0xFF3C312B) // BROWN SHADE,
              alignment: Alignment.center, // Center the text within the button
            ),
            child: customText(
              title: buttonText,
              fontSize: 12,
              color: Constants.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
