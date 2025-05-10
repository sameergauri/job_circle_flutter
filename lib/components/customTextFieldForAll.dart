// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/themes/colors.dart';

class CustomTextFieldforAll extends StatelessWidget {
  final String hint;
  final bool? isGmail;
  final bool isPrimaryNumber;
  final int? maxLength;
  final bool isNumber;
  final bool? keyboardType;
  final bool isDisabled;
  final int? maxline;
  final bool? isSearchBar;
  final bool? isSearch;
  final FocusNode? focusNode;
  final Function(String)? onChanged;
  final VoidCallback? onEditingComplete;
  final Function(PointerDownEvent)? onTabOutside;
  final Function(String)? onFieldSubmitted;
  final TextEditingController controller;
  final Function? onTab;
  final bool? headline;

  const CustomTextFieldforAll(
      {super.key,
      required this.controller,
      required this.hint,
      this.isGmail,
      this.isPrimaryNumber = false,
      this.maxLength,
      this.isNumber = false,
      this.keyboardType,
      this.isDisabled = true,
      this.maxline,
      this.onChanged,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.onTabOutside,
      this.onTab,
      this.isSearchBar,
      this.isSearch,
      this.headline,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxline == null ? MediaQuery.of(context).size.height / 24 : null,
      child: TextFormField(
        focusNode: focusNode,
        onTap: () {
          onTab != null ? onTab!() : null;
        },
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        onTapOutside: onTabOutside,
        maxLines: maxline,
        enabled: isDisabled,
        inputFormatters: isNumber
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : (isGmail != null && isGmail!)
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.singleLineFormatter
                  ]
                : <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'))
                  ],
        maxLength: maxLength,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.name,
        textCapitalization: keyboardType == true
            ? TextCapitalization.none
            : TextCapitalization.sentences,
        controller: controller,
        style: GoogleFonts.montserrat(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          /*      prefix: isPrimaryNumber == true
              ? const customText(
                  monst: true,
                  title: "+91 ",
                  fontSize: 14,
                  color: Constants.black,
                  fontWeight: FontWeight.w500)
              : null, */
          filled: isPrimaryNumber
              ? true
              : isSearch != null && isSearch!
                  ? true
                  : false,
          fillColor: isPrimaryNumber
              ? Constants.lightdull
              : isSearch != null && isSearch!
                  ? Colors.white
                  : Colors.transparent,
          contentPadding:
              const EdgeInsets.only(top: 8, bottom: 8, left: 10, right: 10),
          counterText: headline != null && headline == true ? null : '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Constants.lightdull),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: Constants.lightdull), // light border
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Constants.lightdull)),
          focusColor: const Color(0x0ff0eceb),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.black),
          ),
          hintText: hint,
          hintStyle: isSearchBar != null && isSearchBar != false
              ? GoogleFonts.montserrat(
                  color: Constants.subtitleclr, fontSize: 12)
              : GoogleFonts.montserrat(
                  color: Constants.subtitleclr, fontSize: 14),
        ),
      ),
    );
  }
}
