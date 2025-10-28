import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomButtonForSave extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final Color? buttonColor;
  final Color? textColor;
  final bool? isBorder;
  final bool? isPading;

  const CustomButtonForSave({
    super.key,
    required this.onTap,
    required this.title,
    this.buttonColor,
    this.textColor,
    this.isBorder,
    this.isPading = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: isPading!
            ? const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: buttonColor ?? Constants.darkBlue,
          borderRadius: BorderRadius.circular(8),
          border: isBorder != null && isBorder != false
              ? Border.all(color: Constants.darkBlue)
              : const Border(),
        ),
        width: isBorder != null && isBorder! ? null : double.infinity,
        padding: const EdgeInsets.only(bottom: 8, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            customText(
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
