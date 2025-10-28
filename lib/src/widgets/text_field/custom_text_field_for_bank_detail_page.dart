import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';

class CustomBankTextField extends StatelessWidget {
  const CustomBankTextField({
    super.key,
    required this.controller,
    required this.hint,
    required this.textfieldNo,
    required this.enabled,
    required this.obscureText,
    required this.maxLength,
    this.onTap,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final int textfieldNo;
  final bool enabled;
  final bool obscureText;
  final int maxLength;
  final VoidCallback? onTap;
  final void Function(String)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    TextInputType keyboardType;
    if (textfieldNo == 1 || textfieldNo == 2) {
      keyboardType = TextInputType.number;
    } else {
      keyboardType = TextInputType.text;
    }

    List<TextInputFormatter> inputFormatters = [];
    if (textfieldNo == 1 || textfieldNo == 2) {
      inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    } else if (textfieldNo == 3) {
      inputFormatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
      );
    } else {
      inputFormatters.add(
        FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
      );
    }

    TextCapitalization textCapitalization;
    if (textfieldNo == 4 || textfieldNo == 5) {
      textCapitalization = TextCapitalization.characters;
    } else {
      textCapitalization = TextCapitalization.sentences;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height / 24,
      child: TextField(
        onTap: onTap,
        maxLength: maxLength,
        enableInteractiveSelection: !obscureText,
        obscureText: obscureText,
        enabled: enabled,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        onSubmitted: onSubmitted,
        textCapitalization: textCapitalization,
        controller: controller,
        style: GoogleFonts.montserrat(
          color: Constants.black,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          fillColor: enabled ? Colors.transparent : Constants.lightdull,
          filled: !enabled,
          contentPadding: const EdgeInsets.only(
            top: 8,
            bottom: 8,
            left: 10,
            right: 10,
          ),
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Constants.lightdull),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Constants.lightdull),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Constants.lightdull),
          ),
          focusColor: const Color(0x0ff0eceb),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black),
          ),
          hintText: hint,
          hintStyle: GoogleFonts.montserrat(
            color: enabled ? Constants.subtitleclr : Constants.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
