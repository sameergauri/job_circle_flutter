// ignore_for_file: camel_case_types, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/provider/login_signup_provider/login_provider.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart' show customText;

class customLoginTextField extends StatelessWidget {
  const customLoginTextField({
    super.key,
    required this.loginProvider,
    required this.mobileFocus,
  });

  final LoginProvider loginProvider;
  final FocusNode mobileFocus;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: loginProvider.mobileController,
      focusNode: mobileFocus,
      cursorColor: Colors.grey,

      autofocus: true,
      validator: (value) {
        if (value == null || value.length < 10) {
          return 'Please enter your 10 digit mobile number.';
        }
        return null;
      },
      maxLength: 10,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
      ],
      style: GoogleFonts.montserrat(
        color: Constants.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        counterText: '',
        contentPadding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 10,
          right: 10,
        ),
        prefix: const customText(
          monst: true,
          title: "+91 ",
          color: Constants.subtitleclr,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusColor: const Color(0xfff729995),
        enabled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        labelText: "Mobile",
        labelStyle: GoogleFonts.montserrat(color: Constants.subtitleclr),
        hintText: '865156****',
        hintStyle: GoogleFonts.montserrat(
          color: Constants.subtitleclr,
          fontSize: 15,
        ),
      ),
    );
  }
}
