import 'package:flutter/material.dart';

class Constants {
  static const bgPanelColor = Colors.white; //Color(0xfffef1e9);
  static const bgColorWhite = Color(0xffffffff);
  static const themeBgColor = Color(0xfff729995);
  static const themeBgColorLight = Color(0xffffdf7f6);
  // static const borderColor = Color(0xffffbefed);
  static const borderColor = Color(0xfffedf6f9);
  static const subtitleclr = Color(0xfff898d8c);
  static const hintColor = Color(0xfffa8a3a3);
  static const maintheme_light_color = Color(0xffb3caca);
  static final lightdull = Colors.grey.shade300;

  static const MaterialColor theme = MaterialColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xffffffff),
      100: Color(0xffffffff),
      200: Color(0xffffffff),
      300: Color(0xffffffff),
      400: Color(0xffffffff),
      500: Color(0xffffffff),
      600: Color(0xffffffff),
      700: Color(0xffffffff),
      800: Color(0xffffffff),
      900: Color(0xffffffff),
    },
  );
  static const int _redPrimaryValue = 0xffce3538;
}
