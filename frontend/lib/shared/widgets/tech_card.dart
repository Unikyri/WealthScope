import 'package:flutter/material.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';

class TechCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final bool isInteractive;
  final Color? borderColor;

  const TechCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.onTap,
    this.isInteractive = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final techTheme = theme.extension<TechTheme>();
    final borderCol = borderColor ?? techTheme?.lineColor ?? Colors.white12;

    Widget content = Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        border: Border.all(color: borderCol, width: 1.0),
        borderRadius: BorderRadius.zero, // Sharp corners for Tech aesthetic
      ),
      child: child,
    );

    if (isInteractive || onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: theme.primaryColor.withOpacity(0.1),
          highlightColor: theme.primaryColor.withOpacity(0.05),
          child: content,
        ),
      );
    }

    return content;
  }
}

class TechStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String? subValue;
  final Color? valueColor;
  final IconData? icon;

  const TechStatCard({
    super.key,
    required this.label,
    required this.value,
    this.subValue,
    this.valueColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TechCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  letterSpacing: 1.2,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              if (icon != null)
                Icon(icon, size: 16, color: Theme.of(context).colorScheme.tertiary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: valueColor ?? Theme.of(context).colorScheme.onSurface,
              fontFamily: 'SpaceMono', // Explicitly using tech font
            ),
          ),
          if (subValue != null) ...[
            const SizedBox(height: 4),
            Text(
              subValue!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.neutralColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
