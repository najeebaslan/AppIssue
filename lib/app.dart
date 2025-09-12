import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/services/services_locator.dart';

import 'core/router/routes_constants.dart';
import 'core/router/routes_manager.dart';
import 'core/theme/theme.dart';
import 'core/utils/app_theme_and_languages_notifier/app_theme_and_languages_cubit.dart';
import 'features/accused/accused_cubit/accused_cubit.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey(
  debugLabel: "Main Navigator",
);

class Issue extends StatelessWidget {
  const Issue({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: context.isTablet ? const Size(481, 890) : const Size(428, 926),
      minTextAdapt: true,
      enableScaleText: () => false,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider<AppThemeAndLanguagesCubit>(
            create: (BuildContext context) => AppThemeAndLanguagesCubit(),
          ),
          BlocProvider<AccusedCubit>(
            create: (BuildContext context) => getIt<AccusedCubit>(),
          ),
        ],
        child: BlocBuilder<AppThemeAndLanguagesCubit, AppThemeAndLanguagesState>(
          builder: (context, state) {
            context.setLocale(BlocProvider.of<AppThemeAndLanguagesCubit>(context).locale);
            return MaterialApp(
              title: 'مواعيد تمديدات الحبس',
              theme: lightTheme(),
              darkTheme: darkTheme(),
              locale: context.locale,
              themeAnimationStyle:  AnimationStyle(curve: Curves.fastOutSlowIn),
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              navigatorKey: navigatorKey,
              initialRoute: AppRoutesConstants.splashView,
              onGenerateRoute: AppRouter.onGenerateRoute,
              debugShowCheckedModeBanner: false,
              themeMode: BlocProvider.of<AppThemeAndLanguagesCubit>(context).theme,
              builder: (context, child) {
                final MediaQueryData data = MediaQuery.of(context);
                return MediaQuery(
                  data: data.copyWith(textScaler: const TextScaler.linear(1)),
                  child: ScrollConfiguration(
                    behavior: const ScrollBehavior(),
                    child: AnnotatedRegion(
                      value: context.isDark ? darkSystemUiOverlayStyle : lightSystemUiOverlayStyle,
                      child: child!,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
/* 
1. Purpose of the Application
Meamar is a marketplace app specialized in construction tools. It connects two types of users:

- Managers: Construction professionals who list tools for rent or sale.
- Clients: Users who browse, search, and contact tool owners for their construction needs.
Key Points:

- The app is not for the general public; users must select their role (Manager/Client) during signup.
- All tool listings and posts are user-generated and moderated for compliance.
- There are no in-app payments; all transactions and communications happen externally (e.g., WhatsApp, phone, SMS).






2. Core Features
Authentication
Users can sign up and log in using:
Phone number
Email and password
Google Auth
Apple Auth
Account Types
Manager: Can add, edit, and delete tools and posts.
Client: Can browse tools and posts, like posts, and contact tool owners.

 */
