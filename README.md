Liquid Border 💧A lightweight Flutter library that creates liquid-inspired, light-driven borders for modern UIs.It simulates light refraction, depth, and "wet" edges using physics-based gradient logic—without the heavy performance cost of real-time 3D or expensive glassmorphism blurs. Ideal for high-performance scrolling lists, cards, and buttons.(Replace this image link with a real GIF of your showcase app)✨ FeaturesLight-Driven Physics: Borders react to a global light source direction (e.g., top-left).Volumetric Depth: Simulates "inner glow" and "refraction" to give buttons a convex, bubbly feel.3D Illusion on 2D Canvas: Uses advanced SweepGradient logic to create depth using only opacity—zero 3D rendering required.High Performance: Built 100% with CustomPainter. No heavy BackdropFilter or saveLayer calls unless explicitly requested. Safe for ListView and low-end devices.Responsive Shapes: Automatically handles Circle, Rectangle, and Stadium (pill) shapes with correct corner highlights.Fully Customizable: Fine-tune intensity, thickness, glow opacity, and refraction brightness.📦 InstallationAdd this to your package's pubspec.yaml file:YAMLdependencies:
liquid_border: ^0.0.1
Or install it from the command line:Bashflutter pub add liquid_border
🚀 Getting StartedWrap any widget in a LiquidContainer. By default, it creates a subtle, glass-like border.Dartimport 'package:flutter/material.dart';
import 'package:liquid_border/liquid_border.dart';

class MyButton extends StatelessWidget {
@override
Widget build(BuildContext context) {
return LiquidContainer(
shape: LiquidShape.stadium,
style: LiquidStyle.crisp, // Use a preset or customize
child: Padding(
padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
child: Text("Liquid Button"),
),
);
}
}
💡 Core Concepts1. The Light SourceThe core of this library is the lightSource alignment. The highlights on the border will rotate to face this direction. You can even animate it!DartLiquidContainer(
// Light comes from the bottom-right
style: LiquidStyle(
lightSource: Alignment.bottomRight,
),
child: ...
)
2. Refraction & GlowTo make the object look like glass/water, we simulate two key physics phenomena:Inner Glow: A soft light entering the shape at the light source.Refraction: A secondary, dimmer highlight on the opposite side of the light, where light exits the material.🛠 Advanced UsageCustomizing the PhysicsYou have full control over the optical properties of the border using LiquidStyle.DartLiquidContainer(
   shape: LiquidShape.circle,
   style: LiquidStyle(
   thickness: 2.0,
   intensity: 0.9,           // How "shiny" the white highlight is
   insideGlowIntensity: 0.3, // Opacity of the inner volumetric glow
   refractionIntensity: 0.8, // Brightness of the opposite edge
   baseColor: Colors.cyan,   // Tint the glass liquid
   withOuterGlow: true,      // Adds a bloom effect (more expensive)
   ),
   child: Icon(Icons.water_drop, color: Colors.white),
   )
   Animating the LightSince LiquidContainer is a standard widget, you can easily animate the LiquidStyle properties or the lightSource using a Tween or state changes.(See the example/ folder for a full runnable animation demo)📖 API DocumentationLiquidContainerThe main widget for rendering the border.PropertyTypeDescriptionchildWidgetThe widget to wrap.shapeLiquidShapecircle, rectangle, or stadium.styleLiquidStyleThe visual configuration object.borderRadiusBorderRadius?Used only if shape is rectangle.backgroundColorColor?Optional fill color behind the child.LiquidStyleThe configuration class defines the "material" properties of the liquid.PropertyTypeDefaultDescriptionthicknessdouble1.5Width of the border stroke.intensitydouble0.8Brightness of the main specular highlight (0.0 - 1.0).insideGlowIntensitydouble0.2Opacity of the volumetric glow inside the shape.refractionIntensitydouble0.6Brightness of the secondary highlight on the opposite side.lightSourceAlignmenttopLeftDirection of the incoming light.withInnerHighlightbooltrueAdds a sharp, thin "wet" line on top of the border.withOuterGlowboolfalseAdds a blur bloom outside. Note: Adds render cost.baseColorColorwhiteThe color of the light/glass.PresetsLiquidStyle comes with three built-in presets for quick prototyping:LiquidStyle.soft: Very subtle, low opacity, suitable for dividers or secondary elements.LiquidStyle.standard: Balanced visibility, good for cards.LiquidStyle.crisp: High contrast, strong inner glow, and outer bloom. Great for primary buttons.⚡ Performance NoteThis library is designed for 60fps scrolling.Good: LiquidContainer uses CustomPainter vector drawing. It is very cheap to render.Caution: Enabling withOuterGlow: true adds a MaskFilter.blur. While optimized, using too many blurred borders in a large ListView on low-end Android devices may affect performance. Use withOuterGlow selectively.❤️ ContributingContributions are welcome! If you find a bug or want to improve the physics model:Fork the repo.Create your feature branch (git checkout -b feature/amazing-physics).Commit your changes.Push to the branch.Open a Pull Request.📄 LicenseThis project is licensed under the MIT License - see the LICENSE file for details.