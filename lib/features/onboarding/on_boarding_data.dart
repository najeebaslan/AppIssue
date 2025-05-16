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
    const OnBoardingModel(
      image: ImagesConstants.onboardingAutoBackups,
      title: 'autoBackups',
      description: 'autoBackupsSubtitle',
    ),
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
