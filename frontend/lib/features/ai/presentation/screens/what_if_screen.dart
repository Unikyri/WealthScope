import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/scenarios/presentation/providers/scenarios_providers.dart';
import 'package:wealthscope_app/features/scenarios/domain/entities/scenario_entity.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';

enum ScenarioType {
  marketMove('Market Movement', Icons.trending_down, 'market_move'),
  buyAsset('Buy Asset', Icons.add_shopping_cart, 'buy_asset'),
  sellAsset('Sell Asset', Icons.sell, 'sell_asset'),
  newAsset('Add New Asset', Icons.add_circle, 'new_asset'),
  rebalance('Rebalance Portfolio', Icons.balance, 'rebalance');

  final String label;
  final IconData icon;

  /// The API type value expected by the backend (snake_case)
  final String apiType;
  const ScenarioType(this.label, this.icon, this.apiType);
}

class WhatIfScreen extends ConsumerStatefulWidget {
  const WhatIfScreen({super.key});

  @override
  ConsumerState<WhatIfScreen> createState() => _WhatIfScreenState();
}

class _WhatIfScreenState extends ConsumerState<WhatIfScreen> {
  ScenarioType _selectedType = ScenarioType.marketMove;
  final _formKey = GlobalKey<FormState>();

  // Market move params
  double _changePercent = -10;

  // Buy/sell params
  String? _selectedAssetId;
  double _quantity = 0;
  double _price = 0;

  SimulationResultEntity? _result;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final gate = ref.watch(featureGateProvider);
    final whatIfResult = gate.canUseWhatIf();

