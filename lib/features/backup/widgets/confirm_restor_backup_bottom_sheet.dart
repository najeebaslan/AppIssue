import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/custom_button.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme.dart';
import '../../../core/helpers/helper_user.dart';
import '../../../core/router/routes_constants.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/widgets/custom_toast.dart';
import '../backup_cubit/backup_cubit.dart';

class ConfirmRestoreBackupBottomSheet extends StatelessWidget {
  const ConfirmRestoreBackupBottomSheet({super.key, required this.dataStore});
  final List<int> dataStore;

  @override
  Widget build(BuildContext context) {
    int initialTypeMethodRestoreIndex = TypeRestoreBackup.merge.index;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.1,
      maxChildSize: 1,
      expand: false,
      builder: (__, controller) => Padding(
        padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
        child: SingleChildScrollView(
          controller: controller,
          child: BlocListener<BackupCubit, BackupState>(
            listenWhen: (previous, current) => _shouldRebuildState(current),
            listener: (context, state) => _restoredStateListener(state, context),
            child: _buildBodyContent(initialTypeMethodRestoreIndex),
          ),
        ),
      ),
    );
  }

  StatefulBuilder _buildBodyContent(int initialTypeMethodRestoreIndex) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            SizedBox(height: defaultPadding.h),
            CircleAvatar(
              radius: 50.w,
              backgroundColor: AppColors.thirdAlarmColor.withValues(alpha: 0.09),
              child: Icon(
                AppIcons.warningFilled,
                color: AppColors.thirdAlarmColor,
                size: 70.w,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'chooseHowToInstallTheCopy'.tr(),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10.h),
            Text(
              initialTypeMethodRestoreIndex == 0
                  ? 'mergeDescription'.tr()
                  : 'replaceDescription'.tr(),
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium,
            ),
            SizedBox(height: 20.h),
            SizedBox(height: defaultPadding.h),
            SizedBox(height: 10.h),
            _buildRadioListTile(
              context: context,
              initialIndex: initialTypeMethodRestoreIndex,
              name: 'merge'.tr(),
              type: TypeRestoreBackup.merge,
              onChanged: (value) => setState(
                () => initialTypeMethodRestoreIndex = value?.toInt() ?? 0,
              ),
            ),
            SizedBox(height: defaultPadding.h),
            _buildRadioListTile(
              context: context,
              initialIndex: initialTypeMethodRestoreIndex,
              name: 'replace'.tr(),
              type: TypeRestoreBackup.replace,
              onChanged: (value) => setState(
                () => initialTypeMethodRestoreIndex = value?.toInt() ?? 0,
              ),
            ),
            SizedBox(height: defaultPadding.h * 3),
            CustomButton(
              onPressed: () {
                context.read<BackupCubit>().restoreBackup(
                      dataStore: dataStore,
                      typeResterBackup: TypeRestoreBackup.values[initialTypeMethodRestoreIndex],
                    );
              },
              label: 'install',
            ),
            SizedBox(height: defaultPadding.h),
          ],
        );
      },
    );
  }

  bool _shouldRebuildState(BackupState current) {
    return current is LoadingRestoredBackup ||
        current is DoneRestoredBackup ||
        current is ErrorRestoredBackup;
  }

  void _restoredStateListener(BackupState state, BuildContext context) {
    if (state is LoadingRestoredBackup) {
      context.showLoading();
    } else if (state is DoneRestoredBackup) {
      context.hideLoading();
      getIt.get<UserHelper>().saveIsUserInTrialMode(false);
      CustomToast.showSuccessToast('successful'.tr());
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutesConstants.navigationBar,
        (route) => false,
      );
    } else if (state is ErrorRestoredBackup) {
      context.hideLoading();
      CustomToast.showErrorToast(state.error);
    }
  }

  Widget _buildRadioListTile({
    required BuildContext context,
    required int initialIndex,
    required String name,
    required TypeRestoreBackup type,
    void Function(int?)? onChanged,
  }) {
    return RadioListTile.adaptive(
      contentPadding: EdgeInsets.symmetric(
        horizontal: defaultPadding,
        vertical: 5.h,
      ),
      dense: true,
      splashRadius: defaultBorderRadius,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          width: 1,
          color: type.index != initialIndex
              ? context.customColors!.blackAndWhite!.withValues(alpha: 0.3)
              : context.themeData.primaryColor,
        ),
      ),
      selectedTileColor: context.themeData.primaryColor.withValues(alpha: .1),
      selected: type.index == initialIndex,
      visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
      secondary: _buildIndicator(
        type: type,
        isSelected: type.index == initialIndex,
      ),
      title: Text(name, style: context.textTheme.bodyLarge),
      activeColor: AppColors.kPrimaryColor,
      value: type.index,
      groupValue: initialIndex,
      onChanged: onChanged,
    );
  }

  Widget _buildIndicator({required TypeRestoreBackup type, required bool isSelected}) {
    return Container(
      height: 40.h,
      width: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isSelected ? AppColors.kPrimaryColor : AppColors.kPrimaryColor.withValues(alpha: 0.6),
      ),
      child: Center(
        child: Icon(
          type == TypeRestoreBackup.merge ? AppIcons.merge : Icons.find_replace_sharp,
          color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
