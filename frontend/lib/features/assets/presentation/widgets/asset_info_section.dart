import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';

/// Asset Info Section Widget
/// Displays quantity owned, purchase price, total value, gain/loss, purchase date
class AssetInfoSection extends StatelessWidget {
  final StockAsset asset;

  const AssetInfoSection({
    required this.asset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Investment Details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          // Quantity
          _InfoRow(
            label: 'Quantity Owned',
            value: asset.quantity.toString(),
            icon: Icons.inventory_2_outlined,
            theme: theme,
          ),
          const SizedBox(height: 16),
          
          // Purchase Price
          _InfoRow(
            label: 'Purchase Price',
            value: '${asset.currency.symbol}${asset.purchasePrice.toStringAsFixed(2)}',
            icon: Icons.attach_money,
            theme: theme,
          ),
          const SizedBox(height: 16),
          
          // Total Invested
          _InfoRow(
            label: 'Total Invested',
            value: '${asset.currency.symbol}${asset.totalInvested.toStringAsFixed(2)}',
            icon: Icons.payment,
            theme: theme,
          ),
          const SizedBox(height: 16),
          
          // Current Value
          _InfoRow(
            label: 'Current Value',
            value: '${asset.currency.symbol}${(asset.totalValue ?? asset.totalInvested).toStringAsFixed(2)}',
            icon: Icons.account_balance_wallet,
            theme: theme,
          ),
          const SizedBox(height: 16),
          
          // Gain/Loss
          if (asset.gainLoss != null && asset.gainLossPercent != null)
            _InfoRow(
              label: 'Gain/Loss',
              value: '${asset.gainLoss! >= 0 ? '+' : ''}${asset.currency.symbol}${asset.gainLoss!.toStringAsFixed(2)} (${asset.gainLossPercent!.toStringAsFixed(2)}%)',
              icon: asset.gainLoss! >= 0 ? Icons.trending_up : Icons.trending_down,
              valueColor: asset.gainLoss! >= 0 ? Colors.green : Colors.red,
              theme: theme,
            ),
          if (asset.gainLoss != null && asset.gainLossPercent != null)
            const SizedBox(height: 16),
          
          // Purchase Date
          if (asset.purchaseDate != null)
            _InfoRow(
              label: 'Purchase Date',
              value: dateFormat.format(asset.purchaseDate!),
              icon: Icons.calendar_today,
              theme: theme,
            ),
          
          // Notes (if any)
          if (asset.notes != null && asset.notes!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Divider(color: theme.colorScheme.outline.withOpacity(0.2)),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.note_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notes',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        asset.notes!,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final ThemeData theme;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.onSurface.withOpacity(0.6),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
