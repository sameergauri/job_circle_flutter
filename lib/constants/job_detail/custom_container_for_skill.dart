
import 'package:flutter/material.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

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
    return Container(
      margin: const EdgeInsets.only(bottom: 5, right: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Constants.lightdull,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isicon
              ? Icon(
                  icon,
                  size: 16,
                )
              : const SizedBox(),
          const SizedBox(
            width: 6,
          ),
          customTextForWeather(title: title)
        ],
      ),
    );
  }
}
