// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomFieldBlock extends StatelessWidget {
  final String imageUrl;
  final String description;
  final String buttonText;
  final Color? iconColor; // Added an optional parameter for icon color
  final VoidCallback? onPressed;
  final double height;
  final bool isAssets;

  const CustomFieldBlock({
    super.key,
    required this.imageUrl,
    required this.description,
    required this.buttonText,
    required this.height,
    required this.isAssets,
    this.iconColor, // Made the iconColor optional
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
      padding: const EdgeInsets.only(right: 5, top: 5, left: 5, bottom: 5),
      width: 180,
      // height: MediaQuery.of(context).size.height / 7,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isAssets
              ? Image.asset(imageUrl, height: 50, fit: BoxFit.cover)
              : CustomNetworkImage(
                  height: 50,
                  width: 50,
                  imageUrl: imageUrl,
                  defaultIcon: Icons.error,
                ),
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
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
