import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';

import 'app_colors.dart';
import 'custom_colors.dart';

const double kContentFontSize = 16.0;
const double viewPadding = 20.0;
const double defaultPadding = 20;
const double defaultIconSize = 26;
const double defaultBorderRadius = 20;

const String defaultFontFamily = 'IBM Plex Sans Arabic';
const String defaultFontFamilyMedium = 'IBM Plex Sans Arabic Medium';

ThemeData lightTheme() => ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: lightSystemUiOverlayStyle,
        iconTheme: IconThemeData(
          color: AppColors.iconColor,
        ),
        backgroundColor: AppColors.background,
      ),
      bottomAppBarTheme: const BottomAppBarTheme(color: AppColors.background),
      fontFamily: defaultFontFamily,
      primaryColor: AppColors.kPrimaryColor,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      unselectedWidgetColor: Colors.grey[300],
      canvasColor: AppColors.background,
      dividerColor: Colors.grey[300],
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: Colors.white,
      ),
      dialogTheme: const DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      highlightColor: Colors.black.withValues(alpha: 0.1),
      splashColor: Colors.black.withValues(alpha: 0.1),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: AppColors.gray800,
          fontSize: 20.sp,
          fontFamily: defaultFontFamily,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: AppColors.black,
          fontSize: 17.sp,
          fontFamily: defaultFontFamilyMedium,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: AppColors.gray800,
          fontSize: 14.sp,
          fontFamily: defaultFontFamilyMedium,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: AppColors.gray800,
          fontFamily: defaultFontFamily,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: AppColors.gray800,
          fontSize: 16.sp,
          fontFamily: defaultFontFamily,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: const Color(0xFF95979A),
          fontFamily: defaultFontFamily,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        displayLarge: TextStyle(
          fontSize: 16.sp,
          height: 1.5,
          color: const Color(0xff6f85d5),
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontSize: 16.sp,
          height: 1.5,
          color: Colors.white,
        ),
        labelLarge: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xff6f85d5),
          height: 1,
        ),
        headlineLarge: TextStyle(
          color: AppColors.gray800,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          fontFamily: defaultFontFamilyMedium,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all<double>(0.0),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.kPrimaryColor.withValues(alpha: 0.7);
              }
              return AppColors.kPrimaryColor;
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return (states.contains(WidgetState.disabled))
                  ? Colors.white30
                  : Colors.lightBlue[100];
            },
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(
              fontFamily: defaultFontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1,
            ),
          ),
          overlayColor: WidgetStateProperty.all<Color>(Colors.white24),
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(5),
        thumbColor: WidgetStateProperty.all(Colors.grey[300]),
      ),
      iconTheme: IconThemeData(color: Colors.grey[400], size: 30),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey[300],
        filled: true,
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      cardColor: Colors.grey[200],
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: const Color(0xff6f85d5),
        brightness: Brightness.light,
        outline: const Color(0xff6f85d5),
      ),
      extensions: <ThemeExtension<dynamic>>[
        CustomColors(
          bottomSheetColor: AppColors.white,
          smoothTextColor: const Color(0xFF253840),
          dividerColor: Colors.black.withAlpha(50),
          authButtonColor: AppColors.kPrimaryColor,
          blackAndWhite: AppColors.black,
          whiteAndBlack: AppColors.white,
          selectedRowColor: const Color(0xffB3B3FF),
          backgroundColorCircle: Colors.white,
          backgroundTextField: Colors.white,
        ),
      ],
    );

