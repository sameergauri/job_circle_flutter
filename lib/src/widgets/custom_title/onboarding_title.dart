import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class OnboardingTitle extends StatelessWidget {
  final String title;
  final double fontSize;
  const OnboardingTitle({super.key, required this.title,this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: customText(
        title: title,
        fontSize: fontSize,
        color: Constants.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
