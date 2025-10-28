
import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';

class CustomcallsmsButton extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final double? height;
  final double? width;
  final bool? isCircle;
  final Color? buttonColor;

  const CustomcallsmsButton({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.onTap,
    this.iconColor = Constants.subtitleclr,
    this.height = 30.0,
    this.width = 30.0,
    this.isCircle = false,
    this.buttonColor = Constants.lightdull,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        // width: 80,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        decoration: isCircle == true
            ? BoxDecoration(color: buttonColor, shape: BoxShape.circle)
            : BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.circular(12),
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: height,
              width: width,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                color: iconColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
