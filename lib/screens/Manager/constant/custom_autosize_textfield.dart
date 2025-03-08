import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/screens/Manager/constant/custom_textfield.dart';
import 'package:job_circle/themes/colors.dart';

class CustomAutoSizeTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int maxLength;
  final double minFontSize;
  final double maxFontSize;
  final int maxline;

  const CustomAutoSizeTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.maxline,
    this.maxLength = 1500,
    this.minFontSize = 14.0,
    this.maxFontSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
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
            color: Colors.black,
            fontWeight: FontWeight.w500,
            fontSize: maxFontSize,
          ),
          cursorColor: Constants.themeBgColor,
          decoration: InputDecoration(
            counterStyle: GoogleFonts.montserrat(
              color: Colors.grey,
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
                    borderSide: const BorderSide(
                      color: Constants.subtitleclr,
                    ),
                    borderRadius: BorderRadius.circular(8))
                : UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0x0ff0eceb)),
                  ),
            focusColor: const Color(0x0ff0eceb),
            focusedBorder: maxLength < 1500
                ? OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Constants.black,
                    ),
                    borderRadius: BorderRadius.circular(8))
                : UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.black,
                    ),
                  ),
            hintText: hintText,
            hintStyle: GoogleFonts.merriweather(
              color: Colors.grey,
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
                return customTextForMonst(
                  title: "${value.text.length}/$maxLength",
                  color: Constants.subtitleclr,
                  fontSize: 12,
                );
              },
            ),
            InkWell(
              onTap: () {
                controller.clear();
              },
              child: const customTextForWeather(
                title: "Clear All",
                color: Constants.themeBgColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
