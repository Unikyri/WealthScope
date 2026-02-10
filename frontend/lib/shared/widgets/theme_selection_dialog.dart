import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';

class ThemeSelectionDialog extends ConsumerWidget {
  const ThemeSelectionDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Choose Theme'),
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: ThemeModeOption.values.map((mode) {
          final isSelected = currentTheme == mode;
          
          return RadioListTile<ThemeModeOption>(
            value: mode,
            groupValue: currentTheme,
            onChanged: (value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setThemeMode(value);
                Navigator.pop(context);
              }
            },
            title: Text(mode.displayName),
            secondary: Icon(
              mode.icon,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
