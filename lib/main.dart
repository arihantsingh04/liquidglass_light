import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'liquid_border/liquid_border.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const LiquidBorderApp());
}

class LiquidBorderApp extends StatefulWidget {
  const LiquidBorderApp({super.key});

  @override
  State<LiquidBorderApp> createState() => _LiquidBorderAppState();
}

class _LiquidBorderAppState extends State<LiquidBorderApp> {
  // Global state for the gyro feature
  bool isGyroEnabled = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Liquid Border Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F0F0F),
        useMaterial3: true,
      ),
      // Pass the state down to the screen
      home: LiquidShowcaseScreen(
        isGyroEnabled: isGyroEnabled,
        onToggleGyro: (value) => setState(() => isGyroEnabled = value),
      ),
    );
  }
}

class LiquidShowcaseScreen extends StatelessWidget {
  final bool isGyroEnabled;
  final ValueChanged<bool> onToggleGyro;

  const LiquidShowcaseScreen({
    super.key,
    required this.isGyroEnabled,
    required this.onToggleGyro,
  });

  @override
  Widget build(BuildContext context) {
    // ROOT: Wrap the screen in LiquidGyro with the toggle parameter
    return LiquidGyro(
      enableGyro: isGyroEnabled, // <--- Controlled here
      fallbackAlignment: Alignment.topLeft, // Where it goes when disabled
      sensitivity: 0.5,
      smoothing: 0.05,
      child: _ShowcaseContent(
        isGyroEnabled: isGyroEnabled,
        onToggleGyro: onToggleGyro,
      ),
    );
  }
}

class _ShowcaseContent extends StatefulWidget {
  final bool isGyroEnabled;
  final ValueChanged<bool> onToggleGyro;

  const _ShowcaseContent({
    required this.isGyroEnabled,
    required this.onToggleGyro,
  });

  @override
  State<_ShowcaseContent> createState() => _ShowcaseContentState();
}

class _ShowcaseContentState extends State<_ShowcaseContent> with SingleTickerProviderStateMixin {
  late AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const baseStyle = LiquidStyle.standard;

    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundGradient(),
          _buildAnimatedBlobs(),

          CustomScrollView(
            slivers: [
              _buildAppBar(),
              SliverPadding(
                padding: const EdgeInsets.all(24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _sectionHeader("1. Gyro Controls"),
                    const SizedBox(height: 8),
                    Text(
                      widget.isGyroEnabled
                          ? "Tilt your phone to move the light source."
                          : "Gyro disabled. Using static Top-Left light.",
                      style: const TextStyle(color: Colors.white30, fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    _buildPrimitivesRow(baseStyle),

                    const SizedBox(height: 48),
                    _sectionHeader("2. Intensity Presets"),
                    const SizedBox(height: 16),
                    _buildPresetsRow(),

                    const SizedBox(height: 48),
                    _sectionHeader("3. Real-World Glass Card"),
                    const SizedBox(height: 16),
                    _buildCreditCard(baseStyle),

                    const SizedBox(height: 48),
                    _sectionHeader("4. High Performance List"),
                    const SizedBox(height: 16),
                    _buildScrollingList(baseStyle),

                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: _buildDebugFab(context),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      backgroundColor: Colors.transparent,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 24, bottom: 16),
        title: const Text(
          "Liquid Borders",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: -0.5),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
        ),
      ),
      actions: [
        // THE TOGGLE SWITCH
        Row(
          children: [
            const Icon(Icons.screen_rotation, size: 16, color: Colors.white70),
            const SizedBox(width: 8),
            Switch(
              value: widget.isGyroEnabled,
              onChanged: widget.onToggleGyro,
              activeColor: Colors.cyanAccent,
            ),
            const SizedBox(width: 16),
          ],
        )
      ],
    );
  }

  Widget _buildDebugFab(BuildContext context) {
    final controller = LiquidGyro.of(context);

    // Even if disabled, we get a controller (it just stays static)
    if (controller == null) return const SizedBox();

    return ValueListenableBuilder<Alignment>(
      valueListenable: controller,
      builder: (context, alignment, child) {
        return FloatingActionButton.extended(
          onPressed: () {
            // Toggle via FAB as well for convenience
            widget.onToggleGyro(!widget.isGyroEnabled);
          },
          icon: Icon(widget.isGyroEnabled ? Icons.sensors : Icons.sensors_off),
          label: Text(
            widget.isGyroEnabled
                ? "Light: ${_formatAlignment(alignment)}"
                : "Gyro Off",
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
          backgroundColor: Colors.white.withValues(alpha: 0.9),
          foregroundColor: Colors.black,
        );
      },
    );
  }

  // ... (Rest of the widgets: _buildPrimitivesRow, _buildCreditCard, etc. remain unchanged) ...
  // Paste the rest of the file content from the previous main.dart here if not using the full dump

  Widget _buildAnimatedBlobs() {
    return AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Stack(
            children: [
              _FloatingBlob(
                color: Colors.blueAccent.withValues(alpha: 0.3),
                size: 300,
                x: -0.5 + (math.sin(_bgController.value * math.pi) * 0.2),
                y: -0.5,
              ),
              _FloatingBlob(
                color: Colors.purpleAccent.withValues(alpha: 0.2),
                size: 250,
                x: 0.8,
                y: 0.2 + (math.cos(_bgController.value * math.pi) * 0.2),
              ),
              _FloatingBlob(
                color: Colors.cyanAccent.withValues(alpha: 0.15),
                size: 200,
                x: -0.2,
                y: 0.8,
              ),
            ],
          );
        }
    );
  }

