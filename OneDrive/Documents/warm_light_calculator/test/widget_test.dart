import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:warm_light_calculator/main.dart';

void main() {
  testWidgets('Warm Light Calculator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WarmLightCalculatorApp());

    // Verify that the app title is displayed
    expect(find.text('Warm Light Calculator'), findsOneWidget);
    
    // Verify that the display shows '0' initially
    expect(find.text('0'), findsOneWidget);
    
    // Verify that basic calculator buttons are present
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
    expect(find.text('='), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
  });
}
