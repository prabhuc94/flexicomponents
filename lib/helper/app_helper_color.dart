import 'dart:ui';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "0xFF$hexColor";
    }
    return int.parse(hexColor);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}