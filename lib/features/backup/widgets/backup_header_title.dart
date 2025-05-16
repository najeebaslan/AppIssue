
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:issue/core/extensions/context_extension.dart';

class BackUpHeaderTitle extends StatelessWidget {
  const BackUpHeaderTitle({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: title.tr(),
        style: context.textTheme.titleLarge?.copyWith(
          letterSpacing: 0.5,
        ),
        children: <TextSpan>[
          TextSpan(
            text: '\n?Google Drive',
            style: context.textTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
