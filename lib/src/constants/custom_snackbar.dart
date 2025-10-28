import 'package:flutter/material.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/main.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';


class CustomSnackbar {
  static void show(String title, bool error) {
    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        elevation: 1.0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        content: Row(
          children: [
            error
                ? const Icon(
                    Icons.error_outline_outlined,
                    color: Colors.red,
                    size: 15,
                  )
                : Image.asset(
                   CustomAssetUrl.doublecheckicon,
                    color: Colors.green,
                    height: 15,
                  ),
            const SizedBox(width: 8.0),
            Expanded(child: customText(title: title, fontSize: 14.0)),
          ],
        ),
      ),
    );
  }
}
