import 'package:flutter/material.dart';
import 'package:qofi_comp/constants/hex_color.dart';
import 'package:qofi_comp/constants/ui_helpers.dart';
import 'package:sizer/sizer.dart';

extension StringExtension on dynamic {
  String trs(BuildContext context) {
    if (toString().isEmpty) {
      return this;
    }
    return contains("@") || contains("http")
        ? this
        : (this[0].toUpperCase() + substring(1)).replaceAll("_", " ");
  }
}

bool get isTablet {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalShortestSide =
      firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  return logicalShortestSide > 600;
}

font(num font) {
  return isTablet ? (font * 0.9).sp : (font * 1.1).sp;
}

// String formatCurrency(num? val, {String? locale, String? symbol}) {
//   return NumberFormat.currency(
//     locale: locale ?? 'en_US',
//     symbol: symbol ?? 'Rs. ',
//     decimalDigits: 0,
//   ).format(val ?? "0");
// }

TextStyle homeHeadingStyle(context) => TextStyle(
      fontSize: 17.ft,
      color: Theme.of(context).canvasColor,
      fontWeight: FontWeight.w600,
    );

extension Weight on int {
  FontWeight get wt => getFontWeight(this);
}

getFontWeight(int weight) {
  switch (weight) {
    case 400:
      return FontWeight.w400;
    case 500:
      return FontWeight.w500;
    case 600:
      return FontWeight.w600;
    case 700:
      return FontWeight.bold;
    case 800:
      return FontWeight.w800;
    default:
      return FontWeight.normal;
  }
}

List<BoxShadow> boxShadow(double spread, {Color? color}) => [
      BoxShadow(
          color: color ?? Colors.grey.withOpacity(0.15),
          spreadRadius: spread,
          blurRadius: 12)
    ];

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

BoxDecoration cardDecor(context, {Color? backgroundColor}) => BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(13.sp),
    border: Border.all(
      color: Theme.of(context).indicatorColor,
    ));

Color primaryColor = HexColor("##4DAF4E");

ThemeData get darkTheme => ThemeData(
      useMaterial3: true,
      shadowColor: Colors.grey.withOpacity(0.15),
      highlightColor: Colors.grey,
      primaryColor: primaryColor,
      fontFamily: "Figtree",
      dividerColor: Colors.grey[800],
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          color: Colors.white,
        ),
      ),
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
      disabledColor: Colors.grey.withOpacity(0.6),
      canvasColor: Colors.white,
      hoverColor: HexColor("#cdfacf"),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        shadow: Colors.grey.withOpacity(0.15),
        background: HexColor("#1a1a1a"),
        brightness: Brightness.light,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        foregroundColor: HexColor("#1a1a1a"),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 14.ft,
        ),
      ),
      cardColor: Colors.black,
      scaffoldBackgroundColor: HexColor("#1a1a1a"),
    );

ThemeData get lightTheme => ThemeData(
      useMaterial3: true,

      secondaryHeaderColor: HexColor("#273766"),
      unselectedWidgetColor: HexColor("#D5DDEE"),

      shadowColor: Colors.grey.withOpacity(0.15),
      primaryColor: primaryColor,
      // Change the primary color here
      fontFamily: "Rubik",
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
          background: Colors.white,
          error: HexColor("#FF0000")),
      cardColor: Colors.white,
      canvasColor: HexColor("#1a1a1a"),
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
        centerTitle: false,
        backgroundColor: HexColor("#F1F4F9"),
        scrolledUnderElevation: 0,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: "Figtree",
          color: Colors.black,
          fontSize: 14.ft,
        ),
      ),
      highlightColor: HexColor("#F1F4F9"),
      dividerColor: HexColor("#878787"),

      scaffoldBackgroundColor: HexColor('#F1F4F9'),
    );

extension Errorhandler on Object {
  String get errorFromException => this.toString();
}

