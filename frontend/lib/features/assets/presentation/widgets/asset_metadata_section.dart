import 'package:flutter/material.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_metadata.dart';
import 'package:wealthscope_app/features/assets/domain/entities/asset_type.dart';
import 'package:wealthscope_app/features/assets/domain/entities/stock_asset.dart';

/// Asset Metadata Section Widget
/// Displays type-specific metadata based on asset type
class AssetMetadataSection extends StatelessWidget {
  final StockAsset asset;

  const AssetMetadataSection({
    required this.asset,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // If no metadata, don't show the section
    if (asset.metadata.isEmpty) {
      return const SizedBox.shrink();
    }

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
            'Additional Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildMetadataContent(theme),
        ],
      ),
    );
  }

  Widget _buildMetadataContent(ThemeData theme) {
    switch (asset.type) {
      case AssetType.stock:
      case AssetType.etf:
        return _buildStockMetadata(theme);
      case AssetType.realEstate:
        return _buildRealEstateMetadata(theme);
      case AssetType.gold:
        return _buildGoldMetadata(theme);
      case AssetType.crypto:
        return _buildCryptoMetadata(theme);
      case AssetType.bond:
        return _buildBondMetadata(theme);
      default:
        return _buildGenericMetadata(theme);
    }
  }

  Widget _buildStockMetadata(ThemeData theme) {
    final metadata = StockMetadata.fromJson(asset.metadata);
    
    return Column(
      children: [
        if (metadata.exchange != null)
          _MetadataRow(
            label: 'Exchange',
            value: metadata.exchange!,
            icon: Icons.business,
            theme: theme,
          ),
        if (metadata.exchange != null && metadata.sector != null)
          const SizedBox(height: 16),
        if (metadata.sector != null)
          _MetadataRow(
            label: 'Sector',
            value: metadata.sector!,
            icon: Icons.category,
            theme: theme,
          ),
        if (metadata.sector != null && metadata.industry != null)
          const SizedBox(height: 16),
        if (metadata.industry != null)
          _MetadataRow(
            label: 'Industry',
            value: metadata.industry!,
            icon: Icons.factory,
            theme: theme,
          ),
        if (metadata.industry != null && metadata.country != null)
          const SizedBox(height: 16),
        if (metadata.country != null)
          _MetadataRow(
            label: 'Country',
            value: metadata.country!,
            icon: Icons.flag,
            theme: theme,
          ),
      ],
    );
  }

  Widget _buildRealEstateMetadata(ThemeData theme) {
    final metadata = RealEstateMetadata.fromJson(asset.metadata);
    
    return Column(
      children: [
        if (metadata.propertyType != null)
          _MetadataRow(
            label: 'Property Type',
            value: metadata.propertyType!,
            icon: Icons.home_work,
            theme: theme,
          ),
        if (metadata.propertyType != null && metadata.address != null)
          const SizedBox(height: 16),
        if (metadata.address != null)
          _MetadataRow(
            label: 'Address',
            value: metadata.address!,
            icon: Icons.location_on,
            theme: theme,
          ),
        if (metadata.address != null && metadata.city != null)
          const SizedBox(height: 16),
        if (metadata.city != null)
          _MetadataRow(
            label: 'City',
            value: '${metadata.city}${metadata.country != null ? ', ${metadata.country}' : ''}',
            icon: Icons.location_city,
            theme: theme,
          ),
        if (metadata.city != null && metadata.areaSqm != null)
          const SizedBox(height: 16),
        if (metadata.areaSqm != null)
          _MetadataRow(
            label: 'Area',
            value: '${metadata.areaSqm!.toStringAsFixed(0)} m²',
            icon: Icons.square_foot,
            theme: theme,
          ),
        if (metadata.areaSqm != null && metadata.yearBuilt != null)
          const SizedBox(height: 16),
        if (metadata.yearBuilt != null)
          _MetadataRow(
            label: 'Year Built',
            value: metadata.yearBuilt.toString(),
            icon: Icons.calendar_today,
            theme: theme,
          ),
        if (metadata.yearBuilt != null && metadata.rentalIncome != null)
          const SizedBox(height: 16),
        if (metadata.rentalIncome != null)
          _MetadataRow(
            label: 'Rental Income',
            value: '${asset.currency.symbol}${metadata.rentalIncome!.toStringAsFixed(2)}/mo',
            icon: Icons.payments,
            theme: theme,
          ),
      ],
    );
  }

  Widget _buildGoldMetadata(ThemeData theme) {
    final metadata = GoldMetadata.fromJson(asset.metadata);
    
    return Column(
      children: [
        if (metadata.form != null)
          _MetadataRow(
            label: 'Form',
            value: metadata.form!,
            icon: Icons.diamond,
            theme: theme,
          ),
        if (metadata.form != null && metadata.purity != null)
          const SizedBox(height: 16),
        if (metadata.purity != null)
          _MetadataRow(
            label: 'Purity',
            value: '${(metadata.purity! * 100).toStringAsFixed(1)}%',
            icon: Icons.verified,
            theme: theme,
          ),
        if (metadata.purity != null && metadata.weightOz != null)
          const SizedBox(height: 16),
        if (metadata.weightOz != null)
          _MetadataRow(
            label: 'Weight',
            value: '${metadata.weightOz!.toStringAsFixed(2)} oz',
            icon: Icons.scale,
            theme: theme,
          ),
        if (metadata.weightOz != null && metadata.storageLocation != null)
          const SizedBox(height: 16),
        if (metadata.storageLocation != null)
          _MetadataRow(
            label: 'Storage Location',
            value: metadata.storageLocation!,
            icon: Icons.warehouse,
            theme: theme,
          ),
      ],
    );
  }

  Widget _buildCryptoMetadata(ThemeData theme) {
    final metadata = CryptoMetadata.fromJson(asset.metadata);
    
    return Column(
      children: [
        if (metadata.network != null)
          _MetadataRow(
            label: 'Network',
            value: metadata.network!,
            icon: Icons.hub,
            theme: theme,
          ),
        if (metadata.network != null && metadata.walletAddress != null)
          const SizedBox(height: 16),
        if (metadata.walletAddress != null)
          _MetadataRow(
            label: 'Wallet Address',
            value: _truncateAddress(metadata.walletAddress!),
            icon: Icons.account_balance_wallet,
            theme: theme,
          ),
        if (metadata.walletAddress != null && metadata.staking != null)
          const SizedBox(height: 16),
        if (metadata.staking != null)
          _MetadataRow(
            label: 'Staking',
            value: metadata.staking! ? 'Yes' : 'No',
            icon: Icons.savings,
            theme: theme,
          ),
      ],
    );
  }

  Widget _buildBondMetadata(ThemeData theme) {
    final metadata = BondMetadata.fromJson(asset.metadata);
    
    return Column(
      children: [
        if (metadata.issuer != null)
          _MetadataRow(
            label: 'Issuer',
            value: metadata.issuer!,
            icon: Icons.business,
            theme: theme,
          ),
        if (metadata.issuer != null && metadata.bondType != null)
          const SizedBox(height: 16),
        if (metadata.bondType != null)
          _MetadataRow(
            label: 'Bond Type',
            value: metadata.bondType!,
            icon: Icons.category,
            theme: theme,
          ),
        if (metadata.bondType != null && metadata.couponRate != null)
          const SizedBox(height: 16),
        if (metadata.couponRate != null)
          _MetadataRow(
            label: 'Coupon Rate',
            value: '${metadata.couponRate!.toStringAsFixed(2)}%',
            icon: Icons.percent,
            theme: theme,
          ),
        if (metadata.couponRate != null && metadata.maturityDate != null)
          const SizedBox(height: 16),
        if (metadata.maturityDate != null)
          _MetadataRow(
            label: 'Maturity Date',
            value: _formatDate(metadata.maturityDate!),
            icon: Icons.event,
            theme: theme,
          ),
        if (metadata.maturityDate != null && metadata.rating != null)
          const SizedBox(height: 16),
        if (metadata.rating != null)
          _MetadataRow(
            label: 'Rating',
            value: metadata.rating!,
            icon: Icons.star,
            theme: theme,
          ),
      ],
    );
  }

  Widget _buildGenericMetadata(ThemeData theme) {
    return Column(
      children: asset.metadata.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _MetadataRow(
            label: _formatKey(entry.key),
            value: entry.value.toString(),
            icon: Icons.info_outline,
            theme: theme,
          ),
        );
      }).toList(),
    );
  }

  String _formatKey(String key) {
    return key
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _truncateAddress(String address) {
    if (address.length <= 16) return address;
    return '${address.substring(0, 8)}...${address.substring(address.length - 8)}';
  }
}

class _MetadataRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final ThemeData theme;

  const _MetadataRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 20,
          color: theme.colorScheme.primary,
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
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
