// ignore_for_file: unused_result, library_private_types_in_public_api, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/services/navigation/navigation_services.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomDialogForConfirmation extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function onYes;
  final String button1text;
  final String? button2text;
  final bool onlysinglebutton;

  CustomDialogForConfirmation({
    super.key,
    required this.title,
    required this.onYes,
    required this.subtitle,
    required this.button1text,
    this.button2text,
    required this.onlysinglebutton,
  });

  bool isUnderGraduate = false;

  bool isGraduate = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 0,
      contentPadding: const EdgeInsets.only(
        top: 5,
        left: 14,
        right: 10,
        bottom: 20,
      ),
      content: SizedBox(
        // width: MediaQuery.of(context).size.width / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!onlysinglebutton)
              Align(
                alignment: Alignment.topRight,
                child: InkWell(
                  onTap: () {
                    NavigationService.pop();
                  },
                  child: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: Constants.subtitleclr,
                  ),
                ),
              ),
            customText(
              title: title,
              fontSize: 16,
              softwrap: true,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 10),
            customText(
              title: subtitle,
              fontSize: 12,
              softwrap: true,
              color: Constants.subtitleclr,
              fontWeight: FontWeight.normal,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    onYes();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Constants.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    child: customText(
                      title: button1text,
                      fontWeight: FontWeight.bold,
                      color: Constants.darkBlue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
