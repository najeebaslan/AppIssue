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
      designSize: const Size(428, 926),
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
              themeAnimationStyle: AnimationStyle(curve: Curves.fastOutSlowIn),
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
2- // TODO========> When click to contact use button go to Apple Store if the mobile is iphone else open Google Play Store
 */
