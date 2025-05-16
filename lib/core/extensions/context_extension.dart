import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/custom_colors.dart';
import '../widgets/animations/animation_dialog.dart';

extension ContextExtension<T> on BuildContext {
  ThemeData get themeData => Theme.of(this);
  TextTheme get textTheme => themeData.textTheme;
  CustomColors? get customColors => themeData.extension<CustomColors>();
  Size get mediaQuerySize => MediaQuery.sizeOf(this);
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get height => mediaQuerySize.height;
  EdgeInsets get viewPadding => MediaQuery.viewPaddingOf(this);
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  double get width => mediaQuerySize.width;
  bool get isSmallDevice => height < 600;
  bool get isTablet => width >= 600;
  bool get isIOS => Theme.of(this).platform == TargetPlatform.iOS;

  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  void awesomeDialog({
    required String title,
    required BuildContext context,
    CustomDialogType? dialogType,
    Color? color,
    String? btnCancel,
    String? description,
    String? btnOkText,
    VoidCallback? btnOkOnPress,
    VoidCallback? btnCancelOnPress,
    bool? dismissOnBackKeyPress,
  }) {
    AnimationDialog().showAnimationDialog(
      okOnPress: btnOkOnPress,
      okColor: color,
      cancelOnPress: btnCancelOnPress,
      dialogType: dialogType,
      context: context,
      title: title,
      description: description,
      cancelText: btnCancel,
      okText: btnOkText,
    );
  }

  Future<void> showLoading({
    material.TextDirection? textDirection,
    double? progress,
    material.Widget? loadingWidget,
  }) async {
    return await showDialog<void>(
      context: this,
      barrierDismissible: false,
      builder: (_) {
        return Directionality(
          textDirection: textDirection ?? material.TextDirection.rtl,
          child: PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) => false,
            child: SimpleDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 0.0,
              contentPadding: const EdgeInsets.all(10),
              backgroundColor: this.themeData.scaffoldBackgroundColor,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('loading'.tr(), style: textTheme.bodyLarge),
                    loadingWidget ??
                        CupertinoActivityIndicator(
                          animating: true,
                          color: this.isDark
                              ? AppColors.white
                              : AppColors.kPrimaryColor.withValues(alpha: 0.5),
                        ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  hideLoading() {
    Navigator.of(this).pop();
  }
}

extension LocaleExtension on Locale {
  bool get isArabic => languageCode == 'ar';
}
