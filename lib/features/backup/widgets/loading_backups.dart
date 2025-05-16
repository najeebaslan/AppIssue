import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/theme.dart';
import '../../../core/widgets/adaptive_them_container.dart';
import '../../../core/widgets/shimmer.dart';

class LoadingBackups extends StatelessWidget {
  const LoadingBackups({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: defaultPadding.h),
      itemCount: 10,
      itemBuilder: (context, index) {
        return AdaptiveThemeContainer(
          margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: defaultPadding.w),
          child: ListTile(
            dense: true,
            leading: CustomShimmer(height: 50.h, width: 50.w, isCircle: true),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
            title: Row(
              children: [
                Flexible(child: CustomShimmer(height: 7.h, width: 150.w)),
                SizedBox(width: 10.w),
                CustomShimmer(height: 15.h, width: 20.w, isCircle: true)
              ],
            ),
            subtitle: Row(
              children: [
                CustomShimmer(height: 7.h, width: 120.w),
                SizedBox(width: 3.w),
                CustomShimmer(height: 15.h, width: 15.w, isCircle: true)
              ],
            ),
            trailing: CustomShimmer(height: 5.h, width: 27.w),
          ),
        );
      },
    );
  }
}
