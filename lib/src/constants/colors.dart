// ignore_for_file: constant_identifier_names, use_full_hex_values_for_flutter_colors, unused_field

import 'package:flutter/material.dart';

class Constants {
  static const white = Colors.white;
  static const themeBgColorLight = Color(0xffffdf7f6);
  static const borderColor = Color(0xfffedf6f9);
  static const subtitleclr = Color(0xfff898d8c);
  static const hintColor = Color(0xfffa8a3a3);
  static const blue = Color(0xfff5783e2);
  static const green = Color(0xfff0b6623);
  static const lightBlue = Color(0xff4fc3ff);
  static const yellow = Color(0xffffe96e);
  static const lightdull = Color(0xffff2f2f2);
  static const navyblue = Color(0xff00308f);
  static const dullBlue = Color(0xfffccf5ff);

  static const themeBgColor = Color(0xfff5783e2);
  static const black = Color(0xfff030303);
  static const orange = Color(0xffff27070);
  static const int _redPrimaryValue = 0xffce3538;
  static const yelloLight = Color(0xffffefcef);
  static const yelloborder = Color(0xffff4f0d3);
  static const red = Color(0xfff840918);
  static const darkgreen = Color(0xfff348708);
  static const offwhite = Color(0xffff1eded);
  static const bluegrey = Color(0xfff0097b2);
  static const winecolor = Color(0xfff471320);
  static const lightcolor = Color(0xfffe9f2fb);
  static const indigo = Color(0xfff9874f8);
  static const skyblue = Color(0xfff5bc8f3);
  static const dullgreen = Color(0xfff69e6cb);
  static const diffblue = Color(0xfff4d84fd);
  static const tongleColor = Color(0xfff286f29);
  // static const black = Colors.black;
  static const bgColor = Color(0xfff000000);
  static const normalAppBarColor = Color(0xfff353b47);
  static const cardColor = Color(0xfff1d2226);
  static const testPrimaryColor = Color(0xfff030303);
  static const darkBlue = Color(0xfff018aff);
  static const lightBlueColor = Color(0xfffedf6f9);
  static const darkThemeTabTextColor = Color(0xfffc4c5c9);
  static const darkThemeTabColor = Color(0xfff353b47);
  static const subtitleTextColor = Color(0xfffc4c5c9);
}

class AppColors extends ThemeExtension<AppColors> {
  final Color? bgColor;
  final Color? headingColor;
  final Color? appbarColor;
  final Color? surfaceColor;
  final Color? textPrimary;
  final Color? accentBlue;
  final Color? textfieldTextColor;
  final Color? tabColor;
  final Color? tabTextColor;
  final Color? tabBorderColor;
  // tab bar colors
  final Color? unSelectedTabColor;
  final Color? selectedTabColor;
  final Color? unSelectedTabTextColor;
  final Color? selectedTabTextColor;
  final Color? selectedTabBorderColor;
  final Color? unSelectedTabBorderColor;
  // bottom nav bar colors can be added here similarly
  final Color? unSelectedNavTabColor;
  final Color? selectedNavTabColor;
  final Color? unSelectedNavTabTextColor;
  final Color? selectedNavTabTextColor;
  final Color? selectedNavTabBorderColor;
  final Color? unSelectedNavTabBorderColor;
  final Color? unselectedNavTabIconColor;
  // normal text color etc.
  final Color? textColor;
  final Color? subtitleTextColor;
  final Color? draweBgColor;
  // ats page
  final Color? atsTabTextColor;
  final Color? orangeLine;
  final Color? atsCardColor;
  final Color? subtabTitleColor;
  final Color? atsUnSelectedTabColor;
  // jobdetail page colors can be added here
  final Color? jobdetailGreyColor;
  final Color? jobdetailContainerColor;
  final Color? recruiterCardBgColor;
  final Color? mailCallIconColor;
  final Color? chatIconColor;
  final Color? shadowColor;
  // joiners page colors can be added here
  final Color? subTitleColor;
  final Color? buttonTextColor;
  final Color? circlebgColor;

