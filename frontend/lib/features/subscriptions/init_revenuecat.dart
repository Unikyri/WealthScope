import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:wealthscope_app/shared/providers/auth_state_provider.dart';

/// Initialize RevenueCat service
Future<void> initializeRevenueCat(WidgetRef ref) async {
  try {
    final service = ref.read(revenueCatServiceProvider);
    final user = ref.read(currentUserProvider);
    
    // Initialize with user ID if available
    final userId = user?.id;
    await service.initialize(userId: userId);
    
    print('✅ RevenueCat initialized with user: ${userId ?? "anonymous"}');
  } catch (e) {
    print('❌ Failed to initialize RevenueCat: $e');
  }
}

/// Provider initialization state
final revenueCatInitializedProvider = StateProvider<bool>((ref) => false);
