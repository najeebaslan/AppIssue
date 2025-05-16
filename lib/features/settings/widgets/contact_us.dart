import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../core/services/launch_uri.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/adaptive_them_container.dart';
import '../../../core/widgets/animations/hero/custom_rect_tween.dart';
import '../../../core/widgets/animations/hero/hero_dialog_route.dart';
import 'list_tile_setting.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      flightShuttleBuilder:
          (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: toHeroContext.widget,
        );
      },
      createRectTween: (begin, end) {
        return CustomRectTween(begin: begin!, end: end!);
      },
      tag: 'ContactUsTag',
      child: ListTileSetting(
        icon: AppIcons.email,
        title: 'contactUs',
        onTap: () => Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  child: Hero(
                    tag: 'ContactUsTag',
                    createRectTween: (begin, end) {
                      return CustomRectTween(begin: begin!, end: end!);
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColors.firstAlarmColor,
                      child: AdaptiveThemeContainer(
                        width: context.width,
                        height: 220.h,
                        padding: EdgeInsets.symmetric(
                          vertical: 10.h,
                          horizontal: 40.w,
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'contactBy'.tr(),
                                    style: context.textTheme.titleLarge,
                                  ),
                                  SizedBox(height: defaultPadding.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: contactButton(
                                          isWhatsappLogo: true,
                                          backgroundIconColor: Colors.green,
                                          context: context,
                                          title: 'whatsApp'.tr(),
                                          onPressed: LaunchUri().launchWhatsApp,
                                        ),
                                      ),
                                      SizedBox(width: 80.w),
                                      Expanded(
                                        child: contactButton(
                                          isWhatsappLogo: false,
                                          backgroundIconColor: AppColors.errorDeepColor,
                                          context: context,
                                          title: 'mail'.tr(),
                                          onPressed: LaunchUri().launchEmail,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  RawMaterialButton contactButton({
    required BuildContext context,
    required VoidCallback onPressed,
    required Color backgroundIconColor,
    required bool isWhatsappLogo,
    required String title,
    IconData? icon,
  }) {
    return RawMaterialButton(
      highlightColor: !context.isDark ? Colors.transparent : null,
      highlightElevation: !context.isDark ? 0 : 8.0,
      focusElevation: 0,
      fillColor: isWhatsappLogo ? Colors.grey.withValues(alpha: 0.15) : null,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
        side: BorderSide(
          width: 0.07,
          color: context.customColors!.blackAndWhite!,
        ),
      ),
      onPressed: () {
        Navigator.pop(context);
        onPressed.call();
      },
      constraints: BoxConstraints(
        minHeight: 60.h,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 40.w,
                maxWidth: 40.w,
                minWidth: 40.w,
                minHeight: 40.w,
              ),
              child: ColoredBox(
                color: isWhatsappLogo ? AppColors.white : backgroundIconColor,
                child: isWhatsappLogo
                    ? SvgPicture.asset(
                        ImagesConstants.whatsappLogo,
                        colorFilter: const ColorFilter.mode(
                          Colors.green,
                          BlendMode.srcIn,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          icon ?? AppIcons.emailFille,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Text(title, style: context.textTheme.bodyLarge),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
