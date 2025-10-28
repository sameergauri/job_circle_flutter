/* import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final IconData defaultIcon;
  final double? height;
  final double? width;
  final Color? color;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.defaultIcon,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height ?? 20,
      width: width,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return defaultIcon == Icons.home
            ? Image.network(CustomIconUrl.companyicon, height: 30, width: 30)
            : Icon(defaultIcon, size: 30);
      },
    );
  }
} */
import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final IconData defaultIcon;
  final double? height;
  final double? width;
  final Color? color;

  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.defaultIcon,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height ?? 20,
      width: width ?? 20,
      color: color,
      // fit: BoxFit.contain,
      // 👇 Jab tak image load ho rahi hai
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child; // Image loaded
        return SizedBox(
          height: height ?? 20,
          width: width ?? 20,
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Constants.darkBlue,
            ),
          ),
        );
      },
      // 👇 Agar image load fail ho jaye
      errorBuilder: (context, error, stackTrace) {
        return defaultIcon == Icons.home
            ? Image.network(
                CustomIconUrl.companyicon,
                height: height ?? 20,
                width: width ?? 20,
              )
            : Icon(defaultIcon, size: height ?? 20, color: color);
      },
    );
  }
}
