// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class customText extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final bool? softwrap;
  final TextAlign? textAlign;
  final int? maxlines;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final bool? monst;
  final TextDecoration? textDecoration;
  final double? letterspacing;
  final bool? normal;

  const customText({
    required this.title,
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.softwrap,
    this.textAlign,
    this.maxlines,
    this.fontStyle,
    this.overflow,
    this.monst,
    this.textDecoration,
    this.letterspacing,
    this.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: softwrap,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: overflow,
      style: monst == null
          ? GoogleFonts.merriweather(
              fontSize: fontSize ?? 12,
              color: color ?? Colors.black,
              fontWeight: fontWeight,
              decoration: textDecoration ?? TextDecoration.none,
              fontStyle: fontStyle,
              letterSpacing: letterspacing,
            )
          : monst != null && monst == true
          ? GoogleFonts.montserrat(
              fontSize: fontSize ?? 12,
              color: color ?? Colors.black,
              fontWeight: fontWeight,
              decoration: TextDecoration.none,
              fontStyle: fontStyle,
              letterSpacing: letterspacing,
            )
          : GoogleFonts.signika(
              fontSize: fontSize ?? 12,
              color: color ?? Colors.black,
              fontWeight: fontWeight,
              decoration: TextDecoration.none,
              fontStyle: fontStyle,
              letterSpacing: letterspacing,
            ),
    );
  }
}

class customTextFornCambria extends StatelessWidget {
  final String title;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final bool? softwrap;
  final TextAlign? textAlign;
  final int? maxlines;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final bool? monst;
  final TextDecoration? textDecoration;
  final double? letterspacing;
  final bool? normal;

  const customTextFornCambria({
    required this.title,
    super.key,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.softwrap,
    this.textAlign,
    this.maxlines,
    this.fontStyle,
    this.overflow,
    this.monst,
    this.textDecoration,
    this.letterspacing,
    this.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      softWrap: softwrap,
      textAlign: textAlign,
      maxLines: maxlines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: "Cambria",
        fontSize: fontSize ?? 12,
        color: color ?? Colors.black,
        fontWeight: fontWeight,
        decoration: TextDecoration.none,
        fontStyle: fontStyle,
        letterSpacing: letterspacing,
      ),
    );
  }
}
