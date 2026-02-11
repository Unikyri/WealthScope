import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/core/theme/custom_icons.dart';
import 'package:wealthscope_app/core/theme/custom_home_icon.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onDestinationSelected;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardGrey,
        border: Border(
          top: BorderSide(
            color: AppTheme.electricBlue.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left side: HOME + ASSETS
              Expanded(
                child: _NavBarItem(
                  customIconWidget: (color, size) => CustomHomeIcon(
                    color: color,
                    size: size,
                  ),
                  label: 'HOME',
                  isSelected: selectedIndex == 0,
                  onTap: () => onDestinationSelected(0),
                ),
              ),
              Expanded(
                child: _NavBarItem(
                  icon: CustomIcons.assets,
                  label: 'ASSETS',
                  isSelected: selectedIndex == 1,
                  onTap: () => onDestinationSelected(1),
                ),
              ),

              // Central gap for FAB
              const SizedBox(width: 72),

              // Right side: ADVISOR + SYSTEM
              Expanded(
                child: _NavBarItem(
                  icon: CustomIcons.ai,
                  label: 'ADVISOR',
                  isSelected: selectedIndex == 2,
                  onTap: () => onDestinationSelected(2),
                ),
              ),
              Expanded(
                child: _NavBarItem(
                  icon: CustomIcons.settings,
                  label: 'SYSTEM',
                  isSelected: selectedIndex == 3,
                  onTap: () => onDestinationSelected(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData? icon;
  final Widget Function(Color color, double size)? customIconWidget;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    this.icon,
    this.customIconWidget,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : assert(icon != null || customIconWidget != null, 
              'Either icon or customIconWidget must be provided');

  @override
  Widget build(BuildContext context) {
    final color =
        isSelected ? AppTheme.electricBlue : Colors.white.withValues(alpha: 0.6);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.electricBlue.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: isSelected
                    ? Border.all(
                        color: AppTheme.electricBlue.withValues(alpha: 0.5),
                        width: 1.5,
                      )
                    : null,
              ),
              child: customIconWidget != null
                  ? customIconWidget!(color, isSelected ? 26 : 24)
                  : Icon(
                      icon,
                      color: color,
                      size: isSelected ? 26 : 24,
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: isSelected ? 10 : 9,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                letterSpacing: 0.5,
                color: color,
                height: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