  // searchfield page colors can be added here

  // bottom sheet colors can be added here
  final Color? bottomsheetbgColor;
  final Color? bottomsheerCard1Color;
  final Color? bottomsheerCard2Color;

  const AppColors({
    required this.bgColor,
    required this.headingColor,
    required this.appbarColor,
    required this.surfaceColor,
    required this.textPrimary,
    required this.accentBlue,
    required this.textfieldTextColor,
    required this.tabColor,
    required this.tabTextColor,
    required this.tabBorderColor,
    required this.unSelectedTabColor,
    required this.selectedTabColor,
    required this.unSelectedTabTextColor,
    required this.selectedTabTextColor,
    required this.selectedTabBorderColor,
    required this.unSelectedTabBorderColor,
    required this.unSelectedNavTabColor,
    required this.selectedNavTabColor,
    required this.unSelectedNavTabTextColor,
    required this.selectedNavTabTextColor,
    required this.selectedNavTabBorderColor,
    required this.unSelectedNavTabBorderColor,
    required this.unselectedNavTabIconColor,
    required this.textColor,
    required this.subtitleTextColor,
    required this.draweBgColor,
    required this.atsTabTextColor,
    required this.orangeLine,
    required this.atsCardColor,
    required this.subtabTitleColor,
    required this.atsUnSelectedTabColor,
    required this.jobdetailGreyColor,
    required this.jobdetailContainerColor,
    required this.recruiterCardBgColor,
    required this.mailCallIconColor,
    required this.chatIconColor,
    required this.shadowColor,
    required this.bottomsheetbgColor,
    required this.bottomsheerCard1Color,
    required this.bottomsheerCard2Color,
    required this.subTitleColor,
    required this.buttonTextColor,
    required this.circlebgColor,
  });

