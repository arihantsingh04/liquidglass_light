import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'liquid_shape.dart';
import 'liquid_style.dart';
import 'liquid_gyro.dart'; // Needed for type checking

class LiquidBorderPainter extends CustomPainter {
  final LiquidShape shape;
  final LiquidStyle style;
  final BorderRadius radius;
  final Color? fillColor;

  // FIX: Explicitly declare this field so we can access it inside paint()
  final Listenable? repaint;

  LiquidBorderPainter({
    required this.shape,
    required this.style,
    required this.radius,
    this.fillColor,
    this.repaint, // Initialize our local field
  }) : super(repaint: repaint); // Pass it to the superclass for the repaint mechanism

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final RRect rrect = _resolveShape(rect);

    // 1. Background
    if (fillColor != null) {
      final paint = Paint()..color = fillColor!;
      canvas.drawRRect(rrect, paint);
    }

    // 2. Determine Active Light Source
    // Default to style, but override if we have a live gyro controller
    Alignment activeLight = style.lightSource;

    // FIX: Now 'repaint' is accessible here
    if (repaint is LiquidController) {
      activeLight = (repaint as LiquidController).value;
    }

    // 3. Draw Layers using activeLight
    if (style.insideGlowIntensity > 0) {
      _drawInnerSourceGlow(canvas, rrect, rect, activeLight);
    }

    final double lightAngle = _calculateAngle(activeLight, rect);

    if (style.withOuterGlow) {
      _drawGlow(canvas, rrect, rect, lightAngle, activeLight);
    }

    _drawPrimaryStroke(canvas, rrect, rect, lightAngle, activeLight);

    if (style.withInnerHighlight) {
      _drawInnerHighlight(canvas, rrect, rect, lightAngle, activeLight);
    }
  }

  // --- Drawing Helpers ---

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

  void _drawInnerSourceGlow(Canvas canvas, RRect rrect, Rect rect, Alignment light) {
    final paint = Paint()..style = PaintingStyle.fill;
    final glowColor = style.baseColor.withValues(alpha: style.insideGlowIntensity);

    paint.shader = RadialGradient(
      center: light, // Dynamic light
      radius: 0.75,
      colors: [glowColor, Colors.transparent],
      stops: const [0.0, 1.0],
    ).createShader(rect);

    canvas.save();
    canvas.clipRRect(rrect);
    canvas.drawRect(rect, paint);
    canvas.restore();
  }

  void _drawPrimaryStroke(Canvas canvas, RRect rrect, Rect rect, double angle, Alignment light) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = style.thickness
      ..strokeCap = StrokeCap.round;

    final colors = [
      style.baseColor.withValues(alpha: 0.95),
      style.baseColor.withValues(alpha: 0.0),
      style.baseColor.withValues(alpha: style.refractionIntensity),
      style.baseColor.withValues(alpha: 0.0),
      style.baseColor.withValues(alpha: 0.95),
    ];

    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: colors,
      stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      transform: GradientRotation(angle),
    );

    paint.shader = gradient.createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  void _drawInnerHighlight(Canvas canvas, RRect rrect, Rect rect, double angle, Alignment light) {
    final double inset = style.thickness * 0.8;
    final RRect innerRRect = rrect.deflate(inset);
    if (innerRRect.width <= 0 || innerRRect.height <= 0) return;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.5, style.thickness * 0.6);

    final colors = [
      style.baseColor.withValues(alpha: 1.0 * style.intensity),
      Colors.transparent,
      style.baseColor.withValues(alpha: 0.5 * style.refractionIntensity),
      Colors.transparent,
      style.baseColor.withValues(alpha: 1.0 * style.intensity),
    ];

    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: colors,
      stops: const [0.0, 0.20, 0.5, 0.80, 1.0],
      transform: GradientRotation(angle),
    );

    paint.shader = gradient.createShader(rect);
    canvas.drawRRect(innerRRect, paint);
  }

  void _drawGlow(Canvas canvas, RRect rrect, Rect rect, double angle, Alignment light) {
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
      stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
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