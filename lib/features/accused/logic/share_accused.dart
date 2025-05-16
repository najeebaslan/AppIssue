import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:issue/core/extensions/date_time_extension.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/services/shard_pdf_service.dart';
import '../../../core/utils/alarms_days.dart';
import '../../../core/utils/app_theme_and_languages_notifier/app_theme_and_languages_cubit.dart';
import '../../../data/models/accuse_model.dart';

class ShareAccusedAsPDF {
  void onShareAccused(AccusedModel accused, BuildContext context) async {
    final totalAlarmDays = [
      AlarmsDays.calculateLavalDays(AlarmLevel.first),
      AlarmsDays.calculateLavalDays(AlarmLevel.next),
      AlarmsDays.calculateLavalDays(AlarmLevel.third),
    ];

    final alarmDates = totalAlarmDays
        .map((days) => DateTime.parse(accused.date.toString()).add(Duration(days: days)))
        .toList();
    final invoice = Invoice(
      supplier: Supplier(
        name: 'charge_details'.tr(),
        address: accused.name ?? '',
        paymentInfo: 'https://paypal.me/sarahfieldzz',
      ),
      items: [
        InvoiceItem(
          description: '${'notice'.tr()} ${"first".tr()}',
          date: alarmDates[0].toString().formatWithEnglishLanguage(),
          remainingDays: (accused.firstAlarm == 1 || accused.isCompleted == 1)
              ? 'durationCompleted'.tr()
              : '${DateTime.now().getRemainingDays(time: alarmDates[0])} ${'day'.tr()}',
        ),
        InvoiceItem(
          description: '${'notice'.tr()} ${"second".tr()}',
          date: alarmDates[1].toString().formatWithEnglishLanguage(languageCode: 'en'),
          remainingDays: (accused.nextAlarm == 1 || accused.isCompleted == 1)
              ? 'durationCompleted'.tr()
              : '${DateTime.now().getRemainingDays(time: alarmDates[1])} ${'day'.tr()}',
        ),
        InvoiceItem(
          description: '${'notice'.tr()} ${"third".tr()}',
          date: alarmDates[2].toString().formatWithEnglishLanguage(),
          remainingDays: (accused.thirdAlert == 1 || accused.isCompleted == 1)
              ? 'durationCompleted'.tr()
              : '${DateTime.now().getRemainingDays(time: alarmDates[2])} ${'day'.tr()}',
        ),
      ],
    );

    var username = accused.name.toString().trim().split(' ');
    var fullName = '${username.first} ${username.last}';

    final pdfFile = await SharedPDFService.generatePDFGraph(
      fullName,
      accused,
      invoice,
      context.locale.languageCode == 'ar' ? LanguageType.arabic : LanguageType.english,
    );
    XFile files = XFile.fromData(
      pdfFile.readAsBytesSync(),
      path: pdfFile.path,
      mimeType: 'application/pdf',
    );

    //This for share pdf then delete file
    await Share.shareXFiles([files]).then((value) async {
      await File(pdfFile.path).delete(recursive: true);
    });
  }
}
