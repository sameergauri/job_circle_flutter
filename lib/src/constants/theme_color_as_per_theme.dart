// Light Theme
import 'package:flutter/material.dart';
import 'package:job_circle/src/constants/colors.dart';

final lightThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: Constants.white,
  /*  colorScheme: ColorScheme.fromSeed(
    seedColor: Constants.white,
    primary: Constants.blue, // Aapka primary blue color
    surface: Constants.white,
    brightness: Brightness.light,
  ), */
  appBarTheme: AppBarTheme(
    backgroundColor: Constants.borderColor,
    surfaceTintColor: Constants.borderColor,
  ),

  // Purana BottomSheet logic yahan move karein
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Constants.white,
    surfaceTintColor:
        Constants.white, // M3 mein surfaceTintColor purple shade deta hai
  ),
  canvasColor: Constants.white,
  extensions: [
    AppColors(
      bgColor: Constants.white,
      headingColor: Constants.black,
      appbarColor: Constants.borderColor,
      surfaceColor: Constants.white,
      textPrimary: Constants.black,
      accentBlue: Constants.blue,
      textfieldTextColor: Constants.black,
      tabColor: Constants.lightBlueColor,
      tabTextColor: Constants.testPrimaryColor,
      tabBorderColor: Constants.borderColor,
      unSelectedTabColor: Constants.white,
      selectedTabColor: Constants.borderColor,
      unSelectedTabTextColor: Constants.black,
      selectedTabTextColor: Constants.black,
      selectedTabBorderColor: Constants.borderColor,
      unSelectedTabBorderColor: Constants.lightdull,
      // Navigation Tab Colors
      unSelectedNavTabColor: Constants.borderColor,
      selectedNavTabColor: Constants.darkBlue,
      unSelectedNavTabTextColor: Constants.white,
      selectedNavTabTextColor: Constants.white,
      selectedNavTabBorderColor: Constants.darkBlue,
      unSelectedNavTabBorderColor: Constants.borderColor,
      unselectedNavTabIconColor: Constants.darkThemeTabTextColor,
      textColor: Constants.lightdull,
      subtitleTextColor: Constants.black,
      draweBgColor: Constants.white,
      atsTabTextColor: Constants.darkBlue,
      orangeLine: Constants.orange,
      atsCardColor: Constants.lightdull,
      subtabTitleColor: Constants.black,
      atsUnSelectedTabColor: Constants.subtitleclr,
      jobdetailGreyColor: Constants.black,
      jobdetailContainerColor: Constants.darkBlue,
      recruiterCardBgColor: Constants.white,
      mailCallIconColor: Constants.darkBlue,
      chatIconColor: Constants.darkgreen,
      shadowColor: Constants.lightdull,
      bottomsheetbgColor: Constants.white,
      bottomsheerCard1Color: Constants.lightdull,
      bottomsheerCard2Color: Constants.white,
      subTitleColor: Constants.subtitleclr,
      buttonTextColor: Constants.white,
      circlebgColor: Constants.white,
      darkBlue: Constants.darkBlue
    ),
  ],
);

// Dark Theme (Yahan aap dark versions colors assign karein)
final darkThemeData = ThemeData.dark().copyWith(
  /* colorScheme: ColorScheme.fromSeed(
    seedColor: Constants.black,
    primary: Constants.white, // Aapka primary blue color
    surface: Constants.black,
    brightness: Brightness.dark,
  ), */
  appBarTheme: AppBarTheme(
    backgroundColor: Constants.normalAppBarColor,
    surfaceTintColor: Constants.normalAppBarColor,
  ),
  // Purana BottomSheet logic yahan move karein
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Constants.normalAppBarColor,
    surfaceTintColor:
        Constants.black, // M3 mein surfaceTintColor purple shade deta hai
  ),
  dialogTheme: DialogThemeData(backgroundColor: Constants.normalAppBarColor),

  canvasColor: Constants.white,
  scaffoldBackgroundColor: Constants.white,
  extensions: [
    AppColors(
      bgColor: Constants.bgColor,
      headingColor: Constants.white,
      appbarColor: Constants.normalAppBarColor, // Darker shade for app bar
      surfaceColor: Constants.cardColor, // Dark grey
      textPrimary: Constants.white,
      accentBlue: Constants.lightBlueColor,
      textfieldTextColor: Constants.white,
      tabColor: Constants.darkThemeTabColor,
      tabTextColor: Constants.darkThemeTabTextColor,
      tabBorderColor: Constants.darkBlue,
      unSelectedTabColor: Constants.darkThemeTabColor,
      selectedTabColor: Constants.darkBlue,
      unSelectedTabTextColor: Constants.subtitleclr,
      selectedTabTextColor: Constants.white,
      selectedTabBorderColor: Constants.darkBlue,
      unSelectedTabBorderColor: Constants.darkThemeTabColor,
      // Navigation Tab Colors
      unSelectedNavTabColor: Constants.darkThemeTabColor,
      selectedNavTabColor: Constants.cardColor,
      unSelectedNavTabTextColor: Constants.darkThemeTabColor,
      selectedNavTabTextColor: Constants.white,
      selectedNavTabBorderColor: Constants.darkBlue,
      unSelectedNavTabBorderColor: Constants.darkThemeTabColor,
      unselectedNavTabIconColor: Constants.darkThemeTabTextColor,
      textColor: Constants.subtitleTextColor,
      subtitleTextColor: Constants.subtitleTextColor,
      draweBgColor: Constants.cardColor,
      atsTabTextColor: Constants.white,
      orangeLine: Constants.orange,
      atsCardColor: Constants.cardColor,
      subtabTitleColor: Constants.white,
      atsUnSelectedTabColor: Constants.cardColor,
      jobdetailGreyColor: Constants.darkThemeTabTextColor,
      jobdetailContainerColor: Constants.darkThemeTabTextColor,
      recruiterCardBgColor: Constants.cardColor,
      mailCallIconColor: Constants.darkThemeTabTextColor,
      chatIconColor: Constants.darkThemeTabTextColor,
      shadowColor: Constants.black,
      bottomsheetbgColor: Constants.normalAppBarColor,
      bottomsheerCard1Color: Constants.cardColor,
      bottomsheerCard2Color: Constants.darkThemeTabColor,
      subTitleColor: Constants.subtitleTextColor,
      buttonTextColor: Constants.darkBlue,
      circlebgColor: Constants.subtitleTextColor,
      darkBlue: Constants.darkBlue,
    ),
  ],
);
