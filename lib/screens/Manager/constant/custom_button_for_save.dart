import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class CustomButtonForSave extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color? buttonColor;
  final Color? textColor;
  final bool? isBorder;

  const CustomButtonForSave({
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
            borderRadius: BorderRadius.circular(8.r),
            border: isBorder != null && isBorder != false
                ? Border.all(color: Constants.darkBlue)
                : const Border()),
        width: double.maxFinite,
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customTextForWeather(
              title: title,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor ?? Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
