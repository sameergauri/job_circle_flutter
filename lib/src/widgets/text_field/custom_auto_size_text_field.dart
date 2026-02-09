// ignore_for_file: strict_top_level_inference, prefer_typing_uninitialized_variables

import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

class CustomAutoSizeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final double minFontSize;
  final double maxFontSize;
  final int maxline;
  final needClearAll;

  const CustomAutoSizeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxline,
    this.maxLength = 1500,
    this.minFontSize = 14.0,
    this.maxFontSize = 18.0,
    this.needClearAll = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeTextField(
          controller: controller,
          minFontSize: minFontSize,
          maxFontSize: maxFontSize,
          stepGranularity: 1.0,
          maxLength: maxLength,
          textCapitalization: TextCapitalization.sentences,
          fullwidth: true,
          maxLines: maxline,
          textAlign: TextAlign.start,
          style: GoogleFonts.montserrat(
            color: colors.headingColor,
            fontWeight: FontWeight.w500,
            fontSize: maxFontSize,
          ),
          cursorColor: Constants.themeBgColor,
          decoration: InputDecoration(
            counterStyle: GoogleFonts.montserrat(
              color: colors.subTitleColor,
              fontSize: 12,
            ),
            fillColor: Colors.transparent,
            contentPadding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: 10,
              right: 10,
            ),
            counterText: '',
            border: maxLength < 1500
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: colors.subTitleColor!),
                    borderRadius: BorderRadius.circular(8),
                  )
                : UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors.subTitleColor!),
                  ),
            focusColor: colors.headingColor,
            focusedBorder: maxLength < 1500
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: colors.headingColor!),
                    borderRadius: BorderRadius.circular(8),
                  )
                : UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: colors.headingColor!),
                  ),
            hintText: hintText,
            hintStyle: GoogleFonts.merriweather(
              color: colors.subTitleColor,
              fontSize: 14,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                return customText(
                  monst: true,
                  title: "${value.text.length}/$maxLength",
                  color: colors.subTitleColor,
                  fontSize: 12,
                );
              },
            ),
            if (controller.text.isNotEmpty && needClearAll)
              InkWell(
                onTap: () {
                  controller.clear();
                },
                child: customText(
                  title: "Clear All",
                  color: colors.orangeLine,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
