import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/data/models/accuse_model.dart';

import '../../../core/theme/app_colors.dart';
import '../filter_cubit/filter_cubit.dart';

class ListIssueNumbers extends StatefulWidget {
  const ListIssueNumbers({super.key});

  @override
  State<ListIssueNumbers> createState() => _ListIssueNumbersState();
}

class _ListIssueNumbersState extends State<ListIssueNumbers> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(-1);

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final listAccused = AccusedModel.removeDuplicates(
      context.read<FilterCubit>().listAccused,
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ValueListenableBuilder<int>(
        valueListenable: _selectedIndex,
        builder: (context, selectedIndex, child) {
          return Row(
            spacing: 2.w,
            children: List.generate(
              listAccused.length,
              (index) {
                final issueNumber = listAccused[index].issueNumber.toString();
                final isSelected = selectedIndex == index;

                return RawChip(
                  showCheckmark: false,
                  labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
                  selectedColor: context.themeData.primaryColor,
                  side: BorderSide(
                    color: AppColors.grey.withValues(alpha: 0.1),
                  ),
                  backgroundColor: context.customColors?.backgroundTextField,
                  selected: isSelected,
                  visualDensity: const VisualDensity(horizontal: 4),
                  label: Text(
                    issueNumber,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: isSelected
                          ? AppColors.white
                          : context.isDark
                              ? null
                              : AppColors.iconColor,
                    ),
                  ),
                  onPressed: () {
                    final isAlreadySelected = _selectedIndex.value == index;
                    context.read<FilterCubit>().filterByIssueNumber(
                          listAccused[index].issueNumber!,
                          isAlreadySelected,
                        );

                    _selectedIndex.value = isAlreadySelected ? -1 : index;
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
