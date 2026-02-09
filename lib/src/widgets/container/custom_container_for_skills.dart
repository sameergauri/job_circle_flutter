import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomContainerFoeSkill extends StatelessWidget {
  final String title;
  final IconData? icon;
  final bool isicon;
  const CustomContainerFoeSkill({
    super.key,
    required this.title,
    required this.isicon,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.only(bottom: 5, right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: colors.tabColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isicon
              ? Icon(icon, size: 16, color: colors.headingColor)
              : const SizedBox(),
          const SizedBox(width: 6),
          customText(title: title, color: colors.headingColor),
        ],
      ),
    );
  }
}
