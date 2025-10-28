import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomJobOverview extends StatelessWidget {
  final String education;
  final String shifttime;
  final String weekoff;
  final List<String> language;

  const CustomJobOverview({
    super.key,
    required this.education,
    required this.shifttime,
    required this.weekoff,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 6),
      decoration: BoxDecoration(
        color: Constants.borderColor,
        border: Border.all(color: Constants.darkBlue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const customText(
            title: "Job Overview",
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
            CustomIconUrl.educationoutlineicon,
            education,
          ),
          const SizedBox(height: 4),
          _buildInfoRow(
            CustomIconUrl.holidayicon,
            weekoff,
          ),
          const SizedBox(height: 4),
          _buildInfoRow(
             CustomIconUrl.watchicon,
            shifttime,
          ),
          const SizedBox(height: 4),
          if (language.isNotEmpty) _buildLanguageRow(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String imgurl, String text) {
    return Row(
      children: [
        CustomNetworkImage(
          imageUrl: imgurl,
          defaultIcon: Icons.error_outline,
          height: 16,
        ),
        const SizedBox(width: 8),
        customText(title: text),
      ],
    );
  }

  Widget _buildLanguageRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomNetworkImage(
          imageUrl:  CustomIconUrl.languageicon,
          defaultIcon: Icons.error_outline,
          height: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: customText(
            title: language.length == 1
                ? language.join(', ')
                : "${language.join(', ')} (Any one regional language is mandatory)", // Comma separated string
            softwrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
