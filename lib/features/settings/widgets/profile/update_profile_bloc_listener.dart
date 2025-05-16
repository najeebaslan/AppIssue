import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../../core/widgets/custom_toast.dart';
import '../../profile_cubit/profile_cubit.dart';

class UpdateProfileBlocListener extends StatelessWidget {
  const UpdateProfileBlocListener(
      {super.key, required this.contextUpdateProfileWidget, required this.child});
  final BuildContext contextUpdateProfileWidget;

  final Function(ProfileCubit profileCubit) child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          current is LoadingUpdateProfileState ||
          current is SuccessUpdateProfileState ||
          current is ErrorUpdateProfileState,
      listener: (context, state) {
        if (state is LoadingUpdateProfileState) {
          context.showLoading();
        } else if (state is SuccessUpdateProfileState) {
          context.hideLoading(); // hide loading
          bool updatedProfile = true;
          Navigator.pop(contextUpdateProfileWidget, updatedProfile); // hide bottom sheet
        } else if (state is ErrorUpdateProfileState) {
          context.hideLoading();
          CustomToast.showErrorToast(state.error);
        }
      },
      child: child(context.read<ProfileCubit>()),
    );
  }
}
