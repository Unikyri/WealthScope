import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wealthscope_app/core/theme/app_theme.dart';
import 'package:wealthscope_app/features/ai/domain/entities/ocr_result.dart';
import 'package:wealthscope_app/features/ai/presentation/providers/ocr_provider.dart';
import 'package:wealthscope_app/features/ai/presentation/screens/extracted_assets_screen.dart';
import 'package:wealthscope_app/features/ai/presentation/services/document_picker_service.dart';
import 'package:wealthscope_app/features/ai/presentation/widgets/processing_view.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/revenuecat_service.dart';
import 'package:wealthscope_app/features/subscriptions/data/services/usage_tracker.dart';
import 'package:wealthscope_app/features/subscriptions/domain/plan_limits.dart';
import 'package:wealthscope_app/features/subscriptions/presentation/widgets/upgrade_prompt_dialog.dart';

/// Document Upload Screen
/// Main screen for uploading documents with multiple options (camera, gallery, PDF)
class DocumentUploadScreen extends ConsumerStatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  ConsumerState<DocumentUploadScreen> createState() =>
      _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends ConsumerState<DocumentUploadScreen> {
  File? _selectedFile;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import from Document'),
      ),
      body: Column(
        children: [
          // OCR scan limit banner for Scout users
          _OcrScanLimitBanner(),

          Expanded(
            child: _isProcessing
                ? const ProcessingView()
                : _selectedFile != null
                    ? _PreviewView(
                        file: _selectedFile!,
                        onRemove: () => setState(() => _selectedFile = null),
                        onProcess: _processDocument,
                      )
                    : _UploadOptionsView(
                        onImageSelected: (file) =>
                            setState(() => _selectedFile = file),
                      ),
          ),
        ],
      ),
    );
  }

  Future<void> _processDocument() async {
    if (_selectedFile == null) return;

    // Check OCR scan limit for Scout users
    final isPremium = await ref.read(isPremiumProvider.future);
    if (!isPremium) {
      final usage = await ref.read(usageTrackerProvider.future);
      if (usage.ocrScansUsedThisMonth >= PlanLimits.scoutMaxOcrScansPerMonth) {
        if (!mounted) return;
        showUpgradePrompt(
          context,
          title: 'Monthly OCR Limit Reached',
          message:
              'Scout plan includes ${PlanLimits.scoutMaxOcrScansPerMonth} document scan per month. '
              'Upgrade for ${PlanLimits.sentinelMaxOcrScansPerMonth} scans/month.',
          icon: Icons.document_scanner,
        );
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      final result =
          await ref.read(ocrProvider.notifier).processDocument(_selectedFile!);

      // Record OCR scan usage for Scout users
      if (!isPremium) {
        await ref.read(usageTrackerProvider.notifier).recordOcrScan();
      }

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExtractedAssetsScreen(result: result),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}

/// Upload Options View
/// Displays three upload options: camera, gallery, and PDF
class _UploadOptionsView extends ConsumerWidget {
  final Function(File) onImageSelected;

  const _UploadOptionsView({required this.onImageSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final pickerService = ref.read(documentPickerServiceProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Icon(
            Icons.document_scanner,
            size: 80,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Import Assets from Document',
            style: theme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Upload a bank statement, brokerage report, or screenshot to automatically extract your assets.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Options
          _UploadOption(
            icon: Icons.camera_alt,
            title: 'Take Photo',
            subtitle: 'Capture a document using camera',
            onTap: () => _pickFromCamera(context, pickerService),
          ),
          const SizedBox(height: 16),
          _UploadOption(
            icon: Icons.photo_library,
            title: 'Choose from Gallery',
            subtitle: 'Select an existing image',
            onTap: () => _pickFromGallery(context, pickerService),
          ),
          const SizedBox(height: 16),
          _UploadOption(
            icon: Icons.picture_as_pdf,
            title: 'Upload PDF',
            subtitle: 'Select a PDF document',
            onTap: () => _pickPDF(context, pickerService),
          ),

          const Spacer(),

          // Supported formats
          Text(
            'Supported formats: JPG, PNG, PDF (max 10MB)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _pickFromCamera(
    BuildContext context,
    DocumentPickerService pickerService,
  ) async {
    final file = await pickerService.pickFromCamera(context);
    if (file != null) {
      if (!pickerService.isFileSizeValid(file)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size exceeds 10MB limit'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      onImageSelected(file);
    }
  }

  Future<void> _pickFromGallery(
    BuildContext context,
    DocumentPickerService pickerService,
  ) async {
    final file = await pickerService.pickFromGallery(context);
    if (file != null) {
      if (!pickerService.isFileSizeValid(file)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size exceeds 10MB limit'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      onImageSelected(file);
    }
  }

  Future<void> _pickPDF(
    BuildContext context,
    DocumentPickerService pickerService,
  ) async {
    final file = await pickerService.pickPDF();
    if (file != null) {
      if (!pickerService.isFileSizeValid(file)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size exceeds 10MB limit'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
      onImageSelected(file);
    }
  }
}

/// Upload Option Card
/// Individual card for each upload option
class _UploadOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _UploadOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
          ),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

/// Banner shown to Scout users indicating remaining monthly OCR scans.
class _OcrScanLimitBanner extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPremiumAsync = ref.watch(isPremiumProvider);
    final usageAsync = ref.watch(usageTrackerProvider);

    final isPremium = isPremiumAsync.valueOrNull ?? true;
    if (isPremium) return const SizedBox.shrink();

    final used = usageAsync.valueOrNull?.ocrScansUsedThisMonth ?? 0;
    final max = PlanLimits.scoutMaxOcrScansPerMonth;
    final remaining = (max - used).clamp(0, max);
    final isAtLimit = remaining <= 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isAtLimit
            ? Colors.amber.withValues(alpha: 0.12)
            : AppTheme.electricBlue.withValues(alpha: 0.08),
        border: Border(
          bottom: BorderSide(
            color: isAtLimit
                ? Colors.amber.withValues(alpha: 0.2)
                : AppTheme.electricBlue.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isAtLimit ? Icons.warning_amber_rounded : Icons.document_scanner,
            size: 14,
            color: isAtLimit ? Colors.amber : AppTheme.electricBlue,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isAtLimit
                  ? 'Monthly scan limit reached'
                  : '$remaining/$max scans remaining this month',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isAtLimit ? Colors.amber : AppTheme.textGrey,
              ),
            ),
          ),
          if (isAtLimit)
            GestureDetector(
              onTap: () => showUpgradePrompt(
                context,
                title: 'Monthly OCR Limit Reached',
                message:
                    'Scout plan includes $max document scan per month. '
                    'Upgrade for ${PlanLimits.sentinelMaxOcrScansPerMonth} scans/month.',
                icon: Icons.document_scanner,
              ),
              child: Text(
                'Upgrade',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.electricBlue,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Preview View
/// Shows preview of selected file before processing
class _PreviewView extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;
  final VoidCallback onProcess;

  const _PreviewView({
    required this.file,
    required this.onRemove,
    required this.onProcess,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Preview
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: theme.colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  file,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // File info
          Text(
            file.path.split('/').last,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Actions
          FilledButton.icon(
            onPressed: onProcess,
            icon: const Icon(Icons.upload),
            label: const Text('Process Document'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRemove,
            icon: const Icon(Icons.close),
            label: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}
