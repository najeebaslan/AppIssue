import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/assets_constants.dart';
import '../../../core/helpers/helper_user.dart';
import '../../../core/router/routes_constants.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/animations/hero/custom_rect_tween.dart';
import '../../../core/widgets/animations/hero/hero_dialog_route.dart';
import '../../../core/widgets/cache_image.dart';
import '../../accused/accused_cubit/accused_cubit.dart';
import '../../settings/profile_cubit/profile_cubit.dart';
import 'search_app_bar/accuse_search_bpp_bar.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccusedCubit, AccusedState>(
      buildWhen: (previous, current) => current is OnRefreshProfileAppBar,
      builder: (context, state) {
        return NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            final imageUri = context.read<ProfileCubit>().adaptiveImageUri();
            return [
              SliverPadding(padding: EdgeInsets.only(top: 5.h)),
              _buildSliverAppBar(context, imageUri),
            ];
          },
          body: child,
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar(BuildContext context, String imageUri) {
    return SliverAppBar(
      backgroundColor: context.themeData.scaffoldBackgroundColor,
      floating: true,
      snap: true,
      expandedHeight: 12.1,
      centerTitle: false,
      toolbarHeight: kToolbarHeight,
      actions: _buildAppBarActions(context, imageUri),
    );
  }

  List<Widget> _buildAppBarActions(BuildContext context, String imageUri) {
    return [
      _buildProfileImageButton(context, imageUri),
      _buildUserInfo(context),
      const Spacer(),
      _buildSearchButton(context),
      _buildNotificationButton(context),
    ];
  }

  Widget _buildProfileImageButton(BuildContext context, String imageUri) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
      child: GestureDetector(
        onTap: () => _showProfileImage(context, imageUri),
        child: Hero(
          tag: 'imageProfile',
          createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
          child: _buildImageProfile(context, imageUri),
        ),
      ),
    );
  }

  void _showProfileImage(BuildContext context, String imageUri) {
    Navigator.of(context).push(
      HeroDialogRoute(
        builder: (context) => Center(
          child: Hero(
            tag: 'imageProfile',
            createRectTween: (begin, end) => CustomRectTween(begin: begin!, end: end!),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.firstAlarmColor,
                child: _buildImageProfile(context, imageUri, 350, 350, 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: Text('prisonDates'.tr(), style: context.textTheme.titleLarge)),
        Text(
          getIt.get<UserHelper>().getUsername().getFirstAndLastName() ?? '',
          style: context.textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    return _buildIconButton(
      context,
      icon: AppIcons.search,
      onPressed: () => showSearch(context: context, delegate: AccuseSearch()),
    );
  }

  Widget _buildNotificationButton(BuildContext context) {
    return _buildIconButton(
      context,
      icon: AppIcons.notificationBadge,
      onPressed: () => Navigator.pushNamed(context, AppRoutesConstants.notificationsView),
    );
  }

  Widget _buildIconButton(BuildContext context,
      {required IconData icon, required VoidCallback onPressed}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: defaultPadding.w / 2),
      child: RawMaterialButton(
        onPressed: onPressed,
        constraints: BoxConstraints.tightFor(height: 30.h, width: 30.w),
        shape: const CircleBorder(),
        padding: EdgeInsets.zero,
        child: Icon(icon,
            color: Colors.grey[700],
            size: defaultIconSize + (icon == AppIcons.notificationBadge ? 1 : 0)),
      ),
    );
  }

  AspectRatio _buildImageProfile(BuildContext context, String imageUri,
      [double? height, double? width, double? circularRadius]) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(circularRadius ?? 50),
        child: imageUri.isEmptyOrNull
            ? _defaultProfileImage()
            : CacheImageWidget(
                url: imageUri,
                fit: BoxFit.cover,
                height: height ?? 60.h,
                width: width ?? 60.h,
                errorWidget: _defaultProfileImage(),
              ),
      ),
    );
  }

  CircleAvatar _defaultProfileImage() {
    return const CircleAvatar(
      backgroundImage: AssetImage(ImagesConstants.profileImage),
    );
  }
}
