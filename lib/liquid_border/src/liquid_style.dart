import 'package:flutter/material.dart';

/// Configuration for the liquid border aesthetics.
class LiquidStyle {
  /// The width of the border stroke.
  final double thickness;

  /// Controls the contrast of the PRIMARY highlight (Light Source).
  /// 0.0 = Flat, 1.0 = High Gloss/Wet look.
  final double intensity;

  /// Controls the opacity of the "inner glow" near the light source.
  /// 0.0 = No glow, 1.0 = Full opacity fill.
  final double insideGlowIntensity;

  /// NEW: Controls the intensity of the "refraction" highlight
  /// (usually the bottom-right border opposite the light).
  /// Default was 0.6. Higher = brighter bottom-right edge.
  final double refractionIntensity;

  /// The direction the light is coming from.
  /// Defaults to Top-Left (-1, -1).
  final Alignment lightSource;

  /// If true, draws a sharp, thin inner specular highlight
  /// to simulate a wet edge.
  final bool withInnerHighlight;

  /// If true, adds a subtle glow outside the border.
  /// Use sparingly as this adds a blur cost.
  final bool withOuterGlow;

  /// The base color of the "liquid" (usually white/glass).
  final Color baseColor;

  const LiquidStyle({
    this.thickness = 0.5,
    this.intensity = 0.8,
    this.insideGlowIntensity = 0.0,
    this.refractionIntensity = 0.6, // Default refraction visibility
    this.lightSource = Alignment.topLeft,
    this.withInnerHighlight = true,
    this.withOuterGlow = false,
    this.baseColor = Colors.white,
  });

  /// Preset: Subtle, barely-there glass edge.
  static const LiquidStyle soft = LiquidStyle(
      intensity: 0.2,
      refractionIntensity: 0.3,
      insideGlowIntensity: 0.1,
      thickness: 0.4,
      withInnerHighlight: false
  );

  /// Preset: High contrast, "wet" look with outer glow.
  static const LiquidStyle crisp = LiquidStyle(
    intensity: 1.0,
    refractionIntensity: 0.8,
    insideGlowIntensity: 0.3,
    thickness: 1.0,
    withOuterGlow: true,
    withInnerHighlight: true,
  );

  /// Preset: Standard iOS-style frosted border.
  static const LiquidStyle standard = LiquidStyle();

  /// Helper to copy with changes
  LiquidStyle copyWith({
    double? thickness,
    double? intensity,
    double? insideGlowIntensity,
    double? refractionIntensity,
    Alignment? lightSource,
    bool? withInnerHighlight,
    bool? withOuterGlow,
    Color? baseColor,
  }) {
    return LiquidStyle(
      thickness: thickness ?? this.thickness,
      intensity: intensity ?? this.intensity,
      insideGlowIntensity: insideGlowIntensity ?? this.insideGlowIntensity,
      refractionIntensity: refractionIntensity ?? this.refractionIntensity,
      lightSource: lightSource ?? this.lightSource,
      withInnerHighlight: withInnerHighlight ?? this.withInnerHighlight,
      withOuterGlow: withOuterGlow ?? this.withOuterGlow,
      baseColor: baseColor ?? this.baseColor,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is LiquidStyle &&
              runtimeType == other.runtimeType &&
              thickness == other.thickness &&
              intensity == other.intensity &&
              insideGlowIntensity == other.insideGlowIntensity &&
              refractionIntensity == other.refractionIntensity &&
              lightSource == other.lightSource &&
              withInnerHighlight == other.withInnerHighlight &&
              withOuterGlow == other.withOuterGlow &&
              baseColor == other.baseColor;

  @override
  int get hashCode => Object.hash(
    thickness,
    intensity,
    insideGlowIntensity,
    refractionIntensity,
    lightSource,
    withInnerHighlight,
    withOuterGlow,
    baseColor,
  );
}