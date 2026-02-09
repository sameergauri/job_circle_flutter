import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomCheckboxRow extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const CustomCheckboxRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey, width: 1.5),
          ),
          height: 16,
          width: 20,
          child: Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              side: BorderSide(color: colors.bgColor!),
              activeColor: colors.bgColor,
              checkColor: Colors.blue, // Change color based on your constants
              visualDensity: VisualDensity.compact,
              value: value,
              onChanged: onChanged,
            ),
          ),
        ),
        Expanded(
          child: customText(
            title: title,
            fontSize: 12,
            color: value ? colors.subtitleTextColor : colors.subTitleColor,
          ),
        ),
      ],
    );
  }
}
