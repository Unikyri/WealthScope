// Example route configuration for GoRouter
// Add this to your router configuration file

import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/features/assets/presentation/screens/real_estate_form_screen.dart';

/// Add this route to your GoRouter routes list:
/// 
/// GoRoute(
///   path: '/assets/real-estate/new',
///   name: 'newRealEstate',
///   builder: (context, state) => const RealEstateFormScreen(),
/// ),
/// 
/// Usage from any widget:
/// 
/// ```dart
/// // Navigate to real estate form
/// context.push('/assets/real-estate/new');
/// 
/// // Or using named route
/// context.pushNamed('newRealEstate');
/// ```
/// 
/// Example FAB in dashboard:
/// 
/// ```dart
/// FloatingActionButton(
///   onPressed: () => context.push('/assets/real-estate/new'),
///   child: const Icon(Icons.add),
/// )
/// ```
