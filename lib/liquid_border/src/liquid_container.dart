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
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius effectiveRadius = borderRadius ?? BorderRadius.circular(20);

    // 1. Lookup the controller (O(1) operation)
    final gyroController = LiquidGyro.of(context);

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: CustomPaint(
        // 2. Connect the controller to the painter's refresh mechanism
        painter: LiquidBorderPainter(
          shape: shape,
          style: style,
          radius: effectiveRadius,
          fillColor: backgroundColor,
          // If gyro is found, the painter will listen to it automatically
          repaint: gyroController,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.all(style.thickness + 4),
          child: child,
        ),
      ),
    );
  }
}