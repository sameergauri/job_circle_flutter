
import 'package:flutter/material.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';

class CustomIconButton extends StatelessWidget {
  final String imageUrl;
  final VoidCallback onTap;

  const CustomIconButton({
    super.key,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: CustomNetworkImage(
        imageUrl: imageUrl,
        defaultIcon: Icons.edit_outlined,
        height: 22,
      ),
    );
  }
}
