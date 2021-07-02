import 'package:flutter/material.dart';
import 'package:lit_ui_kit/lit_ui_kit.dart';
import 'dart:math' as Math;

class PercentIndicatorPainter extends CustomPainter {
  final double progressRatio;
  final AnimationController? animationController;
  const PercentIndicatorPainter({
    required this.progressRatio,
    required this.animationController,
  });
  @override
  void paint(Canvas canvas, Size size) {
    /// Define the life thirds.
    final double firstThird = (1 / 3);
    final double secondThird = (2 / 3);

    /// The [Color] the progress [Paint] will draw with.
    final Color progressColor = progressRatio < firstThird
        ? LitColors.mintGreen
        : progressRatio < secondThird ? LitColors.lightRed : LitColors.midRed;

    /// The midpoint of the canvas.
    final Offset center = Offset(size.width / 2, size.height / 2);

    /// The radius which will always be the lower value of the
    /// canvas midpoint.
    final double radius = Math.min(center.dx, center.dy);

    /// The total radian of the circle is calculated by multiplying
    /// the full circle (2 PI) by the provided [progressRatio].
    final double radian =
        animationController!.value * (2 * Math.pi) * (progressRatio);

    /// The [Offset] used to draw the ending indicator of the progress
    /// bar.
    final Offset endDotOffset = Offset(
      ((center.dx) + (radius * Math.sin(radian))),
      ((center.dy) - (radius * Math.cos(radian))),
    );

    final Rect arc = Rect.fromCircle(center: center, radius: radius);

    /// The [Paint] objects used to draw the shapes.
    final Paint progress = Paint()
      ..color = progressColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    final Paint bg = Paint()
      ..color = Colors.white54
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    final Paint cirBg = Paint()
      ..color = LitColors.mediumGrey.withOpacity(0.6)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;
    final Paint progressDots = Paint()
      ..color = LitColors.lightMintGreen
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.fill;

    canvas.drawOval(Rect.fromCircle(center: center, radius: radius), bg);
    canvas.drawArc(arc, -Math.pi / 2, radian, false, progress);
    canvas.drawOval(
        Rect.fromCircle(center: Offset(size.width / 2, 0), radius: 3.0),
        progressDots);
    canvas.drawCircle(Offset(center.dx, center.dy), 18, cirBg);

    canvas.drawCircle(endDotOffset, 3, progressDots);
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
          text:
              "${(progressRatio * 100.0 * animationController!.value).toInt()}",
          style: LitTextStyles.sansSerif.copyWith(
            color: Colors.white,
            fontSize: 12.0,
            fontWeight: FontWeight.w700,
          )),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );
    textPainter.paint(
        canvas,
        Offset(center.dx - textPainter.width / 2,
            center.dy - textPainter.height / 2));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