  @override
  AppColors copyWith({
    Color? bgColor,
    Color? headingColor,
    Color? appbarColor,
    Color? surfaceColor,
    Color? textPrimary,
    Color? accentBlue,
    Color? textfieldTextColor,
    Color? tabColor,
    Color? tabTextColor,
    Color? tabBorderColor,
    Color? unSelectedTabColor,
    Color? selectedTabColor,
    Color? unSelectedTabTextColor,
    Color? selectedTabTextColor,
    Color? selectedTabBorderColor,
    Color? unSelectedTabBorderColor,
    Color? unSelectedNavTabColor,
    Color? selectedNavTabColor,
    Color? unSelectedNavTabTextColor,
    Color? selectedNavTabTextColor,
    Color? selectedNavTabBorderColor,
    Color? unSelectedNavTabBorderColor,
    Color? unselectedNavTabIconColor,
    Color? textColor,
    Color? subtitleTextColor,
    Color? draweBgColor,
    Color? atsTabTextColor,
    Color? orangeLine,
    Color? atsCardColor,
    Color? subtabTitleColor,
    Color? atsUnSelectedTabColor,
    Color? jobdetailGreyColor,
    Color? jobdetailContainerColor,
    Color? recruiterCardBgColor,
    Color? mailCallIconColor,
    Color? chatIconColor,
    Color? shadowColor,
    Color? bottomsheetbgColor,
    Color? bottomsheerCard1Color,
    Color? bottomsheerCard2Color,
    Color? subTitleColor,
    Color? buttonTextColor,
    Color? circlebgColor,
  }) {
    return AppColors(
      bgColor: bgColor ?? this.bgColor,
      headingColor: headingColor ?? this.headingColor,
      appbarColor: appbarColor ?? this.appbarColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      textPrimary: textPrimary ?? this.textPrimary,
      accentBlue: accentBlue ?? this.accentBlue,
      textfieldTextColor: textfieldTextColor ?? this.textfieldTextColor,
      tabColor: tabColor ?? this.tabColor,
      tabTextColor: tabTextColor ?? this.tabTextColor,
      tabBorderColor: tabBorderColor ?? this.tabBorderColor,
      unSelectedTabColor: unSelectedTabColor ?? this.unSelectedTabColor,
      selectedTabColor: selectedTabColor ?? this.selectedTabColor,
      unSelectedTabTextColor:
          unSelectedTabTextColor ?? this.unSelectedTabTextColor,
      selectedTabTextColor: selectedTabTextColor ?? this.selectedTabTextColor,
      selectedTabBorderColor:
          selectedTabBorderColor ?? this.selectedTabBorderColor,
      unSelectedTabBorderColor:
          unSelectedTabBorderColor ?? this.unSelectedTabBorderColor,
      unSelectedNavTabColor:
          unSelectedNavTabColor ?? this.unSelectedNavTabColor,
      selectedNavTabColor: selectedNavTabColor ?? this.selectedNavTabColor,
      unSelectedNavTabTextColor:
          unSelectedNavTabTextColor ?? this.unSelectedNavTabTextColor,
      selectedNavTabTextColor:
          selectedNavTabTextColor ?? this.selectedNavTabTextColor,
      selectedNavTabBorderColor:
          selectedNavTabBorderColor ?? this.selectedNavTabBorderColor,
      unSelectedNavTabBorderColor:
          unSelectedNavTabBorderColor ?? this.unSelectedNavTabBorderColor,
      unselectedNavTabIconColor:
          unselectedNavTabIconColor ?? this.unselectedNavTabIconColor,
      textColor: textColor ?? this.textColor,
      subtitleTextColor: subtitleTextColor ?? this.subtitleTextColor,
      draweBgColor: draweBgColor ?? this.draweBgColor,
      atsTabTextColor: atsTabTextColor ?? this.atsTabTextColor,
      orangeLine: orangeLine ?? this.orangeLine,
      atsCardColor: atsCardColor ?? this.atsCardColor,
      subtabTitleColor: subtabTitleColor ?? this.subtabTitleColor,
      atsUnSelectedTabColor:
          atsUnSelectedTabColor ?? this.atsUnSelectedTabColor,
      jobdetailGreyColor: jobdetailGreyColor ?? this.jobdetailGreyColor,
      jobdetailContainerColor:
          jobdetailContainerColor ?? this.jobdetailContainerColor,
      recruiterCardBgColor: recruiterCardBgColor ?? this.recruiterCardBgColor,
      mailCallIconColor: mailCallIconColor ?? this.mailCallIconColor,
      chatIconColor: chatIconColor ?? this.chatIconColor,
      shadowColor: shadowColor ?? this.shadowColor,
      bottomsheetbgColor: bottomsheetbgColor ?? this.bottomsheetbgColor,
      bottomsheerCard1Color:
          bottomsheerCard1Color ?? this.bottomsheerCard1Color,
      bottomsheerCard2Color:
          bottomsheerCard2Color ?? this.bottomsheerCard2Color,
      subTitleColor: subTitleColor ?? this.subTitleColor,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
       circlebgColor: circlebgColor ?? this.circlebgColor,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bgColor: Color.lerp(bgColor, other.bgColor, t),
      headingColor: Color.lerp(headingColor, other.headingColor, t),
      appbarColor: Color.lerp(appbarColor, other.appbarColor, t),
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t),
      textfieldTextColor: Color.lerp(
        textfieldTextColor,
        other.textfieldTextColor,
        t,
      ),
      tabColor: Color.lerp(tabColor, other.tabColor, t),
      tabTextColor: Color.lerp(tabTextColor, other.tabTextColor, t),
      tabBorderColor: Color.lerp(tabBorderColor, other.tabBorderColor, t),
      unSelectedTabColor: Color.lerp(
        unSelectedTabColor,
        other.unSelectedTabColor,
        t,
      ),
      selectedTabColor: Color.lerp(selectedTabColor, other.selectedTabColor, t),
      unSelectedTabTextColor: Color.lerp(
        unSelectedTabTextColor,
        other.unSelectedTabTextColor,
        t,
      ),
      selectedTabTextColor: Color.lerp(
        selectedTabTextColor,
        other.selectedTabTextColor,
        t,
      ),
      selectedTabBorderColor: Color.lerp(
        selectedTabBorderColor,
        other.selectedTabBorderColor,
        t,
      ),
      unSelectedTabBorderColor: Color.lerp(
        unSelectedTabBorderColor,
        other.unSelectedTabBorderColor,
        t,
      ),
      unSelectedNavTabColor: Color.lerp(
        unSelectedNavTabColor,
        other.unSelectedNavTabColor,
        t,
      ),
      selectedNavTabColor: Color.lerp(
        selectedNavTabColor,
        other.selectedNavTabColor,
        t,
      ),
      unSelectedNavTabTextColor: Color.lerp(
        unSelectedNavTabTextColor,
        other.unSelectedNavTabTextColor,
        t,
      ),
      selectedNavTabTextColor: Color.lerp(
        selectedNavTabTextColor,
        other.selectedNavTabTextColor,
        t,
      ),
      selectedNavTabBorderColor: Color.lerp(
        selectedNavTabBorderColor,
        other.selectedNavTabBorderColor,
        t,
      ),
      unSelectedNavTabBorderColor: Color.lerp(
        unSelectedNavTabBorderColor,
        other.unSelectedNavTabBorderColor,
        t,
      ),
      unselectedNavTabIconColor: Color.lerp(
        unselectedNavTabIconColor,
        other.unselectedNavTabIconColor,
        t,
      ),
      textColor: Color.lerp(textColor, other.textColor, t),
      subtitleTextColor: Color.lerp(
        subtitleTextColor,
        other.subtitleTextColor,
        t,
      ),
      draweBgColor: Color.lerp(draweBgColor, other.draweBgColor, t),
      atsTabTextColor: Color.lerp(atsTabTextColor, other.atsTabTextColor, t),
      orangeLine: Color.lerp(orangeLine, other.orangeLine, t),
      atsCardColor: Color.lerp(atsCardColor, other.atsCardColor, t),
      subtabTitleColor: Color.lerp(subtabTitleColor, other.subtabTitleColor, t),
      atsUnSelectedTabColor: Color.lerp(
        atsUnSelectedTabColor,
        other.atsUnSelectedTabColor,
        t,
      ),
      jobdetailGreyColor: Color.lerp(
        jobdetailGreyColor,
        other.jobdetailGreyColor,
        t,
      ),
      jobdetailContainerColor: Color.lerp(
        jobdetailContainerColor,
        other.jobdetailContainerColor,
        t,
      ),
      recruiterCardBgColor: Color.lerp(
        recruiterCardBgColor,
        other.recruiterCardBgColor,
        t,
      ),
      mailCallIconColor: Color.lerp(
        mailCallIconColor,
        other.mailCallIconColor,
        t,
      ),
      chatIconColor: Color.lerp(chatIconColor, other.chatIconColor, t),
      shadowColor: Color.lerp(shadowColor, other.shadowColor, t),
      bottomsheetbgColor: Color.lerp(
        bottomsheetbgColor,
        other.bottomsheetbgColor,
        t,
      ),
      bottomsheerCard1Color: Color.lerp(
        bottomsheerCard1Color,
        other.bottomsheerCard1Color,
        t,
      ),
      bottomsheerCard2Color: Color.lerp(
        bottomsheerCard2Color,
        other.bottomsheerCard2Color,
        t,
      ),
      subTitleColor: Color.lerp(subTitleColor, other.subTitleColor, t),
      buttonTextColor: Color.lerp(buttonTextColor, other.buttonTextColor, t),
      circlebgColor: Color.lerp(circlebgColor, other.circlebgColor, t)
    );
  }
}

extension AppThemeContext on BuildContext {
  // Ab aap kisi bhi page par sirf 'context.appColors' use kar sakte hain
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;

  // Shortcut for text theme if needed
  TextTheme get textTheme => Theme.of(this).textTheme;
}
