import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class OnboardingAppBarHeading extends StatelessWidget {
  const OnboardingAppBarHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        customText(
          title: "Welcome to ",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        customText(
          title: "JOB",
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Constants.darkBlue,
        ),
        customText(
          title: "CIRCLE",
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}

class OnboardingAppBarSubTitle extends StatelessWidget {
  const OnboardingAppBarSubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const customText(
      title: "Start building your professional profile",
    );
  }
}
