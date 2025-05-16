import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/not_found_data.dart';

import '../../../../core/services/services_locator.dart';
import '../../../../core/widgets/adaptive_them_container.dart';
import '../../../../core/widgets/image/select_image_cubit/select_image_cubit.dart';
import '../../../../core/widgets/shimmer.dart';
import '../../../../data/models/profile_model.dart';
import '../../../accused/accused_cubit/accused_cubit.dart';
import '../../profile_cubit/profile_cubit.dart';

class ProfileBlocConsumer extends StatelessWidget {
  const ProfileBlocConsumer({super.key, required this.child});
  final Function(ProfileModel profileModel) child;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SelectImageCubit(),
      child: AdaptiveThemeContainer(
        width: context.width,
        child: BlocConsumer<ProfileCubit, ProfileState>(
          buildWhen: (previous, current) =>
              current is SuccessGetProfileState ||
              current is LoadingGetProfileState ||
              current is SuccessUpdateProfileState ||
              current is SuccessUpdateProfileState ||
              current is ErrorGetProfileState,
          listener: (context, state) {
            if (state is RefreshProfileState) {
              final userId = getIt.get<FirebaseAuth>().currentUser!.uid;
              context.read<ProfileCubit>().getProfile(userId);
              context.read<AccusedCubit>().onRefreshProfile();
            } else if (state is SuccessUpdateProfileState) {
              context.read<AccusedCubit>().onRefreshProfile();
            }
          },
          builder: (context, state) {
            if (state is SuccessGetProfileState) {
              return child(state.profileModel);
            }
            if (state is LoadingGetProfileState) {
              return const LoadingWidget();
            }
            if (state is ErrorGetProfileState) {
              return NotFoundData(error: state.error);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15.h),
            const Flexible(
              child: CustomShimmer(
                height: 200,
                width: 200,
                isCircle: true,
              ),
            ),
            SizedBox(height: 15.h),
            CustomShimmer(height: 10.h, width: 150.w),
            SizedBox(height: 15.h),
            CustomShimmer(height: 10.h, width: 150.w),
            SizedBox(height: 35.h),
            CustomShimmer(
              height: 35.h,
              width: 130.w,
              borderRadius: BorderRadius.circular(30.r),
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}
