import 'package:flutter/material.dart';
import 'liquid_border/liquid_border.dart'; // Ensure path matches your structure

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LiquidBorderShowcase(),
    ),
  );
}

class LiquidBorderShowcase extends StatefulWidget {
  const LiquidBorderShowcase({super.key});

  @override
  State<LiquidBorderShowcase> createState() => _LiquidBorderShowcaseState();
}

class _LiquidBorderShowcaseState extends State<LiquidBorderShowcase> {
  // We can animate this to test performance
  Alignment lightSource = Alignment.topLeft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark bg makes glass pop
      appBar: AppBar(
        title: const Text("Liquid Border Test Lab"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.light_mode),
            tooltip: "Rotate Light Source",
            onPressed: () {
              setState(() {
                // Cycle light source to test dynamic updates
                if (lightSource == Alignment.topLeft) {
                  lightSource = Alignment.topRight;
                } else if (lightSource == Alignment.topRight) {
                  lightSource = Alignment.bottomRight;
                } else if (lightSource == Alignment.bottomRight) {
                  lightSource = Alignment.bottomLeft;
                } else {
                  lightSource = Alignment.topLeft;
                }
              });
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _sectionHeader("1. Shape Primitives"),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              // Circle
              LiquidContainer(
                shape: LiquidShape.circle,
                width: 80,
                height: 80,
                style: LiquidStyle.crisp.copyWith(lightSource: lightSource),
                child: const Center(
                  child: Icon(Icons.water_drop, color: Colors.cyan),
                ),
              ),
              // Stadium / Pill
              LiquidContainer(
                shape: LiquidShape.stadium,
                width: 120,
                height: 50,
                style: LiquidStyle.standard.copyWith(lightSource: lightSource),
                child: const Center(
                  child: Text("Stadium", style: TextStyle(color: Colors.white)),
                ),
              ),
              // Rounded Rect
              LiquidContainer(
                shape: LiquidShape.rectangle,
                width: 100,
                height: 100,
                borderRadius: BorderRadius.circular(16),
                style: LiquidStyle.soft.copyWith(lightSource: lightSource),
                child: const Center(
                  child: Text("Rect", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _sectionHeader("2. Styles & Intensity"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _label(
                "Soft",
                LiquidContainer(
                  style: LiquidStyle.soft.copyWith(lightSource: lightSource),
                  child: const SizedBox(width: 80, height: 80),
                ),
              ),
              _label(
                "Standard",
                LiquidContainer(
                  style: LiquidStyle.standard.copyWith(
                    lightSource: lightSource,
                  ),
                  child: const SizedBox(width: 80, height: 80),
                ),
              ),
              _label(
                "Crisp (Glow)",
                LiquidContainer(
                  style: LiquidStyle.crisp.copyWith(lightSource: lightSource),
                  child: const SizedBox(width: 80, height: 80),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          _sectionHeader("3. Real World: Card"),
          LiquidContainer(
            shape: LiquidShape.rectangle,
            borderRadius: BorderRadius.circular(24),
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            style: LiquidStyle(
              thickness: 1.5,
              intensity: 0.9,
              lightSource: lightSource,
              withInnerHighlight: true,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Glass Debit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "The border catches the light based on angle.",
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
          _sectionHeader("4. Real World: Scrolling List"),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (c, i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: LiquidContainer(
                    shape: LiquidShape.stadium,
                    style: LiquidStyle.standard.copyWith(
                      lightSource: lightSource,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.center,
                      child: Text(
                        "Item $i",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          letterSpacing: 1.2,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _label(String text, Widget child) {
    return Column(
      children: [
        child,
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}

// Extension to safely change style props for the test
extension StyleCopy on LiquidStyle {
  LiquidStyle copyWith({Alignment? lightSource}) {
    return LiquidStyle(
      thickness: thickness,
      intensity: intensity,
      lightSource: lightSource ?? this.lightSource,
      withInnerHighlight: withInnerHighlight,
      withOuterGlow: withOuterGlow,
      baseColor: baseColor,
    );
  }
}
