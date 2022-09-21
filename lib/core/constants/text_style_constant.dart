import 'package:flutter/material.dart';

class TextStyleConstant {
  static TextStyle get APP_BAR_STYLE => const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 32,
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
  static TextStyle get MY_NEWS_TITLE => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      );

  static TextStyle get CURRENT_USER => TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.grey.shade400,
      );

  static TextStyle get NEWS_CONTENT => const TextStyle(
        fontSize: 18,
        color: Colors.white,
      );
  static TextStyle get MY_NEWS_CONTENT => const TextStyle(
        fontSize: 16,
        color: Colors.black,
      );
}
