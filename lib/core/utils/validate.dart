

import 'package:flutter/material.dart';

class InputValidation {
//this is Global validation
  static String? validationTextField({
    required var controller,
    required String error,
    required String lengthMinError,
    required String lengthMaxError,
    required int main,
    required int max,
  }) {
    ///this is for check if controller equal  TextEditingController or no
    /// for if controller equal TextEditingController do it [controller.text] else do it [controller.trim() or anything]
    if (controller is TextEditingController) {
      ///if text is equal Empty return error
      if (controller.text.trim().isEmpty) {
        return error.toString();

        ///if the length of the text is less than the minimum
      } else if (controller.text.trim().length < main) {
        return lengthMinError.toString();

        ///If the length of the text is greater than the maximum
      } else if (controller.text.trim().length > max) {
        return lengthMaxError.toString();
      }

      ///if text is equal Empty return error
    } else if (controller.trim() != null && controller.trim().isEmpty) {
      return error.toString();

      ///if the length of the text is less than the minimum
    } else if (controller.trim().length < main) {
      return lengthMinError.toString();

      ///If the length of the text is greater than the maximum
    } else if (controller.trim().length > max) {
      return lengthMaxError.toString();
    }
    return null;
  }
    bool isValidEmail(String email) {
  String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  RegExp regex = RegExp(pattern);
  return regex.hasMatch(email);
}
}

