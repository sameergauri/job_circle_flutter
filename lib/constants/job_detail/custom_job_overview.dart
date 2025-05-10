import 'package:flutter/material.dart';
import 'package:job_circle/constants/job_detail/custom_netwrok_image.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

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
          const customTextForWeather(
            title: "Job Overview",
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 6),
          _buildInfoRow(
              "https://cdn-icons-png.flaticon.com/128/15399/15399161.png",
              education),
          const SizedBox(
            height: 4,
          ),
          _buildInfoRow(
              "https://cdn-icons-png.flaticon.com/128/9247/9247317.png",
              weekoff),
          const SizedBox(
            height: 4,
          ),
          _buildInfoRow(
              "https://cdn-icons-png.flaticon.com/128/9586/9586308.png",
              shifttime),
          const SizedBox(
            height: 4,
          ),
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
        customTextForWeather(title: text),
      ],
    );
  }

  Widget _buildLanguageRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomNetworkImage(
          imageUrl: "https://cdn-icons-png.flaticon.com/128/17390/17390484.png",
          defaultIcon: Icons.error_outline,
          height: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: customTextForWeather(
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
