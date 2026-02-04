import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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

class _UploadOptionsView extends StatelessWidget {
  final Function(File) onImageSelected;

  const _UploadOptionsView({required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Icon(
            Icons.document_scanner,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Import Assets from Document',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Upload a bank statement, brokerage report, or screenshot to automatically extract your assets.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),

          // Options
          _UploadOption(
            icon: Icons.camera_alt,
            title: 'Take Photo',
            subtitle: 'Capture a document using camera',
            onTap: () => _pickImage(context, ImageSource.camera),
          ),
          const SizedBox(height: 16),
          _UploadOption(
            icon: Icons.photo_library,
            title: 'Choose from Gallery',
            subtitle: 'Select an existing image',
            onTap: () => _pickImage(context, ImageSource.gallery),
          ),
          const SizedBox(height: 16),
          _UploadOption(
            icon: Icons.picture_as_pdf,
            title: 'Upload PDF',
            subtitle: 'Select a PDF document',
            onTap: () => _pickPDF(context),
          ),

          const Spacer(),

          // Supported formats
          Text(
            'Supported formats: JPG, PNG, PDF',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
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

  Future<void> _pickPDF(BuildContext context) async {
    // TODO: Implement PDF picker using file_picker package
    // final result = await FilePicker.platform.pickFiles(
    //   type: FileType.custom,
    //   allowedExtensions: ['pdf'],
    // );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF upload not yet implemented'),
        ),
      );
    }
  }
}

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
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

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
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
          ),
        ],
      ),
    );
  }
}

class _ProcessingView extends StatelessWidget {
  const _ProcessingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 24),
          Text(
            'Processing document...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Extracting asset information using AI',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                ),
          ),
        ],
      ),
    );
  }
}
