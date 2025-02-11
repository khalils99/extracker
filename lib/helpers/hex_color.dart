import 'dart:ui';

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    String hex = hexColor.toUpperCase().replaceAll("#", "");

    if (hex.length == 6) {
      hex = "FF" + hex; // Add alpha channel if it's missing
    }

    return int.parse(hex, radix: 16);
  }
}
