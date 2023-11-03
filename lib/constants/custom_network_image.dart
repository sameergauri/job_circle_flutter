import 'package:flutter/material.dart';
import 'package:job_circle/themes/colors.dart';

class CustomImage extends StatefulWidget {
  final String imageUrl;
  final String defaultImageUrl;

  const CustomImage(
      {super.key, required this.imageUrl, required this.defaultImageUrl});

  @override
  _CustomImageState createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.imageUrl,
      fit: BoxFit.contain,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          isLoading = false;
        }
        return isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(), // Customize the loading indicator here.
              )
            : child;
      },
      errorBuilder:
          (BuildContext context, Object exception, StackTrace? stackTrace) {
        // Display the default image when there's an error loading the image.
        return const Center(
            child: CircularProgressIndicator(
          color: Constants.themeBgColor,
        )); /* Image.asset(
          widget.defaultImageUrl,
          fit: BoxFit.contain,
        ); */
      },
    );
  }
}
