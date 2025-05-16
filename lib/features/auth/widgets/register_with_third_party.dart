import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../core/constants/assets_constants.dart';

class RegisterWithThirdParty extends StatelessWidget {
  const RegisterWithThirdParty({
    super.key,
    required this.onTapApple,
    required this.onTapGoogle,
  });
  final VoidCallback onTapApple;
  final VoidCallback onTapGoogle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildExpandedDivider(),
            Text(
              'orSignInBy'.tr(),
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.customColors?.blackAndWhite,
              ),
            ),
            _buildExpandedDivider(),
          ],
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Expanded(child: continueWithGoogle(context)),
          ],
        ),
      ],
    );
  }

  Widget continueWithGoogle(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            context.isDark ? const Color(0xff1B2349) : Colors.grey.withValues(alpha: 0.1),
        shape: StadiumBorder(side: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
        padding: EdgeInsets.symmetric(vertical: 12.h),
      ),
      onPressed: onTapGoogle,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              ImagesConstants.googleLogo,
              height: 30.h,
              width: 30.w,
            ),
            SizedBox(width: 10.w),
            Text(
              'continue_with_google'.tr(),
              style: context.textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildExpandedDivider() {
    return Expanded(
      child: Divider(
        color: Colors.grey,
        height: 1,
        thickness: 1,
        indent: 5.w,
        endIndent: 10.w,
      ),
    );
  }
}
