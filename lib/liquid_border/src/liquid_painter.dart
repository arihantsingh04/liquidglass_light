import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'liquid_shape.dart';
import 'liquid_style.dart';

class LiquidBorderPainter extends CustomPainter {
  final LiquidShape shape;
  final LiquidStyle style;
  final BorderRadius radius;
  final Color? fillColor;

  LiquidBorderPainter({
    required this.shape,
    required this.style,
    required this.radius,
    this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final RRect rrect = _resolveShape(rect);

    if (fillColor != null) {
      final paint = Paint()..color = fillColor!;
      canvas.drawRRect(rrect, paint);
    }

    if (style.insideGlowIntensity > 0) {
      _drawInnerSourceGlow(canvas, rrect, rect);
    }

    final double lightAngle = _calculateAngle(style.lightSource, rect);

    if (style.withOuterGlow) {
      _drawGlow(canvas, rrect, rect, lightAngle);
    }

    _drawPrimaryStroke(canvas, rrect, rect, lightAngle);

    if (style.withInnerHighlight) {
      _drawInnerHighlight(canvas, rrect, rect, lightAngle);
    }
  }

  RRect _resolveShape(Rect rect) {
    if (shape == LiquidShape.circle) {
      final double s = math.min(rect.width, rect.height);
      final center = rect.center;
      return RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: s, height: s),
        Radius.circular(s / 2),
      );
    } else if (shape == LiquidShape.stadium) {
      return RRect.fromRectAndRadius(rect, Radius.circular(999));
    }
    return radius.toRRect(rect);
  }

  double _calculateAngle(Alignment alignment, Rect rect) {
    if (shape == LiquidShape.stadium) {
      return math.atan2(alignment.y * rect.height, alignment.x * rect.width);
    }
    return math.atan2(alignment.y, alignment.x);
  }

  void _drawInnerSourceGlow(Canvas canvas, RRect rrect, Rect rect) {
    final paint = Paint()..style = PaintingStyle.fill;

    final glowColor = style.baseColor.withValues(alpha: style.insideGlowIntensity);

    paint.shader = RadialGradient(
      center: style.lightSource,
      radius: 0.75,
      colors: [glowColor, Colors.transparent],
      stops: const [0.0, 1.0],
    ).createShader(rect);

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRect(rect, paint);
    canvas.restore();
  }

  void _drawPrimaryStroke(Canvas canvas, RRect rrect, Rect rect, double angle) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.thickness
      ..strokeCap = StrokeCap.round;

    // USE NEW style.refractionIntensity here at index 2
    final colors = [
      style.baseColor.withValues(alpha: 0.95),             // 0.0:  Main Highlight
      style.baseColor.withValues(alpha: 0.0),              // 0.25: Transparent
      style.baseColor.withValues(alpha: style.refractionIntensity), // 0.5: Refraction
      style.baseColor.withValues(alpha: 0.0),              // 0.75: Transparent
      style.baseColor.withValues(alpha: 0.95),             // 1.0:  Loop
    ];

    const stops = [0.0, 0.25, 0.5, 0.75, 1.0];

    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: colors,
      stops: stops,
      transform: GradientRotation(angle),
    );

    paint.shader = gradient.createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  void _drawInnerHighlight(Canvas canvas, RRect rrect, Rect rect, double angle) {
    final double inset = style.thickness * 0.8;
    final RRect innerRRect = rrect.deflate(inset);

    if (innerRRect.width <= 0 || innerRRect.height <= 0) return;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.5, style.thickness * 0.6);

    // Inner highlight also respects refraction intensity for the bottom-right glint
    final colors = [
      style.baseColor.withValues(alpha: 1.0 * style.intensity),
      Colors.transparent,
      style.baseColor.withValues(alpha: 0.5 * style.refractionIntensity), // Scaled
      Colors.transparent,
      style.baseColor.withValues(alpha: 1.0 * style.intensity),
    ];

    const stops = [0.0, 0.20, 0.5, 0.80, 1.0];

    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: colors,
      stops: stops,
      transform: GradientRotation(angle),
    );

    paint.shader = gradient.createShader(rect);
    canvas.drawRRect(innerRRect, paint);
  }

  void _drawGlow(Canvas canvas, RRect rrect, Rect rect, double angle) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.thickness * 3
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final colors = [
      style.baseColor.withValues(alpha: 0.4 * style.intensity),
      Colors.transparent,
      Colors.transparent,
      Colors.transparent,
      style.baseColor.withValues(alpha: 0.4 * style.intensity),
    ];

    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: colors,
      stops: [0.0, 0.2, 0.5, 0.8, 1.0],
      transform: GradientRotation(angle),
    );

    paint.shader = gradient.createShader(rect);
    canvas.drawRRect(rrect.inflate(1), paint);
  }

  @override
  bool shouldRepaint(LiquidBorderPainter oldDelegate) {
    return oldDelegate.style != style ||
        oldDelegate.shape != shape ||
        oldDelegate.fillColor != fillColor ||
        oldDelegate.radius != radius;
  }
}