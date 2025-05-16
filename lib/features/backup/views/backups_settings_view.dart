import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/widgets/custom_toast.dart';

import '../../../core/helpers/helper_user.dart';
import '../../../core/services/services_locator.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../backup_cubit/backup_cubit.dart';
import '../widgets/let_started_setting_google_drive.dart';
import '../widgets/select_backup_method.dart';

class BackupsSettingsView extends StatefulWidget {
  const BackupsSettingsView({super.key});

  @override
  State<BackupsSettingsView> createState() => _BackupsSettingsViewState();
}

class _BackupsSettingsViewState extends State<BackupsSettingsView> {
  late final PageController _pageController;

  static const Duration _pageTransitionDuration = Duration(milliseconds: 500);
  static const int _totalPages = 2;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: _pageTransitionDuration,
      curve: Curves.easeInOut,
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: _pageTransitionDuration,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      LetStartedSettingGoogleDrive(nextPage: _nextPage),
      SelectBackupMethod(previousPage: _previousPage),
    ];
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocListener<BackupCubit, BackupState>(
        listenWhen: (previous, current) =>
            current is LoadingUploadBackup ||
            current is LoadedUploadBackup ||
            current is ErrorUploadBackup,
        listener: (context, state) {
          if (state is LoadingUploadBackup) {
            context.showLoading();
          } else if (state is LoadedUploadBackup) {
            context.hideLoading();
            CustomToast.showSuccessToast('doneSuccessfullyCreateBackup'.tr());
          } else if (state is ErrorUploadBackup) {
            context.hideLoading();
            CustomToast.showErrorToast(state.error);
          }
        },
        child: PageView.builder(
          itemCount: _totalPages,
          physics: const NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemBuilder: (context, index) => pages[index],
        ),
      ),
    );
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      onClickBack: () => _onBack(context),
      size: const Size.fromHeight(kToolbarHeight),
      title: Text(
        'backup'.tr(),
        style: context.textTheme.titleLarge,
      ),
    );
  }

  void _onBack(BuildContext context) {
    if (_pageController.page == 1) {
      _previousPage();
    } else {
      Navigator.pop(context, getIt.get<UserHelper>().getBackupStatus());
    }
  }
}
