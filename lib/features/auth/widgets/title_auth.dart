import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

class TitleAuth extends StatelessWidget {
  const TitleAuth({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: context.height * .33,
          bottom: 20.h,
        ),
        child: Text(
          title.tr(),
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.textTheme.titleLarge!.color,
            fontSize: 23.sp,
          ),
        ),
      ),
    );
  }
}
