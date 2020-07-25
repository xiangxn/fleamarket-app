import 'package:flutter/material.dart';

class Style {
  Style();
  Style.from(
      {this.primarySwatch,
      this.backgroundColor,
      this.splashColor,
      this.highlightColor,
      this.dividerColor,
      this.scaffoldBackgroundColor,
      this.headerTextTheme,
      this.headerIconTheme});

  MaterialColor primarySwatch = MaterialColor(
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
  Color backgroundColor = Colors.grey[100];
  Color splashColor = Colors.transparent;
  Color highlightColor = Colors.transparent;
  Color dividerColor = Colors.transparent;
  Color scaffoldBackgroundColor = Colors.grey[100];

  TextTheme headerTextTheme = TextTheme(
      headline6: TextStyle(
    color: Colors.grey[800],
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ));

  IconThemeData headerIconTheme = IconThemeData(color: Colors.grey[600]);

  Color headerBackgroundColor = Colors.white;

  BoxDecoration shadowBottom = BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          offset: Offset(0.0, 2.0),
          blurRadius: 10.0,
        )
      ]);
}
