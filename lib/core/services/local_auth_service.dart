import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart' show AndroidAuthMessages;
import 'package:local_auth_darwin/local_auth_darwin.dart' show IOSAuthMessages;

import '../helpers/helper_user.dart';
import 'services_locator.dart';

class LocalAuthService {
  final LocalAuthentication auth;
  LocalAuthService(this.auth);
  Future<bool> isDeviceSupported() async {
    return await auth.isDeviceSupported();
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    final auth = getIt.get<LocalAuthentication>();
    final List<BiometricType> availableBiometrics = await auth.getAvailableBiometrics();

    return availableBiometrics;
  }

  void stopAuthentication() async {
    await auth.stopAuthentication();
  }

  Future<void> authenticateWithBiometrics(void Function() handleNavigator,
      {bool? stickyAuth}) async {
    if (await isDeviceSupported() && getIt.get<UserHelper>().isEnableLocalAuth()) {
      try {
        final authenticated = await auth.authenticate(
          localizedReason: 'localizedReason'.tr(),
          authMessages: [
            AndroidAuthMessages(
              signInTitle: 'signInTitle'.tr(),
              biometricHint: 'biometricHint'.tr(),
              cancelButton: 'cancelButton'.tr(),
              deviceCredentialsRequiredTitle: 'deviceCredentialsRequiredTitle'.tr(),
              biometricNotRecognized: 'biometricNotRecognized'.tr(),
              biometricRequiredTitle: 'biometricRequiredTitle'.tr(),
              biometricSuccess: 'biometricSuccess'.tr(),
              deviceCredentialsSetupDescription: 'deviceCredentialsSetupDescription'.tr(),
              goToSettingsButton: 'goToSettingsButton'.tr(),
              goToSettingsDescription: 'goToSettingsDescription'.tr(),
            ),
            IOSAuthMessages(
              cancelButton: 'cancelButton'.tr(),
              goToSettingsButton: 'goToSettingsButton'.tr(),
              goToSettingsDescription: 'goToSettingsDescription'.tr(),
              localizedFallbackTitle: 'localizedReason'.tr(),
            ),
          ],
          options: const AuthenticationOptions(
            stickyAuth: false,
            useErrorDialogs: true,
          ),
        );
        if (authenticated) return handleNavigator();
      } on PlatformException catch (e) {
        debugPrint(e.toString());
        return;
      }
    } else {
      return handleNavigator();
    }
  }
}
