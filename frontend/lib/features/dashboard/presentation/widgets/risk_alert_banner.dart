import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/dashboard/domain/entities/portfolio_summary.dart';

/// Severity for concentration alerts
enum RiskAlertBannerSeverity {
  warning,
  critical,
}

/// Item for the risk alert banner
class RiskAlertBannerItem {
  const RiskAlertBannerItem({
    required this.message,
    required this.severity,
    this.assetType,
  });

  final String message;
  final RiskAlertBannerSeverity severity;
  final String? assetType;

  factory RiskAlertBannerItem.warning(String message, String? assetType) =>
      RiskAlertBannerItem(
        message: message,
        severity: RiskAlertBannerSeverity.warning,
        assetType: assetType,
      );

  factory RiskAlertBannerItem.critical(String message, String? assetType) =>
      RiskAlertBannerItem(
        message: message,
        severity: RiskAlertBannerSeverity.critical,
        assetType: assetType,
      );
}

/// Computes concentration alerts from breakdown and risk score.
List<RiskAlertBannerItem> computeConcentrationAlerts(
  List<AssetTypeBreakdown> breakdown,
  int riskScore,
) {
  final items = <RiskAlertBannerItem>[];
  for (final b in breakdown) {
    final typeLabel = _formatTypeLabel(b.type);
    if (b.percent > 85) {
      items.add(RiskAlertBannerItem.critical(
        'Riesgo critico: $typeLabel domina tu portfolio',
        b.type,
      ));
    } else if (b.percent > 70) {
      items.add(RiskAlertBannerItem.warning(
        'Alta concentracion en $typeLabel',
        b.type,
      ));
    }
  }
  if (riskScore > 70) {
    items.add(RiskAlertBannerItem.warning(
      'Portfolio poco diversificado',
      null,
    ));
  }
  return items;
}

String _formatTypeLabel(String type) {
  if (type.isEmpty) return type;
  return type[0].toUpperCase() + type.substring(1);
}

/// Banner showing concentration risk alerts.
/// Non-intrusive, tappable to navigate to AI chat.
class RiskAlertBanner extends StatelessWidget {
  const RiskAlertBanner({
    super.key,
    required this.alerts,
  });

  final List<RiskAlertBannerItem> alerts;

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    final topAlert = alerts.first;
    final isCritical = topAlert.severity == RiskAlertBannerSeverity.critical;
    final bgColor = isCritical
        ? AppTheme.alertRed.withValues(alpha: 0.15)
        : Colors.amber.withValues(alpha: 0.15);
    final borderColor =
        isCritical ? AppTheme.alertRed : Colors.amber;
    final iconColor = isCritical ? AppTheme.alertRed : Colors.amber;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.push(
            '/ai-chat?prompt=${Uri.encodeComponent('How can I diversify my portfolio?')}',
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  topAlert.message,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
