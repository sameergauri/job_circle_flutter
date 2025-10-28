// ignore_for_file: use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';
import 'package:job_circle/src/widgets/custom_network_image.dart';
import 'package:job_circle/src/widgets/text/custom_text.dart';

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
  final bool? readonly;
  final String? prefixicon;
  final String? sufix;

  const CustomTextFieldforAll({
    super.key,
    required this.controller,
    required this.hint,
    this.isGmail,
    this.isPrimaryNumber = false,
    this.maxLength,
    this.isNumber = false,
    this.keyboardType,
    this.isDisabled = true,
    this.readonly = false,
    this.maxline,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTabOutside,
    this.onTab,
    this.isSearchBar,
    this.isSearch,
    this.headline,
    this.focusNode,
    this.prefixicon,
    this.sufix,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size using MediaQuery
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate responsive font size (e.g., 2% of screen width)
    final double fontSize = screenWidth * 0.035; // Adjust multiplier as needed

    return SizedBox(
      height: maxline != null && maxline! > 1
          ? null // Adjust height for multiline text field
          : MediaQuery.of(context).size.height /
                24, // Default height for single line
      child: TextFormField(
        readOnly: readonly!,
        focusNode: focusNode,
        onTap: () {
          onTab != null ? onTab!() : null;
        },
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onEditingComplete: onEditingComplete,
        onTapOutside: onTabOutside,
        maxLines: maxline ?? 1, // Default to 1 line if not specified
        enabled: isDisabled,
        inputFormatters: isNumber
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : (isGmail != null && isGmail!)
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.singleLineFormatter,
              ]
            : <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
              ],
        maxLength: maxLength,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.name,
        textCapitalization: keyboardType == true
            ? TextCapitalization.none
            : TextCapitalization.sentences,
        controller: controller,
        style: GoogleFonts.montserrat(
          color: Colors.black,
          fontSize: fontSize, // Responsive font size
          fontWeight: FontWeight.w500,
        ),

        decoration: InputDecoration(
          suffix: sufix != null && sufix != ""
              ? customText(title: sufix!, color: Constants.subtitleclr)
              : null,
          prefixIcon: prefixicon != null && prefixicon != ""
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomNetworkImage(
                    color: Constants.subtitleclr,
                    height: 14,
                    width: 14,
                    imageUrl: prefixicon!,
                    defaultIcon: Icons.calendar_month,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.symmetric(
            vertical: maxline != null && maxline! > 1
                ? screenHeight *
                      0.015 // Adjust padding for multiline
                : 8, // Default padding for single line
            horizontal: 10, // Horizontal padding
          ),
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
          counterText: headline != null && headline == true ? null : '',
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
          hintStyle: isSearchBar != null && isSearchBar != false
              ? GoogleFonts.montserrat(
                  color: Constants.subtitleclr,
                  fontSize: fontSize * 0.9, // Slightly smaller hint text
                )
              : GoogleFonts.montserrat(
                  color: Constants.subtitleclr,
                  fontSize: fontSize, // Responsive hint font size
                ),
        ),
      ),
    );
  }
}
