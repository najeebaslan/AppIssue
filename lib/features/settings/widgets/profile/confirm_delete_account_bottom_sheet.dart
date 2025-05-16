import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/helpers/shared_prefs_service.dart';
import '../../../../core/router/routes_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/adaptive_them_container.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../profile_cubit/profile_cubit.dart';

class ConfirmDeleteAccountBottomSheet extends StatefulWidget {
  const ConfirmDeleteAccountBottomSheet({super.key, required this.profileImage});
  final String? profileImage;

  @override
  State<ConfirmDeleteAccountBottomSheet> createState() => _ConfirmDeleteAccountBottomSheetState();
}

class _ConfirmDeleteAccountBottomSheetState extends State<ConfirmDeleteAccountBottomSheet> {
  late final TextEditingController _passwordController;
  late FocusNode _focusNode;
  bool obscureText = true;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isExpanded = !_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveThemeContainer(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: !_isExpanded ? 0.6 : 0.95,
        minChildSize: 0.1,
        maxChildSize: 1,
        expand: false,
        builder: (__, controller) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
            child: BlocListener<ProfileCubit, ProfileState>(
              listenWhen: (previous, current) =>
                  current is LoadingDeleteAccountState ||
                  current is SuccessDeleteAccountState ||
                  current is ErrorDeleteAccountState,
              listener: (context, state) {
                if (state is LoadingDeleteAccountState) {
                  context.showLoading();
                } else if (state is SuccessDeleteAccountState) {
                  context.hideLoading();

                  HelperSharedPreferences.clear().whenComplete(() {
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutesConstants.signUpView,
                        (route) => false,
                      );
                    }
                  });
                } else if (state is ErrorDeleteAccountState) {
                  context.hideLoading();
                  CustomToast.showErrorToast(state.error);
                }
              },
              child: SingleChildScrollView(
                controller: controller,
                child: Column(
                  children: [
                    SizedBox(height: defaultPadding.h),
                    CircleAvatar(
                      radius: 50.w,
                      backgroundColor: AppColors.errorDeepColor.withValues(alpha: 0.07),
                      child: Icon(
                        AppIcons.warningFilled,
                        color: AppColors.errorDeepColor,
                        size: 70.w,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      'deleteMyAccount'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'conformDeleteMyAccountDescription'.tr(),
                      textAlign: TextAlign.center,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: context.customColors?.blackAndWhite,
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return CustomTextField(
                          focusNode: _focusNode,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icon(Icons.lock, color: AppColors.kPrimaryColor),
                          obscureText: obscureText,
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => obscureText = !obscureText),
                            child: Icon(
                              obscureText ? Icons.visibility : Icons.visibility_off,
                              color: !obscureText
                                  ? AppColors.kPrimaryColor
                                  : AppColors.kPrimaryColor.withValues(alpha: 0.6),
                            ),
                          ),
                          placeholder: 'password'.tr(),
                          maxLength: 32,
                          controller: _passwordController,
                        );
                      },
                    ),
                    SizedBox(height: defaultPadding.h * 3),
                    ElevatedButton(
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50.h)),
                        backgroundColor: WidgetStateProperty.all(AppColors.errorDeepColor),
                        shape: WidgetStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        )),
                      ),
                      onPressed: () => onConformDeleteAccount(context),
                      child: Text(
                        'deleteMyAccount'.tr(),
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: defaultPadding.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void onConformDeleteAccount(BuildContext context) {
    if (_passwordController.text.isEmpty) {
      CustomToast.showErrorToast('emptyPassword'.tr());
    } else if (_passwordController.text.length < 6) {
      CustomToast.showErrorToast('lengthPassword'.tr());
    } else {
      context.read<ProfileCubit>().deleteMyAccount(
            password: _passwordController.text.trim(),
            imageUri: widget.profileImage,
          );
    }
  }
}
