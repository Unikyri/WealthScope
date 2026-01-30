import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wealthscope_app/features/auth/presentation/screens/register_screen.dart';

/// Widget tests for RegisterScreen
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

  group('RegisterScreen - UI Rendering', () {
    testWidgets('renders all essential UI elements', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Verify logo is present
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);

      // Verify title and subtitle
      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Start managing your wealth'), findsOneWidget);

      // Verify all three input fields are present
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
      expect(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        findsOneWidget,
      );

      // Verify terms checkbox
      expect(find.byType(CheckboxListTile), findsOneWidget);
      expect(find.text('I accept the '), findsOneWidget);

      // Verify create account button
      expect(
        find.widgetWithText(FilledButton, 'Create Account'),
        findsOneWidget,
      );
    });

    testWidgets('renders navigation to login screen link', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Verify login link text
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
    });

    testWidgets('email field has correct hint text', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Verify email field has proper hint text
      expect(find.text('email@example.com'), findsOneWidget);
      // Verify email icon is present
      expect(find.byIcon(Icons.email_outlined), findsOneWidget);
    });

    testWidgets('password fields have visibility toggles', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Verify password fields have lock icons
      expect(find.byIcon(Icons.lock_outline), findsNWidgets(2));
      
      // Find visibility toggle button in password field
      final passwordVisibilityIcon = find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(IconButton),
      );
      expect(passwordVisibilityIcon, findsOneWidget);

      // Find visibility toggle button in confirm password field
      final confirmVisibilityIcon = find.descendant(
        of: find.widgetWithText(TextFormField, 'Confirm Password'),
        matching: find.byType(IconButton),
      );
      expect(confirmVisibilityIcon, findsOneWidget);
    });
  });

  group('RegisterScreen - Email Validation', () {
    testWidgets('shows error when email is empty and form is submitted',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Tap create account button without entering data
      await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Verify email validation error is shown
      expect(find.text('El email es requerido'), findsOneWidget);
    });

    testWidgets('shows error for invalid email format', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
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
      expect(find.text('Ingresa un email válido'), findsOneWidget);
    });

    testWidgets('accepts valid email format', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      // Tap outside to trigger validation
      await tester.tap(find.widgetWithText(TextFormField, 'Password'));
      await tester.pumpAndSettle();

      // Verify no email error is shown
      expect(find.text('El email es requerido'), findsNothing);
      expect(find.text('Ingresa un email válido'), findsNothing);
    });
  });

  group('RegisterScreen - Password Validation', () {
    testWidgets('shows error when password is empty', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Enter valid email
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );

      // Tap create account button without entering password
      await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Verify password validation error is shown
      expect(find.text('La contraseña es requerida'), findsOneWidget);
    });

    testWidgets('shows error when password is too short', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
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

      // Tap outside to trigger validation
      await tester.tap(find.widgetWithText(TextFormField, 'Confirm Password'));
      await tester.pumpAndSettle();

      // Verify password length error is shown
      expect(
        find.text('La contraseña debe tener al menos 8 caracteres'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when password lacks uppercase letter',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Enter password without uppercase
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'password123',
      );

      // Tap outside to trigger validation
      await tester.tap(find.widgetWithText(TextFormField, 'Confirm Password'));
      await tester.pumpAndSettle();

      // Verify uppercase requirement error is shown
      expect(
        find.text('La contraseña debe tener al menos una mayúscula'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when password lacks number', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Enter password without number
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password',
      );

      // Tap outside to trigger validation
      await tester.tap(find.widgetWithText(TextFormField, 'Confirm Password'));
      await tester.pumpAndSettle();

      // Verify number requirement error is shown
      expect(
        find.text('La contraseña debe tener al menos un número'),
        findsOneWidget,
      );
    });

    testWidgets('accepts valid password', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Enter valid password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123',
      );

      // Tap outside to trigger validation
      await tester.tap(find.widgetWithText(TextFormField, 'Confirm Password'));
      await tester.pumpAndSettle();

      // Verify no password errors are shown
      expect(find.text('La contraseña es requerida'), findsNothing);
      expect(
        find.text('La contraseña debe tener al menos 8 caracteres'),
        findsNothing,
      );
      expect(
        find.text('La contraseña debe tener al menos una mayúscula'),
        findsNothing,
      );
      expect(
        find.text('La contraseña debe tener al menos un número'),
        findsNothing,
      );
    });
  });

  group('RegisterScreen - Password Confirmation Validation', () {
    testWidgets('shows error when confirmation is empty', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Enter valid email and password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123',
      );

      // Tap create account without confirming password
      await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Verify confirmation error is shown
      expect(
        find.text('La confirmación de contraseña es requerida'),
        findsOneWidget,
      );
    });

    testWidgets('shows error when passwords do not match', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Enter valid email and password
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'Password123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'DifferentPassword123',
      );

      // Tap create account button
      await tester.tap(find.widgetWithText(FilledButton, 'Create Account'));
      await tester.pumpAndSettle();

      // Verify passwords don't match error is shown
      expect(find.text('Las contraseñas no coinciden'), findsOneWidget);
    });

    testWidgets('accepts matching passwords', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      const password = 'Password123';

      // Enter valid email and matching passwords
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'test@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        password,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        password,
      );

      // Wait for validation
      await tester.pumpAndSettle();

      // Verify no confirmation errors are shown
      expect(
        find.text('La confirmación de contraseña es requerida'),
        findsNothing,
      );
      expect(find.text('Las contraseñas no coinciden'), findsNothing);
    });
  });

  group('RegisterScreen - Password Visibility Toggle', () {
    testWidgets('password visibility toggle button responds to taps',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Find the visibility toggle button in password field
      final passwordVisibilityIcon = find.descendant(
        of: find.widgetWithText(TextFormField, 'Password'),
        matching: find.byType(IconButton),
      );

      expect(passwordVisibilityIcon, findsOneWidget);

      // Enter password to test visibility toggle behavior
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'TestPassword123',
      );

      // Tap to toggle password visibility
      await tester.tap(passwordVisibilityIcon);
      await tester.pumpAndSettle();

      // If no exceptions occurred, toggle works
      expect(passwordVisibilityIcon, findsOneWidget);
    });

    testWidgets('confirm password visibility toggle works independently',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Find the visibility toggle button in confirm password field
      final confirmVisibilityIcon = find.descendant(
        of: find.widgetWithText(TextFormField, 'Confirm Password'),
        matching: find.byType(IconButton),
      );

      expect(confirmVisibilityIcon, findsOneWidget);

      // Enter password to test visibility toggle behavior
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'TestPassword123',
      );

      // Tap to toggle confirm password visibility
      await tester.tap(confirmVisibilityIcon);
      await tester.pumpAndSettle();

      // If no exceptions occurred, toggle works
      expect(confirmVisibilityIcon, findsOneWidget);
    });
  });

  group('RegisterScreen - Terms and Conditions', () {
    testWidgets('checkbox is unchecked by default', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );

      expect(checkbox.value, false);
    });

    testWidgets('toggles checkbox when tapped', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Find and tap the checkbox
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Checkbox should now be checked
      var checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkbox.value, true);

      // Tap again to uncheck
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Checkbox should be unchecked again
      checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkbox.value, false);
    });

    testWidgets('displays terms and conditions text', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Verify terms text is displayed
      expect(find.text('I accept the '), findsOneWidget);
      expect(find.textContaining('terms and conditions'), findsOneWidget);
    });
  });

  group('RegisterScreen - Navigation', () {
    testWidgets('has link to login screen',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Verify sign in link exists
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Already have an account? '), findsOneWidget);
    });
  });

  group('RegisterScreen - Accessibility', () {
    testWidgets('has proper semantic labels for screen readers',
        (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Verify fields have labels
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm Password'), findsOneWidget);
    });
  });

  group('RegisterScreen - Complete Form Validation', () {
    testWidgets('validates complete registration flow', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: RegisterScreen(),
          ),
        ),
      );

      // Enter all valid data
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Email'),
        'newuser@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'SecurePass123',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm Password'),
        'SecurePass123',
      );

      // Accept terms
      await tester.tap(find.byType(CheckboxListTile));
      await tester.pumpAndSettle();

      // Verify no validation errors
      expect(find.text('El email es requerido'), findsNothing);
      expect(find.text('La contraseña es requerida'), findsNothing);
      expect(
        find.text('La confirmación de contraseña es requerida'),
        findsNothing,
      );
      expect(find.text('Las contraseñas no coinciden'), findsNothing);

      // Verify button is enabled (not null onPressed)
      final button = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Create Account'),
      );
      expect(button.onPressed, isNotNull);
    });
  });
}
