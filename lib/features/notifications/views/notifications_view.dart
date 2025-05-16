import 'package:easy_localization/easy_localization.dart' as easy_localization;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/iterable_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/widgets/custom_app_bar.dart';
import 'package:issue/features/notifications/notifications_cubit/notifications_cubit.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/not_found_data.dart';
import '../../../data/models/notification_model.dart';
import '../../backup/widgets/loading_backups.dart';
import '../widgets/list_view_notifications.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<NotificationsCubit>(context).getNotifications();
  }

  bool sortByNewsNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        size: Size.fromHeight(kTextTabBarHeight.h),
        title: Text('notifications'.tr(), style: context.textTheme.titleLarge),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is ErrorGetNotifications) {
            return NotFoundData(error: state.error, icon: AppIcons.emptyNotifications);
          } else if (state is ErrorDeleteNotifications) {
            return NotFoundData(error: state.error);
          } else if (state is SuccessGetNotifications) {
            return _buildBodyContent(state.notificationAdapter);
          }
          if (state is SuccessDeleteNotifications) {
            return NotFoundData(
              error: 'doneDeletedNotifications'.tr(),
              icon: AppIcons.notificationsOff,
              description: "emptyNotificationsDescription".tr(),
            );
          }
          return const LoadingBackups();
        },
      ),
    );
  }

  Widget _buildBodyContent(List<NotificationAdapter> notificationAdapter) {
    if (notificationAdapter.isEmptyOrNull) {
      return NotFoundData(
        error: 'emptyNotifications'.tr(),
        icon: AppIcons.notificationsOff,
        description: "emptyNotificationsDescription".tr(),
      );
    }
    _sortByDateNotifications(notificationAdapter, sortByNewsNotification);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 10.h, right: defaultPadding.w, left: defaultPadding.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(getCountNotifications(notificationAdapter), style: context.textTheme.titleSmall),
              const Spacer(),
              customRawMaterialButton(
                icon: AppIcons.delete,
                onPressed: context.read<NotificationsCubit>().clearAllNotifications,
              ),
              SizedBox(width: defaultPadding.w),
              customRawMaterialButton(
                icon: AppIcons.sort,
                onPressed: () {
                  _sortByDateNotifications(notificationAdapter, !sortByNewsNotification);
                  setState(() => sortByNewsNotification = !sortByNewsNotification);
                },
              )
            ],
          ),
        ),
        Expanded(child: ListViewNotifications(notificationAdapter: notificationAdapter)),
      ],
    );
  }

  String getCountNotifications(List<NotificationAdapter> notificationAdapter) {
    int countNotifications = notificationAdapter.length;
    if (countNotifications == 1) return "oneNotification".tr();
    if (countNotifications == 2) return "towNotification".tr();
    if (countNotifications > 10) return '$countNotifications ${"singleNotifications".tr()}';
    return '$countNotifications ${"notification".tr()}';
  }

  ConstrainedBox customRawMaterialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(Size(36.w, 40.h)),
      child: AspectRatio(
        aspectRatio: 1.9 / 2,
        child: RawMaterialButton(
          onPressed: onPressed,
          elevation: 0,
          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: context.customColors!.blackAndWhite!, width: 0.2),
            borderRadius: BorderRadius.circular(5),
          ),
          fillColor: context.customColors?.backgroundTextField,
          child: Icon(
            icon,
            size: defaultIconSize - 4,
            color: context.customColors!.blackAndWhite?.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  LayoutBuilder buildRemainingRow({
    required BuildContext context,
    required DateTime accusedDate,
    required DateTime notificationDate,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth / 2),
              child: Text(
                '${'since'.tr()} ${intl.DateFormat.yMd().format(accusedDate)}',
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.bodyMedium,
              ),
            ),
            const Spacer(),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth / 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      intl.DateFormat.yMd().format(notificationDate),
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontSize: context.locale.isArabic ? null : 13.5.sp,
                        color: context.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  const Icon(AppIcons.alertUrgent, size: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _sortByDateNotifications(
      List<NotificationAdapter> notifications, bool sortByNewsNotification) {
    notifications.sort(
      (a, b) {
        final start = DateTime.parse(b.notificationModel.notificationDate.validate());
        final end = DateTime.parse(a.notificationModel.notificationDate.validate());
        if (sortByNewsNotification) {
          return start.compareTo(end);
        } else {
          return end.compareTo(start);
        }
      },
    );
  }
}
