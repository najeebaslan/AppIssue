import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/data/models/accuse_model.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/animations/animation_dialog.dart';
import '../accused_cubit/accused_cubit.dart';
import '../logic/share_accused.dart';

enum AccusedPopUpMenuStatus { edit, share, end, reactivate, delete }

class PopupMenuDetailsAccused extends StatelessWidget {
  final AccusedModel accused;
  final VoidCallback onEditOnTap;
  final AccusedCubit accusedCubit;

  const PopupMenuDetailsAccused({
    super.key,
    required this.accused,
    required this.onEditOnTap,
    required this.accusedCubit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
      child: PopupMenuButton<int>(
        splashRadius: defaultBorderRadius,
        icon: CircleAvatar(
          radius: 15,
          backgroundColor: context.themeData.iconTheme.color?.withValues(
            alpha: context.isDark ? 0.10 : 0.2,
          ),
          child: Icon(
            AppIcons.moreVertical,
            color: context.customColors?.blackAndWhite?.withValues(alpha: 0.6),
            size: defaultIconSize,
          ),
        ),
        elevation: 10,
        menuPadding: EdgeInsets.symmetric(horizontal: 10.w),
        color: context.isDark ? const Color(0xff1B2349) : AppColors.white,
        shadowColor: context.themeData.scaffoldBackgroundColor,
        onSelected: (int value) => _handleMenuSelection(value, context),
        offset: Offset(0.0, AppBar().preferredSize.height * 0.80),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        itemBuilder: (ctx) => _buildMenuItems(context),
      ),
    );
  }

  List<PopupMenuItem<int>> _buildMenuItems(BuildContext context) {
    return [
      _buildPopupMenuItem('edit', AppIcons.edit, AccusedPopUpMenuStatus.edit.index, context),
      _buildPopupMenuItem('share', AppIcons.share, AccusedPopUpMenuStatus.share.index, context),
      _buildPopupMenuItem(
        accused.isCompleted == 0 ? 'end' : 'reactivate',
        accused.isCompleted == 0 ? AppIcons.done : AppIcons.reActive,
        accused.isCompleted == 0
            ? AccusedPopUpMenuStatus.end.index
            : AccusedPopUpMenuStatus.reactivate.index,
        context,
      ),
      _buildPopupMenuItem('delete', AppIcons.delete, AccusedPopUpMenuStatus.delete.index, context),
    ];
  }

  PopupMenuItem<int> _buildPopupMenuItem(
    String title,
    IconData iconData,
    int position,
    BuildContext context,
  ) {
    return PopupMenuItem(
      value: position,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title.tr(), style: context.textTheme.bodyMedium),
          Icon(iconData, color: context.customColors?.blackAndWhite?.withValues(alpha: 0.4)),
        ],
      ),
    );
  }

  void _handleMenuSelection(int value, BuildContext context) {
    switch (value) {
      case 0:
        onEditOnTap();
        break;
      case 1:
        ShareAccusedAsPDF().onShareAccused(accused, context);
        break;
      case 2:
        _showConfirmationDialog(
          context,
          title: "${'endCharge'.tr()} ${accused.name}",
          description: "${'doYouWantTerminateCharge'.tr()} ${accused.name}",
          onConfirm: () => accusedCubit.accuseCompleted(accused.id!),
          color: AppColors.errorDeepColor,
        );
        break;
      case 3:
        _showConfirmationDialog(
          context,
          title: "${'reactivate'.tr()} ${accused.name}",
          description: "${'doYouWantReActiveCharge'.tr()} ${accused.name}",
          onConfirm: () => accusedCubit.reActiveAccuse(accused.id!),
        );
        break;
      case 4:
        _showConfirmationDialog(
          context,
          title: "${'deleteAccused'.tr()} ${accused.name}",
          description: "${'doYouWantDeleteAccused'.tr()} ${accused.name}",
          onConfirm: () {
            accusedCubit.deleteAccused(accused.id!);
            Navigator.pop(context);
          },
          color: AppColors.errorDeepColor,
        );
        break;
    }
  }

  void _showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onConfirm,
    Color? color,
  }) {
    context.awesomeDialog(
      dialogType: CustomDialogType.warning,
      color: color,
      title: title,
      description: description,
      context: context,
      btnOkOnPress: onConfirm,
    );
  }
}
