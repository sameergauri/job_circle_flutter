import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewConatinerForSkills extends StatelessWidget {
  final List<String> skills;
  final Color valueColor;
  final String title;

  const ViewConatinerForSkills({
    super.key,
    required this.skills,
    required this.valueColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 6,
        bottom: 6,
      ),
      child: Wrap(
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
                  text: skills
                      .map((e) => e
                          .replaceAll('"', '')
                          .replaceAll('[', '')
                          .replaceAll(']', ''))
                      .join(', '),
                  style: GoogleFonts.merriweather(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: valueColor,
                    fontStyle: FontStyle.italic,
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
