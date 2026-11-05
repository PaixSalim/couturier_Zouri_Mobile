import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dev_couturier/widgets/app_logo.dart';

void main() {
  testWidgets('AppLogo renders an image widget', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppLogo(size: 32),
        ),
      ),
    );

    expect(find.byType(Image), findsOneWidget);
  });
}
