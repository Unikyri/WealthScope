import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/features/auth/data/providers/auth_service_provider.dart';
import 'package:wealthscope_app/features/profile/domain/entities/user_profile.dart';

part 'profile_provider.g.dart';

/// Provider for User Profile
/// Returns the current user's profile information
@riverpod
class Profile extends _$Profile {
  @override
  FutureOr<UserProfile?> build() async {
    final user = ref.watch(currentUserProvider);
    
    if (user == null) {
      return null;
    }

    // Convert Supabase User to UserProfile entity
    return UserProfile(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
    );
  }

  /// Refresh profile data
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final user = ref.read(currentUserProvider);
      
      if (user == null) {
        return null;
      }

      return UserProfile(
        id: user.id,
        email: user.email ?? '',
        fullName: user.userMetadata?['full_name'] as String?,
        avatarUrl: user.userMetadata?['avatar_url'] as String?,
      );
    });
  }
}
