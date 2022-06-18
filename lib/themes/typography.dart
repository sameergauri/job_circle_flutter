import 'package:flutter/material.dart';

class TypographyStyle {
  static Widget textH1(
    String text,
    Color? color,
  ) {
    return Text(
      text,
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: color),
    );
  }

  static Widget textH2(
    String text,
    Color? color,
  ) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color),
    );
  }

  static Widget textH3(
    String? text,
    Color? color,
  ) {
    return Text(
      text!,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color),
    );
  }

  static Widget textH4(
    String text,
    Color? color,
  ) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color),
    );
  }

  static Widget textH5(
    String text,
    Color? color,
  ) {
    return Text(
      text,
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color),
    );
  }

  static Widget textH6(
    String text,
    Color? color,
  ) {
    return Text(
      text,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: color),
    );
  }
}
