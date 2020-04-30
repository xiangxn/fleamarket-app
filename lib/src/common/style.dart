import 'package:flutter/material.dart';

class Style{
  static BoxDecoration shadowChunk(){
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey[300],
          offset: Offset(1.0, 1.0),
        )
      ]
    );
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

  static BoxDecoration get shadowBottom => BoxDecoration(
    color: Colors.white,
    boxShadow: [
      BoxShadow(
          color:Colors.grey[300],
          offset: Offset(0.0, 2.0),
          blurRadius: 10.0,
      )
    ]
  );

  static Color get backgroundColor => Colors.grey[100];

  static Color get headerBackgroundColor => Colors.white;

  static TextTheme get headerTextTheme => TextTheme(
    title: TextStyle(
      color: Colors.grey[800],
      fontSize: 18,
      fontWeight: FontWeight.bold,
    )
  );

  static IconThemeData get headerIconTheme => IconThemeData(
    color: Colors.grey[600]
  );

  static TextStyle get smallFont => TextStyle(
    fontSize: 12,
    color: Colors.grey[700]
  );

}