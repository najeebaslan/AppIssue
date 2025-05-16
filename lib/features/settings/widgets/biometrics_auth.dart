import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:issue/core/constants/assets_constants.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/iterable_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/services/services_locator.dart';
import 'package:issue/core/widgets/not_found_data.dart';
import 'package:local_auth/local_auth.dart';

import '../../../core/constants/app_icons.dart';
import '../../../core/constants/default_settings.dart';
import '../../../core/services/local_auth_service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/custom_button.dart';

class BiometricsAuthBottomSheet extends StatefulWidget {
  const BiometricsAuthBottomSheet({super.key, required this.notifierStateBiometrics});
  final ValueNotifier notifierStateBiometrics;
  @override
  State<BiometricsAuthBottomSheet> createState() => _BiometricsAuthBottomSheetState();
}

class _BiometricsAuthBottomSheetState extends State<BiometricsAuthBottomSheet> {
  final LocalAuthService _localAuthService = LocalAuthService(getIt.get<LocalAuthentication>());
  bool isDeviceSupported = false;
  List<BiometricType> biometricTypes = [];
  int selectedIndex = -1; // Default to no selection
  final bool isEnableLocalAuth = getIt.get<UserHelper>().isEnableLocalAuth();

  @override
  void initState() {
    super.initState();
    _checkDeviceSupport();
  }

  Future<void> _checkDeviceSupport() async {
    isDeviceSupported = await _localAuthService.isDeviceSupported();
    if (isDeviceSupported) {
      biometricTypes = await _localAuthService.getAvailableBiometrics();
      _setInitialBiometricSelection();
      setState(() {});
    }
  }

  void _setInitialBiometricSelection() {
    final savedBiometric = getIt.get<UserHelper>().getAppBiometric();
    if (savedBiometric != DefaultSettings.biometric && isEnableLocalAuth) {
      int index = biometricTypes.indexWhere((type) => type.name == savedBiometric);
      selectedIndex = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isDeviceSupported) return _buildUnsupportedDeviceView(context);
    if (biometricTypes.isEmptyOrNull) return _buildNoBiometricMethodsView(context);

    return _buildBiometricMethodsView(context);
  }

  Widget _buildUnsupportedDeviceView(BuildContext context) {
    return NotFoundData(
      descriptionPadding: EdgeInsets.only(top: 20.h),
      descriptionFontSize: 20.sp,
      description: 'unsupportedDevice'.tr(),
      icon: AppIcons.fingerprint,
      circleWidget: CircleAvatar(
        radius: 50,
        backgroundColor: context.themeData.primaryColor.withValues(alpha: 0.07),
        child: Icon(
          AppIcons.fingerprint,
          color: context.themeData.primaryColor.withValues(alpha: 0.7),
          size: 60,
        ),
      ),
    );
  }

  Widget _buildNoBiometricMethodsView(BuildContext context) {
    return NotFoundData(
      errorFontSize: 20.sp,
      // offset: context.height > 700 ? const Offset(0, -30) : const Offset(0, -10),
      descriptionFontSize: 17.sp,
      error: 'noBiometricActivated'.tr(),
      description: 'noBiometricActivatedDescription'.tr(),
      icon: AppIcons.fingerprint,
      circleWidget: CircleAvatar(
        radius: context.height > 700 ? 50 : 40,
        backgroundColor: context.themeData.primaryColor.withValues(alpha: 0.07),
        child: Icon(
          AppIcons.fingerprint,
          color: context.themeData.primaryColor.withValues(alpha: 0.7),
          size: 60,
        ),
      ),
    );
  }

  Widget _buildBiometricMethodsView(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        SizedBox(height: 10.h),
        Text(
          'chooseAuthMethodRefer'.tr(),
          style: context.textTheme.bodyMedium,
        ),
        SizedBox(height: 3.h),
        Text(
          'chooseAuthMethodReferDescription'.tr(),
          style: context.textTheme.bodySmall,
        ),
        SizedBox(height: 10.h),
        ...List.generate(
          biometricTypes.length,
          (index) => _buildBiometricTile(context, biometricTypes[index], index),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: defaultPadding.h * 3,
            bottom: (context.mediaQuery.padding.bottom + 15).h,
          ),
          child: _buildContinueButton(context),
        ),
      ],
    );
  }

  Widget _buildBiometricTile(BuildContext context, BiometricType biometricType, int index) {
    return RadioListTile.adaptive(
      contentPadding: EdgeInsets.zero,

      visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
      secondary: _buildBiometricIndicator(index == selectedIndex, biometricType),
      title: Text(
        biometricType.toString().split('.').last.tr(),
        style: context.textTheme.bodyLarge,
      ),
      activeColor: AppColors.kPrimaryColor,
      toggleable: true,
      value:
          index, // don't use biometricTypes.index because it's get index from all the list but we need get index from the available biometricTypes
      groupValue: selectedIndex,
      onChanged: (value) {
        setState(() => selectedIndex = (selectedIndex == value) ? -1 : value?.toInt() ?? -1);
      },
    );
  }

  Widget _buildBiometricIndicator(bool isSelected, BiometricType biometricType) {
    return Container(
      height: 40.h,
      width: 40.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            isSelected ? AppColors.kPrimaryColor : AppColors.kPrimaryColor.withValues(alpha: 0.6),
      ),
      child: biometricType == BiometricType.face
          ? SvgPicture.asset(
              ImagesConstants.faceID,
              height: 25.h,
              width: 25.w,
            )
          : Icon(
              getIconByBiometricType(biometricType),
              size: defaultIconSize.w,
              color: AppColors.white,
            ),
    );
  }

  IconData getIconByBiometricType(BiometricType biometricType) {
    switch (biometricType) {
      case BiometricType.fingerprint:
        return AppIcons.fingerprint;
      case BiometricType.iris:
        return AppIcons.eyeTracking;

      default:
        return AppIcons.eyeTracking;
    }
  }

  Widget _buildContinueButton(BuildContext context) {
    return CustomButton(
      onPressed: () async {
        final userHelper = getIt.get<UserHelper>();
        if (-1 == selectedIndex) {
          await userHelper.saveEnableLocalAuth(false);
          _localAuthService.stopAuthentication();
          widget.notifierStateBiometrics.value = false;
        } else {
          await userHelper.saveEnableLocalAuth(true);
          await userHelper.saveAppBiometric(biometricTypes[selectedIndex]);
          widget.notifierStateBiometrics.value = true;
        }
        if (context.mounted) {
          Navigator.pop(context);
        }
      },
      label: 'continue',
    );
  }
}
