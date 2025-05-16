import 'dart:convert' as convert;

import 'package:easy_localization/easy_localization.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/core/extensions/iterable_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/networking/type_response.dart';
import 'package:issue/data/models/accuse_model.dart';
import 'package:sqflite/sqflite.dart';

import '../../core/services/encryption_service.dart';
import '../../core/utils/alarms_days.dart';
import '../../features/backup/backup_cubit/backup_cubit.dart';
import '../../features/settings/widgets/notification_cleanup.dart';
import '../models/notification_model.dart';

class DBHelper {
  DBHelper._();
  static final DBHelper instance = DBHelper._();
  static Database? _database;
  static const int _version = 2;
  static const String _tableName = "tasks";
  static const String _notificationTableName = "notifications";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = '${await getDatabasesPath()}Issue.db';
    return await openDatabase(
      path,
      version: _version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await Future.wait([
      db.execute('''
        CREATE TABLE $_tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          note TEXT,
          date TEXT,
          issueNumber TEXT,
          accused TEXT,
          phoneNu INTEGER,
          firstAlarm INTEGER,
          nextAlarm INTEGER,
          thirdAlert INTEGER,
          isCompleted INTEGER
        )
      '''),
      db.execute('''
        CREATE TABLE $_notificationTableName (
          notificationID INTEGER PRIMARY KEY AUTOINCREMENT,
          userID INTEGER,
          notificationDate TEXT,
          alarmType INTEGER
        )
      '''),
    ]);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE $_notificationTableName (
          notificationID INTEGER PRIMARY KEY AUTOINCREMENT,
          userID INTEGER,
          notificationDate TEXT,
          alarmType INTEGER
        )
      ''');
    }
  }

  Future<int?> addAccused(AccusedModel? accused) async {
    if (accused == null) return null;
    final isUserExist = await searchAccusedByName(accused.name.validate());
    if (!isUserExist.isEmptyOrNull) throw 'userAlreadyExist'.tr();
    try {
      final db = await database;
      return db.insert(_tableName, accused.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AccusedModel>> getAllAccused() async {
    final db = await database;
    return _fetchAccusedList(await db.query(_tableName));
  }

// Method to fetch data added a specific number of days ago
  Future<List<Map<String, dynamic>>> fetchDataDaysAgo(int days) async {
    DateTime targetDate = DateTime.now().subtract(Duration(days: days));

    Map<int, String> fieldMap = {7: 'firstAlarm', 52: 'nextAlarm', 97: 'thirdAlert'};
    Map<int, int> completedLevelMap = {7: 0, 52: 7, 97: 52};
    String nameField = fieldMap[days] ?? '';
    final formattedTargetDate = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final dateNow = DateTime.now().subtract(Duration(days: completedLevelMap[days] ?? 0));
    final db = await database;

    final query = await db.rawQuery(
      'SELECT * FROM $_tableName WHERE date >= ? AND date <= ? AND isCompleted=? AND $nameField=?',
      [formattedTargetDate.toString(), dateNow.toString(), 0, 0],
    );

    return query;
  }

  Future<int?> addNotification(NotificationModel notification) async {
    try {
      final db = await database;
      return await db.insert(_notificationTableName, notification.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    final db = await database;
    final result = await db.query(_notificationTableName);
    if (result.isEmptyOrNull) return [];
    return result.map((e) => NotificationModel.fromMap(e)).toList();
  }

  Future<int?> clearAllNotifications(NotificationCleanupOptions notificationCleanupOptions) async {
    late DateTime form;
    if (notificationCleanupOptions == NotificationCleanupOptions.daily) {
      form = DateTime.now().subtract(const Duration(days: 2));
    } else if (notificationCleanupOptions == NotificationCleanupOptions.weekly) {
      form = DateTime.now().subtract(const Duration(days: 8));
    } else if (notificationCleanupOptions == NotificationCleanupOptions.monthly) {
      form = DateTime.now().subtract(const Duration(days: 31));
    }

    final db = await database;
    return await db.delete(
      _notificationTableName,
      where: 'notificationDate >= ? AND notificationDate <= ?',
      whereArgs: [form.toString(), DateTime.now().subtract(const Duration(days: 1)).toString()],
    );
  }

// Generic fetch function for different days
  Future<List<AccusedModel>> fetchDataByDays(int days) async {
    Map<int, AlarmLevel> totalAlarmDaysMap = {
      7: AlarmLevel.first,
      52: AlarmLevel.next,
      97: AlarmLevel.third,
    };
    final totalAlarmDays = AlarmsDays.calculateLavalDays(totalAlarmDaysMap[days]!);
    final firstAlarm = _fetchAccusedList(await fetchDataDaysAgo(totalAlarmDays));

    return firstAlarm.where((accused) {
      final alarmDate = DateTime.parse(accused.date!).add(Duration(days: totalAlarmDays));
      final remainingDays = DateTime.now().getRemainingDays(time: alarmDate);
      return remainingDays == 1 || remainingDays == 0;
    }).toList();
  }

  Future<List<AccusedModel>> fetchData7DaysAgo() => fetchDataByDays(7);
  Future<List<AccusedModel>> fetchData52DaysAgo() => fetchDataByDays(52);
  Future<List<AccusedModel>> fetchData97DaysAgo() => fetchDataByDays(97);

  Future<List<AccusedModel>> customQueryByExpiredTime() async {
    final db = await database;
    return _fetchAccusedList(await db.query(_tableName, where: 'isCompleted=?', whereArgs: [1]));
  }

  Future<AccusedModel> getAccuseById(int id) async {
    final db = await database;
    return _fetchAccusedList(await db.query(_tableName, where: 'id=?', whereArgs: [id])).first;
  }

  Future<int?> deleteAccused(int? accusedID) async {
    try {
      final db = await database;
      return await db.delete(_tableName, where: 'id=?', whereArgs: [accusedID]);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateByNameField(
      {required int accusedID, required int typeAlarm, required String nameField}) async {
    try {
      final sql = nameField == 'isCompleted'
          ? 'UPDATE $_tableName SET firstAlarm = ?, nextAlarm = ?, thirdAlert = ?, isCompleted = ? WHERE id =?'
          : 'UPDATE $_tableName SET $nameField = ? WHERE id =?';

      final args = nameField == 'isCompleted' ? [0, 0, 0, 1, accusedID] : [typeAlarm, accusedID];

      final db = await database;
      return await db.rawUpdate(sql, args);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> completedAccused({required int accusedID}) async {
    try {
      const sql =
          'UPDATE $_tableName SET firstAlarm = ?, nextAlarm = ?, thirdAlert = ?, isCompleted = ? WHERE id =?';

      final args = [1, 1, 1, 1, accusedID];

      final db = await database;
      return await db.rawUpdate(sql, args);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> reActiveAccused({required int accusedID}) async {
    try {
      const sql =
          'UPDATE $_tableName SET firstAlarm = ?, nextAlarm = ?, thirdAlert = ?, isCompleted = ? WHERE id =?';

      final args = [0, 0, 0, 0, accusedID];

      final db = await database;
      return await db.rawUpdate(sql, args);
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> updateAllDataAccused(AccusedModel accused) async {
    try {
      final db = await database;
      return await db.rawUpdate('''
        UPDATE $_tableName
        SET name = ?, note = ?, date = ?, issueNumber = ?, accused = ?, phoneNu = ?
        WHERE id =?
      ''', [
        accused.name!,
        accused.note!,
        accused.date!,
        accused.issueNumber!,
        accused.accused!,
        accused.phoneNu!,
        accused.id!
      ]);
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> addDataTest(List<Map<String, Object?>> data) async {
    try {
      await clearAllTables();
      for (var element in data) {
        final db = await database;
        await db.insert(_tableName, element);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> clearAllTables() async {
    try {
      final db = await database;
      await db.delete(_tableName);
      await db.rawQuery("DELETE FROM sqlite_sequence WHERE name='$_tableName'");
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AccusedModel>> searchAccusedByName(String name) async {
    final db = await database;
    return _fetchAccusedList(
        await db.rawQuery("SELECT * FROM $_tableName WHERE name LIKE ?", ['%$name%']));
  }

  Future<List<AccusedModel>> filterByDetailsNotification() async {
    final db = await database;
    return _fetchAccusedList(await db.rawQuery(
        'SELECT * FROM $_tableName WHERE isCompleted=? AND firstAlarm=? AND nextAlarm=? AND thirdAlert=?',
        [0, 0, 0, 0]));
  }

  Future<ResponseResult<String, String>> generateBackup() async {
    try {
      final db = await database;
      final backups = await db.query(_tableName);
      if (backups.isEmptyOrNull) return Failure('notFountDataInDataBase');
      String json = convert.jsonEncode(backups);
      return Success(EncryptionService().encryptData(json));
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<ResponseResult<String, String>> restoreBackup({
    required String backup,
    required TypeRestoreBackup typeResterBackup,
  }) async {
    try {
      final db = await database;
      Batch batch = db.batch();
      final result = EncryptionService().decryptData(backup);
      if (result is Success) {
        List<dynamic> json = convert.jsonDecode(result.success ?? '');
        for (var item in json) {
          Map<String, dynamic> result = AccusedModel(
            accused: item['accused'],
            date: item['date'],
            id: item['id'],
            isCompleted: item['isCompleted'],
            issueNumber: item['issueNumber'],
            name: item['name'],
            note: item['note'],
            phoneNu: item['phoneNu'],
            firstAlarm: item['firstAlarm'],
            nextAlarm: item['nextAlarm'],
            thirdAlert: item['thirdAlert'],
          ).toMap();
          if (typeResterBackup == TypeRestoreBackup.merge) {
            final db = await database;
            final existingRecord =
                await db.query(_tableName, where: 'id = ?', whereArgs: [item['id']]);

            if (existingRecord.isEmpty) batch.insert(_tableName, result);
          } else {
            batch.insert(_tableName, result, conflictAlgorithm: ConflictAlgorithm.replace);
          }
        }
        await batch.commit(continueOnError: false, noResult: true);

        return Success('Successfully Restored');
      } else {
        return Failure('Backup is not valid');
      }
    } catch (e) {
      return Failure(e.toString());
    }
  }

  // Helper method to fetch and map results
  List<AccusedModel> _fetchAccusedList(List<Map<String, dynamic>>? result) {
    return result?.map((e) => AccusedModel.fromMap(e)).toList() ?? [];
  }
}
