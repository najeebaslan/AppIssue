import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/features/home/views/home_view.dart';

import '../../../core/helpers/task_scheduler.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/custom_upgrade_alert.dart';
import '../../../data/repositories/sync_users_repository.dart';
import '../../accused/add_accused_view.dart';
import '../../filter/filter_cubit/filter_cubit.dart';
import '../../filter/views/filter_view.dart';
import '../../settings/profile_cubit/profile_cubit.dart';
import '../../settings/views/setting_view.dart';
import '../widgets/material_indicator.dart';

class NavigationBarView extends StatefulWidget {
  const NavigationBarView({super.key});

  @override
  State<NavigationBarView> createState() => _NavigationBarViewState();
}

class _NavigationBarViewState extends State<NavigationBarView> with TickerProviderStateMixin {
  late final TabController _tabController;
  final PageStorageBucket _bucket = PageStorageBucket();
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  final List<Widget> _pages = [
    BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>(),
      child: const HomeView(),
    ),
    BlocProvider<FilterCubit>(
      create: (context) => getIt<FilterCubit>(),
      child: const FilterView(),
    ),
    const AddAccusedView(),
    BlocProvider<ProfileCubit>(
      create: (context) => getIt<ProfileCubit>(),
      child: const SettingView(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
    _scheduleTasks();
    _syncUserData();
  }

  void _scheduleTasks() {
    final user = getIt<FirebaseAuth>().currentUser;
    if (user != null) {
      getIt<HelperTaskManager>().scheduleTasks(user.uid); // This for production
      // getIt<HelperTaskManager>().testScheduleTasks(); // This for testing
    }
  }

  void _syncUserData() {
    final currentUser = getIt.get<FirebaseAuth>().currentUser;
    SyncOldUsersRepository().syncOldUserDataToFireStoreIfNotExists(currentUser: currentUser);
  }

  @override
  void dispose() {
    _selectedIndex.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomUpgradeAlert(
        child: SafeArea(
          child: PageStorage(
            bucket: _bucket,
            child: ValueListenableBuilder<int>(
              valueListenable: _selectedIndex,
              builder: (context, value, child) {
                return TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: _pages,
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnnotatedRegion(
        value: context.isDark ? homeDarkSystemUiOverlayStyle : homeLightSystemUiOverlayStyle,
        child: BottomAppBar(
          color: context.isDark ? AppColors.kSecondColor : AppColors.white,
          height: 75.h,
          child: ValueListenableBuilder<int>(
            valueListenable: _selectedIndex,
            builder: (context, value, child) {
              return TabBar(
                overlayColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
                onTap: (index) {
                  _selectedIndex.value = index;
                  _tabController.index = index; // Update TabController's index
                },
                tabs: _buildTabs(value),
                labelStyle: context.textTheme.bodyMedium?.copyWith(
                  locale: context.locale,
                ),
                labelColor: context.themeData.primaryColor,
                unselectedLabelColor: Colors.grey[600],
                unselectedLabelStyle: context.textTheme.bodyMedium?.copyWith(
                  locale: context.locale,
                ),
                indicatorColor: context.themeData.primaryColor,
                controller: _tabController,
                indicator: MaterialIndicator(
                  color: context.themeData.primaryColor,
                  tabPosition: TabPosition.top,
                  horizontalPadding: 20.w,
                  height: 4,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTabs(int selectedIndex) {
    const onSelectedIcons = [
      FluentIcons.home_16_filled,
      FluentIcons.filter_24_filled,
      FluentIcons.person_add_20_filled,
      FluentIcons.settings_20_filled,
    ];
    const icons = [
      FluentIcons.home_16_regular,
      FluentIcons.filter_24_regular,
      FluentIcons.person_add_20_regular,
      FluentIcons.settings_20_regular,
    ];
    const labels = ['homeView', 'filter', 'addAccused', 'setting'];

    return List<Widget>.generate(4, (index) {
      return Tab(
        iconMargin: EdgeInsets.zero,
        icon: Icon(selectedIndex == index ? onSelectedIcons[index] : icons[index]),
        text: labels[index].tr(),
      );
    });
  }
}
