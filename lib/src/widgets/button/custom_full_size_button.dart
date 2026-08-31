import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomButtonForJobPosting extends StatelessWidget {
  final EdgeInsetsGeometry? margin;
  final String buttonText;
  final VoidCallback onTap;
  final Color? buttonColor;
  final Color? textColor;
  final bool? isBorder;

  const CustomButtonForJobPosting({
    super.key,
    required this.buttonText,
    required this.onTap,
    this.buttonColor,
    this.textColor,
    this.isBorder,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin:
            margin ??
            const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 10),
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
              title: buttonText,
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

class CustomToggleButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelect;
  final bool isForTab;
  final Color? selectedColor;
  final Color? selectedBorderColor;
  final Color? titleColor;
  final bool? rightPaddingDissable;

  const CustomToggleButton({
    super.key,
    required this.title,
    required this.onTap,
    this.isSelect = false, // Default value for isSelect
    this.isForTab = false,
    this.selectedColor,
    this.selectedBorderColor,
    this.titleColor,
    this.rightPaddingDissable
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return IntrinsicWidth(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          margin: rightPaddingDissable!=null&&rightPaddingDissable==true?EdgeInsets.only(top: 5, bottom: 5,): EdgeInsets.only(top: 5, bottom: 5, right: 10),
          decoration: BoxDecoration(
            color: isSelect
                ? (selectedColor ?? colors.selectedTabColor!)
                : colors.unSelectedTabColor!,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelect
                  ? (selectedBorderColor ?? colors.selectedTabBorderColor!)
                  : colors.unSelectedTabBorderColor!,
            ),
          ),
          child: Center(
            child: customText(
              title: title,
              fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
              color:
                  titleColor ??
                  (isSelect
                      ? colors.selectedTabTextColor
                      : colors.unSelectedTabTextColor),
              fontSize: 12,
              softwrap: isForTab ? false : null,
              overflow: isForTab ? TextOverflow.visible : null,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomGenderButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelect;
  final double width;
  final double height;

  const CustomGenderButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.width,
    required this.height,
    this.isSelect = false,
    // Default value for isSelect
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return IntrinsicWidth(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          height: height,
          width: width,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          margin: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
          decoration: BoxDecoration(
            color: isSelect
                ? colors.selectedTabColor!
                : colors.unSelectedTabColor!,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelect
                  ? colors.selectedTabBorderColor!
                  : colors.unSelectedTabBorderColor!,
            ),
          ),
          child: Center(
            child: customText(
              title: title,
              fontWeight: isSelect ? FontWeight.bold : FontWeight.normal,
              color: isSelect
                  ? colors.selectedTabTextColor
                  : colors.unSelectedTabTextColor,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomSelectedSkillButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CustomSelectedSkillButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return IntrinsicWidth(
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
          margin: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
          decoration: BoxDecoration(
            color: colors.appbarColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.appbarColor!),
          ),
          child: Center(
            child: customText(
              title: title,
              fontWeight: FontWeight.bold,
              color: colors.headingColor,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
