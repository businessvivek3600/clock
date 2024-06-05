import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../home_page.dart';

class ClockView extends StatefulWidget {
  const ClockView({super.key});

  @override
  State<ClockView> createState() => _ClockViewState();
}

class _ClockViewState extends State<ClockView> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeNotifier.value = DateTime.now();
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      width: 300,
      child: Transform.rotate(
        angle: -pi / 2,
        child: CustomPaint(
          painter: ClockPainter(),
        ),
      ),
    );
  }
}

class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    DateTime now = timeNotifier.value;
    double centerX = size.width / 2;
    double centerY = size.height / 2;
    Offset center = Offset(centerX, centerY);
    double radius = min(centerX, centerY);
    double strokeWidth = 16;
    double secTickLineWidth = 5;

    Color secHandColor = const Color(0xFFFF5C5C);
    List<Color> minHandColors = const [Color(0xFF748EF6), Color(0xFF77DDFF)];
    List<Color> hourHandColors = const [Color(0xFFEA74AB), Color(0xFFC279FB)];

    double secWidth = strokeWidth / 3;
    double secHandLength = radius - 40;
    double secHandTailLength = 20;

    double minWidth = strokeWidth / 2;
    double minHandLength = radius - 60;
    double minHandTailLength = 20;

    double hourWidth = strokeWidth / 1.5;
    double hourHandLength = radius - 80;
    double hourHandTailLength = 20;

    var fillBrush = Paint()
      ..color = const Color(0xFF444974)
      ..style = PaintingStyle.fill;

    var outlineBrush = Paint()
      ..color = const Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint centerFillBrush(Color color, double w) => Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = w;

    var secHandBrush = Paint()
      ..color = secHandColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = secWidth;

    var minHandBrush = Paint()
      ..shader = RadialGradient(colors: minHandColors)
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = minWidth;

    var hourHandBrush = Paint()
      ..shader = RadialGradient(colors: hourHandColors)
          .createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = hourWidth;

    var dashBrush = Paint()
      ..color = const Color(0xFFEAECFF)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    var outerCircleRadius = radius - 45 - strokeWidth / 2;
    var innerCircleRadius = radius - 45 - strokeWidth / 2;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outlineBrush);

    ///hour hand
    double hourHandX =
        centerX + 60 * cos((now.hour * 30 + now.minute * 0.5) * pi / 180);
    double hourHandY =
        centerY + 60 * sin((now.hour * 30 + now.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);
    canvas.drawCircle(
        center, strokeWidth / 1.5, centerFillBrush(hourHandColors.first, 2));

    double minHandX = centerX + 80 * cos(now.minute * 6 * pi / 180);
    double minHandY = centerY + 80 * sin(now.minute * 6 * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);
    canvas.drawCircle(
        center, strokeWidth / 2, centerFillBrush(minHandColors.first, 2));

    double secHandX = centerX + 80 * cos(now.second * 6 * pi / 180);
    double secHandY = centerY + 80 * sin(now.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);
    canvas.drawCircle(
        center, strokeWidth / 3, centerFillBrush(secHandColor, 2));

    /// inner second lines for each tick

    for (double i = 0; i < 360; i += 6) {
      double x1 =
          centerX + (innerCircleRadius + secTickLineWidth) * cos(i * pi / 180);
      double y1 =
          centerY + (innerCircleRadius + secTickLineWidth) * sin(i * pi / 180);
      double x2 =
          centerX + (outerCircleRadius - secTickLineWidth) * cos(i * pi / 180);
      double y2 =
          centerY + (outerCircleRadius - secTickLineWidth) * sin(i * pi / 180);

      double hi = 5;
      if (i % 90 == 0) {
        y1 += (i == 90 ? hi : (i == 270 ? -hi : 0));
        y2 += (i == 90 ? -hi : (i == 270 ? hi : 0));
        x1 += (i == 0 ? hi : (i == 180 ? -hi : 0));
        x2 += (i == 0 ? -hi : (i == 180 ? hi : 0));

        dashBrush.strokeWidth = 5;
        dashBrush.color = hourHandColors.first;
        dashBrush.strokeCap = StrokeCap.square;
      } else if (i % 30 == 0) {
        dashBrush.strokeWidth = 2.5;
        dashBrush.color = Colors.white;
        dashBrush.strokeCap = StrokeCap.round;
      } else {
        dashBrush.strokeWidth = 1;
        dashBrush.color = Colors.white;
        dashBrush.strokeCap = StrokeCap.round;
      }
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
