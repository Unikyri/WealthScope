import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/router/app_router.dart';

/// Router Provider
/// Provides the GoRouter instance for the app
final routerProvider = Provider<GoRouter>((ref) {
  return AppRouter.router;
});
