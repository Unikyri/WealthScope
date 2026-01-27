import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';

class WealthScopeApp extends ConsumerWidget {
  const WealthScopeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'WealthScope',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
