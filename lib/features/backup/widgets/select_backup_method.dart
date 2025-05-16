import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/services/services_locator.dart';

import '../../../core/constants/assets_constants.dart';
import '../../../core/constants/default_settings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../backup_cubit/backup_cubit.dart';
import 'backup_elevated_button.dart';
import 'backup_header_title.dart';
import 'let_started_setting_google_drive.dart';

class SelectBackupMethod extends StatefulWidget {
  const SelectBackupMethod({super.key, required this.previousPage});
  final VoidCallback previousPage;

  @override
  State<SelectBackupMethod> createState() => _SelectBackupMethodState();
}

class _SelectBackupMethodState extends State<SelectBackupMethod> {
  List<String> descriptionMethods = [
    'automaticBackupDescription',
    'manualBackupDescription',
  ];
  static List<ListBackUpItems> listItems = [
    ListBackUpItems(
      title: 'automaticBackup',
      imageUri: ImagesConstants.backupAutomatically,
    ),
    ListBackUpItems(
      title: 'manualBackup',
      imageUri: ImagesConstants.backupManually,
    ),
  ];
  static int _selectedIndex = getIt.get<UserHelper>().getBackupStatus().index;

  static List<String> items = [
    BackupOptions.daily.name,
    BackupOptions.weekly.name,
    BackupOptions.monthly.name,
  ];
  static String selectedValue = getIt.get<UserHelper>().getBackupOptions().name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: context.height * 0.1),
          const Center(child: BackUpHeaderTitle(title: 'backupSettingsTo')),
          SizedBox(height: context.height * 0.05),
          ...List.generate(listItems.length, (index) {
            bool isSelected = _selectedIndex == index;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: BackUpElevatedButton(
                backgroundColor:
                    _selectedIndex == index ? AppColors.kPrimaryColor.withValues(alpha: 0.1) : null,
                radioWidget: Row(
                  children: [
                    if (index == 0 && _selectedIndex == index)
                      StatefulBuilder(builder: (context, rebuild) {
                        return DropdownButton<String>(
                          value: selectedValue,
                          underline: const SizedBox.shrink(),
                          dropdownColor: context.customColors?.backgroundTextField,
                          icon: const Icon(
                            AppIcons.chevronDown,
                            size: defaultIconSize / 1.5,
                          ),
                          onChanged: (String? newValue) {
                            getIt.get<UserHelper>().saveBackupOptions(
                                  BackupOptions.values.byName(
                                    newValue ?? DefaultSettings.backupOptions.name,
                                  ),
                                );
                            rebuild(() => selectedValue = newValue ?? '');
                          },
                          items: items.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value.tr(),
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontSize: 13.sp,
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Icon(
                        isSelected ? Icons.radio_button_on : Icons.radio_button_off,
                        color: isSelected ? AppColors.kPrimaryColor : Colors.grey,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                borderSide: BorderSide(
                  color: isSelected ? AppColors.kPrimaryColor : Colors.grey,
                  width: isSelected ? 1.5 : 1,
                ),
                onPressed: () {
                  setState(() => _selectedIndex = index);
                  listItems[index].onTap?.call();
                  getIt.get<UserHelper>().saveBackupStatus(
                        _selectedIndex == 0 ? BackupSyncTypes.auto : BackupSyncTypes.manual,
                      );
                },
                imageUri: listItems[index].imageUri,
                title: listItems[index].title,
              ),
            );
          }),
          if (_selectedIndex >= 0) ...[
            SizedBox(height: defaultPadding.h),
            Text(
              _selectedIndex == 0 ? 'automaticBackup'.tr() : 'manualBackup'.tr(),
              style: context.textTheme.titleMedium,
            ),
            SizedBox(height: 5.h),
            Text(
              descriptionMethods[_selectedIndex].tr(),
              style: context.textTheme.bodyLarge?.copyWith(
                color: context.isDark ? Colors.grey.shade400 : Colors.grey.shade800,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
