import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';

class CustomDialogueForAddResume extends StatefulWidget {
  final String subtitle;
  final VoidCallback onClose;
  const CustomDialogueForAddResume(
      {super.key, required this.subtitle, required this.onClose});

  @override
  State<CustomDialogueForAddResume> createState() =>
      _CustomDialogueForAddResumeState();
}

class _CustomDialogueForAddResumeState
    extends State<CustomDialogueForAddResume> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add your custom dialog content here

            Text(
              widget.subtitle,
              style: const TextStyle(fontSize: 16.0),
            ),

            InkWell(
              onTap: widget.onClose,
              child: Container(
                margin: const EdgeInsets.only(top: 10, right: 6, bottom: 4),
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                    border: Border.all(color: Constants.themeBgColor),
                    borderRadius: BorderRadius.circular(8),
                    color: Constants.themeBgColor),
                child: Text(
                  "Close",
                  style: GoogleFonts.varela(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
