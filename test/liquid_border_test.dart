import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// CORRECT IMPORT
import 'package:liquidglass_light/liquid_border/liquid_border.dart';

void main() {
  testWidgets('LiquidContainer renders without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: LiquidContainer(
            shape: LiquidShape.rectangle,
            child: Text('Test'),
          ),
        ),
      ),
    );

    expect(find.byType(LiquidContainer), findsOneWidget);
    expect(find.text('Test'), findsOneWidget);
  });

  test('LiquidStyle equality works', () {
    const style1 = LiquidStyle(intensity: 0.5);
    const style2 = LiquidStyle(intensity: 0.5);
    const style3 = LiquidStyle(intensity: 1.0);

    expect(style1, equals(style2));
    expect(style1, isNot(equals(style3)));
  });
}
