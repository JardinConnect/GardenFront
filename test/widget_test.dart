import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garden_connect/app.dart';

void main() {
  testWidgets('Login page', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}