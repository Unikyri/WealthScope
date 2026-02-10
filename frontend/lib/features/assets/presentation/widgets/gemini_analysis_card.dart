import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/ai/domain/entities/chat_message.dart';
import 'package:wealthscope_app/features/ai/presentation/providers/ai_chat_provider.dart';

// Provider to fetch asset analysis
final assetAnalysisProvider = FutureProvider.autoDispose.family<InsightsResponse, String>((ref, symbol) async {
  final repository = ref.watch(aiRepositoryProvider);
  final result = await repository.getAssetAnalysis(symbol: symbol);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (response) => response,
  );
});

class GeminiAnalysisCard extends ConsumerWidget {
  final String symbol;

  const GeminiAnalysisCard({
    super.key,
    required this.symbol,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisAsync = ref.watch(assetAnalysisProvider(symbol));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.purpleAccent.withOpacity(0.15),
            AppTheme.electricBlue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppTheme.purpleAccent.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.purpleAccent.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.auto_awesome, color: AppTheme.purpleAccent, size: 24)
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2000.ms, color: Colors.white),
                  const SizedBox(width: 12),
                  Column( // Title column
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GEMINI INSIGHT',
                        style: TextStyle(
                          color: AppTheme.purpleAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'AI-Powered Analysis',
                        style: TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              IconButton( // Refresh button
                icon: const Icon(Icons.refresh, color: AppTheme.purpleAccent, size: 20),
                onPressed: () {
                   ref.invalidate(assetAnalysisProvider(symbol));
                },
                tooltip: 'Regenerate Analysis',
              ),
            ],
          ),
          const SizedBox(height: 20),
          analysisAsync.when(
            data: (analysis) => _buildContent(context, analysis),
            error: (err, stack) => _buildError(context, err),
            loading: () => _buildLoading(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildShimmerLine(width: double.infinity),
        const SizedBox(height: 12),
        _buildShimmerLine(width: double.infinity),
        const SizedBox(height: 12),
        _buildShimmerLine(width: 200),
      ],
    );
  }

  Widget _buildShimmerLine({required double width}) {
    return Container(
      height: 14,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(4),
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .shimmer(duration: 1500.ms, color: Colors.white.withOpacity(0.1));
  }

  Widget _buildError(BuildContext context, Object error) {
    return Text(
      'Unable to generate insight available at this moment.',
      style: TextStyle(color: AppTheme.alertRed.withOpacity(0.8)),
    );
  }

  Widget _buildContent(BuildContext context, InsightsResponse analysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          analysis.summary,
          style: const TextStyle(
            color: Colors.white,
            height: 1.5,
            fontSize: 14,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }
}
