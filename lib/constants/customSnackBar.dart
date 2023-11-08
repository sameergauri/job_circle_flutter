import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';
import 'package:flutter/material.dart';



class CustomTextSnackBar extends StatelessWidget {
  final String text;
  final bool error;

  const CustomTextSnackBar({super.key, required this.text,required this.error});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      elevation: 1.0,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 5),
      backgroundColor: Constants.borderColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      // margin: const EdgeInsets.all(5),
      content: Row(
        children: [
          error
              ? const Icon(
                  Icons.error_outline_outlined,
                  color: Colors.red,
                )
              : const SizedBox(),
          Text(
            text,
            style: GoogleFonts.varela(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }
}
