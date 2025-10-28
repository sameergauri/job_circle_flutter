// ignore_for_file: deprecated_member_use, strict_top_level_inference

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/services/cache_clear_and_app_version/cache_clear_and_app_version_service.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FutureBuilder(
                future: Future.delayed(
                  const Duration(seconds: 1),
                ), // Simulating image loading delay
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show a loading indicator while the image is loading
                    return const CircularProgressIndicator(strokeWidth: 1);
                  } else {
                    // Image is loaded, display it
                    return Image.asset(CustomAssetUrl.rocketicon);
                  }
                },
              ),
              /* const Text(
                'Update Available',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ), */
              const SizedBox(height: 15),
              Text(
                'A new version of the app is available. Please update for the latest features and improvements.',
                textAlign: TextAlign.center,
                style: GoogleFonts.varela(fontSize: 18),
              ),
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () async {
                    _launchURL(
                      'https://play.google.com/store/apps/details?id=com.job_circle_flutter',
                    );
                    await CacheClearAppVersionService.clearCache();
                   NavigationService.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Constants.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "Update Now",
                      style: GoogleFonts.varela(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
