import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/services/services_locator.dart';
import 'package:issue/core/theme/app_colors.dart';
import 'package:issue/core/widgets/custom_toast.dart';
import 'package:issue/core/widgets/not_found_data.dart';
import 'package:issue/features/backup/widgets/backup_list.dart';

import '../../../core/widgets/custom_app_bar.dart';
import '../backup_cubit/backup_cubit.dart';
import '../widgets/confirm_restor_backup_bottom_sheet.dart';
import '../widgets/loading_backups.dart';

class GetBackupsView extends StatefulWidget {
  const GetBackupsView({super.key});

  @override
  State<GetBackupsView> createState() => _GetBackupsViewState();
}

class _GetBackupsViewState extends State<GetBackupsView> {
  late ScrollController _controller;
  late BackupCubit _backupCubit;
  @override
  void initState() {
    super.initState();
    _backupCubit = BlocProvider.of<BackupCubit>(context);
    _backupCubit.getDriveApi();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: BlocConsumer<BackupCubit, BackupState>(
        listener: (context, state) {
          _backupStateListener(state, context);
        },
        buildWhen: (previous, current) {
          return _shouldRebuildState(current);
        },
        builder: (context, state) {
          if (state is ErrorGetGoogleDriveApi) {
            return NotFoundData(error: state.error);
          } else if (state is LoadedGetBackups) {
            return BackupList(backups: state.backups);
          } else if (state is DoneDeleteBackup) {
            return BackupList(backups: state.backups);
          } else {
            return const LoadingBackups();
          }
        },
      ),
    );
  }

  bool _shouldRebuildState(BackupState current) {
    return current is LoadingGetGoogleDriveApi ||
        current is LoadedGetGoogleDriveApi ||
        current is DoneDeleteBackup ||
        current is ErrorGetGoogleDriveApi ||
        current is LoadingGetBackups ||
        current is LoadedGetBackups ||
        current is ErrorGetBackups;
  }

  void _backupStateListener(BackupState state, BuildContext context) {
    if (state is LoadingDeleteBackup) {
      context.showLoading();
    } else if (state is DoneDeleteBackup) {
      context.hideLoading();
    } else if (state is ErrorDeleteBackup) {
      context.hideLoading();
      CustomToast.showErrorToast(state.error);
    } else if (state is LoadedGetGoogleDriveApi) {
      _backupCubit.getAllBackups();
    } else if (state is ErrorGetBackups) {
      CustomToast.showErrorToast(state.error);
    } else if (state is LoadingDownloadBackup) {
      context.showLoading();
    } else if (state is LoadedDownloadBackup) {
      Navigator.pop(context);
      showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        useRootNavigator: true,
        isScrollControlled: true,
        enableDrag: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(50.r),
          ),
        ),
        barrierColor: context.isDark
            ? context.themeData.scaffoldBackgroundColor.withValues(alpha: 0.4)
            : AppColors.iconColor.withValues(alpha: 0.5),
        builder: (BuildContext context) {
          return BlocProvider(
            create: (context) => getIt<BackupCubit>(),
            child: ConfirmRestoreBackupBottomSheet(
              dataStore: state.dataStore,
            ),
          );
        },
      );
    }
  }

  CustomAppBar _buildAppBar(BuildContext context) {
    return CustomAppBar(
      size: const Size.fromHeight(kToolbarHeight),
      title: Text(
        'backups'.tr(),
        style: context.textTheme.titleLarge,
      ),
    );
  }
}
