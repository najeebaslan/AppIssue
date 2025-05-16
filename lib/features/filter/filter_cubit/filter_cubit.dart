import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/core/extensions/iterable_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';

import '../../../core/utils/alarms_days.dart';
import '../../../data/data_base/db_helper.dart';
import '../../../data/models/accuse_model.dart';

part 'filter_state.dart';

enum SortTypes { defaultType, alphabetically, addedRecently }

enum FilterTypes { defaultType, completed, stopped, endSoon }

class FilterCubit extends Cubit<FilterState> {
  FilterCubit(this._dbHelper) : super(FilterInitial());

  final DBHelper _dbHelper;
  int sortSelectedIndex = SortTypes.defaultType.index;
  int filterSelectedIndex = FilterTypes.defaultType.index;

  List<AccusedModel> listAccused = [];

  final List<SortTypes> listSortTypes = SortTypes.values.toList();
  final List<FilterTypes> listFilterTypes = FilterTypes.values.toList();

  void getAccusedFiltered() async {
    emit(LoadingFilteredAccusedState());

    try {
      final getAllAccused = await _dbHelper.getAllAccused();
      if (getAllAccused.isEmptyOrNull) {
        emit(EmptyGetAccusedState());
        return;
      }

      listAccused = getAllAccused;
      _sortAccusedByDate();
      emit(SuccessFilteredAccusedState(listAccused: listAccused));
    } catch (e) {
      emit(ErrorFilteredAccusedState(e.toString()));
    }
  }

  void onSelectedSort(SortTypes sort) {
    if (listAccused.isEmptyOrNull) return;
    sortSelectedIndex = sort.index;

    switch (sort) {
      case SortTypes.defaultType:
      case SortTypes.addedRecently:
        _sortAccusedByDate();
        break;
      case SortTypes.alphabetically:
        listAccused.sort((a, b) => a.name!.compareTo(b.name!));
        break;
    }

    emit(RefreshFilterView());
  }

  void onSelectedFilter(FilterTypes filter) {
    filterSelectedIndex = filter.index;

    switch (filter) {
      case FilterTypes.defaultType:
        _sortAccusedByDate();
        emit(RefreshFilterView());
        break;

      case FilterTypes.completed:
        emit(CompletedOrSoonCompletedSelected(
          listAccused: listAccused.where((data) => getRemainingDays(data) <= 0).toList(),
        ));
        break;

      case FilterTypes.stopped:
        final fakeList = listAccused.where((data) => data.isCompleted == 1).toList();
        fakeList.sort(
          (a, b) => DateTime.parse(b.date.toString()).compareTo(
            DateTime.parse(a.date.toString()),
          ),
        );
        emit(CompletedOrSoonCompletedSelected(listAccused: fakeList));
        break;

      case FilterTypes.endSoon:
        final fakeList = listAccused.where((data) {
          return getRemainingDays(data) <= 30;
        }).toList();
        emit(CompletedOrSoonCompletedSelected(listAccused: fakeList));
        break;
    }
  }

  void filterByIssueNumber(String issueNumber, bool unFiltered) {
    final filteredList = listAccused.where((data) => data.issueNumber == issueNumber).toList();
    emit(FilterByIssueNumber(listAccused: unFiltered ? listAccused : filteredList));
  }

  void searchAccusedList(String query) {
    if (query.isEmptyOrNull) {
      listAccused.isEmptyOrNull
          ? emit(EmptyGetAccusedState())
          : emit(SearchAccusedByNameOrIssueNumber(listAccused: listAccused));
    } else {
      final results = listAccused.where((accused) {
        return accused.name!.toLowerCase().contains(query.toLowerCase()) ||
            accused.issueNumber!.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(SearchAccusedByNameOrIssueNumber(listAccused: results));
    }
  }

  /// calculate days form add user data to after 97 [AlarmLevel.third]
  /// and get difference between  date today and date after 97 days
  /// then get the remaining days
  int getRemainingDays(AccusedModel data) {
    return DateTime.now().getRemainingDays(
      time: DateTime.parse(data.date!).add(
        Duration(days: AlarmsDays.calculateLavalDays(AlarmLevel.third)),
      ),
    );
  }

  void _sortAccusedByDate() {
    listAccused.sort(
      (a, b) => DateTime.parse(b.date.toString()).compareTo(
        DateTime.parse(a.date.toString()),
      ),
    );
  }
}
