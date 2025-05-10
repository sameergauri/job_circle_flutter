import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';

class CustomRemarkConatiner extends StatelessWidget {
  final String subtitle;
  final Color valueColor;
  final String title;

  const CustomRemarkConatiner({
    super.key,
    required this.subtitle,
    required this.valueColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Constants.lightdull),
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$title : ",
                  style: GoogleFonts.merriweather(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.black),
                ),
                TextSpan(
                  text: subtitle,
                  style: GoogleFonts.merriweather(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: valueColor,
                    
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
