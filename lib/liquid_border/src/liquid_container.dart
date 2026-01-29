import 'package:flutter/material.dart';
import 'liquid_shape.dart';
import 'liquid_style.dart';
import 'liquid_painter.dart';

/// A container that wraps its child in a liquid-inspired, light-refracting border.
/// 
/// This widget is optimized for scrolling lists (ListView/GridView) as it uses
/// CustomPainter and avoids heavy BackdropFilters.
class LiquidContainer extends StatelessWidget {
  final Widget child;
  
  /// The geometric shape of the border.
  final LiquidShape shape;
  
  /// Configuration for the visual style (lighting, thickness, etc).
  final LiquidStyle style;
  
  /// Border radius (ignored if shape is Circle or Stadium).
  final BorderRadius? borderRadius;
  
  /// Background color fill. 
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
    // Default radius for rectangles if not provided
    final BorderRadius effectiveRadius = borderRadius ?? BorderRadius.circular(20);

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
        ),
        // Ensure child doesn't overlap the border stroke
        child: Padding(
          padding: padding ?? EdgeInsets.all(style.thickness + 4),
          child: child,
        ),
      ),
    );
  }
}
