import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/base_bottom_sheet.dart';
import 'package:issue/features/accused/accused_cubit/accused_cubit.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_toast.dart';
import '../../../core/widgets/image/select_image_cubit/select_image_cubit.dart';
import '../../../core/widgets/shimmer.dart';
import '../../../data/models/profile_model.dart';
import '../profile_cubit/profile_cubit.dart';
import '../widgets/profile/edit_profile_bottom_sheet_content.dart';
import '../widgets/profile/profile_bloc_consumer.dart';
import '../widgets/profile/profile_image_widget.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  void _fetchProfile() {
    final userId = getIt.get<FirebaseAuth>().currentUser!.uid;
    context.read<ProfileCubit>().getProfile(userId);
  }

  ValueNotifier<double> initialChildSize = ValueNotifier(0.5);
  @override
  void dispose() {
    initialChildSize.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfileBlocConsumer(
      child: (profile) {
        return SizedBox(
          height: 350.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 15.h),
                _buildImageProfile(),
                SizedBox(height: 10.h),
                _buildTextOrLoading(
                  profile.name,
                  context.textTheme.headlineLarge,
                ),
                SizedBox(height: 5.h),
                _buildTextOrLoading(
                  profile.email,
                  context.textTheme.bodyMedium,
                ),
                SizedBox(height: 20.h),
                _buildEditButton(context, profile),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Flexible _buildImageProfile() {
    return Flexible(
      child: BlocConsumer<ProfileCubit, ProfileState>(
        listenWhen: (previous, current) =>
            current is ErrorUpdateImageState || current is SuccessUpdateImageState,
        listener: (context, state) {
          if (state is ErrorUpdateImageState) {
            CustomToast.showErrorToast(state.error);
          }
          if (state is SuccessUpdateImageState) {
            context.read<AccusedCubit>().onRefreshProfile();
            context.read<SelectImageCubit>()
              ..clearImage()
              ..setState();
          }
        },
        buildWhen: (previous, current) =>
            current is LoadingUpdateImageState ||
            current is SuccessUpdateImageState ||
            current is ErrorUpdateImageState,
        builder: (context, state) {
          return ProfileImageWidget(
            imageSize: 200,
            imageUri: context.read<ProfileCubit>().adaptiveImageUri(),
            isLoading: state is LoadingUpdateImageState,
            enablePickImages: !context.read<ProfileCubit>().isSignInUsingGoogle,
          );
        },
      ),
    );
  }

  Widget _buildTextOrLoading(String? text, TextStyle? style) {
    if (text != null) return Text(text, style: style);
    return CustomShimmer(height: 10.h, width: 150.w);
  }

  Widget _buildEditButton(BuildContext context, ProfileModel profile) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            side: BorderSide(
              width: 0.8,
              color: AppColors.iconColor.withValues(alpha: 0.2),
            ),
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
      ),
      onPressed: () async {
        await BaseBottomSheet()
            .show(
          headerTitle: 'dataAccount',
          context: context,
          isScrollControlled: true,
          initialChildSize: initialChildSize,
          child: (controller) {
            return EditProfileBottomSheetContent(
              onFieldSubmitted: (value) => initialChildSize.value = 0.5,
              onTapTextFormField: () => initialChildSize.value = 0.8,
              profileModel: profile,
              controller: controller!,
            );
          },
        )
            .then((updatedProfile) {
          if (context.mounted && updatedProfile != null && updatedProfile == true) {
            context.read<ProfileCubit>().refreshProfileView();
          }
          initialChildSize.value = 0.5;
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'account'.tr(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: AppColors.white,
            ),
          ),
          const Icon(
            AppIcons.back,
            color: AppColors.white,
          ),
        ],
      ),
    );
  }
}