ThemeData darkTheme() => ThemeData(
      useMaterial3: false,
      brightness: Brightness.dark,
      appBarTheme: AppBarTheme(
        systemOverlayStyle: darkSystemUiOverlayStyle,
        backgroundColor: const Color(0xff10122C),
        iconTheme: IconThemeData(
          color: AppColors.iconColor,
        ),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        color: Color(0xff10122C),
      ),
      fontFamily: defaultFontFamily,
      primaryColor: AppColors.kPrimaryColor,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      canvasColor: const Color(0xff10122C),
      dividerColor: const Color(0xff3C387B),
      iconTheme: IconThemeData(
        color: AppColors.kPrimaryColor.withValues(alpha: 0.5),
        size: 30,
      ),
      unselectedWidgetColor: Colors.grey[300],
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white24,
        filled: true,
        hintStyle: TextStyle(color: Colors.white38),
      ),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          color: AppColors.white,
          fontSize: 20.sp,
          fontFamily: defaultFontFamily,
          fontWeight: FontWeight.w400,
        ),
        bodyLarge: TextStyle(
          color: AppColors.white,
          fontFamily: defaultFontFamily,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: AppColors.white,
          fontSize: 16.sp,
          fontFamily: defaultFontFamily,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontFamily: defaultFontFamily,
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
        titleMedium: TextStyle(
          color: AppColors.white,
          fontSize: 16.sp,
          fontFamily: defaultFontFamilyMedium,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          color: AppColors.white,
          fontSize: 14.sp,
          fontFamily: defaultFontFamilyMedium,
          fontWeight: FontWeight.w500,
        ),
        displayLarge: TextStyle(
          fontSize: 16.sp,
          height: 1.5,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontSize: 16.sp,
          height: 1.5,
          color: Colors.white,
        ),
        labelLarge: TextStyle(
          fontSize: 14.sp,
          color: const Color(0xff6f85d5),
          height: 1,
        ),
        headlineLarge: TextStyle(
          color: AppColors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          fontFamily: defaultFontFamilyMedium,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all<double>(0.0),
          backgroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled)) {
                return AppColors.kPrimaryColor.withValues(alpha: 0.6);
              }
              return AppColors.kPrimaryColor.withValues(alpha: 0.5);
            },
          ),
          foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (Set<WidgetState> states) {
              return (states.contains(WidgetState.disabled))
                  ? Colors.white30
                  : Colors.lightBlue[100];
            },
          ),
          textStyle: WidgetStateProperty.all<TextStyle>(
            const TextStyle(
              fontFamily: defaultFontFamily,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1,
            ),
          ),
          overlayColor: WidgetStateProperty.all<Color>(Colors.white10),
        ),
      ),
      splashColor: Colors.black.withValues(alpha: 0.1),
      highlightColor: const Color(0xff3C387B).withValues(alpha: 0.5),
      bottomSheetTheme: BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: const Color(0xff1B2349),
      ),
      dialogTheme: const DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        backgroundColor: Color(0xff1B2349),
      ),
      cardColor: const Color(0xff10122C),
      scrollbarTheme: ScrollbarThemeData(
        radius: const Radius.circular(5),
        thumbColor: WidgetStateProperty.all(
          const Color(0xff3C387B).withValues(alpha: 0.5),
        ),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: Colors.white,
        brightness: Brightness.dark,
        outline: const Color(0xff6f85d5),
      ),
      extensions: <ThemeExtension<dynamic>>[
        CustomColors(
          bottomSheetColor: const Color(0xff10122C),
          backgroundTextField: const Color(0xff1B2349),
          smoothTextColor: const Color(0xFFFFFFFF),
          whiteAndBlack: AppColors.black,
          blackAndWhite: AppColors.white,
          dividerColor: Colors.grey.withAlpha(150),
          authButtonColor: const Color(0xff132137),
          selectedRowColor: const Color(0xff33477F),
          backgroundColorCircle: const Color(0xff383152),
        ),
      ],
    );

SystemUiOverlayStyle darkSystemUiOverlayStyle = const SystemUiOverlayStyle(
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: Color(0xff10122C),
);

SystemUiOverlayStyle lightSystemUiOverlayStyle = const SystemUiOverlayStyle(
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarIconBrightness: Brightness.dark,
  statusBarColor: Colors.transparent,
  systemNavigationBarColor: AppColors.background,
);

SystemUiOverlayStyle homeLightSystemUiOverlayStyle = const SystemUiOverlayStyle(
  statusBarBrightness: Brightness.light,
  statusBarIconBrightness: Brightness.dark,
  statusBarColor: AppColors.background,
  systemNavigationBarColor: AppColors.white,
  systemNavigationBarIconBrightness: Brightness.dark,
);

SystemUiOverlayStyle homeDarkSystemUiOverlayStyle = const SystemUiOverlayStyle(
  statusBarBrightness: Brightness.dark,
  statusBarIconBrightness: Brightness.light,
  statusBarColor: Color(0xff10122C),
  systemNavigationBarColor: AppColors.kSecondColor,
  systemNavigationBarIconBrightness: Brightness.light,
);
SystemUiOverlayStyle authSystemUiOverlayStyle(BuildContext context) {
  return SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: context.isDark ? const Color(0xff10122C) : AppColors.background,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
}
