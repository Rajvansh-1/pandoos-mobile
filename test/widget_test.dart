import 'package:flutter_test/flutter_test.dart';
import 'package:pandoos_mobile/src/app.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PandoosApp());
    expect(find.text('Home Placeholder'), findsOneWidget);
  });
}
