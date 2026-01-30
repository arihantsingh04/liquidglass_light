import 'dart:ui';
import 'package:flutter/material.dart';
import 'liquid_shape.dart';
import 'liquid_style.dart';
import 'liquid_painter.dart';
import 'liquid_gyro.dart';

class LiquidContainer extends StatelessWidget {
  final Widget child;
  final LiquidShape shape;
  final LiquidStyle style;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  /// NEW: Whether this specific container should react to the gyro.
  /// Defaults to FALSE (off) as requested.
  final bool enableGyro;

  const LiquidContainer({
    super.key,
    required this.child,
    this.shape = LiquidShape.rectangle,
    this.style = const LiquidStyle(),
    this.borderRadius,
    this.backgroundColor,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.enableGyro = false, // Default: OFF
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius effectiveRadius =
        borderRadius ?? BorderRadius.circular(20);

    // 1. Conditional Gyro Lookup
    // If enableGyro is false, we pass null, so the painter stays static.
    final gyroController = enableGyro ? LiquidGyro.of(context) : null;

    // 2. Prepare content
    Widget content = Padding(
      padding: padding ?? EdgeInsets.all(style.thickness + 4),
      child: child,
    );

    // 3. Apply Blur if defined in style
    if (style.blurStrength > 0) {
      content = ClipRRect(
        borderRadius: _resolveBorderRadius(effectiveRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: style.blurStrength,
            sigmaY: style.blurStrength,
          ),
          child: content,
        ),
      );
    } else if (shape == LiquidShape.circle || shape == LiquidShape.stadium) {
      // Standard clipping for non-rect shapes
      content = ClipRRect(
        borderRadius: _resolveBorderRadius(effectiveRadius),
        child: content,
      );
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: CustomPaint(
        painter: LiquidBorderPainter(
          shape: shape,
          style: style,
          radius: effectiveRadius,
          fillColor: backgroundColor,
          // Will be null if enableGyro is false
          repaint: gyroController,
        ),
        child: content,
      ),
    );
  }

  BorderRadius _resolveBorderRadius(BorderRadius input) {
    if (shape == LiquidShape.circle) return BorderRadius.circular(1000);
    if (shape == LiquidShape.stadium) return BorderRadius.circular(1000);
    return input;
  }
}
