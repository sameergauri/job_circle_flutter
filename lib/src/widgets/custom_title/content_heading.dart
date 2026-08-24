// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class contentHeading extends StatelessWidget {
  final String title;
  const contentHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return customText(
      title: title,
      fontSize: 12,
      color: colors.headingColor,
      fontWeight: FontWeight.w600,
    );
  }
}
