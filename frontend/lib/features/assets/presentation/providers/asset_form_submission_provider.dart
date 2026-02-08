import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wealthscope_app/core/errors/failures.dart';
import 'package:wealthscope_app/features/assets/data/providers/asset_repository_provider.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/features/dashboard/presentation/providers/dashboard_providers.dart';

part 'asset_form_submission_provider.g.dart';

/// Asset Form Submission State
/// Represents the state of the asset form submission process
class AssetFormSubmissionState {
  const AssetFormSubmissionState({
    this.isLoading = false,
    this.error,
    this.savedAsset,
  });

  final bool isLoading;
  final String? error;
  final StockAsset? savedAsset;

  AssetFormSubmissionState copyWith({
    bool? isLoading,
    String? error,
    StockAsset? savedAsset,
  }) {
    return AssetFormSubmissionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      savedAsset: savedAsset ?? this.savedAsset,
    );
  }
}

/// Asset Form Submission Provider
/// Manages the submission of asset creation/update forms to the backend API.
/// Handles loading states, success, and error scenarios.
@riverpod
class AssetFormSubmission extends _$AssetFormSubmission {
  @override
  AssetFormSubmissionState build() {
    return const AssetFormSubmissionState();
  }

  /// Submit asset creation form
  /// Makes POST request to /api/v1/assets endpoint
  Future<void> submitCreate(StockAsset asset) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(assetRepositoryProvider);
      final savedAsset = await repository.addAsset(asset);

      // Invalidate assets list and portfolio summary to trigger refresh
      ref.invalidate(allAssetsProvider);
      ref.invalidate(dashboardPortfolioSummaryProvider);

      state = state.copyWith(
        isLoading: false,
        savedAsset: savedAsset,
      );
    } on ValidationFailure catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } on AuthFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'Session expired. Please log in again.',
      );
    } on NetworkFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'Connection error. Please check your internet.',
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Submit asset update form
  /// Makes PUT request to /api/v1/assets/{id} endpoint
  Future<void> submitUpdate(StockAsset asset) async {
    if (asset.id == null) {
      state = state.copyWith(
        isLoading: false,
        error: 'Asset ID is required for update',
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(assetRepositoryProvider);
      final updatedAsset = await repository.updateAsset(asset);

      // Invalidate assets list and portfolio summary to trigger refresh
      ref.invalidate(allAssetsProvider);
      ref.invalidate(dashboardPortfolioSummaryProvider);

      state = state.copyWith(
        isLoading: false,
        savedAsset: updatedAsset,
      );
    } on ValidationFailure catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } on AuthFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'Session expired. Please log in again.',
      );
    } on NetworkFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'Connection error. Please check your internet.',
      );
    } on NotFoundFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'Asset not found',
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Delete an asset
  /// Makes DELETE request to /api/v1/assets/{id} endpoint
  Future<void> submitDelete(String assetId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(assetRepositoryProvider);
      await repository.deleteAsset(assetId);

      // Invalidate assets list and portfolio summary to trigger refresh
      ref.invalidate(allAssetsProvider);
      ref.invalidate(dashboardPortfolioSummaryProvider);

      state = state.copyWith(
        isLoading: false,
        savedAsset: null,
      );
    } on AuthFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'Session expired. Please log in again.',
      );
    } on NetworkFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'Connection error. Please check your internet.',
      );
    } on NotFoundFailure {
      state = state.copyWith(
        isLoading: false,
        error: 'Asset not found',
      );
    } on Failure catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.message,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Unexpected error: ${e.toString()}',
      );
    }
  }

  /// Reset form state (useful after navigation)
  void reset() {
    state = const AssetFormSubmissionState();
  }
}
