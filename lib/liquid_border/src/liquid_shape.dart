library liquid_border;

/// Defines the geometric shape of the liquid container.
enum LiquidShape {
  /// A perfect circle.
  circle,

  /// A rectangle with rounded corners.
  rectangle,

  /// A pill shape (semicircles on the shortest side).
  stadium,
}
