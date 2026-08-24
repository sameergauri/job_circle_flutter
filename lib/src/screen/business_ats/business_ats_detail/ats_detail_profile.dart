import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class AtsProfile extends StatelessWidget {
  const AtsProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Center(
      child: customText(
        title: "Not implemented yet",
        color: colors.headingColor,
        fontSize: 16,
      ),
    );
  }

  String capitalizeFirstLetter(String? text) {
    if (text == null || text.isEmpty) {
      return '';
    }
    return text[0].toUpperCase() + text.substring(1);
  }

  String formatLocality(String locality) {
    List<String> parts = locality.split(',');
    if (parts.length >= 2) {
      String part1 = parts[0].trim();
      String part2 = parts[1].trim();
      return '$part1, $part2';
    }
    return locality;
  }
}
