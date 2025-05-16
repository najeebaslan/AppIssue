import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../core/router/routes_constants.dart';
import '../../../core/widgets/custom_toast.dart';
import '../accused_cubit/accused_cubit.dart';

class AddAccusedBlocListener extends StatelessWidget {
  const AddAccusedBlocListener({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AccusedCubit, AccusedState>(
      listenWhen: (previous, current) =>
          current is LoadingAddAccused ||
          current is SuccessAddAccused ||
          current is ErrorAddAccused,
      listener: (context, state) {
        if (state is LoadingAddAccused) {
          context.showLoading();
        } else if (state is SuccessAddAccused) {
          context.hideLoading();
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutesConstants.navigationBar,
            (route) => false,
          );
        } else if (state is ErrorAddAccused) {
          context.hideLoading();
          CustomToast.showErrorToast(state.error);
        }
      },
      child: child,
    );
  }
}
