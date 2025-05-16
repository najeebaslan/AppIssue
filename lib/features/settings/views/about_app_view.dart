import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/theme/theme.dart';
import 'package:issue/core/widgets/adaptive_them_container.dart';

import '../../../core/widgets/custom_app_bar.dart';

class AboutAppView extends StatefulWidget {
  const AboutAppView({super.key});

  @override
  State<AboutAppView> createState() => _AboutAppViewState();
}

class _AboutAppViewState extends State<AboutAppView> {
  final List<bool> _isVisible = List.filled(7, false);

  @override
  void initState() {
    super.initState();
    _fadeInElements();
  }

  void _fadeInElements() {
    for (int i = 0; i < _isVisible.length; i++) {
      Future.delayed(Duration(milliseconds: 150 * (i + 1)), () {
        if (mounted) setState(() => _isVisible[i] = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        size: const Size.fromHeight(kToolbarHeight),
        title: Text(
          'aboutApp'.tr(),
          style: context.textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: defaultPadding.h),
        child: ListView.separated(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          itemCount: 7,
          separatorBuilder: (context, index) => SizedBox(height: 10.h),
          itemBuilder: (context, index) {
            return _fadeInCard(
              titles[index].tr(),
              _getDescription(index),
              _isVisible[index],
            );
          },
        ),
      ),
    );
  }

  Widget _fadeInCard(String title, String description, bool isVisible) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 800),
      child: AdaptiveThemeContainer(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.85,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> titles = [
    'introduction',
    'privacy',
    'accusedSettings',
    'searchFilterSort',
    'sharing',
    'protection',
    'notificationManagement',
  ];

  String _getDescription(int index) {
    switch (index) {
      case 0:
        return '${'welcomeMessage'.tr()}\n${'features.alert1'.tr()}\n${'features.alert2'.tr()}\n${'features.alert3'.tr()}';
      case 1:
        return '${'privacyDetails.accessFiles'.tr()}\n${'privacyDetails.accessDrive'.tr()}';
      case 2:
        return '${'accusedSettingsDetails.addNew'.tr()}\n${'accusedSettingsDetails.modify'.tr()}\n${'accusedSettingsDetails.endCharge'.tr()}\n${'accusedSettingsDetails.delete'.tr()}';
      case 3:
        final sortOptions = [
          'searchFilterSortDetails.sortOptions.0'.tr(),
          'searchFilterSortDetails.sortOptions.1'.tr(),
          'searchFilterSortDetails.sortOptions.2'.tr(),
          'searchFilterSortDetails.sortOptions.3'.tr(),
        ];
        return '${'searchFilterSortDetails.search'.tr()}\n${'searchFilterSortDetails.sort'.tr()}\n${sortOptions.join('\n')}';
      case 4:
        return 'sharingDetails'.tr();
      case 5:
        return 'protectionDetails'.tr();
      case 6:
        return 'notificationManagementDetails'.tr();

      default:
        return '';
    }
  }
}
