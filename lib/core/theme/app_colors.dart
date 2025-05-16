import 'package:flutter/material.dart';

import 'color_hex.dart';

class AppColors {
  AppColors._();

  static Color kPrimaryColor = const Color(0xff3d63ff);
  static Color kPrimaryColor200 = const Color(0xFFDDE3FB);
  static Color firstAlarmColor = HexColor('#87A0E5');
  static Color nextAlarmColor = HexColor('#F56E98');
  static Color thirdAlarmColor = HexColor('#F1B440');
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF2F3F8);
  static const Color kSecondColor = Color(0xff161A3A);
  static const Color cardDarkBackgroundColor = Color(0xff1B2349);
  static Color black = const Color(0xFF171717);
  static Color iconColor = Colors.grey[700]!;
  static Color errorColor = HexColor('#ff7a7a');
  static Color errorDeepColor = HexColor('#ed4954');
  static Color successColor = Colors.green;
  static const Color grey = Color(0xFF3A5160);
  static Color get gray800 => Colors.black.withValues(alpha: 0.80);
}
