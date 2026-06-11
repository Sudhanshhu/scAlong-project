import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:midchains_customer_portal/src/common/widgets/k_text.dart';

void main() {
  testWidgets('KText displays correct text widget test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: KText('Hello Midchains', style: KTextStyle.titleLarge),
        ),
      ),
    );

    // Verify that the KText displays the correct text.
    expect(find.text('Hello Midchains'), findsOneWidget);
  });
}
