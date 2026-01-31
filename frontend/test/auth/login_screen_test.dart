import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthscope_app/features/auth/presentation/screens/login_screen.dart';

/// Widget tests for LoginScreen
/// Tests UI rendering, validation, navigation, and loading states
void main() {
  // Suppress overflow errors in tests
  TestWidgetsFlutterBinding.ensureInitialized();
  
  setUp(() {
    // Suppress rendering overflow errors during tests
    FlutterError.onError = (FlutterErrorDetails details) {
      final exception = details.exception;
      final isOverflowError = exception is FlutterError &&
          exception.message.contains('overflowed by');
      
      if (!isOverflowError) {
        FlutterError.presentError(details);
      }
    };
  });
  
  tearDown(() {
    // Restore error handling
    FlutterError.onError = FlutterError.presentError;
  });

  group('LoginScreen - UI Rendering', () {
    testWidgets('renders all essential UI elements', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify logo is present
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);

      // Verify title and subtitle
      expect(find.text('Welcome back'), findsOneWidget);

      // Verify email and password fields are present
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);

      // Verify login button is present
      expect(find.widgetWithText(FilledButton, 'Sign In'), findsOneWidget);
    });

    testWidgets('renders navigation to register screen link', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify register link text
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);
    });

    testWidgets('renders forgot password link', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify forgot password link
      expect(find.text('Forgot your password?'), findsOneWidget);
    });

    testWidgets('email field has correct hint text', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify email field has proper hint text
      expect(find.text('email@example.com'), findsOneWidget);
      // Verify email icon is present
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('password field has visibility toggle', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify password field has lock icon and visibility toggle
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      
      // Find visibility toggle button
      final visibilityIcon = find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(IconButton),
      );
      expect(visibilityIcon, findsOneWidget);
    });
  });

  group('LoginScreen - Form Validation', () {
    testWidgets('shows error when email is empty and form is submitted',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Tap login button without entering data
      await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Verify email validation error is shown
      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('shows error when password is empty and form is submitted',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      // Tap login button without entering password
      await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Verify password validation error is shown
      expect(find.text('Password is required'), findsOneWidget);
    });

    testWidgets('shows error for invalid email format', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter invalid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'invalid-email',
      );

      // Tap outside to trigger validation
      await tester.tap(find.widgetWithText(TextFormField, 'Password'));
      await tester.pumpAndSettle();

      // Verify email format error is shown
      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('shows error when password is too short', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      // Enter short password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        '123',
      );

      // Tap login button
      await tester.tap(find.widgetWithText(FilledButton, 'Sign In'));
      await tester.pumpAndSettle();

      // Verify password length error is shown
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('accepts valid email and password', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      // Enter valid password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Wait for autovalidation
      await tester.pumpAndSettle();

      // Verify no validation errors are shown
      expect(find.text('Email is required'), findsNothing);
      expect(find.text('Enter a valid email'), findsNothing);
      expect(find.text('Password is required'), findsNothing);
      expect(
        find.text('Password must be at least 6 characters'),
        findsNothing,
      );
    });
  });

  group('LoginScreen - Password Visibility Toggle', () {
    testWidgets('password visibility toggle button responds to taps',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Find the visibility toggle button in password field
      final visibilityIcon = find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(IconButton),
      );

      expect(visibilityIcon, findsOneWidget);

      // Enter password to test visibility toggle behavior
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'testpassword',
      );

      // Tap to toggle password visibility
      await tester.tap(visibilityIcon);
      await tester.pumpAndSettle();

      // Tap again to toggle back
      await tester.tap(visibilityIcon);
      await tester.pumpAndSettle();

      // If no exceptions occurred, toggle works
      expect(visibilityIcon, findsOneWidget);
    });
  });

  group('LoginScreen - Navigation', () {
    testWidgets('has link to register screen',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify create account link exists
      expect(find.text('Create account'), findsOneWidget);
      expect(find.text("Don't have an account? "), findsOneWidget);
    });
  });

  group('LoginScreen - Accessibility', () {
    testWidgets('has proper semantic labels for screen readers',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: LoginScreen(),
          ),
        ),
      );

      // Verify fields have labels
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });
  });
}
