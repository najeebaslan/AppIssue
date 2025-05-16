import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/percent_indicator.dart';
import 'on_boarding_data.dart';

class AnimationCircularIndicator extends StatelessWidget {
  const AnimationCircularIndicator({
    super.key,
    required this.pageIndex,
    required this.nextPage,
    required this.onAnimationEnd,
  });

  final int pageIndex;
  final VoidCallback nextPage;
  final VoidCallback onAnimationEnd;
  static const double circleRadius = 360.0;
  static const int firstPageIndex = 1;
  static int totalPage = OnBoardingData.onBoardingList.length;
  static const int animationDuration = 150;

  @override
  Widget build(BuildContext context) {
    final double percent = _getPercent(pageIndex + firstPageIndex);

    return CircularPercentIndicator(
      radius: 83.r,
      lineWidth: 3.5.w,
      animation: true,
      onAnimationEnd: onAnimationEnd,
      animateFromLastPercent: true,
      animationDuration: animationDuration,
      backgroundColor: AppColors.kPrimaryColor200,
      progressColor: context.themeData.primaryColor,
      percent: percent,
      center: RawMaterialButton(
        fillColor: context.themeData.primaryColor,
        shape: const CircleBorder(),
        onPressed: nextPage,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Icon(
            Icons.arrow_forward_ios_sharp,
            size: 25.0.w,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  double _getPercent(int remainingPages) {
    return ((remainingPages / totalPage) * circleRadius).abs();
  }
}
