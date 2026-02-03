import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wealthscope_app/features/ai/domain/entities/ocr_result.dart';
import 'package:wealthscope_app/features/ai/presentation/providers/ocr_provider.dart';
import 'package:wealthscope_app/features/ai/presentation/screens/extracted_assets_screen.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import from Document'),
      ),
      body: _isProcessing
          ? const _ProcessingView()
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
    );
  }

  Future<void> _processDocument() async {
    if (_selectedFile == null) return;

    setState(() => _isProcessing = true);

    try {
      final result =
          await ref.read(ocrProvider.notifier).processDocument(_selectedFile!);

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
class _UploadOptionsView extends StatelessWidget {
  final Function(File) onImageSelected;

  const _UploadOptionsView({required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            onTap: () => _pickImage(ImageSource.camera),
          ),
          const SizedBox(height: 16),
          _UploadOption(
            icon: Icons.photo_library,
            title: 'Choose from Gallery',
            subtitle: 'Select an existing image',
            onTap: () => _pickImage(ImageSource.gallery),
          ),
          const SizedBox(height: 16),
          _UploadOption(
            icon: Icons.picture_as_pdf,
            title: 'Upload PDF',
            subtitle: 'Select a PDF document',
            onTap: _pickPDF,
          ),

          const Spacer(),

          // Supported formats
          Text(
            'Supported formats: JPG, PNG, PDF',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 85,
    );

    if (image != null) {
      onImageSelected(File(image.path));
    }
  }

  Future<void> _pickPDF() async {
    // TODO: Implement PDF picker using file_picker package
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );
    // if (result != null && result.files.single.path != null) {
    //   onImageSelected(File(result.files.single.path!));
    // }
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

/// Processing View
/// Shown while document is being processed
class _ProcessingView extends StatelessWidget {
  const _ProcessingView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Processing document...',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
