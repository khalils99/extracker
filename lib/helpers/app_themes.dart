import 'package:expense_management/helpers/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:qofi_comp/constants/ui_helpers.dart';
import 'package:sizer/sizer.dart';

import 'hex_color.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          HexColor("#C8E5C9"),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(color: HexColor("#3C503D"), fontFamily: 'Rubik'),
        ),
      ),
    ),
    secondaryHeaderColor: HexColor("#4DAF4E"),
    unselectedWidgetColor: HexColor("#ebf7e9"),
    shadowColor: Colors.grey.withOpacity(0.15),
    primaryColor: primaryColor,
    // Change the primary color here
    fontFamily: "Poppins",
    indicatorColor: HexColor("#D6D6D6"),
    disabledColor: HexColor("#E0E3EB"),
    primarySwatch: MaterialColor(primaryColor.value, <int, Color>{
      50: primaryColor,
      100: primaryColor,
      200: primaryColor,
      300: primaryColor,
      400: primaryColor,
      500: primaryColor,
      600: primaryColor,
      700: primaryColor,
      800: primaryColor,
      900: primaryColor,
    }),
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        onPrimary: HexColor("2fcc71"),
        scrim: HexColor("#C5E6C0").withOpacity(0.5),
        background: Colors.white,
        error: HexColor("#FF0000")),
    cardColor: Colors.white,
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        side: WidgetStateProperty.all(
          BorderSide(color: HexColor("##2D3D2E"), width: 1),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(color: HexColor("#2D3D2E"), fontFamily: 'Rubik'),
        ),
      ),
    ),
    canvasColor: HexColor("#1F2125"),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        color: HexColor("#1a1a1a"),
      ),
      bodyMedium: TextStyle(
        color: HexColor("#1a1a1a"),
      ),
    ),
    hoverColor: HexColor("#cdfacf"),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      hintStyle: TextStyle(
        color: HexColor("#f0f2f5"),
        fontSize: 13.ft,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 0.6.h,
      ),
      enabledBorder: homeTextFieldBorder.copyWith(
        borderRadius: BorderRadius.zero,
      ),
      focusedBorder: homeTextFieldBorder.copyWith(
        borderRadius: BorderRadius.zero,
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: HexColor("#F1F4F1"),
      scrolledUnderElevation: 0,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontFamily: "Poppins",
        color: Colors.black,
        fontWeight: FontWeight.w500,
        fontSize: 17.ft,
      ),
    ),

    highlightColor: HexColor("#F1F4F9"),
    dividerColor: HexColor("#878787"),
    scaffoldBackgroundColor: HexColor('#F1F4F1'),
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
          HexColor("#C8E5C9"),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(color: HexColor("#3C503D"), fontFamily: 'Rubik'),
        ),
      ),
    ),
    secondaryHeaderColor: HexColor("#4DAF4E"),
    unselectedWidgetColor: HexColor("#ebf7e9"),
    shadowColor: Colors.grey.withOpacity(0.15),
    primaryColor: primaryColor,
    fontFamily: "Poppins",
    indicatorColor: Colors.white54,
    disabledColor: HexColor("#E0E3EB"),
    primarySwatch: MaterialColor(primaryColor.value, <int, Color>{
      50: primaryColor,
      100: primaryColor,
      200: primaryColor,
      300: primaryColor,
      400: primaryColor,
      500: primaryColor,
      600: primaryColor,
      700: primaryColor,
      800: primaryColor,
      900: primaryColor,
    }),
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        onPrimary: HexColor("2fcc71"),
        scrim: HexColor("#C5E6C0").withOpacity(0.5),
        error: HexColor("#FF0000")),
    cardColor: HexColor("1F2125"),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        side: WidgetStateProperty.all(
          BorderSide(color: HexColor("##2D3D2E"), width: 1),
        ),
        textStyle: WidgetStateProperty.all(
          TextStyle(color: HexColor("#2D3D2E"), fontFamily: 'Rubik'),
        ),
      ),
    ),
    canvasColor: Colors.white,
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    hoverColor: HexColor("#cdfacf"),
    hintColor: Colors.white70,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      hintStyle: TextStyle(
        color: Colors.white70,
        fontSize: 13.ft,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: 4.w,
        vertical: 0.6.h,
      ),
      enabledBorder: homeTextFieldBorder.copyWith(
        borderRadius: BorderRadius.zero,
      ),
      focusedBorder: homeTextFieldBorder.copyWith(
        borderRadius: BorderRadius.zero,
      ),
    ),
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: HexColor("#1a1a1a"),
      scrolledUnderElevation: 0,
      foregroundColor: Colors.white,
      titleTextStyle: TextStyle(
        fontFamily: "Poppins",
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontSize: 17.ft,
      ),
    ),
    highlightColor: HexColor("#F1F4F9"),
    dividerColor: HexColor("#878787"),
    scaffoldBackgroundColor: HexColor('#1a1a1a'),
  );
}
