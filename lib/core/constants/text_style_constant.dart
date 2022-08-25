import 'package:flutter/material.dart';

class TextStyleConstant {
  static TextStyle get APP_BAR_STYLE => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
      );
  static TextStyle get HOME_TITLES => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      );

  static TextStyle get HOME_NOTICE_TITLE => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      );

  static TextStyle get HOME_NOTICE_CONTENT => const TextStyle(
        color: Colors.white,
        fontSize: 16,
      );

  static TextStyle get HOME_NEWS_TITLE => const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      );

  static TextStyle get HOME_NEWS_CONTENT => const TextStyle(
        fontSize: 16,
      );

  static TextStyle get NEWS_TITLE => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      );

  static TextStyle get NEWS_CONTENT => const TextStyle(
        fontSize: 18,
        color: Colors.white,
      );
}
