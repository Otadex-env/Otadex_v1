import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:otadex/app.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: OtadexApp()));
    await tester.pump(Duration.zero);
    expect(find.byType(MaterialApp), findsOneWidget);
    // Advance past all SplashScreen timers so they fire and cancel cleanly
    await tester.pump(const Duration(milliseconds: 4000));
    await tester.pump(Duration.zero);
  });
}
