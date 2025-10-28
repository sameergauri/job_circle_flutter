// ignore_for_file: unused_import


import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomToggleButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelect;
  final Color? textcolor;
  final Color? buttonColor;

  const CustomToggleButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isSelect = false,
    this.buttonColor = Constants.borderColor,
    this.textcolor = Constants.black, // Default value for isSelect
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
        margin: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
        decoration: BoxDecoration(
          color: isSelect ? buttonColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelect ? Constants.borderColor : Constants.lightdull,
          ),
        ),
        child: customText(
          // monst: true,
          title: title,
          fontWeight: isSelect ? FontWeight.bold : FontWeight.w500,
          color: textcolor,
        ),
      ),
    );
  }
}
