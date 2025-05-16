import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis/drive/v2.dart' as api_v2;
import 'package:intl/intl.dart' as intl;
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/iterable_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/theme/app_colors.dart';
import 'package:issue/core/theme/theme.dart';
import 'package:issue/core/widgets/adaptive_them_container.dart';
import 'package:issue/core/widgets/animations/animation_dialog.dart';
import 'package:issue/core/widgets/not_found_data.dart';
import 'package:issue/features/backup/backup_cubit/backup_cubit.dart';

class BackupList extends StatelessWidget {
  final List<api_v2.File> backups;

  const BackupList({super.key, required this.backups});

  @override
  Widget build(BuildContext context) {
    if (backups.isEmptyOrNull) {
      return NotFoundData(error: 'notFountBackups'.tr());
    }
    _sortByDateUploadedRecently(backups);
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: defaultPadding.h),
      itemCount: backups.length,
      itemBuilder: (context, index) {
        final backup = backups[index];
        return AdaptiveThemeContainer(
          margin: EdgeInsets.symmetric(
            vertical: 8.h,
            horizontal: defaultPadding.w,
          ),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              backgroundColor: context.themeData.primaryColor.withValues(alpha: 0.13),
              child: Icon(
                AppIcons.downloadBackup,
                color: context.themeData.primaryColor,
              ),
            ),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -1),
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    _getDate(backup.modifiedDate!.toLocal().toString(), context),
                    textAlign: TextAlign.right,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                const Icon(AppIcons.time, size: 20),
              ],
            ),
            subtitle: Row(
              children: [
                Text(
                  '${"sizeBackup".tr()} ${_formatFileSize(
                    int.tryParse(backup.fileSize.toString()) ?? 0,
                  )}',
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  style: context.textTheme.titleSmall?.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: context.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                  ),
                ),
                const Icon(Icons.sd_storage_outlined, size: 15),
              ],
            ),
            trailing: _buildPopupMenuButton(context, backup, backups),
          ),
        );
      },
    );
  }

  PopupMenuButton<dynamic> _buildPopupMenuButton(
    BuildContext context,
    api_v2.File backup,
    List<api_v2.File> backups,
  ) {
    return PopupMenuButton(
      color: context.isDark ? null : Colors.white,
      onSelected: (value) {
        if (value == 1) {
          context.read<BackupCubit>().downloadBackup(
                backupID: backup.id.validate(),
              );
        } else {
          context.awesomeDialog(
            title: 'deleteBackup'.tr(),
            context: context,
            dialogType: CustomDialogType.warning,
            color: AppColors.errorDeepColor,
            btnOkOnPress: () => context.read<BackupCubit>().deleteBackup(
                  backupID: backup.id.validate(),
                  listBackups: backups,
                ),
            description: 'deleteBackupDescription'.tr(),
          );
        }
      },
      itemBuilder: (BuildContext context) => [
        _buildPopupMenuItem('download'.tr(), AppIcons.download, 1, context),
        _buildPopupMenuItem('delete'.tr(), AppIcons.delete, 2, context),
      ],
      child: Icon(
        AppIcons.moreVertical,
        color: context.customColors?.blackAndWhite?.withValues(alpha: 0.5),
      ),
    );
  }

  String _getDate(String formatter, BuildContext context) {
    return intl.DateFormat('yyyy/MM/dd  (hh:mm a)', context.locale.languageCode).format(
      DateTime.tryParse(formatter) ?? DateTime.now(),
    );
  }

  void _sortByDateUploadedRecently(List<api_v2.File> backups) {
    backups.sort((a, b) {
      return b.createdDate!.compareTo(a.createdDate!);
    });
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
    }
  }

  PopupMenuItem _buildPopupMenuItem(
      String title, IconData iconData, int position, BuildContext context) {
    return PopupMenuItem(
      value: position,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: position == 1
                  ? context.textTheme.bodyMedium?.color?.withValues(alpha: 0.8)
                  : AppColors.errorDeepColor,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Icon(
              iconData,
              size: 25,
              color: position == 1 ? AppColors.kPrimaryColor : AppColors.errorDeepColor,
            ),
          ),
        ],
      ),
    );
  }
}
