import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:garden_connect/app.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('Login page', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}