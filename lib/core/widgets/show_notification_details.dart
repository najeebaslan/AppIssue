import 'package:flutter/material.dart';
import 'package:issue/core/extensions/string_extension.dart';
import 'package:issue/core/router/routes_constants.dart';
import 'package:issue/data/data_base/db_helper.dart';

import '../services/notifications/payload_model.dart';
import '../services/services_locator.dart';

class ShowNotificationDetails extends StatefulWidget {
  const ShowNotificationDetails({super.key, required this.notificationModel});
  final PayloadModel notificationModel;

  @override
  State<ShowNotificationDetails> createState() => _ShowNotificationDetailsState();
}

class _ShowNotificationDetailsState extends State<ShowNotificationDetails> {
  @override
  void initState() {
    super.initState();

    getIt
        .get<DBHelper>()
        .getAccuseById(int.parse(widget.notificationModel.id.validate()))
        .then((onValue) {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutesConstants.accusedDetailsView,
          arguments: onValue,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) => false,
      child: const Scaffold(
        body: SizedBox.shrink(),
      ),
    );
  }
}
