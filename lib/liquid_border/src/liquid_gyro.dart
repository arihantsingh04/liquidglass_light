import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// A high-performance controller that broadcasts orientation changes
/// without triggering widget rebuilds.
class LiquidController extends ValueNotifier<Alignment> {
  LiquidController(super.value);
}

/// A scope that provides the LiquidController to all descendants.
/// It does NOT rebuild the child when the value changes.
class LiquidGyro extends StatefulWidget {
  final Widget child;

  /// Whether the gyroscopic movement is active.
  /// If false, the light source resets to [fallbackAlignment].
  final bool enableGyro;

  /// The static position to use when [enableGyro] is false.
  final Alignment fallbackAlignment;

  /// Sensitivity factor. Higher = light moves faster/further with less tilt.
  final double sensitivity;

  /// Smoothing factor (0.0 - 1.0).
  final double smoothing;

  const LiquidGyro({
    super.key,
    required this.child,
    this.enableGyro = true,
    this.fallbackAlignment = Alignment.topLeft,
    this.sensitivity = 0.5,
    this.smoothing = 0.05,
  });

  static LiquidController? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_LiquidGyroScope>()?.controller;
  }

  @override
  State<LiquidGyro> createState() => _LiquidGyroState();
}

class _LiquidGyroState extends State<LiquidGyro> with SingleTickerProviderStateMixin {
  late final LiquidController _controller;
  StreamSubscription<AccelerometerEvent>? _subscription;
  late Ticker _ticker;

  Alignment _targetAlignment = Alignment.topLeft;

  @override
  void initState() {
    super.initState();
    _controller = LiquidController(widget.fallbackAlignment);
    _ticker = createTicker(_onTick);
    _updateGyroState();
  }

  @override
  void didUpdateWidget(LiquidGyro oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableGyro != oldWidget.enableGyro ||
        widget.fallbackAlignment != oldWidget.fallbackAlignment) {
      _updateGyroState();
    }
  }

  void _updateGyroState() {
    if (widget.enableGyro) {
      // START everything if not already running
      if (_subscription == null) _startSensor();
      if (!_ticker.isActive) _ticker.start();
    } else {
      // STOP everything to save battery
      _subscription?.cancel();
      _subscription = null;
      _ticker.stop();

      // Reset to fallback
      _targetAlignment = widget.fallbackAlignment;
      _controller.value = widget.fallbackAlignment;
    }
  }

  void _startSensor() {
    _subscription = accelerometerEventStream().listen((event) {
      if (!mounted) return;

      double targetX = -(event.x * widget.sensitivity);
      double targetY = -(event.y * widget.sensitivity) + 3.0;

      targetX = targetX.clamp(-1.0, 1.0);
      targetY = targetY.clamp(-1.0, 1.0);

      _targetAlignment = Alignment(targetX, targetY);
    });
  }

  void _onTick(Duration elapsed) {
    final current = _controller.value;

    if (current == _targetAlignment) return;

    final double newX = lerpDouble(current.x, _targetAlignment.x, widget.smoothing)!;
    final double newY = lerpDouble(current.y, _targetAlignment.y, widget.smoothing)!;

    if ((newX - current.x).abs() < 0.001 && (newY - current.y).abs() < 0.001) {
      return;
    }

    _controller.value = Alignment(newX, newY);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _LiquidGyroScope(
      controller: _controller,
      child: widget.child,
    );
  }
}

class _LiquidGyroScope extends InheritedWidget {
  final LiquidController controller;

  const _LiquidGyroScope({
    required this.controller,
    required super.child,
  });

  @override
  bool updateShouldNotify(_LiquidGyroScope oldWidget) => false;
}