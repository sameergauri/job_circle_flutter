import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customText(
                title: 'Made in',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colors.headingColor,
              ),
              const SizedBox(width: 7),
              Image.asset(CustomAssetUrl.indiaicon, height: 22),
              const SizedBox(width: 7),
              customText(
                title: 'with',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: colors.headingColor,
              ),
              const SizedBox(width: 7),
              Image.asset(CustomAssetUrl.hearticon, height: 22),
            ],
          ),
          const SizedBox(height: 20),
          customText(
            title: '@ All rights reserved 2026-27',
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: colors.headingColor,
          ),
        ],
      ),
    );
  }
}
