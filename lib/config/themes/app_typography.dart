import 'dart:io' show Platform;
import 'package:flutter/material.dart';

class AppTypography {
  static String get fontFamily => Platform.isIOS ? 'SF Pro Display' : 'Roboto';

  // === Крупные заголовки ===
  static TextStyle numbers0Medium0 = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 44,
    height: 48 / 44,
  );
  static TextStyle numbers1Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 40,
    height: 44 / 40,
  );
  static TextStyle numbers2Regular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 36,
    height: 44 / 36,
  );
  static TextStyle numbers2Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 36,
    height: 48 / 36,
  );

  // === Semibold/Bold заголовки ===
  static TextStyle title0Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 32,
    height: 34 / 32,
  );
  static TextStyle title1Bold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 32 / 28,
  );
  static TextStyle title2Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 24,
    height: 28 / 24,
  );
  static TextStyle title2Bold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 28 / 24,
  );
  static TextStyle title3Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 24 / 20,
  );
  static TextStyle title3Bold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 20,
    height: 24 / 20,
  );
  static TextStyle title4Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 18,
    height: 22 / 18,
  );
  static TextStyle title4Bold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
    fontSize: 18,
    height: 22 / 18,
  );

  // === Body/Paragraph ===
  static TextStyle text1Regular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 20 / 16,
  );
  static TextStyle text1Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 20 / 16,
  );
  static TextStyle text1Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 20 / 16,
  );
  static TextStyle text2Regular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 18 / 14,
  );
  static TextStyle text2Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 18 / 14,
  );
  static TextStyle text2Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 18 / 14,
  );

  // === Кнопки ===
  static TextStyle button1Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 20 / 16,
  );

  static TextStyle openSectionButtonStyle = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 18 / 14,
    letterSpacing: 0.33,
    color: const Color.fromRGBO(10, 56, 153, 1),
  );

  // === Капсулы и спец. стили ===
  static TextStyle caption1Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 20 / 13,
    letterSpacing: 0.5,
  );
  static TextStyle caption2Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 14 / 12,
  );
  static TextStyle caption3Medium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 12 / 10,
  );
  static TextStyle caption3Semibold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
    fontSize: 10,
    height: 12 / 10,
  );
}
