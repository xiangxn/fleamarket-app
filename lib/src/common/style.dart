import 'package:flutter/material.dart';

class Style {
  static BoxDecoration shadowChunk() {
    return BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [
      BoxShadow(
        color: Colors.grey[300],
        offset: Offset(1.0, 1.0),
      )
    ]);
  }

  // static BoxDecoration shadowBottom(){
  //   return BoxDecoration(
  //     color: Colors.white,
  //     boxShadow: [
  //       BoxShadow(
  //           color:Colors.grey[300],
  //           offset: Offset(0.0, 2.0),
  //           blurRadius: 10.0,
  //       )
  //     ]
  //   );
  // }

  static BoxDecoration get shadowBottom => BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          offset: Offset(0.0, 2.0),
          blurRadius: 10.0,
        )
      ]);

  static Color get backgroundColor => Colors.grey[100];

  static Color get headerBackgroundColor => Colors.white;

  static TextTheme get headerTextTheme => TextTheme(
          title: TextStyle(
        color: Colors.grey[800],
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ));

  static IconThemeData get headerIconTheme => IconThemeData(color: Colors.grey[600]);

  static TextStyle get smallFont => TextStyle(fontSize: 12, color: Colors.grey[700]);

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
