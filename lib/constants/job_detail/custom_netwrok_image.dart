import 'package:flutter/material.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final IconData defaultIcon;
  final double? height;
  final double? width;
  final Color? color;

  const CustomNetworkImage(
      {super.key,
      required this.imageUrl,
      required this.defaultIcon,
      this.height,
      this.width,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: height ?? 20,
      width: width ?? 20,
      color: color,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          defaultIcon,
          size: height,
        );
      },
    );
  }
}
