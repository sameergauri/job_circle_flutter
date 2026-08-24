// ignore_for_file: use_full_hex_values_for_flutter_colors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_circle/src/constants/colors.dart';

class CustomBulletTextFieldForJobPost extends StatefulWidget {
  final String hintText;
  final int maxLength;
  final int maxLines;
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const CustomBulletTextFieldForJobPost({
    super.key,
    required this.hintText,
    required this.maxLength,
    required this.maxLines,
    required this.controller,
    this.onChanged,
  });

  @override
  _CustomBulletTextFieldForJobPostState createState() =>
      _CustomBulletTextFieldForJobPostState();
}

class _CustomBulletTextFieldForJobPostState
    extends State<CustomBulletTextFieldForJobPost> {
  final String bullet = '\u2022 ';
  String lastText = '';

  @override
  @override
  void initState() {
    super.initState();

    // If controller is empty, initialize with a bullet
    if (widget.controller!.text.trim().isEmpty) {
      widget.controller!.text = bullet;
    } else {
      // If value exists, prefix bullet to each line if not already
      final lines = widget.controller!.text.split('\n');
      final updatedLines = lines.map((line) {
        line = line.trimLeft();
        return line.startsWith(bullet) ? line : bullet + line;
      }).toList();

      widget.controller!.text = updatedLines.join('\n');
    }

    lastText = widget.controller!.text;
    widget.controller!.addListener(_onTextChanged);
  }
  /* void initState() {
    super.initState();
    widget.controller!.text = bullet;
    lastText = widget.controller!.text;

    widget.controller!.addListener(_onTextChanged);
  } */

  void _onTextChanged() {
    String currentText = widget.controller!.text;
    int cursorPosition = widget.controller!.selection.baseOffset;

    // Agar pura field delete ho gaya, to bullet wapas set karo
    if (currentText.trim().isEmpty) {
      _updateText(bullet, bullet.length);
      lastText = bullet;
      return;
    }

    // 🔐 Prevent user from removing the first bullet
    if (!currentText.startsWith(bullet)) {
      _updateText(lastText, bullet.length);
      return;
    }

    // ⏎ Add bullet on new line
    if (currentText.length > lastText.length &&
        cursorPosition > 0 &&
        currentText[cursorPosition - 1] == '\n') {
      String newText =
          currentText.substring(0, cursorPosition) +
          bullet +
          currentText.substring(cursorPosition);
      _updateText(newText, cursorPosition + bullet.length);
      lastText = newText;
      return;
    }

    // ✅ Save the current valid text
    lastText = currentText;
  }

  void _updateText(String newText, int cursorPos) {
    widget.controller!.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: cursorPos),
    );
  }

  @override
  void dispose() {
    widget.controller!.removeListener(_onTextChanged);
    // Don't dispose here if passed from outside
    // widget.controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return TextFormField(
      onChanged: widget.onChanged,
      style: GoogleFonts.montserrat(
        color: colors.headingColor,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      controller: widget.controller,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textCapitalization: TextCapitalization.sentences,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: 10,
          right: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.bottomsheerCard1Color!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: colors.bottomsheerCard1Color!,
          ), // light border
        ),
        focusColor: const Color(0x0ff0eceb),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.bottomsheerCard1Color!),
        ),

        hintText: widget.hintText,
        hintMaxLines: widget.maxLines,
        hintStyle: GoogleFonts.montserrat(
          color: Constants.subtitleclr,
          fontSize: 14,
        ),
      ),
    );
  }
}
