# Liquid Border

A high-performance Flutter package that creates distinct, "liquid-like" borders that react to device orientation (gyroscope). It simulates light refraction, specular highlights, and glassmorphism to give your UI a premium, physical feel.

![Liquid Border Demo](https://raw.githubusercontent.com/arihantsingh04/liquidglass_light/refs/heads/main/assets/3.gif)
(https://raw.githubusercontent.com/arihantsingh04/liquidglass_light/refs/heads/main/assets/1.jpeg)
https://raw.githubusercontent.com/arihantsingh04/liquidglass_light/refs/heads/main/assets/2.jpeg
## Features

* **📱 Gyro-Reactive Lighting:** The border's light source moves as you tilt your device.
* **⚡ High Performance:** Uses `CustomPainter` and `ValueNotifier` to animate smoothly without rebuilding the widget tree.
* **💎 Glassmorphism Ready:** Optional background blur (`blurStrength`) integration.
* **🎨 Highly Customizable:** Control refraction, intensity, glow, and thickness.
* **🔋 Efficiency Mode:** Gyroscope can be disabled globally or per-container to save battery.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  liquid_border: ^0.0.1