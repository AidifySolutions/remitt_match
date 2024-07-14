import 'package:flutter/material.dart';

class FiatStyles {
  static var _fontFamily = 'Poppins';
  static TextStyle heading1() {
    return TextStyle(fontFamily: _fontFamily, fontSize: 24, height: 3.0);
  }

  static TextStyle body2() {
    return TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.normal,
        color: FiatColors.darkBlue);
  }

  static TextStyle body3() {
    return TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        height: 1.8,
        fontWeight: FontWeight.normal,
        color: FiatColors.fiatBlack);
  }

  static TextStyle body14() {
    return TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      height: 2.1,
    );
  }

  static TextStyle body5() {
    return TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        height: 1.8,
        fontWeight: FontWeight.bold,
        color: FiatColors.darkBlue);
  }

  static TextStyle setStyle({required TextStyle style, required Color color}) {
    return style.copyWith(color: color);
  }
}

class FiatColors {
  static var white = Color(0xFFFFFFFF);
  static var darkBlue = Color(0xFF30067F);
  static var fiatBlack = Color(0xFF000000);
  static var fiatGreen = Color(0xFF2FBF71);
  static var fiatGrey = Color(0xFFC4C4C4);
  static var fiatBackgorund = Color(0xFFE5E5E5);
}
