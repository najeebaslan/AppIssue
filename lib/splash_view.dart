import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:issue/core/constants/app_icons.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/services/services_locator.dart';
import 'package:local_auth/local_auth.dart';

import 'core/router/routes_constants.dart';
import 'core/services/local_auth_service.dart';
import 'core/services/notifications/local_notifications.dart';
import 'core/widgets/not_found_data.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double logoOpacity = 0.0;
  final _localAuth = LocalAuthService(getIt.get<LocalAuthentication>());
  @override
  void initState() {
    super.initState();
    _handleAuthentication();
  }

  void _handleAuthentication() async {
    await _localAuth.authenticateWithBiometrics(() => _navigateToNextScreen());

    // Please don't move this function to up[authenticateWithBiometrics]
    // because when user click notification i want open the application
    // and go to navigatorBar and after that open details notification view
    // for display the notification details
    await _goToNotificationDetails();
  }

  Future<void> _navigateToNextScreen() async {
    final String route = await _determineRoute();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, route, (route) => false);
  }

  Future<String> _determineRoute() async {
    final UserHelper userHelper = getIt.get<UserHelper>();
    final User? currentUser = getIt.get<FirebaseAuth>().currentUser;

    if (userHelper.isUserLoggedIn() && currentUser != null) {
      return AppRoutesConstants.navigationBar;
    } else if (!userHelper.isSeenOnboarding()) {
      return AppRoutesConstants.onboardingView;
    } else {
      return AppRoutesConstants.signInView;
    }
  }

  Future<void> _goToNotificationDetails() async {
    await LocalNotificationService().onLaunchNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getIt.get<UserHelper>().isEnableLocalAuth()
          ? _buildLocalAuthView(context)
          : const SizedBox.shrink(),
    );
  }

  Column _buildLocalAuthView(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NotFoundData(
          error: 'authBiometric'.tr(),
          description: 'pleaseAuthenticateOpenApplication'.tr(),
          icon: AppIcons.fingerprint,
        ),
        TextButton(
          onPressed: () async {
            await _localAuth.authenticateWithBiometrics(() => _navigateToNextScreen());
          },
          child: Text(
            'retry'.tr(),
            style: context.textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
