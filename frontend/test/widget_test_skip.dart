// WealthScope App Widget Tests

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wealthscope_app/app/app.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('WealthScope app smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    // Build our app wrapped in ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: WealthScopeApp(),
      ),
    );

    // Wait for the router to initialize
    await tester.pumpAndSettle();

    // Verify that the register screen is shown (initial route)
    expect(find.text('Start managing your wealth'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
    
    // Verify the register button exists
    expect(
      find.widgetWithText(FilledButton, 'Create Account'),
      findsOneWidget,
    );
  });
}
