import 'package:flutter/material.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';

class CustomIconButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;
  final Color? color;

  const CustomIconButton({
    super.key,
    required this.imageUrl,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: color != null
          ? CustomNetworkImage(
              imageUrl: imageUrl,
              defaultIcon: Icons.edit_outlined,
              height: 22,
              color: color,
            )
          : CustomNetworkImage(
              imageUrl: imageUrl,
              defaultIcon: Icons.edit_outlined,
              height: 22,
            ),
    );
  }
}
