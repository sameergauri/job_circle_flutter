import 'package:flutter/material.dart';

class ScanToApplyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at top-left corner
    path.moveTo(0, 0);

    // Left side curve: Sweeps down and forms the rounded bottom shoulder
    path.cubicTo(
      size.width * 0.15,
      0, // Control point 1 (starts flat at top)
      size.width * 0.22,
      size.height * 0.9, // Control point 2 (slopes downward sharply)
      size.width * 0.35,
      size.height, // End point of left curve (flattens out at bottom)
    );

    // Bottom flat line across the middle deck
    path.lineTo(size.width * 0.65, size.height);

    // Right side curve: Symmetry mirror of the left side
    path.cubicTo(
      size.width * 0.78,
      size.height * 0.9, // Control point 1 (slopes upward sharply)
      size.width * 0.85,
      0, // Control point 2 (starts flattening out at top)
      size.width,
      0, // End point of right curve (lands perfectly at top-right)
    );

    // Close the path outline straight along the top line
    path.lineTo(0, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
