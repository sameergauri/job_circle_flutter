import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomTextWithUnderLine extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final Color underlineColor;
  final double underlineHeight;
  final double spacing;
  final FontStyle fontstyle;

  const CustomTextWithUnderLine({
    super.key,
    required this.title,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w600,
    this.textColor = Colors.black,
    this.underlineColor = Constants.orange,
    this.underlineHeight = 2,
    this.spacing = 2,
    this.fontstyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
            title: title,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
            fontStyle: fontstyle,
          ),
          SizedBox(height: spacing),
          Container(height: underlineHeight, color: underlineColor),
        ],
      ),
    );
  }
}
