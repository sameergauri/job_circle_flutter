import 'package:flutter/material.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class CustomIconTitleButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;
  final String title;
  final double height;
  final double width;

  const CustomIconTitleButton({
    super.key,
    required this.imageUrl,
    required this.onTap,
    required this.title,
    this.height = 25.0,
    this.width = 25.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: height,
            width: width,
            padding: const EdgeInsets.all(4),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              color: Constants.subtitleclr,
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          customTextForWeather(
            title: title,
            fontSize: 12,
          )
        ],
      ),
    );
  }
}
