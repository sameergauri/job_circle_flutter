import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const customText(
                title: 'Made in',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              const SizedBox(width: 7),
              Image.asset(CustomAssetUrl.indiaicon, height: 22),
              const SizedBox(width: 7),
              const customText(
                title: 'with',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
              const SizedBox(width: 7),
              Image.asset(CustomAssetUrl.hearticon, height: 22),
            ],
          ),
          const SizedBox(height: 20),
          const customText(
            title: '@ All rights reserved 2025-26',
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: Constants.black,
          ),
        ],
      ),
    );
  }
}
