import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:focused_menu/modals.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/router/routes_constants.dart';
import 'package:issue/data/models/accuse_model.dart';
import 'package:issue/features/accused/accused_cubit/accused_cubit.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animations/animation_dialog.dart';
import '../../../core/widgets/custom_focused_menu.dart';
import '../../accused/accused_details_view.dart';
import '../../accused/logic/share_accused.dart';
import 'accused_details_card_content.dart';
import 'base_hero_flip_animation.dart';

class AccusedDetailsCard extends StatelessWidget {
  const AccusedDetailsCard({super.key, required this.index});
  final int index;
  @override
  Widget build(BuildContext context) {
    AccusedModel accused = context.read<AccusedCubit>().listAccused[index];
    return BaseHeroFlipAnimation(
      addMaterial: true,
      heroTag: accused.id.toString(),
      child: CustomFocusedMenuHolder(
        menuItems: _buildMenuItems(context, accused),
        child: AccusedDetailsCardContent(accused: accused),
        onPressed: () => Navigator.push(
          context,
          createFadeInRoute(
            routePageBuilder: (context, __, _) {
              return AccusedDetailsView(accusedModel: accused);
            },
          ),
        ),
      ),
    );
  }

  Route createFadeInRoute({required RoutePageBuilder routePageBuilder}) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 600),
      pageBuilder: routePageBuilder,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  List<FocusedMenuItem> _buildMenuItems(BuildContext context, AccusedModel accused) {
    return [
      FocusedMenuItem(
        title: Text(
          'edit'.tr(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
          ),
        ),
        onPressed: () async {
          Navigator.pushNamed(
            context,
            AppRoutesConstants.addAccusedView,
            arguments: accused,
          );
        },
        trailingIcon: Icon(
          AppIcons.edit,
          color: AppColors.iconColor,
        ),
      ),
      FocusedMenuItem(
        title: Text(
          'share'.tr(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
          ),
        ),
        onPressed: () {
          ShareAccusedAsPDF().onShareAccused(accused, context);
        },
        trailingIcon: Icon(
          AppIcons.share,
          color: AppColors.iconColor,
        ),
      ),
      FocusedMenuItem(
        title: Text(
          accused.isCompleted == 0 ? 'end'.tr() : 'reactivate'.tr(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
          ),
        ),
        onPressed: () {
          context.awesomeDialog(
            dialogType: CustomDialogType.warning,
            color: AppColors.errorDeepColor,
            description: accused.isCompleted == 0
                ? "${'doYouWantTerminateCharge'.tr()} ${accused.name}"
                : "${'doYouWantReActiveCharge'.tr()} ${accused.name}",
            title: accused.isCompleted == 0
                ? "${'endCharge'.tr()} ${accused.name}"
                : "${'reactivate'.tr()} ${accused.name}",
            context: context,
            btnOkOnPress: () {
              if (accused.isCompleted == 0) {
                context.read<AccusedCubit>().accuseCompleted(accused.id!);
              } else {
                context.read<AccusedCubit>().reActiveAccuse(accused.id!);
              }
            },
          );
        },
        trailingIcon: Icon(
          accused.isCompleted == 0 ? AppIcons.done : AppIcons.reActive,
          color: AppColors.iconColor,
        ),
      ),
      FocusedMenuItem(
        title: Text(
          'delete'.tr(),
          style: context.textTheme.bodyMedium?.copyWith(
            color: AppColors.errorDeepColor,
          ),
        ),
        onPressed: () {
          context.awesomeDialog(
            dialogType: CustomDialogType.warning,
            color: AppColors.errorDeepColor,
            description: "${'doYouWantDeleteAccused'.tr()} ${accused.name}",
            title: "${'deleteAccused'.tr()} ${accused.name}",
            context: context,
            btnOkOnPress: () {
              context.read<AccusedCubit>().deleteAccused(accused.id!);
            },
          );
        },
        trailingIcon: Icon(
          AppIcons.delete,
          color: AppColors.errorDeepColor,
        ),
      ),
    ];
  }
}
