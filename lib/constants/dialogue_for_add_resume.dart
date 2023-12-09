import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class customDialogueforDublicate extends StatefulWidget {
  // final String subtitle;
  final VoidCallback onClose;
  // final String title;
  const customDialogueforDublicate({
    super.key,
    // required this.subtitle,
    required this.onClose,
    // required this.title
  });

  @override
  State<customDialogueforDublicate> createState() =>
      _customDialogueforDublicateState();
}

class _customDialogueforDublicateState
    extends State<customDialogueforDublicate> {
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Add your custom dialog content here

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Self-Referral ",
                  style: GoogleFonts.varela(
                      fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Not Permitted",
                  style: GoogleFonts.varela(
                      color: Colors.red,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              "It seems like you're trying to refer your own application. Our referral program is designed to encourage genuine user engagement and growth. Self-referrals are not allowed to maintain fairness and integrity.",
              style: GoogleFonts.varela(fontSize: 12.0, letterSpacing: 0.5),
            ),
            SizedBox(
              height: 4.h,
            ),
            Text(
              "Please refer your friends or colleagues as valid referral, than you ll still be eligible for fantastic rewards.",
              style: GoogleFonts.varela(fontSize: 12.0, letterSpacing: 0.5),
            ),
            Center(
              child: Text(
                "Thank you for your understanding!",
                style: GoogleFonts.varela(fontSize: 12.0, letterSpacing: 0.5),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
