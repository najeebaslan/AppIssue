import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:issue/core/extensions/context_extension.dart';
import 'package:issue/core/theme/color_hex.dart';

import '../../../core/utils/alarms_days.dart';

class CircleChartsAlarm extends StatelessWidget {
  const CircleChartsAlarm({super.key, required this.remainingDays});
  final int remainingDays;
  static int circleArea = 360;
  static int thirdAlarmDays = AlarmsDays.calculateLavalDays(
    AlarmLevel.third,
  );
  @override
  Widget build(BuildContext context) {
    const Color nearlyDarkBlue = Color(0xFF2633C5);

    int completedDays = ((remainingDays - thirdAlarmDays) * (100 / thirdAlarmDays)).toInt().abs();
    if (remainingDays == 0 && completedDays == 99) {
      completedDays = 100;
    }
    return Stack(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      children: <Widget>[
        Container(
          width: 90,
          height: 90,
          margin: const EdgeInsets.only(bottom: 4, right: 5, top: 4, left: 5),
          decoration: BoxDecoration(
            color: context.isDark ? const Color(0xFF2D303F).withAlpha(100) : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              width: 4.w,
              color: context.isDark
                  ? Colors.blueAccent.withValues(alpha: 0.1)
                  : nearlyDarkBlue.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                '$completedDays%',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium,
              ),
              Flexible(
                child: Text(
                  context.locale.languageCode == 'ar'
                      ? "${'level'.tr()} ${AlarmsDays.getLevelName(completedDays).tr()}"
                      : "${AlarmsDays.getLevelName(completedDays).tr()}  ${'level'.tr()}",
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    letterSpacing: -0.7,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        CustomPaint(
          painter: CurvePainter(
            colors: [
              context.isDark
                  ? nearlyDarkBlue.withValues(alpha: 0.9)
                  : nearlyDarkBlue.withValues(alpha: 0.9),
              HexColor("#8A98E8"),
              HexColor("#8A98E8"),
            ],
            angle: ((remainingDays - thirdAlarmDays) / thirdAlarmDays * circleArea).abs(),
          ),
          child: const SizedBox(width: 100, height: 100),
        ),
      ],
    );
  }
}

class CurvePainter extends CustomPainter {
  final double angle;
  final List<Color> colors;

  CurvePainter({required this.colors, this.angle = 140});

  @override
  void paint(Canvas canvas, Size size) {
    List<Color> colorsList = [];
    colorsList = colors;
    final rect = Rect.fromLTWH(0.0, 0.0, size.width, size.width);
    final gradient = SweepGradient(
      startAngle: degreeToRadians(268),
      endAngle: degreeToRadians(270.0 + 360),
      tileMode: TileMode.repeated,
      colors: colorsList,
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round // StrokeCap.round is not recommended.
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2) - (14 / 2);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), degreeToRadians(278),
        degreeToRadians(360 - (365 - angle)), false, paint);

    const gradient1 = SweepGradient(
      tileMode: TileMode.repeated,
      colors: [Colors.white, Colors.white],
    );

    var cPaint = Paint();
    cPaint.shader = gradient1.createShader(rect);
    cPaint.color = Colors.white;
    cPaint.strokeWidth = 14 / 2;
    canvas.save();

    final centerToCircle = size.width / 2;
    canvas.save();

    canvas.translate(centerToCircle, centerToCircle);
    canvas.rotate(degreeToRadians(angle + 2));

    canvas.save();
    canvas.translate(0.0, -centerToCircle + 14 / 2);
    canvas.drawCircle(const Offset(0, 0), 14 / 5, cPaint);

    canvas.restore();
    canvas.restore();
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  double degreeToRadians(double degree) {
    var redian = (math.pi / 180) * degree;
    return redian;
  }
}
