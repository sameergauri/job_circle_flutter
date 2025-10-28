import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';


class CustomLoadingIndicator extends StatelessWidget {
  final Color blurColor;
  final double blurSigma;
  final Color loaderColor;

  const CustomLoadingIndicator({
    super.key,
    this.blurColor = Colors.black,
    this.blurSigma = 5,
    this.loaderColor = Constants.darkBlue,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              color: blurColor.withValues(alpha: 0.2), // ✅ new way
            ),
          ),
          CircularProgressIndicator(color: loaderColor),
        ],
      ),
    );
  }
}
