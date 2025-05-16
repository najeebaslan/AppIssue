import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../core/theme/app_colors.dart';
import 'on_boarding_data.dart';

class OnBoardingImage extends StatelessWidget {
  final String imageUri;

  const OnBoardingImage({super.key, required this.imageUri});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: context.padding.top + 70.h),
      decoration: BoxDecoration(color: context.customColors?.bottomSheetColor),
      child: Column(
        children: [
          SizedBox(
            height: context.height / 2,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: imageUri.endsWith('svg') ? SvgPicture.asset(imageUri) : Image.asset(imageUri),
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingTitles extends StatelessWidget {
  const OnBoardingTitles({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildTitle(currentIndex, context),
        SizedBox(height: 16.h),
        _buildSubtitle(currentIndex, context),
        SizedBox(height: 40.h),
      ],
    );
  }

  SizedBox _buildSubtitle(int index, BuildContext context) {
    return SizedBox(
      width: 300.w,
      child: AnimatedSwitcher(
        duration: const Duration(
          milliseconds: 350,
        ),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Text(
          key: ValueKey('${index}subtitle'),
          OnBoardingData.onBoardingList[currentIndex].description.tr(),
          textAlign: TextAlign.center,
          style: context.textTheme.bodyLarge,
          maxLines: 3,
        ),
      ),
    );
  }

  AnimatedSwitcher _buildTitle(int index, BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      transitionBuilder: (child, animation) {
        return FadeTransition(opacity: animation, child: child);
      },
      child: Text(
        key: ValueKey(index),
        textAlign: TextAlign.center,
        OnBoardingData.onBoardingList[currentIndex].title.tr(),
        style: context.textTheme.headlineMedium?.copyWith(
          color: context.isDark ? AppColors.white : AppColors.black,
          fontSize: 26.0.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
