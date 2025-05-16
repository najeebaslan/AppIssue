import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/services/services_locator.dart';
import 'package:issue/core/theme/app_colors.dart';
import 'package:issue/features/settings/profile_cubit/profile_cubit.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/assets_constants.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/cache_image.dart';
import '../../../../core/widgets/image/select_image_cubit/select_image_cubit.dart';
import '../../../../data/repositories/profile_repository.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    required this.imageUri,
    this.enablePickImages = true,
    this.isImageInsideDialog = false,
    this.customPositioned,
    this.imageSize,
    this.isLoading,
  });

  final String? imageUri;
  final bool enablePickImages;
  final Widget? customPositioned;
  final double? imageSize;
  final bool isImageInsideDialog;
  final bool? isLoading;
  @override
  Widget build(BuildContext context) {
    final double size = imageSize ?? context.width * .5;

    return BlocBuilder<SelectImageCubit, SelectImageState>(
      builder: (context, state) {
        final imageFile = context.read<SelectImageCubit>().file != null;

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Opacity(
                opacity: imageFile ? 0.4 : 1,
                child: _buildProfileImage(size, context),
              ),
            ),
            if (imageFile)
              isLoading == true
                  ? const CupertinoActivityIndicator()
                  : UploadImageAnimationButton(imageUri: imageUri),
            if (customPositioned != null) customPositioned!,
            if (enablePickImages)
              Positioned(
                bottom: 10,
                left: 0,
                child: _buildCameraButton(context),
              ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage(double size, BuildContext context) {
    if (context.read<SelectImageCubit>().file != null) {
      return AspectRatio(
        aspectRatio: 16 / 16,
        child: Image.file(
          context.read<SelectImageCubit>().file!,
          fit: BoxFit.cover,
          height: size,
          width: size,
        ),
      );
    } else if (imageUri.isEmptyOrNull) {
      return AspectRatio(
        aspectRatio: 16 / 16,
        child: Image.asset(
          ImagesConstants.profileImage,
          fit: BoxFit.cover,
          height: size,
          width: size,
        ),
      );
    } else {
      return isImageInsideDialog
          ? CacheImageWidget(
              url: imageUri!,
              fit: BoxFit.cover,
              height: size,
              width: size,
            )
          : AspectRatio(
              aspectRatio: 16 / 16,
              child: CacheImageWidget(
                url: imageUri!,
                fit: BoxFit.cover,
                height: size,
                width: size,
              ),
            );
    }
  }

  Widget _buildCameraButton(BuildContext context) {
    return InkWell(
      onTap: () => context.read<SelectImageCubit>().pickImagesFromGallery(context),
      child: Container(
        height: 45.w,
        width: 45.w,
        decoration: BoxDecoration(
          color: context.isDark ? AppColors.cardDarkBackgroundColor : Colors.grey[300],
          shape: BoxShape.circle,
          border: Border.all(
            color: context.isDark ? Colors.grey : AppColors.white,
          ),
        ),
        child: Icon(
          AppIcons.cameraAdd,
          size: defaultIconSize,
          color: context.isDark ? Colors.grey : AppColors.black.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

class UploadImageAnimationButton extends StatefulWidget {
  const UploadImageAnimationButton({
    super.key,
    required this.imageUri,
  });

  final String? imageUri;

  @override
  State<UploadImageAnimationButton> createState() => _UploadImageAnimationButtonState();
}

class _UploadImageAnimationButtonState extends State<UploadImageAnimationButton>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> hoverAnimation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
    hoverAnimation = Tween(
      begin: const Offset(0, 0),
      end: const Offset(0, 0.1),
    ).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: hoverAnimation,
      child: _buildButton(context),
    );
  }

  RawMaterialButton _buildButton(BuildContext context) {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(const Size(60, 60)),
      shape: const CircleBorder(),
      fillColor: AppColors.kPrimaryColor.withValues(alpha: 0.9),
      onPressed: () {
        final imageFile = context.read<SelectImageCubit>().file;
        if (imageFile != null) {
          context.read<ProfileCubit>().updateImage(
                UpdateImageParameters(
                  userId: getIt.get<FirebaseAuth>().currentUser!.uid,
                  oldImageUri: widget.imageUri,
                  newImageFile: imageFile,
                ),
              );
        }
      },
      child: const Icon(
        AppIcons.upload,
        size: defaultIconSize,
        color: AppColors.white,
      ),
    );
  }
}
