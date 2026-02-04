import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
<<<<<<< HEAD
import 'package:wealthscope_app/features/ai/domain/entities/ocr_result.dart';
import 'package:wealthscope_app/features/ai/presentation/providers/ocr_provider.dart';
import 'package:wealthscope_app/features/ai/presentation/screens/extracted_assets_screen.dart';

/// Document Upload Screen
/// Main screen for uploading documents with multiple options (camera, gallery, PDF)
=======

>>>>>>> 253-t-761-create-documentuploadscreen
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
<<<<<<< HEAD
    final theme = Theme.of(context);

=======
>>>>>>> 253-t-761-create-documentuploadscreen
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
<<<<<<< HEAD
      final result =
          await ref.read(ocrProvider.notifier).processDocument(_selectedFile!);

      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExtractedAssetsScreen(result: result),
=======
      // TODO: Implement OCR processing
      // final result = await ref.read(ocrProvider.notifier).processDocument(_selectedFile!);

      if (mounted) {
        // TODO: Navigate to extracted assets screen
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => ExtractedAssetsScreen(result: result),
        //   ),
        // );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OCR processing not yet implemented'),
>>>>>>> 253-t-761-create-documentuploadscreen
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

<<<<<<< HEAD
/// Upload Options View
/// Displays three upload options: camera, gallery, and PDF
=======
>>>>>>> 253-t-761-create-documentuploadscreen
class _UploadOptionsView extends StatelessWidget {
  final Function(File) onImageSelected;

  const _UploadOptionsView({required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final theme = Theme.of(context);

=======
>>>>>>> 253-t-761-create-documentuploadscreen
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Icon(
            Icons.document_scanner,
            size: 80,
<<<<<<< HEAD
            color: theme.colorScheme.primary.withOpacity(0.5),
=======
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
>>>>>>> 253-t-761-create-documentuploadscreen
          ),
          const SizedBox(height: 24),
          Text(
            'Import Assets from Document',
<<<<<<< HEAD
            style: theme.textTheme.headlineSmall,
=======
            style: Theme.of(context).textTheme.headlineSmall,
>>>>>>> 253-t-761-create-documentuploadscreen
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Upload a bank statement, brokerage report, or screenshot to automatically extract your assets.',
<<<<<<< HEAD
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
=======
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
>>>>>>> 253-t-761-create-documentuploadscreen
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Options
          _UploadOption(
            icon: Icons.camera_alt,
            title: 'Take Photo',
            subtitle: 'Capture a document using camera',
<<<<<<< HEAD
            onTap: () => _pickImage(ImageSource.camera),
=======
            onTap: () => _pickImage(context, ImageSource.camera),
>>>>>>> 253-t-761-create-documentuploadscreen
          ),
          const SizedBox(height: 16),
          _UploadOption(
            icon: Icons.photo_library,
            title: 'Choose from Gallery',
            subtitle: 'Select an existing image',
<<<<<<< HEAD
            onTap: () => _pickImage(ImageSource.gallery),
=======
            onTap: () => _pickImage(context, ImageSource.gallery),
>>>>>>> 253-t-761-create-documentuploadscreen
          ),
          const SizedBox(height: 16),
          _UploadOption(
            icon: Icons.picture_as_pdf,
            title: 'Upload PDF',
            subtitle: 'Select a PDF document',
<<<<<<< HEAD
            onTap: _pickPDF,
=======
            onTap: () => _pickPDF(context),
>>>>>>> 253-t-761-create-documentuploadscreen
          ),

          const Spacer(),

          // Supported formats
          Text(
            'Supported formats: JPG, PNG, PDF',
<<<<<<< HEAD
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
=======
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
>>>>>>> 253-t-761-create-documentuploadscreen
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

<<<<<<< HEAD
  Future<void> _pickImage(ImageSource source) async {
=======
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
>>>>>>> 253-t-761-create-documentuploadscreen
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

<<<<<<< HEAD
  Future<void> _pickPDF() async {
=======
  Future<void> _pickPDF(BuildContext context) async {
>>>>>>> 253-t-761-create-documentuploadscreen
    // TODO: Implement PDF picker using file_picker package
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );
<<<<<<< HEAD
    // if (result != null && result.files.single.path != null) {
    //   onImageSelected(File(result.files.single.path!));
    // }
  }
}

/// Upload Option Card
/// Individual card for each upload option
=======
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF upload not yet implemented'),
        ),
      );
    }
  }
}

>>>>>>> 253-t-761-create-documentuploadscreen
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
<<<<<<< HEAD
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            icon,
            color: theme.colorScheme.primary,
          ),
=======
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
>>>>>>> 253-t-761-create-documentuploadscreen
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

<<<<<<< HEAD
/// Preview View
/// Shows preview of selected file before processing
=======
>>>>>>> 253-t-761-create-documentuploadscreen
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
<<<<<<< HEAD
    final theme = Theme.of(context);

=======
>>>>>>> 253-t-761-create-documentuploadscreen
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
<<<<<<< HEAD
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
=======
          Text(
            'Document Preview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: Image.file(
                file,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Remove'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: onProcess,
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Process Document'),
                ),
              ),
            ],
>>>>>>> 253-t-761-create-documentuploadscreen
          ),
        ],
      ),
    );
  }
}

<<<<<<< HEAD
/// Processing View
/// Shown while document is being processed
=======
>>>>>>> 253-t-761-create-documentuploadscreen
class _ProcessingView extends StatelessWidget {
  const _ProcessingView();

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    final theme = Theme.of(context);

=======
>>>>>>> 253-t-761-create-documentuploadscreen
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Processing document...',
<<<<<<< HEAD
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'This may take a few moments',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
=======
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Extracting asset information using AI',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
>>>>>>> 253-t-761-create-documentuploadscreen
          ),
        ],
      ),
    );
  }
}
