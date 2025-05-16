import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/theme/app_colors.dart';
import 'package:issue/core/theme/theme.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/widgets/base_divider.dart';

class BaseBottomSheet {
  Future show({
    bool? centerTitle,
    String? headerTitle,
    bool? isScrollControlled,
    double? heightBottomSheet,
    required BuildContext context,
    ValueNotifier<double>? initialChildSize,
    required Function(ScrollController? controller) child,
    bool useDraggable = true,
  }) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: isScrollControlled ?? true,
      useRootNavigator: true,
      backgroundColor: context.customColors?.backgroundTextField,
      scrollControlDisabledMaxHeightRatio: heightBottomSheet ?? 0.9,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(defaultBorderRadius),
          topRight: Radius.circular(defaultBorderRadius),
        ),
      ),
      barrierColor: context.isDark
          ? context.themeData.scaffoldBackgroundColor.withValues(alpha: 0.4)
          : AppColors.iconColor.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        if (useDraggable) {
          return ValueListenableBuilder<double?>(
            valueListenable: initialChildSize ?? ValueNotifier(null),
            builder: (__, value, _) {
              return DraggableScrollableSheet(
                initialChildSize: value ?? 0.5,
                minChildSize: 0.1,
                maxChildSize: 1,
                expand: false,
                builder: (BuildContext context, ScrollController sheetController) {
                  return BottomSheetContent(
                    useDraggable: useDraggable,
                    centerTitle: centerTitle ?? false,
                    headerTitle: headerTitle,
                    child: child(sheetController),
                  );
                },
              );
            },
          );
        } else {
          return BottomSheetContent(
            centerTitle: centerTitle ?? false,
            headerTitle: headerTitle,
            useDraggable: useDraggable,
            child: child(null),
          );
        }
      },
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  const BottomSheetContent({
    super.key,
    this.headerTitle,
    this.enableDivider,
    required this.child,
    required this.centerTitle,
    required this.useDraggable,
  });
  final String? headerTitle;
  final Widget child;
  final bool? enableDivider;
  final bool centerTitle;
  final bool useDraggable;
  @override
  Widget build(BuildContext context) {
    if (useDraggable) {
      return LayoutBuilder(builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
          child: SizedBox(
            height: maxHeight,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: defaultPadding.h,
                  ),
                  child: Center(child: _HeaderBottomSheet()),
                ),
                _CloseIconButton(),
                if (headerTitle != null && enableDivider == true) const BaseDivider(),
                if (headerTitle != null)
                  centerTitle ? Center(child: _titleText(context)) : _titleText(context),
                SizedBox(height: 10.h),
                const Spacer(),
                child,
                const Spacer(),
              ],
            ),
          ),
        );
      });
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: Center(child: _HeaderBottomSheet()),
            ),
            _CloseIconButton(),
            if (headerTitle != null && enableDivider == true) const BaseDivider(),
            if (headerTitle != null)
              centerTitle ? Center(child: _titleText(context)) : _titleText(context),
            SizedBox(height: 10.h),
            child,
          ],
        ),
      );
    }
  }

  Widget _titleText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        headerTitle!.tr(),
        style: context.textTheme.titleLarge?.copyWith(height: 0.1),
      ),
    );
  }
}

class _HeaderBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30.r),
      child: ColoredBox(
        color: context.customColors!.blackAndWhite!.withValues(alpha: 0.15),
        child: SizedBox(
          height: 6.h,
          width: 70.w,
        ),
      ),
    );
  }
}

class _CloseIconButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: context.locale.isArabic ? Alignment.topLeft : Alignment.topRight,
      child: RawMaterialButton(
        padding: const EdgeInsets.all(20),
        fillColor:
            context.isDark ? Colors.grey.shade300.withValues(alpha: 0.07) : Colors.grey.shade100,
        splashColor: Colors.grey.shade100.withValues(alpha: 0.5),
        elevation: 0,
        visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
        shape: const CircleBorder(),
        constraints: BoxConstraints.loose(Size(30.w, 30.h)),
        onPressed: () => Navigator.pop(context),
        child: Icon(
          AppIcons.close,
          size: defaultIconSize - 8,
          color: context.customColors?.blackAndWhite,
        ),
      ),
    );
  }
}
