import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:otadex/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: OtadexApp()),
    );
    expect(find.byType(MaterialApp), findsNothing);
    expect(find.byType(Router), findsOneWidget);
  });
}
