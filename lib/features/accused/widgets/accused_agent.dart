import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../core/services/launch_uri.dart';
import '../../../core/widgets/adaptive_them_container.dart';
import '../../../data/models/accuse_model.dart';

class AccusedAgent extends StatelessWidget {
  final AccusedModel accused;

  const AccusedAgent({super.key, required this.accused});

  @override
  Widget build(BuildContext context) {
    return _buildAccusedAgentSection(context);
  }

  Widget _buildAccusedAgentSection(BuildContext context) {
    return _containerWithBorder(
      context: context,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('accusedAgent'.tr(), style: context.textTheme.bodyLarge),
          const Spacer(),
          _buildAgentButton(AppIcons.messageSMS, () {
            LaunchUri().sendSMS(accused.phoneNu.toString());
          }),
          _buildAgentButton(AppIcons.call, () {
            LaunchUri().makePhoneCall(accused.phoneNu.toString());
          }),
        ],
      ),
    );
  }

  Widget _containerWithBorder({required Widget child, required BuildContext context}) {
    return AdaptiveThemeContainer(
      enableBoxShadow: false,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      border: Border.all(
        color: context.customColors!.blackAndWhite!.withValues(alpha: .5),
        width: 0.2,
      ),
      borderRadius: BorderRadius.circular(10.r),
      child: child,
    );
  }

  RawMaterialButton _buildAgentButton(IconData icon, VoidCallback onTap) {
    return RawMaterialButton(
      onPressed: onTap,
      constraints: BoxConstraints.tightFor(height: 30.h, width: 30.w),
      shape: const CircleBorder(),
      padding: EdgeInsets.zero,
      child: Icon(icon, size: 25),
    );
  }
}
