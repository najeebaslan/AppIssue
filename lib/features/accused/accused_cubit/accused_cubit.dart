import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:issue/core/extensions/iterable_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/data/models/notification_model.dart';

import '../../../core/utils/alarms_days.dart';
import '../../../data/data_base/db_helper.dart';
import '../../../data/models/accuse_model.dart';

part 'accused_state.dart';

class AccusedCubit extends Cubit<AccusedState> {
  AccusedCubit(this._dbHelper) : super(AccusedInitial());
  final DBHelper _dbHelper;
  List<AccusedModel> listAccused = List.empty(growable: true);
  AccusedModel? updatedAccused;
  void getAccused() async {
    try {
      emit(LoadingGetAccused());
      final getAllAccused = await _dbHelper.getAllAccused();
      if (getAllAccused.isEmptyOrNull) {
        emit(EmptyGetAccused());
        return;
      }
      listAccused = getAllAccused;
      _sortByDateAccused();
      emit(SuccessGetAccused(listAccused));
    } catch (e) {
      emit(ErrorGetAccused(e.toString()));
    }
  }

  void _sortByDateAccused() {
    listAccused.sort(
      (a, b) => DateTime.parse(b.date.validate()).compareTo(
        DateTime.parse(a.date.toString()),
      ),
    );
  }

  void addAccused(AccusedModel accused) async {
    try {
      emit(LoadingAddAccused());
      final addAccused = await _dbHelper.addAccused(accused);
      if (addAccused is int) emit(SuccessAddAccused());
    } catch (e) {
      emit(ErrorAddAccused(e.toString()));
    }
  }

  void updateAllDataAccused(AccusedModel accused) async {
    try {
      final updateAccused = await _dbHelper.updateAllDataAccused(accused);
      if (updateAccused is int) {
        int index = listAccused.indexWhere((data) => data.id == accused.id!);
        listAccused.remove(listAccused[index]);
        listAccused.insert(index, accused);
        _setState(listAccused[index]);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void deleteAccused(int? accusedID) async {
    try {
      final updateAccused = await _dbHelper.deleteAccused(accusedID);
      if (updateAccused is int) {
        int index = listAccused.indexWhere((data) => data.id == accusedID);
        listAccused.remove(listAccused[index]);
        listAccused.length > 1 ? _setState(listAccused[index]) : _setState(null);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void accuseDisableOrEnable(int accusedID, AlarmTypes alarmTypes, bool isEnable) async {
    try {
      await _dbHelper.updateByNameField(
        accusedID: accusedID,
        typeAlarm: isEnable ? 0 : 1,
        nameField: alarmTypes.name,
      );

      int index = listAccused.indexWhere((data) => data.id == accusedID);
      switch (alarmTypes) {
        case AlarmTypes.firstAlarm:
          listAccused[index] = listAccused[index].copyWith(firstAlarm: 1);
          break;
        case AlarmTypes.nextAlarm:
          listAccused[index] = listAccused[index].copyWith(nextAlarm: 1);
          break;
        case AlarmTypes.thirdAlert:
          listAccused[index] = listAccused[index].copyWith(thirdAlert: 1);
        case AlarmTypes.isCompleted:
          listAccused[index] = listAccused[index].copyWith(isCompleted: 1);
          break;
      }
      _setState(listAccused[index]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<bool> accuseCompleted(int accusedID) async {
    try {
      await _dbHelper.completedAccused(accusedID: accusedID);
      int index = listAccused.indexWhere((data) => data.id == accusedID);
      listAccused[index] = listAccused[index].accuseCompleted();
      _setState(listAccused[index]);
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> reActiveAccuse(int accusedID) async {
    try {
      await _dbHelper.reActiveAccused(accusedID: accusedID);

      int index = listAccused.indexWhere((data) => data.id == accusedID);
      listAccused[index] = listAccused[index].reActiveAccuse();

      _setState(listAccused[index]);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void _setState(AccusedModel? accusedModel) => emit(SetState(accused: accusedModel));
  void onRefreshProfile() => emit(OnRefreshProfileAppBar());
}