  Widget _buildPrimitivesRow(LiquidStyle style) {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      alignment: WrapAlignment.center,
      children: [
        _ShowcaseItem(
          label: "Circle",
          child: LiquidContainer(
            shape: LiquidShape.circle,
            width: 80,
            height: 80,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            style: style,
            child: const Center(child: Icon(Icons.water_drop, size: 24, color: Colors.white70)),
          ),
        ),
        _ShowcaseItem(
          label: "Stadium",
          child: LiquidContainer(
            shape: LiquidShape.stadium,
            width: 100,
            height: 50,
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            style: style,
            child: const Center(child: Text("Action", style: TextStyle(fontSize: 12))),
          ),
        ),
        _ShowcaseItem(
          label: "Rectangle",
          child: LiquidContainer(
            shape: LiquidShape.rectangle,
            width: 80,
            height: 80,
            borderRadius: BorderRadius.circular(20),
            backgroundColor: Colors.white.withValues(alpha: 0.1),
            style: style,
            child: const Center(child: Icon(Icons.grid_view, size: 20, color: Colors.white70)),
          ),
        ),
      ],
    );
  }

  Widget _buildPresetsRow() {
    Widget presetBox(String name, LiquidStyle s) {
      return Column(
        children: [
          LiquidContainer(
            width: 70,
            height: 70,
            borderRadius: BorderRadius.circular(16),
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            style: s,
            child: const SizedBox(),
          ),
          const SizedBox(height: 12),
          Text(name, style: const TextStyle(fontSize: 11, color: Colors.white54)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        presetBox("Soft", LiquidStyle.soft),
        presetBox("Standard", LiquidStyle.standard),
        presetBox("Crisp", LiquidStyle.crisp),
      ],
    );
  }

  Widget _buildCreditCard(LiquidStyle style) {
    final cardStyle = style.copyWith(
        intensity: 0.9,
        insideGlowIntensity: 0.3,
        refractionIntensity: 0.8,
        withInnerHighlight: true
    );

    return LiquidContainer(
      width: double.infinity,
      height: 220,
      shape: LiquidShape.rectangle,
      borderRadius: BorderRadius.circular(24),
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      style: cardStyle,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                    Colors.white.withValues(alpha: 0.05),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.blur_on, color: Colors.white70, size: 32),
                    Text("LIQUID GYRO", style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("4920  ••••  ••••  9012", style: TextStyle(fontSize: 24, fontFamily: 'Courier', letterSpacing: 3, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("VALID THRU", style: TextStyle(fontSize: 9, color: Colors.white60)),
                            Text("12/28", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text("CARDHOLDER", style: TextStyle(fontSize: 9, color: Colors.white60)),
                            Text("FLUTTER DEV", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollingList(LiquidStyle style) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LiquidContainer(
              width: 100,
              shape: LiquidShape.stadium,
              style: style.copyWith(thickness: 1.2),
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    index % 2 == 0 ? Icons.water_drop_outlined : Icons.auto_awesome,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 8),
                  Text("Item ${index + 1}", style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.white38,
        fontSize: 12,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }

  String _formatAlignment(Alignment a) {
    return "X:${a.x.toStringAsFixed(1)}, Y:${a.y.toStringAsFixed(1)}";
  }
}

class _ShowcaseItem extends StatelessWidget {
  final String label;
  final Widget child;
  const _ShowcaseItem({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        child,
        const SizedBox(height: 12),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
      ],
    );
  }
}

class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F2027),
            Color(0xFF203A43),
            Color(0xFF2C5364),
          ],
        ),
      ),
    );
  }
}

class _FloatingBlob extends StatelessWidget {
  final Color color;
  final double size;
  final double x;
  final double y;

  const _FloatingBlob({
    required this.color,
    required this.size,
    required this.x,
    required this.y,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(x, y),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [color, Colors.transparent],
            stops: const [0.0, 0.7],
          ),
        ),
      ),
    );
  }
}

extension LiquidStyleDemoExt on LiquidStyle {
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
}