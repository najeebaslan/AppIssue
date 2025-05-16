import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/services/services_locator.dart';
import 'package:issue/features/auth/auth_cubit/auth_cubit.dart';
import 'package:issue/features/notifications/views/notifications_view.dart';

import '../../data/models/accuse_model.dart';
import '../../features/accused/accused_details_view.dart';
import '../../features/accused/add_accused_view.dart';
import '../../features/auth/views/forget_password_view.dart';
import '../../features/auth/views/sign_in_view.dart';
import '../../features/auth/views/sign_up_view.dart';
import '../../features/backup/backup_cubit/backup_cubit.dart';
import '../../features/backup/views/backups_settings_view.dart';
import '../../features/backup/views/get_backups_view.dart';
import '../../features/home/views/navigation_bar_view.dart';
import '../../features/notifications/notifications_cubit/notifications_cubit.dart';
import '../../features/onboarding/onboarding_view.dart';
import '../../features/settings/views/about_app_view.dart';
import '../../splash_view.dart';
import '../helpers/helper_user.dart';
import '../services/notifications/payload_model.dart';
import '../theme/app_colors.dart';
import '../theme/theme.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/show_notification_details.dart';
import 'routes_constants.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // --------------- Root Screen ---------------//
      case AppRoutesConstants.splashView:
        return const SplashView().withAnimation;

      case AppRoutesConstants.signInView:
        return BlocProvider<AuthCubit>(
          create: (BuildContext context) => getIt<AuthCubit>(),
          child: const SignInView(),
        ).withAnimation;

      case AppRoutesConstants.signUpView:
        return BlocProvider<AuthCubit>(
          create: (BuildContext context) => getIt<AuthCubit>(),
          child: const SignUpView(),
        ).withAnimation;

      case AppRoutesConstants.forgotPasswordView:
        return BlocProvider<AuthCubit>(
          create: (BuildContext context) => getIt<AuthCubit>(),
          child: ForgotPasswordView(
            comingFromSignInView: settings.arguments as bool,
          ),
        ).withAnimation;

      case AppRoutesConstants.onboardingView:
        return const OnboardingView().withAnimation;

      case AppRoutesConstants.navigationBar:
        return const NavigationBarView().withAnimation;

      case AppRoutesConstants.addAccusedView:
        return AddAccusedView(
          accused: settings.arguments as AccusedModel,
        ).withAnimation;
      case AppRoutesConstants.showNotificationDetails:
        return ShowNotificationDetails(
          notificationModel: settings.arguments as PayloadModel,
        ).withAnimation;

      case AppRoutesConstants.accusedDetailsView:
        return AccusedDetailsView(
          accusedModel: settings.arguments as AccusedModel,
        ).withAnimation;

      case AppRoutesConstants.backupsSettingsView:
        return BlocProvider<BackupCubit>(
          create: (BuildContext context) => getIt<BackupCubit>(),
          child: const BackupsSettingsView(),
        ).withAnimation;

      case AppRoutesConstants.getBackupsView:
        return BlocProvider<BackupCubit>(
          create: (BuildContext context) => getIt<BackupCubit>(),
          child: const GetBackupsView(),
        ).withAnimation;

      case AppRoutesConstants.notificationsView:
        return BlocProvider<NotificationsCubit>(
          create: (BuildContext context) => getIt<NotificationsCubit>(),
          child: const NotificationsView(),
        ).withAnimation;

      case AppRoutesConstants.aboutApp:
        return const AboutAppView().withAnimation;

      default:
        return unknownRouteScreen();
    }
  }

  static Route<dynamic> unknownRouteScreen() {
    bool isArabic = getIt.get<UserHelper>().getAppLanguage().startsWith('ar');

    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: CustomAppBar(
          size: const Size.fromHeight(kToolbarHeight),
          title: Text(
            isArabic ? 'مسار غير معروف' : 'The Path unKnow',
            style: TextStyle(
              fontSize: 15.sp,
              color: AppColors.black.withValues(alpha: 0.7),
              fontFamily: defaultFontFamily,
              fontWeight: FontWeight.w300,
              overflow: TextOverflow.ellipsis,
              //
            ),
          ),
        ),
        body: Center(
            child: Text(
          isArabic
              ? 'من فضلك تاكد من صحة المسار الذي تريد الذهاب إليه'
              : 'Please check path that would you want going to it',
          style: TextStyle(
            fontSize: 15.sp,
            color: AppColors.black,
            fontFamily: defaultFontFamily,
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        )),
      ),
    );
  }
}

extension AnimationPageRouter on Widget {
  PageRouteBuilder<dynamic> get withAnimation => PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 200),
        reverseTransitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
          opacity: animation,
          child: this,
        ),
      );
}
