import 'package:flutter/material.dart';

class CustomcallsmsButton extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const CustomcallsmsButton({
    super.key,
    required this.imageUrl,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 30,
            width: 30,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
