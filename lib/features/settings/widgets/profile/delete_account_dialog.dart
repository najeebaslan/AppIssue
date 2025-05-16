import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/profile_model.dart';
import 'profile_image_widget.dart';

class DeleteAccountDialog extends StatelessWidget {
  const DeleteAccountDialog({
    super.key,
    required this.profileModel,
    required this.onConfirm,
  });

  final ProfileModel profileModel;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth = constraints.maxWidth;
          return ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth * 0.9),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    SizedBox(
                      height: context.width / 4,
                      child: ProfileImageWidget(
                        imageSize: context.width / 4,
                        enablePickImages: false,
                        isImageInsideDialog: true,
                        imageUri: profileModel.profileImage,
                        customPositioned: Positioned(
                          bottom: -5,
                          right: -5,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: context.themeData.dialogTheme.backgroundColor,
                            child: Icon(
                              AppIcons.warningFilled,
                              color: AppColors.errorDeepColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'deleteMyAccount'.tr(),
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'deleteMyAccountDescription'.tr(),
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.customColors?.blackAndWhite,
                        fontSize: 15.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          Size(double.infinity, 50.h),
                        ),
                        backgroundColor: WidgetStatePropertyAll(
                          AppColors.kPrimaryColor,
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                      ),
                      child: Text(
                        "changedMyMind".tr(),
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                      ),
                      child: Text(
                        'deleteMyAccount'.tr(),
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.errorDeepColor,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
