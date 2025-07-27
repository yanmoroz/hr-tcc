import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const transparent = Colors.transparent;
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);

  // Grey
  static const gray700 = Color(0xFF767679);
  static const gray500 = Color(0xFFBABABE);
  static const gray200 = Color(0xFFE6E6EA);
  static const gray100 = Color(0xFFF2F2F6);
  static const gray50 = Color(0xFFF8F8FA);

  // Blue
  static const blue900 = Color(0xFF0F1F3A);
  static const blue800 = Color(0xFF0A2751);
  static const blue700 = Color(0xFF0A3899);
  static const blue500 = Color(0xFF2C447B);
  static const blue300 = Color(0xFF3F6FD4);
  static const blue200 = Color(0xFFDAE0EF);
  static const blue100 = Color(0xFFEDF0F7);

  // Red
  static const red500 = Color(0xFFD1373B);
  static const red300 = Color(0xFFFF7373);
  static const red200 = Color(0xFFFFA8A8);
  static const red100 = Color(0xFFFFBDBD);

  // Orange
  static const orange500 = Color(0xFFEE8D34);
  static const orange300 = Color(0xFFF3B072);
  static const orange100 = Color(0xFFFBE5D0);

  // Yellow
  static const yellow500 = Color(0xFFFCBD00);
  static const yellow300 = Color(0xFFFCE7A6);
  static const yellow100 = Color(0xFFFDF2CE);

  // Green
  static const green500 = Color(0xFF44BF78);
  static const green100 = Color(0xFFDDF5E7);
  static const green50 = Color(0xFFECF9F2);

  // Gradient
  static const gradientBackground = LinearGradient(
    colors: [Color(0xFFE9F0FE), Color(0xFFF6F4FE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const cardShadowColor = Color.fromRGBO(10, 56, 153, 0.05);
  static const bottomShadowColor = Color.fromRGBO(52, 61, 87, 0.05);

  static const gradientCardBenefits = LinearGradient(
    colors: [Color.fromRGBO(63, 111, 212, 1), Color.fromRGBO(32, 80, 183, 1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientGlass = LinearGradient(
    colors: [
      Color.fromRGBO(255, 255, 255, 0.23),
      Color.fromRGBO(255, 255, 255, 0.4),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const progressIndicatorBackgroundProfile = Color.fromRGBO(
    218,
    224,
    239,
    1,
  );

  static const quickLinksTelegramBackgroundColor = Color.fromRGBO(
    41,
    168,
    234,
    1,
  );

  static const quickLinksIspringBackgroundColor = Color.fromRGBO(
    60,
    180,
    109,
    1,
  );

  static const quickLinksPotokBackgroundColor = Color.fromRGBO(0, 122, 255, 1);

  static const quickLinksConfluenceJiraBackgroundColor = Color.fromRGBO(
    3,
    75,
    201,
    1,
  );
}
