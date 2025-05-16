import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../theme/app_colors.dart';

class CustomToast {
  static _baseToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      fontSize: 16,
      gravity: ToastGravity.CENTER,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
    );
  }
//najeebaslan2019@gmail.com
  static showErrorToast(String message) {
    return _baseToast(message, AppColors.errorDeepColor);
  }

  static showSuccessToast(String message) {
    return _baseToast(message, AppColors.successColor);
  }

  static showDefaultToast(String message) {
    return _baseToast(message, AppColors.kPrimaryColor);
  }
}
