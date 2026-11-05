import 'package:flutter_test/flutter_test.dart';
import 'package:dev_couturier/main.dart';

void main() {
  testWidgets('App démarre', (WidgetTester tester) async {
    await tester.pumpWidget(const MonAtelierApp());
    expect(find.text('Dev Couturier'), findsWidgets);
  });
}
