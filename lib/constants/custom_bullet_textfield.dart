// Import this for AutoSizeTextField
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assuming you're using this for screen responsiveness
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart'; // If you're using Google Fonts

class BulletPointTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxlength;

  const BulletPointTextField({
    super.key,
    required this.controller,
    required this.maxlength,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    // Use a state variable to manage line transitions if necessary

    return AutoSizeTextField(
      controller: controller,
      maxLines: 8,
      minFontSize: 16.0,
      maxFontSize: 24.0,
      maxLength: maxlength,
      stepGranularity: 1.0,
      fullwidth: true,
      textCapitalization: TextCapitalization.sentences,
      style: GoogleFonts.montserrat(
          color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        contentPadding:
            const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xffff0eceb)),
        ),
        focusColor: const Color(0xffff0eceb),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
          color: Constants.subtitleclr,
          fontSize: 14,
        ),
      ),
      onChanged: (value) {
        Future.delayed(const Duration(milliseconds: 100), () {
          String note = controller.text;
          if (note.isEmpty) {
            controller.text = '${controller.text}\u2022 ';
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          }
          if (note.isNotEmpty && note.substring(note.length - 1) == '\n') {
            controller.text = '${controller.text}\u2022 ';
            controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length));
          }
        });
        // Call the onChanged function provided as a parameter
      },
    );
  }
}
