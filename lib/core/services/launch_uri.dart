import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:issue/core/widgets/custom_toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/default_settings.dart';

class LaunchUri {
  void makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await _launchUrl(launchUri);
  }

  void sendSMS(String phoneNumber, [String? message]) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: {'body': message},
    );
    await _launchUrl(launchUri);
  }

  Future<void> _launchUrl(Uri uri) async {
    if (await canLaunchUrl(Uri.parse(uri.toString()))) {
      await launchUrl(Uri.parse(uri.toString()));
    } else {
      throw 'Could not launch $uri';
    }
  }

  void launchEmail() async {
    String subject = Uri.encodeComponent('iNeedSupport'.tr());
    String body = "provideUsInformationProblems".tr();
    String uri = 'mailto:${DefaultSettings.supportEmail}?subject=${Uri.parse(subject)}&body=$body';

    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      CustomToast.showErrorToast('The email cannot be opened');
    }
  }

  Future<void> launchGooglePlay() async {
    String uri = "https://play.google.com/store/apps/details?id=najeeb.aslan.issue";
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      CustomToast.showErrorToast('The GooglePlay cannot be opened');
      throw "The GooglePlay cannot be opened";
    }
  }

  Future<void> launchAppleStore() async {
    String uri = "https://apps.apple.com/app/idYOUR_CLIENT_APP_ID";
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      CustomToast.showErrorToast('The AppleStore cannot be opened');
      throw "The AppleStore cannot be opened";
    }
  }

  Future<void> reviewApplication() async {
    try {
      if (Platform.isIOS) {
        await launchAppleStore();
      } else {
        await launchGooglePlay();
      }
    } catch (e) {
      debugPrint("Could not launch app: $e");
    }
  }

  void launchWhatsApp() async {
    const String phoneNumber = DefaultSettings.supportPhoneNumber;
    String text = Uri.encodeComponent("provideUsInformationProblems".tr());
    String androidUrl = "whatsapp://send?phone=$phoneNumber&text=$text";
    String iosUrl = "https://wa.me/$phoneNumber?text=${Uri.parse(text)}";
    String webUrl =
        'https://api.whatsapp.com/send/?phone=$phoneNumber&text=${"provideUsInformationProblems".tr()}';

    try {
      if (Platform.isIOS) {
        if (await canLaunchUrl(Uri.parse(iosUrl))) {
          await launchUrl(Uri.parse(iosUrl));
        }
      } else {
        if (await canLaunchUrl(Uri.parse(androidUrl))) {
          await launchUrl(Uri.parse(androidUrl));
        }
      }
    } catch (e) {
      await launchUrl(Uri.parse(webUrl), mode: LaunchMode.externalApplication);
    }
  }
}
