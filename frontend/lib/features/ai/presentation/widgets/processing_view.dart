import 'package:flutter/material.dart';

/// Processing View Widget
/// Displays animated progress indicator with status updates and step-by-step feedback
class ProcessingView extends StatefulWidget {
  final String? statusMessage;
  final double? progress; // null for indeterminate

  const ProcessingView({
    super.key,
    this.statusMessage,
    this.progress,
  });

  @override
  State<ProcessingView> createState() => _ProcessingViewState();
}

class _ProcessingViewState extends State<ProcessingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.document_scanner,
                  size: 60,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Progress indicator
            SizedBox(
              width: 200,
              child: widget.progress != null
                  ? LinearProgressIndicator(
                      value: widget.progress,
                      borderRadius: BorderRadius.circular(4),
                    )
                  : const LinearProgressIndicator(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
            ),
            const SizedBox(height: 24),

            // Status text
            Text(
              widget.statusMessage ?? 'Analyzing document...',
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This may take a few seconds',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),

            const SizedBox(height: 48),

            // Processing steps
            _ProcessingSteps(
              currentStep: _getCurrentStep(widget.statusMessage),
            ),
          ],
        ),
      ),
    );
  }

  int _getCurrentStep(String? message) {
    if (message == null) return 0;
    if (message.contains('Uploading')) return 0;
    if (message.contains('Analyzing') || message.contains('OCR')) return 1;
    if (message.contains('Extracting')) return 2;
    if (message.contains('Processing')) return 3;
    return 0;
  }
}

/// Processing Steps Widget
/// Shows step-by-step progress with visual indicators
class _ProcessingSteps extends StatelessWidget {
  final int currentStep;

  const _ProcessingSteps({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final steps = [
      'Uploading document',
      'Running OCR analysis',
      'Extracting assets',
      'Processing data',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final text = entry.value;
        final isCompleted = index < currentStep;
        final isCurrent = index == currentStep;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              if (isCompleted)
                Icon(
                  Icons.check_circle,
                  size: 20,
                  color: theme.colorScheme.primary,
                )
              else if (isCurrent)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                )
              else
                Icon(
                  Icons.circle_outlined,
                  size: 20,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              const SizedBox(width: 12),
              Text(
                text,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isCompleted || isCurrent
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onSurface.withOpacity(0.6),
                  fontWeight: isCurrent ? FontWeight.bold : null,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