    if (!whatIfResult.allowed) return _buildUpgradeScreen(context);
    return _buildWhatIfContent(context);
  }

  Widget _buildUpgradeScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.midnightBlue,
      appBar: AppBar(
        backgroundColor: AppTheme.midnightBlue,
        elevation: 0,
        title: const Text(
          'What-If Simulator',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon with gradient glow
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppTheme.electricBlue.withValues(alpha: 0.25),
                      AppTheme.electricBlue.withValues(alpha: 0.0),
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.science,
                  color: AppTheme.electricBlue,
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                'What-If Simulator',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Sentinel Exclusive Feature',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.electricBlue,
                ),
              ),
              const SizedBox(height: 24),

              // Feature list
              _buildFeatureRow(Icons.trending_down, 'Market crash scenarios'),
              const SizedBox(height: 12),
              _buildFeatureRow(
                  Icons.add_shopping_cart, 'Buy/Sell simulations'),
              const SizedBox(height: 12),
              _buildFeatureRow(Icons.balance, 'Portfolio rebalancing'),
              const SizedBox(height: 12),
              _buildFeatureRow(
                  Icons.show_chart, 'Compound interest projections'),
              const SizedBox(height: 36),

              // CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.push('/subscription'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.electricBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Upgrade to Sentinel',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Unlock all premium features',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.cardGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppTheme.electricBlue, size: 18),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withValues(alpha: 0.85),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWhatIfContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What-If Simulator'),
        actions: [
          // Sentinel badge
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.electricBlue, AppTheme.purpleAccent],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.workspace_premium,
                    size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Text(
                  'Sentinel',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Scenario type selector
              _ScenarioTypeSelector(
                selected: _selectedType,
                onChanged: (type) {
                  setState(() {
                    _selectedType = type;
                    _result = null;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Parameters based on type
              _buildParametersCard(),
              const SizedBox(height: 24),

              // Run simulation button
              FilledButton.icon(
                onPressed: _isLoading ? null : _runSimulation,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow),
                label: const Text('Run Simulation'),
              ),

              // Results
              if (_result != null) ...[
                const SizedBox(height: 32),
                _SimulationResults(result: _result!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParametersCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parameters',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            _buildParameterInputs(),
          ],
        ),
      ),
    );
  }

  Widget _buildParameterInputs() {
    switch (_selectedType) {
      case ScenarioType.marketMove:
        return _MarketMoveParams(
          changePercent: _changePercent,
          onChanged: (value) => setState(() => _changePercent = value),
        );
      case ScenarioType.buyAsset:
      case ScenarioType.sellAsset:
        return _BuySellParams(
          isBuy: _selectedType == ScenarioType.buyAsset,
          selectedAssetId: _selectedAssetId,
          quantity: _quantity,
          price: _price,
          onAssetChanged: (id) => setState(() => _selectedAssetId = id),
          onQuantityChanged: (v) => setState(() => _quantity = v),
          onPriceChanged: (v) => setState(() => _price = v),
        );
      case ScenarioType.newAsset:
        return const _NewAssetParams();
      case ScenarioType.rebalance:
        return const _RebalanceParams();
    }
  }

  Future<void> _runSimulation() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      print('🎯 [WHAT_IF] Starting simulation...');
      print('   Type: ${_selectedType.apiType}');
      print('   Parameters: ${_buildParameters()}');

      // Call simulate on the notifier (uses snake_case API type)
      await ref.read(runSimulationProvider.notifier).simulate(
            type: _selectedType.apiType,
            parameters: _buildParameters(),
          );

      if (!mounted) {
        print('⚠️ [WHAT_IF] Widget unmounted after simulation');
        return;
      }

      // Read the updated state
      final providerState = ref.read(runSimulationProvider);

      print(
          '📊 [WHAT_IF] Got provider state: ${providerState.hasValue ? "has data" : providerState.hasError ? "has error" : "loading"}');

      providerState.when(
        data: (result) {
          print('✅ [WHAT_IF] Simulation completed successfully');
          if (mounted && result != null) {
            setState(() => _result = result);
          }
        },
        loading: () {
          print('⏳ [WHAT_IF] Still loading...');
        },
        error: (error, stack) {
          print('❌ [WHAT_IF] Error: $error');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Simulation failed: ${error.toString()}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } catch (e, stack) {
      print('❌ [WHAT_IF] Exception caught: $e');
      print('   Stack: $stack');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Map<String, dynamic> _buildParameters() {
    switch (_selectedType) {
      case ScenarioType.marketMove:
        return {'change_percent': _changePercent};
      case ScenarioType.buyAsset:
      case ScenarioType.sellAsset:
        return {
          'asset_id': _selectedAssetId,
          'quantity': _quantity,
          'price': _price,
        };
      default:
        return {};
    }
  }
}

class _ScenarioTypeSelector extends StatelessWidget {
  final ScenarioType selected;
  final ValueChanged<ScenarioType> onChanged;

  const _ScenarioTypeSelector({
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ScenarioType.values.map((type) {
          final isSelected = type == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              avatar: Icon(
                type.icon,
                size: 18,
                color:
                    isSelected ? Theme.of(context).colorScheme.onPrimary : null,
              ),
              label: Text(type.label),
              selected: isSelected,
              onSelected: (_) => onChanged(type),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _MarketMoveParams extends StatelessWidget {
  final double changePercent;
  final ValueChanged<double> onChanged;

  const _MarketMoveParams({
    required this.changePercent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Market Change: ${changePercent.toStringAsFixed(0)}%',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Slider(
          value: changePercent,
          min: -50,
          max: 50,
          divisions: 100,
          onChanged: onChanged,
          label: '${changePercent.toStringAsFixed(0)}%',
        ),
        const SizedBox(height: 16),
        // Quick buttons
        Text(
          'Quick Presets',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [-30, -20, -10, 10, 20, 30].map((value) {
            return ActionChip(
              label: Text('${value > 0 ? '+' : ''}$value%'),
              onPressed: () => onChanged(value.toDouble()),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _BuySellParams extends StatelessWidget {
  final bool isBuy;
  final String? selectedAssetId;
  final double quantity;
  final double price;
  final ValueChanged<String?> onAssetChanged;
  final ValueChanged<double> onQuantityChanged;
  final ValueChanged<double> onPriceChanged;

  const _BuySellParams({
    required this.isBuy,
    required this.selectedAssetId,
    required this.quantity,
    required this.price,
    required this.onAssetChanged,
    required this.onQuantityChanged,
    required this.onPriceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Asset selection
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Asset',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.search),
          ),
          value: selectedAssetId,
          items: const [
            // TODO: Load from actual portfolio assets
            DropdownMenuItem(value: '1', child: Text('Apple Inc. (AAPL)')),
            DropdownMenuItem(value: '2', child: Text('Gold (XAU)')),
            DropdownMenuItem(value: '3', child: Text('Bitcoin (BTC)')),
          ],
          onChanged: onAssetChanged,
          validator: (value) => value == null ? 'Please select an asset' : null,
        ),
        const SizedBox(height: 16),

        // Quantity input
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Quantity',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.numbers),
            helperText: isBuy ? 'Amount to buy' : 'Amount to sell',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,8}')),
          ],
          onChanged: (value) {
            final parsed = double.tryParse(value) ?? 0;
            onQuantityChanged(parsed);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter quantity';
            }
            final parsed = double.tryParse(value);
            if (parsed == null || parsed <= 0) {
              return 'Please enter a valid positive number';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Price input
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Price per Unit',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.attach_money),
            helperText: 'Expected price per unit',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          onChanged: (value) {
            final parsed = double.tryParse(value) ?? 0;
            onPriceChanged(parsed);
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter price';
            }
            final parsed = double.tryParse(value);
            if (parsed == null || parsed <= 0) {
              return 'Please enter a valid positive number';
            }
            return null;
          },
        ),

        // Total calculation
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total ${isBuy ? 'Cost' : 'Value'}:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '\$${(quantity * price).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NewAssetParams extends StatelessWidget {
  const _NewAssetParams();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Asset Configuration',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'This feature will be available soon. Add a new asset to see how it affects your portfolio.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.construction),
          label: const Text('Coming Soon'),
        ),
      ],
    );
  }
}

class _RebalanceParams extends StatelessWidget {
  const _RebalanceParams();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Portfolio Rebalancing',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Simulate rebalancing your portfolio to target allocations. This feature will be available soon.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: null,
          icon: const Icon(Icons.construction),
          label: const Text('Coming Soon'),
        ),
      ],
    );
  }
}

class _SimulationResults extends StatelessWidget {
  final SimulationResultEntity result;

  const _SimulationResults({required this.result});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Simulation Results',
                  style: textTheme.titleLarge,
                ),
              ],
            ),
            const Divider(height: 24),

            // Portfolio value change
            _ResultRow(
              label: 'Current Portfolio Value',
              value: '\$${result.currentState.totalValue.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _ResultRow(
              label: 'Projected Portfolio Value',
              value: '\$${result.projectedState.totalValue.toStringAsFixed(2)}',
              valueColor: (result.projectedState.totalValue -
                          result.currentState.totalValue) >=
                      0
                  ? Colors.green
                  : Colors.red,
            ),
            const SizedBox(height: 8),
            _ResultRow(
              label: 'Change',
              value:
                  '${(result.projectedState.totalValue - result.currentState.totalValue) >= 0 ? '+' : ''}\$${(result.projectedState.totalValue - result.currentState.totalValue).toStringAsFixed(2)} (${((result.projectedState.totalValue - result.currentState.totalValue) / result.currentState.totalValue * 100).toStringAsFixed(2)}%)',
              valueColor: (result.projectedState.totalValue -
                          result.currentState.totalValue) >=
                      0
                  ? Colors.green
                  : Colors.red,
            ),

            // AI Analysis
            if (result.aiAnalysis.isNotEmpty) ...[
              const Divider(height: 32),
              Row(
                children: [
                  Icon(
                    Icons.psychology,
                    color: colorScheme.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI Analysis',
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  result.aiAnalysis,
                  style: textTheme.bodyMedium,
                ),
              ),
            ],

            // Warnings
            if (result.warnings.isNotEmpty) ...[
              const Divider(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Warnings',
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...result.warnings.map((warning) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(warning, style: textTheme.bodyMedium)),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _ResultRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
        ),
      ],
    );
  }
}

class _RiskScoreIndicator extends StatelessWidget {
  final double score; // 0-100

  const _RiskScoreIndicator({required this.score});

  @override
  Widget build(BuildContext context) {
    final color = _getRiskColor();
    final label = _getRiskLabel();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Risk Score',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            minHeight: 8,
            backgroundColor:
                Theme.of(context).colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Color _getRiskColor() {
    if (score < 30) return Colors.green;
    if (score < 60) return Colors.orange;
    return Colors.red;
  }

  String _getRiskLabel() {
    if (score < 30) return 'Low Risk';
    if (score < 60) return 'Medium Risk';
    return 'High Risk';
  }
}
