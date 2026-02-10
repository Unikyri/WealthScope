import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/briefing.dart';
import 'ai_chat_provider.dart';

part 'briefing_provider.g.dart';

/// State for the briefing
class BriefingState {
  final bool isLoading;
  final Briefing? briefing;
  final String? error;

  const BriefingState({
    this.isLoading = false,
    this.briefing,
    this.error,
  });

  BriefingState copyWith({
    bool? isLoading,
    Briefing? briefing,
    String? error,
  }) {
    return BriefingState(
      isLoading: isLoading ?? this.isLoading,
      briefing: briefing ?? this.briefing,
      error: error,
    );
  }
}

/// Provider for managing briefing state
@riverpod
class BriefingNotifier extends _$BriefingNotifier {
  @override
  BriefingState build() {
    return const BriefingState();
  }

  /// Load briefing from the API
  Future<void> loadBriefing() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(aiRepositoryProvider);
      final result = await repository.getBriefing();

      result.fold(
        (failure) {
          state = state.copyWith(
            isLoading: false,
            error: failure.message,
          );
        },
        (briefing) {
          state = state.copyWith(
            isLoading: false,
            briefing: briefing,
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh the briefing
  Future<void> refresh() => loadBriefing();
}
