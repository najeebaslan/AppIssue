import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/assets_constants.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/custom_button.dart';

import '../../theme/app_colors.dart';
import 'animated_circle_dialog.dart';

class AnimationDialog {
  void showAnimationDialog({
    String? okText,
    String? cancelText,
    String? description,
    required String title,
    VoidCallback? cancelOnPress,
    VoidCallback? okOnPress,
    Color? okColor,
    required BuildContext context,
    CustomDialogType? dialogType,
  }) {
    showGeneralDialog(
      context: context, 
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, animation, secondaryAnimation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
            child: Dialog(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double maxWidth = constraints.maxWidth;
                  double maxHeight = constraints.maxHeight;
                  bool isSmallDevice = maxHeight < 600;
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: maxHeight * 0.20,
                      minWidth: maxWidth * 0.9,
                      maxHeight: maxHeight * 0.7,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Transform.translate(
                            offset: Offset(0, isSmallDevice ? -70.h : -60.h),
                            child: CircleAvatar(
                              radius: 50.h,
                              backgroundColor: context.themeData.dialogTheme.backgroundColor,
                              child: AnimatedCircleDialog(
                                imageUri: _getCircleImageUri[dialogType] ?? ImagesConstants.failure,
                                backgroundCircleColor:
                                    getBackgroundCircleColor[dialogType] ?? AppColors.kPrimaryColor,
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: maxHeight * 0.045),
                                Text(
                                  title,
                                  textAlign: TextAlign.center,
                                  style: context.textTheme.titleLarge,
                                ),
                                SizedBox(height: 10.h),
                                if (description != null)
                                  Text(
                                    description,
                                    textAlign: TextAlign.center,
                                    style: context.textTheme.bodyLarge?.copyWith(
                                      color: context.customColors?.blackAndWhite,
                                      fontSize: 15.sp,
                                      height: 1.5,
                                    ),
                                  ),
                                SizedBox(height: 15.h),
                                bottomDialog(
                                  context: context,
                                  okText: okText,
                                  okColor: okColor,
                                  cancelText: cancelText,
                                  okOnPress: okOnPress,
                                  cancelOnPress: cancelOnPress,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Row bottomDialog({
    String? okText,
    String? cancelText,
    VoidCallback? okOnPress,
    VoidCallback? cancelOnPress,
    Color? okColor,
    required BuildContext context,
  }) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            isUsingInDialog: true,
            backgroundColor: okColor ?? Colors.green,
            elevation: 0,
            padding: EdgeInsets.symmetric(vertical: 8.h),
            labelStyle: context.textTheme.bodyMedium?.copyWith(
              fontSize: 18.sp,
              color: AppColors.white,
            ),
            onPressed: () {
              okOnPress?.call();
              Navigator.of(context).pop();
            },
            label: okText ?? 'ok'.tr(),
          ),
        ),
        if (okOnPress != null) SizedBox(width: 30.w),
        if (okOnPress != null)
          Expanded(
            child: CustomButton(
              isUsingInDialog: true,
              padding: EdgeInsets.symmetric(vertical: 8.h),
              onPressed: cancelOnPress ?? () => Navigator.of(context).pop(),
              label: cancelText ?? 'cancel'.tr(),
              labelStyle: context.textTheme.bodyMedium?.copyWith(
                fontSize: 18.sp,
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: StadiumBorder(
                side: BorderSide(
                  color: context.customColors!.blackAndWhite!,
                  width: 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Map<CustomDialogType, Color> get getBackgroundCircleColor {
    return {
      CustomDialogType.error: AppColors.errorDeepColor,
      CustomDialogType.warning: AppColors.errorDeepColor,
      CustomDialogType.success: Colors.green,
      CustomDialogType.question: Colors.deepOrangeAccent,
    };
  }

  Map<CustomDialogType, String> get _getCircleImageUri {
    return {
      CustomDialogType.error: ImagesConstants.failure,
      CustomDialogType.warning: ImagesConstants.warning,
      CustomDialogType.success: ImagesConstants.success,
      CustomDialogType.question: ImagesConstants.question,
    };
  }
}

enum CustomDialogType {
  ///Dialog with warning amber type header
  warning,

  ///Dialog with error red type header
  error,

  ///Dialog with success green type header
  success,

  ///Dialog with question header
  question
}
