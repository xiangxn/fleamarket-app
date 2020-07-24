import 'package:flutter/material.dart';

class Style {
  static TextTheme get headerTextTheme => TextTheme(
          headline6: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ));

  static IconThemeData get headerIconTheme => IconThemeData(color: Colors.grey[600]);

  static MaterialColor get mainColor => MaterialColor(
        0xFFE01329,
        <int, Color>{
          50: Color(0xFFFFEBEE),
          100: Color(0xFFFFCDD2),
          200: Color(0xFFec6e7c),
          300: Color(0xFFdf4959),
          400: Color(0xFFdf3548),
          500: Color(0xFFE01329),
          600: Color(0xFFde1026),
          700: Color(0xFFdd0b22),
          800: Color(0xFFdc0920),
          900: Color(0xFFdb031a),
        },
      );
}
