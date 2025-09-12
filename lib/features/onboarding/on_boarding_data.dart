import 'dart:io';

import '../../core/constants/assets_constants.dart';

class OnBoardingData {
  static final List<OnBoardingModel> onBoardingList = [
    const OnBoardingModel(
      image: ImagesConstants.onboardingManageCriminals,
      title: 'manageCriminals',
      description: 'manageCriminalsSubtitle',
    ),
    const OnBoardingModel(
      image: ImagesConstants.onboardingSaveYourTime,
      title: 'saveYourTime',
      description: 'saveYourTimeSubtitle',
    ),
    OnBoardingModel(
      image: ImagesConstants.onboardingAutoBackups,
      title: 'autoBackups',
      description: Platform.isIOS ? "autoBackupsSubtitleIos" : 'autoBackupsSubtitle',
    ),
    //يتيح لك النسخ الاحتياطي التلقائي حفظ بياناتك على فترات زمنية مجدولة دون الحاجة إلى اتخاذ أي إجراء منك.
    const OnBoardingModel(
      image: ImagesConstants.onboardingNotifications,
      title: 'onboardingNotifications',
      description: 'onboardingNotificationsSubtitle',
    ),
  ];
}

class OnBoardingModel {
  final String image;
  final String title;
  final String description;

  const OnBoardingModel({
    required this.image,
    required this.title,
    required this.description,
  });
}
