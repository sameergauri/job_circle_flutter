// ignore_for_file: camel_case_types


import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class customButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color? buttonColor;
  final Color? textColor;
  final bool? isBorder;

  const customButton({
    super.key,
    required this.onTap,
    required this.title,
    this.buttonColor,
    this.textColor,
    this.isBorder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
        decoration: BoxDecoration(
          color: buttonColor ?? Constants.darkBlue,
          borderRadius: BorderRadius.circular(8),
          border: isBorder != null && isBorder != false
              ? Border.all(color: Constants.darkBlue)
              : const Border(),
        ),
        width: double.maxFinite,
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customText(
              title: title,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
