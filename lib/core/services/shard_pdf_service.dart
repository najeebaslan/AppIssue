import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/constants/assets_constants.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/utils/app_theme_and_languages_notifier/app_theme_and_languages_cubit.dart';
import 'package:issue/data/models/accuse_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class SharedPDFService {
  static Future<File> generatePDFGraph(
      String nameFile, AccusedModel accused, Invoice invoice, LanguageType languageType) async {
    final ByteData bytes = await rootBundle.load(ImagesConstants.logo);
    final Uint8List byteList = bytes.buffer.asUint8List();
    final myFont = pw.Font.ttf(await rootBundle.load("assets/fonts/IBMPlexSansArabicRegular.ttf"));

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        textDirection:
            languageType == LanguageType.arabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
        theme: pw.ThemeData.withFont(base: myFont, bold: myFont),
        build: (context) => <pw.Widget>[
          _buildHeader(byteList, invoice, myFont),
          pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildCustomHeader(accused),
          pw.SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildCustomHeadline(languageType == LanguageType.arabic),
          ...buildBulletPoints(accused),
          _buildDetailsHeader(),
          buildInvoice(invoice),
        ],
        footer: (context) {
          final text = '${'page'.tr()} ${context.pageNumber} ${'of'.tr()} ${context.pagesCount}';
          return pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceAround, children: [
            pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1 * PdfPageFormat.cm),
              child: pw.Text(
                text,
                style: const pw.TextStyle(color: PdfColors.black),
              ),
            ),
          ]);
        },
      ),
    );
    return saveFilePDF(name: '$nameFile.pdf', pdf: pdf);
  }

  static Future<File> saveFilePDF({
    required String name,
    required pw.Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static pw.Widget _buildHeader(Uint8List byteList, Invoice invoice, pw.Font font) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
      children: [
        pw.Container(
          height: 100.h,
          width: 100.h,
          child: pw.Image(
            pw.MemoryImage(byteList),
            fit: pw.BoxFit.fitHeight,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 7),
          child: pw.Text(
            'extended_detention_dates'.tr(),
            style: pw.TextStyle(
              color: PdfColors.black,
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(width: 12.w),
        pw.Container(
          height: 100,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            textStyle: pw.TextStyle(
              color: PdfColors.lightBlueAccent700,
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
              font: font,
            ),
            data: invoice.supplier.name,
          ),
        ),
      ],
    );
  }

  static pw.Widget buildCustomHeader(AccusedModel accused) => pw.Container(
        padding: const pw.EdgeInsets.only(bottom: 3 * PdfPageFormat.mm),
        decoration: const pw.BoxDecoration(
          border: pw.Border(bottom: pw.BorderSide(width: 2, color: PdfColors.blue)),
        ),
        child: pw.Row(
          children: [
            pw.PdfLogo(),
            pw.SizedBox(width: 0.5 * PdfPageFormat.cm),
            pw.Text(
              accused.name.toString(),
              style: const pw.TextStyle(fontSize: 20, color: PdfColors.black),
            ),
          ],
        ),
      );

  static pw.Widget buildCustomHeadline(bool isArabic) => pw.Header(
        child: pw.Text(
          'charge_details'.tr(),
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.white,
          ),
        ),
        padding: const pw.EdgeInsets.all(4),
        decoration: const pw.BoxDecoration(color: PdfColors.blue),
      );

  static pw.Widget _buildDetailsHeader() {
    return pw.Header(
      child: pw.Text(
        'notice_details'.tr(),
        style: const pw.TextStyle(fontSize: 20),
      ),
    );
  }

  static List<pw.Widget> buildBulletPoints(AccusedModel accused) => [
        _customRow(label: 'charge'.tr(), value: accused.accused.toString()),
        _customRow(label: 'case_number'.tr(), value: accused.issueNumber.toString()),
        _customRow(label: 'defendant_agent_number'.tr(), value: '${accused.phoneNu ?? ''}'),
        _customRow(label: 'entry_date'.tr(), value: accused.date.formatWithEnglishLanguage()),
        _customRow(label: 'note'.tr(), value: accused.note ?? ''),
      ];

  static pw.Widget _customRow({required String label, required String value}) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.SizedBox(child: pw.Bullet(), width: 20, height: 20),
        pw.Text('$label: ', style: const pw.TextStyle(fontSize: 19)),
        pw.Text(value, style: const pw.TextStyle(fontSize: 20)),
      ],
    );
  }

  static pw.Widget buildInvoice(Invoice invoice) {
    final headers = [
      'theRemaining'.tr(),
      'notice_date'.tr(),
      'notice'.tr(),
    ];
    final data = invoice.items.map((item) {
      return [
        item.remainingDays,
        item.date,
        item.description,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      cellStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerRight,
        2: pw.Alignment.centerRight,
      },
    );
  }
}

class Invoice {
  final Supplier supplier;
  final List<InvoiceItem> items;

  const Invoice({
    required this.supplier,
    required this.items,
  });
}

class InvoiceItem {
  final String description;
  final String date;
  final String remainingDays;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.remainingDays,
  });
}

class Supplier {
  final String name;
  final String address;
  final String paymentInfo;

  const Supplier({
    required this.name,
    required this.address,
    required this.paymentInfo,
  });
}
