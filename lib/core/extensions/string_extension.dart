import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

extension CustomFormatDate on String? {
  ///format data for year - month -day -hour
  String formatDateTime(BuildContext context) {
    DateTime dateTime = DateTime.parse(this!).toLocal();
    String formatString = intl.DateFormat.MONTH_DAY;
    if (!isCurrentYear(dateTime.year)) {
      formatString = intl.DateFormat.YEAR_NUM_MONTH_DAY;
    }
    final intl.DateFormat formatter = intl.DateFormat(
      formatString,
      context.locale.languageCode,
    );
    return formatter.format(dateTime.toLocal());
  }

  bool isCurrentYear(int year) {
    DateTime now = DateTime.now();
    final check = DateTime(year).difference(DateTime(now.year));
    if (check.toString().startsWith('0')) {
      return true;
    } else {
      return false;
    }
  }

  String formatDate({String? languageCode}) {
    return intl.DateFormat(
      intl.DateFormat.YEAR_NUM_MONTH_DAY,
      languageCode,
    ).format(DateTime.parse(this!));
  }

  String formatWithEnglishLanguage({String? languageCode}) {
    return intl.DateFormat(intl.DateFormat.YEAR_NUM_MONTH_DAY, 'en').format(DateTime.parse(this!));
  }

  /// Returns true if given String is null or isEmpty
  bool get isEmptyOrNull =>
      this == null || (this != null && this!.isEmpty) || (this != null && this! == 'null');

  // Check null string, return given value if null
  String validate({String value = ''}) {
    if (isEmptyOrNull) {
      return value;
    } else {
      return this!;
    }
  }

  ///Name Abbreviation
  String? getFirstAndLastName({String value = '', int countTack = 2}) {
    List<String> names = this?.split(" ") ?? [];
    if (names.length >= 3) {
      List<String> firstThreeNames = names.take(countTack).toList();
      return firstThreeNames.join(" ");
    } else {
      return this;
    }
  }
}
