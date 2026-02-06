import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wealthscope_app/features/ai/presentation/providers/simulator_provider.dart';
import 'package:wealthscope_app/features/ai/domain/entities/scenario_result.dart';

enum ScenarioType {
  marketMove('Market Movement', Icons.trending_down),
  buyAsset('Buy Asset', Icons.add_shopping_cart),
  sellAsset('Sell Asset', Icons.sell),
  newAsset('Add New Asset', Icons.add_circle),
  rebalance('Rebalance Portfolio', Icons.balance);

  final String label;
  final IconData icon;
  const ScenarioType(this.label, this.icon);
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

  ScenarioResult? _result;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('What-If Simulator'),
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

    setState(() => _isLoading = true);

    try {
      final result = await ref.read(simulatorProvider.notifier).runSimulation(
            type: _selectedType.name,
            parameters: _buildParameters(),
            includeAIAnalysis: true,
          );

      if (mounted) {
        setState(() => _result = result);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
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
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : null,
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
  final ScenarioResult result;

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
              value: '\$${result.currentValue.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 8),
            _ResultRow(
              label: 'Projected Portfolio Value',
              value: '\$${result.projectedValue.toStringAsFixed(2)}',
              valueColor: result.valueChange >= 0
                  ? Colors.green
                  : Colors.red,
            ),
            const SizedBox(height: 8),
            _ResultRow(
              label: 'Change',
              value:
                  '${result.valueChange >= 0 ? '+' : ''}\$${result.valueChange.toStringAsFixed(2)} (${result.percentChange.toStringAsFixed(2)}%)',
              valueColor: result.valueChange >= 0
                  ? Colors.green
                  : Colors.red,
            ),

            // AI Analysis
            if (result.aiAnalysis != null) ...[
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
                  result.aiAnalysis!,
                  style: textTheme.bodyMedium,
                ),
              ),
            ],

            // Risk score
            if (result.riskScore != null) ...[
              const SizedBox(height: 16),
              _RiskScoreIndicator(score: result.riskScore!),
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
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
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
