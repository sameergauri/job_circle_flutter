import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_circle/custom_icon_url.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomContainerSelectToViewDoc extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final DateTime? date;
  final String heading;
  final String candidateName;
  final bool isDocx;

  const CustomContainerSelectToViewDoc({
    super.key,
    required this.isDocx,
    required this.onPressed,
    required this.title,
    required this.heading,
    this.date,
    required this.candidateName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (heading != "")
            customText(
              title: heading,
              fontSize: 12,
              color: colors.headingColor,
            ),
          const SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(bottom: 7),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: colors.bottomsheerCard1Color!,
                  blurRadius: 2.1,
                  spreadRadius: 2.1,
                  offset: const Offset(1.0, 2.0),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: colors.bottomsheerCard2Color,
              borderRadius: BorderRadius.circular(8),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 12,
                ),
                dense: true,
                onTap: onPressed,
                leading: SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset(
                    CustomAssetUrl.documentiicon,
                    fit: BoxFit.fill,
                  ),
                ),
                title: customText(
                  title: candidateName != ""
                      ? isDocx
                            ? '$candidateName.docx'
                            : "$candidateName.pdf"
                      : isDocx
                      ? 'Resume.docx'
                      : "Resume.pdf",
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.headingColor,
                ),
                subtitle: date != null
                    ? customText(
                        title: DateFormat("MMM d, yyyy, h:mm a").format(date!),
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
