import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/assets_constants.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/router/routes_constants.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/animations/animation_dialog.dart';
import '../backup_cubit/backup_cubit.dart';
import 'backup_elevated_button.dart';
import 'backup_header_title.dart';

class LetStartedSettingGoogleDrive extends StatefulWidget {
  const LetStartedSettingGoogleDrive({super.key, required this.nextPage});
  final VoidCallback nextPage;
  @override
  State<LetStartedSettingGoogleDrive> createState() => _LetStartedSettingGoogleDriveState();
}

class _LetStartedSettingGoogleDriveState extends State<LetStartedSettingGoogleDrive> {
  static int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    List<ListBackUpItems> listItems = [
      ListBackUpItems(
        title: 'backupSettings',
        imageUri: ImagesConstants.googleDrive,
      ),
      ListBackUpItems(
        title: 'createBackup',
        imageUri: ImagesConstants.folders,
        onTap: () {
          context.awesomeDialog(
            title: 'doYouWantUploadNewBackupToGoogleDrive'.tr(),
            context: context,
            dialogType: CustomDialogType.question,
            btnOkOnPress: context.read<BackupCubit>().uploadBackup,
          );
        },
      ),
      ListBackUpItems(
        title: 'downloadBackup',
        imageUri: ImagesConstants.downloadBackup,
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutesConstants.getBackupsView,
        ),
      ),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: defaultPadding.w,
      ),
      child: Column(
        children: [
          SizedBox(height: context.height * 0.1),
          const BackUpHeaderTitle(title: 'letStartSettingBackup'),
          SizedBox(height: context.height * 0.05),
          ...List.generate(
            listItems.length,
            (index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: BackUpElevatedButton(
                backgroundColor: _selectedIndex == index
                    ? AppColors.kPrimaryColor.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderSide: BorderSide(
                  color: _selectedIndex == index ? AppColors.kPrimaryColor : Colors.grey,
                  width: _selectedIndex == index ? 1.5 : 1,
                ),
                onPressed: () {
                  if (index == 0) widget.nextPage.call();
                  setState(() => _selectedIndex = index);
                  listItems[index].onTap?.call();
                },
                imageUri: listItems[index].imageUri,
                title: listItems[index].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ListBackUpItems {
  final String title;
  final String imageUri;
  final VoidCallback? onTap;

  ListBackUpItems({
    required this.title,
    required this.imageUri,
    this.onTap,
  });
}
