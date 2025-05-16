import 'package:flutter/material.dart';

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.selectedRowColor,
    required this.backgroundColorCircle,
    required this.backgroundTextField,
    required this.authButtonColor,
    required this.blackAndWhite,
    required this.whiteAndBlack,
    required this.dividerColor,
    required this.bottomSheetColor,
    required this.smoothTextColor,
  });
  final Color? selectedRowColor;
  final Color? authButtonColor;
  final Color? blackAndWhite;
  final Color? whiteAndBlack;
  final Color? dividerColor;
  final Color? smoothTextColor;
  final Color? backgroundColorCircle;
  final Color? backgroundTextField;
  final Color? bottomSheetColor;

  @override
  CustomColors copyWith({
    Color? selectedRowColor,
    Color? blackAndWhite,
    Color? whiteAndBlack,
    Color? authButtonColor,
    Color? dividerColor,
    Color? smoothTextColor,
    Color? backgroundColorCircle,
  }) {
    return CustomColors(
      smoothTextColor: smoothTextColor,
      dividerColor: dividerColor,
      blackAndWhite: blackAndWhite,
      whiteAndBlack: whiteAndBlack,
      selectedRowColor: selectedRowColor,
      bottomSheetColor: bottomSheetColor,
      authButtonColor: authButtonColor,
      backgroundTextField: backgroundTextField,
      backgroundColorCircle: backgroundColorCircle,
    );
  }

  @override
  CustomColors lerp(CustomColors? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      smoothTextColor: Color.lerp(
        smoothTextColor,
        other.smoothTextColor,
        t,
      ),
      bottomSheetColor: Color.lerp(
        bottomSheetColor,
        other.bottomSheetColor,
        t,
      ),
      backgroundTextField: Color.lerp(
        backgroundTextField,
        other.backgroundTextField,
        t,
      ),
      whiteAndBlack: Color.lerp(
        whiteAndBlack,
        other.whiteAndBlack,
        t,
      ),
      dividerColor: Color.lerp(
        dividerColor,
        other.dividerColor,
        t,
      ),
      backgroundColorCircle: Color.lerp(
        backgroundColorCircle,
        other.backgroundColorCircle,
        t,
      ),
      blackAndWhite: Color.lerp(
        blackAndWhite,
        other.blackAndWhite,
        t,
      ),
      authButtonColor: Color.lerp(
        authButtonColor,
        other.authButtonColor,
        t,
      ),
      selectedRowColor: Color.lerp(
        selectedRowColor,
        other.selectedRowColor,
        t,
      ),
    );
  }

  @override
  String toString() => 'CustomColors(selectedRowColor: $selectedRowColor)';
}
