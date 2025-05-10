// ignore_for_file: constant_identifier_names, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';

class Constants {
  static const bgPanelColor = Colors.white; //Color(0xfffef1e9);
  static const bgColorWhite = Color(0xffffffff);
  // static const themeBgColor = Color(0xfff729995);  //TODO:: Old theme color olive green wala

  static const themeBgColorLight = Color(0xffffdf7f6);
  // static const borderColor = Color(0xffffbefed);
  static const borderColor = Color(0xfffedf6f9);
  static const subtitleclr = Color(0xfff898d8c);
  static const hintColor = Color(0xfffa8a3a3);

  static const blue = Color(0xfff5783e2); //TODO:: Old blue color
  // static const blue = Color(0xfff4F7FE1);
  static const maintheme_light_color = Color(0xffb3caca);
  static const green = Color(0xff00e785);
  static const lightBlue = Color(0xff4fc3ff);
  static const yellow = Color(0xffffe96e);
  static const lightyellow = Color(0xfffff6da);
  static const lightdull = Color(0xffff2f2f2);
  static const navyblue = Color(0xff00308f);
  static const dullBlue = Color(0xfffccf5ff);
  static const darkBlue = Color(0xfff018aff);
  static const themeBgColor = Color(0xfff5783e2);
  static const black = Color(0xfff030303);
  static const dividercolor = Color(0xfffe9eaea);
   static const red = Color(0xffff13724);
   static const orange = Color(0xffff27070);
   static const darkgreen = Color(0xfff348708);


  static const MaterialColor theme = MaterialColor(
    _redPrimaryValue,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(_redPrimaryValue),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );
  static const int _redPrimaryValue = 0xffce3538;
}
