import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/context_extension.dart';
import '../../../../core/extensions/string_extension.dart';
import '../../../../core/router/routes_constants.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/image/select_image_cubit/select_image_cubit.dart';
import '../../../../data/models/profile_model.dart';
import '../../../../data/repositories/profile_repository.dart';
import '../../profile_cubit/profile_cubit.dart';
import 'confirm_delete_account_bottom_sheet.dart';
import 'delete_account_dialog.dart';
import 'update_profile_bloc_listener.dart';

class EditProfileBottomSheetContent extends StatefulWidget {
  const EditProfileBottomSheetContent({
    super.key,
    required this.profileModel,
    required this.controller,
    required this.onFieldSubmitted,
    required this.onTapTextFormField,
  });

  final ProfileModel profileModel;
  final ScrollController controller;
  final VoidCallback onTapTextFormField;
  final Function(String)? onFieldSubmitted;

  @override
  State<EditProfileBottomSheetContent> createState() => _EditProfileBottomSheetContentState();
}

class _EditProfileBottomSheetContentState extends State<EditProfileBottomSheetContent> {
  late final TextEditingController _usernameController;

  @override
  void initState() {
    super.initState();

    _usernameController = TextEditingController(text: widget.profileModel.name);
    usernameListener();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameController.removeListener(usernameListener);
    super.dispose();
  }

  bool showSaveButton = false;

  void usernameListener() {
    _usernameController.addListener(() {
      if (_usernameController.text != widget.profileModel.name) {
        showSaveButton = true;
      } else {
        showSaveButton = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileCubit>(),
      child: UpdateProfileBlocListener(
        contextUpdateProfileWidget: context,
        child: (profileCubit) => SingleChildScrollView(
          padding: EdgeInsets.zero,
          controller: widget.controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: defaultPadding.h),
              Text('username'.tr(), style: context.textTheme.bodyLarge),
              SizedBox(height: 5.h),
              _buildUsernameField(),
              SizedBox(height: 10.h),
              Text('password'.tr(), style: context.textTheme.bodyLarge),
              SizedBox(height: 5.h),
              _buildForgotPassword(),
              SizedBox(height: defaultPadding.h / 2),
              _buildDeleteAccountButton(context),
              SizedBox(height: defaultPadding.h),
              if (_usernameController.text != widget.profileModel.name)
                _buildSaveButton(profileCubit),
              SizedBox(height: defaultPadding.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: defaultPadding * 1.2),
      child: CustomTextField(
        borderRadius: BorderRadius.circular(10.r),
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.name,
        fillColor: context.isDark ? Colors.grey.withValues(alpha: 0.1) : null,
        autofillHints: const [AutofillHints.name],
        onFieldSubmitted: widget.onFieldSubmitted,
        placeholder: 'username'.tr(),
        maxLength: 32,
        onTap: widget.onTapTextFormField,
        controller: _usernameController,
      ),
    );
  }

  Widget _buildForgotPassword() {
    return Container(
      height: 50.h,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.1),
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '*************',
              style: context.textTheme.bodyLarge?.copyWith(
                height: 2.5,
              ),
            ),
            const Spacer(),
            InkWell(
              customBorder: const RoundedRectangleBorder(),
              onTap: () => Navigator.pushNamed(
                context,
                AppRoutesConstants.forgotPasswordView,
                arguments: false,
              ),
              child: Text(
                'change'.tr(),
                style: context.textTheme.bodyLarge?.copyWith(height: 2.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(ProfileCubit profileCubit) {
    return CustomButton(
      enable: _usernameController.text != widget.profileModel.name,
      onPressed: () => _updateProfile(context, profileCubit),
      label: 'save',
    );
  }

  Widget _buildDeleteAccountButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showDeleteAccountDialog(context),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        )),
      ),
      child: Text(
        'deleteMyAccount'.tr(),
        style: context.textTheme.bodyLarge?.copyWith(
          color: AppColors.errorColor,
        ),
      ),
    );
  }

  Future<void> _updateProfile(BuildContext context, ProfileCubit profileCubit) async {
    final newName = _usernameController.text;
    if (profileCubit.isSignInUsingGoogle) {
      CustomToast.showDefaultToast('cannot_change_username_with_google'.tr());
    } else if (newName == widget.profileModel.name) {
      CustomToast.showErrorToast('notEditAnyData'.tr());
    } else if (newName.isEmptyOrNull) {
      CustomToast.showErrorToast('pleaseAddName'.tr());
    } else {
      profileCubit.updateProfile(
        UpdateProfileParameters(
          name: newName,
          userId: getIt.get<FirebaseAuth>().currentUser!.uid,
        ),
      );
    }
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, animation, secondaryAnimation) {
        final curveAnimation = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(curveAnimation),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(curveAnimation),
            child: BlocProvider(
              create: (context) => SelectImageCubit(),
              child: BlocProvider(
                create: (context) => getIt<ProfileCubit>(),
                child: DeleteAccountDialog(
                  profileModel: widget.profileModel,
                  onConfirm: () {
                    onConfirmDeleteAccountBottomSheet();
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void onConfirmDeleteAccountBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      useRootNavigator: true,
      isScrollControlled: true,
      enableDrag: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)),
      ),
      barrierColor: context.isDark
          ? context.themeData.scaffoldBackgroundColor.withValues(alpha: 0.4)
          : AppColors.iconColor.withValues(alpha: 0.5),
      builder: (BuildContext context) {
        return BlocProvider<ProfileCubit>(
          create: (context) => getIt<ProfileCubit>(),
          child: ConfirmDeleteAccountBottomSheet(
            profileImage: widget.profileModel.profileImage,
          ),
        );
      },
    );
  }
}
