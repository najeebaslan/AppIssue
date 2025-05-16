import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/router/routes_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animations/animation_dialog.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../auth/auth_cubit/auth_cubit.dart';
import 'list_tile_setting.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          current is SuccessSignOutState ||
          current is LoadingSignOutState ||
          current is ErrorSignOutState,
      listener: (context, state) {
        if (state is LoadingSignOutState) {
          context.showLoading();
        } else if (state is ErrorSignOutState) {
          CustomToast.showErrorToast(state.error);
        } else if (state is SuccessSignOutState) {
          context.hideLoading();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutesConstants.signInView,
            (predicate) => false,
          );
        }
      },
      child: ListTileSetting(
        isLogoutButton: true,
        icon: AppIcons.logout,
        title: 'logout',
        onTap: ()  {
          context.awesomeDialog(
            title: 'doYouWantLogout'.tr(),
            context: context,
            btnOkText: 'logout'.tr(),
            dialogType: CustomDialogType.question,
            color: AppColors.errorDeepColor,
            btnOkOnPress: () => BlocProvider.of<AuthCubit>(context).signOut(),
          );
        },
      ),
    );
  }
}
