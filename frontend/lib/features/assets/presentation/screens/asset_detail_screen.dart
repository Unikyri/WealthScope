import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/assets/presentation/providers/assets_provider.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:wealthscope_app/shared/widgets/price_freshness_indicator.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_candle_chart.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/gemini_analysis_card.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_detail_skeleton.dart';
import 'package:wealthscope_app/features/assets/presentation/widgets/asset_news_list.dart';
import 'package:wealthscope_app/shared/widgets/asset_icon_resolver.dart';

class AssetDetailScreen extends ConsumerStatefulWidget {
  final String assetId;

  const AssetDetailScreen({super.key, required this.assetId});

  @override
  ConsumerState<AssetDetailScreen> createState() => _AssetDetailScreenState();
}

class _AssetDetailScreenState extends ConsumerState<AssetDetailScreen> {
  String _selectedRange = '1W';
  final List<String> _ranges = ['1D', '1W', '1M', '1Y', 'ALL'];

  @override
  Widget build(BuildContext context) {
    print('💎 [PREMIUM_DETAIL] Build for ${widget.assetId}');
    final assetAsync = ref.watch(assetDetailProvider(widget.assetId));

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark, 
      extendBody: true, // For bottom gradient overlay
      body: assetAsync.when(
        data: (asset) {
          final isPositive = (asset.gainLossPercent ?? 0) >= 0;
          final trendColor = isPositive ? AppTheme.neonGreen : AppTheme.errorRed;
          final trendIcon = isPositive ? Icons.trending_up : Icons.trending_down;
          
          return Stack(
            children: [
              // Main Scrollable Content
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. Glassmorphism Sticky Header
                  SliverAppBar(
                    backgroundColor: AppTheme.backgroundDark.withOpacity(0.8),
                    elevation: 0,
                    pinned: true,
                    expandedHeight: 100, // Just enough for simple header
                    toolbarHeight: 80,
                    leading: Center(
                      child: Container(
                        margin: const EdgeInsets.only(left: 16),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => context.pop(),
                          hoverColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    title: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              asset.symbol,
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppTheme.accentPurple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: AppTheme.accentPurple.withOpacity(0.3)),
                              ),
                              child: Text(
                                asset.type.name.toUpperCase(),
                                style: GoogleFonts.manrope(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.accentPurple,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          asset.name,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    centerTitle: true,
                    actions: [
                      Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: IconButton(
                          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                          onPressed: () {},
                          hoverColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ],
                    flexibleSpace: ClipRRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                  ),

                  // 2. Body Content
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 120),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Hero icon (smooth transition from AssetCard/TopMover)
                          HeroMode(
                            enabled: !MediaQuery.of(context).disableAnimations,
                            child: Hero(
                              tag: 'asset-icon-${asset.id ?? widget.assetId}',
                              child: AssetIconResolver(
                                symbol: asset.symbol,
                                assetType: asset.type,
                                name: asset.name,
                                size: 48,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Hero Price
                          Text(
                            '\$${_formatPrice(asset.currentPrice ?? asset.purchasePrice)}', // Fallback
                            style: GoogleFonts.manrope(
                              fontSize: 48, // 5xl equivalent
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: -2,
                              height: 1,
                              shadows: [
                                Shadow(
                                  color: AppTheme.neonGreen.withOpacity(0.4),
                                  blurRadius: 30,
                                ),
                              ],
                            ),
                          ).animate().fadeIn().scale(duration: 400.ms),
                          
                          if (asset.updatedAt != null || !ref.watch(featureGateProvider).isPremium) ...[
                            const SizedBox(height: 8),
                            PriceFreshnessIndicator(
                              lastUpdated: asset.updatedAt,
                              isScoutPlan: !ref.watch(featureGateProvider).isPremium,
                              compact: true,
                            ),
                          ],
                          
                          const SizedBox(height: 12),
                          
                          // Trend Pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: trendColor.withOpacity(0.1), // bg-primary/20
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: trendColor.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(trendIcon, size: 14, color: trendColor),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '+${(asset.gainLossPercent ?? 1.2).toStringAsFixed(1)}%',
                                  style: GoogleFonts.manrope(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: trendColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Today',
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Chart Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              children: [
                                // Range Selector
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: _ranges.map((range) {
                                    final isSelected = _selectedRange == range;
                                    return GestureDetector(
                                      onTap: () => setState(() => _selectedRange = range),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                        decoration: isSelected
                                            ? BoxDecoration(
                                                color: Colors.white.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(20),
                                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                                                boxShadow: [
                                                   BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: Offset(0, 2))
                                                ]
                                              )
                                            : null,
                                        child: Text(
                                          range,
                                          style: GoogleFonts.manrope(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isSelected ? Colors.white : Colors.grey[500],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 24),
                                // Actual Chart
                                AssetCandleChart(period: _selectedRange), // Contains the Neon Glow Line
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Key Statistics Grid
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Key Statistics',
                                  style: GoogleFonts.manrope(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                GridView.count(
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.5,
                                  children: [
                                    _buildStatCard('MARKET CAP', '\$1.24T'),
                                    _buildStatCard('VOLUME (24H)', '\$32.8B'),
                                    _buildStatCard('CIRCULATING', '19.5M BTC'),
                                    _buildStatCard('DOMINANCE', '52.1%'),
                                    _buildStatCard(
                                      'AVG. COST',
                                      '\$${_formatValue(asset.totalCost ?? 0)}',
                                      isDarker: true,
                                    ),
                                    _buildStatCard(
                                      'TOTAL P&L',
                                      '+\$${_formatValue(asset.gainLoss ?? 0)}',
                                      isDarker: true,
                                      isPnl: true,
                                      textColor: AppTheme.neonGreen,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Gemini Insight Widget
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: GeminiAnalysisCard(symbol: asset.symbol),
                          ),

                          const SizedBox(height: 32),

                          // News Section
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Latest News',
                                  style: GoogleFonts.manrope(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AssetNewsList(symbol: asset.symbol, assetType: asset.type),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Bottom Gradient & Button area
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        AppTheme.backgroundDark,
                        AppTheme.backgroundDark.withOpacity(0.0),
                      ],
                      stops: const [0.6, 1.0],
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Update valuation logic
                        ScaffoldMessenger.of(context).showSnackBar(
                           const SnackBar(content: Text('Updating Valuation...')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 10,
                        shadowColor: Colors.white.withOpacity(0.2),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.refresh, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Update Valuation',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Scaffold(
          backgroundColor: AppTheme.backgroundDark,
          body: AssetDetailSkeleton(),
        ),
        error: (e, _) => Scaffold(
          backgroundColor: AppTheme.backgroundDark,
          body: Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, {bool isDarker = false, bool isPnl = false, Color? textColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarker ? Colors.white.withOpacity(0.05) : const Color(0xFF161616).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.glassBorder),
      ),
      child: Stack(
        children: [
          if (isPnl)
             Positioned(
               right: -10,
               top: -10,
               child: Container(
                 width: 40,
                 height: 40,
                 decoration: BoxDecoration(
                   color: AppTheme.neonGreen.withOpacity(0.2),
                   shape: BoxShape.circle,
                 ),
                 child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(),
                    ),
                 ),
               ),
             ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isPnl ? AppTheme.neonGreen : Colors.grey[500],
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? Colors.white.withOpacity(0.9),
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatPrice(double price) {
    if (price >= 1000) {
      // Add commas
      final parts = price.toStringAsFixed(2).split('.');
      final whole = parts[0].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
      return '$whole.${parts[1]}';
    }
    return price.toStringAsFixed(2);
  }

  String _formatValue(double value) {
     final parts = value.toStringAsFixed(0).split('.');
     final whole = parts[0].replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
     return whole;
  }
}
