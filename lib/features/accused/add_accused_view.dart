import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/helpers/helper_user.dart';
import 'package:issue/core/services/services_locator.dart';
import 'package:issue/core/theme/theme.dart';
import 'package:issue/core/widgets/custom_button.dart';
import 'package:issue/data/data_base/db_helper.dart';
import 'package:issue/features/accused/accused_cubit/accused_cubit.dart';

import '../../core/widgets/custom_app_bar.dart';
import '../../data/models/accuse_model.dart';
import 'widgets/add_accused_bloc_listener.dart';
import 'widgets/form_add_accused.dart';

class AddAccusedView extends StatefulWidget {
  const AddAccusedView({super.key, this.accused});
  final AccusedModel? accused;

  @override
  State<AddAccusedView> createState() => _AddAccusedViewState();
}

class _AddAccusedViewState extends State<AddAccusedView> with AutomaticKeepAliveClientMixin {
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  final _issueController = TextEditingController();
  final _phoneController = TextEditingController();
  final _issueNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    if (widget.accused != null) {
      _nameController.text = widget.accused!.name.validate();
      _issueController.text = widget.accused!.accused.validate();
      _issueNumberController.text = widget.accused!.issueNumber.validate();
      _phoneController.text =
          widget.accused!.phoneNu == 0 ? '' : widget.accused!.phoneNu.toString();
      _noteController.text = widget.accused!.note ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    _issueController.dispose();
    _issueNumberController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: CustomAppBar(
        useCustomBackIconButton: widget.accused != null,
        size: const Size.fromHeight(kToolbarHeight),
        title: Text(
          widget.accused == null ? 'addDataAccused'.tr() : 'editDataAccused'.tr(),
          style: context.textTheme.titleLarge,
        ),
      ),
      body: AddAccusedBlocListener(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: defaultPadding.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: defaultPadding.h * 2),
                  FormAddAccused(
                    nameController: _nameController,
                    issueController: _issueController,
                    phoneController: _phoneController,
                    issueNumberController: _issueNumberController,
                    noteController: _noteController,
                  ),
                  SizedBox(height: defaultPadding.h * 3),
                  CustomButton(
                    elevation: 0,
                    onPressed: _submitForm,
                    label: widget.accused != null ? 'edit' : 'add',
                  ),
                  SizedBox(height: defaultPadding.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.accused == null ? _onAddAccused() : _onUpdateAccused();
    }
  }

  void _onAddAccused() async {
    AccusedModel accusedModel = AccusedModel(
      accused: _issueController.text.trim(),
      date: DateTime.now().toString(),
      note: _noteController.text,
      issueNumber: _issueNumberController.text,
      name: _nameController.text,
      phoneNu: _parsePhoneNumber(_phoneController.text),
      firstAlarm: 0,
      nextAlarm: 0,
      thirdAlert: 0,
      isCompleted: 0,
    );

    if (getIt.get<UserHelper>().isUserInTrialMode()) {
      await getIt.get<DBHelper>().clearAllTables().then((data) {
        if (mounted) {
          context.read<AccusedCubit>().addAccused(accusedModel);
          getIt.get<UserHelper>().saveIsUserInTrialMode(false);
        }
      });
    } else {
      context.read<AccusedCubit>().addAccused(accusedModel);
    }
  }

  void _onUpdateAccused() {
    final updatedAccused = widget.accused!.copyWith(
      accused: _issueController.text.trim(),
      note: _noteController.text,
      issueNumber: _issueNumberController.text,
      name: _nameController.text,
      phoneNu: _parsePhoneNumber(_phoneController.text),
    );

    context.read<AccusedCubit>().updateAllDataAccused(updatedAccused);
    Navigator.pop(context, updatedAccused);
  }

  int _parsePhoneNumber(String phone) {
    return phone.trim().isNotEmpty ? int.parse(phone.trim()) : 0;
  }

  @override
  bool get wantKeepAlive => true;
}
