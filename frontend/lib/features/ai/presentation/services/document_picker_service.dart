import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'document_picker_service.g.dart';

class DocumentPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  /// Pick image from camera
  Future<File?> pickFromCamera(BuildContext context) async {
    // Skip permission check on web - browser handles it
    if (!kIsWeb) {
      final status = await Permission.camera.request();

      if (status.isDenied) {
        if (context.mounted) {
          _showPermissionDeniedDialog(context, 'Camera');
        }
        return null;
      }
    }

    final image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 85,
      preferredCameraDevice: CameraDevice.rear,
    );

    if (image == null) return null;
    
    // On web, we can't create File from path
    if (kIsWeb) {
      // For web, you might need to handle this differently
      // For now, return null as camera on web needs special handling
      return null;
    }
    
    return File(image.path);
  }

  /// Pick image from gallery
  Future<File?> pickFromGallery(BuildContext context) async {
    // Skip permission check on web - browser handles it automatically
    if (!kIsWeb) {
      final status = await Permission.photos.request();

      if (status.isDenied) {
        if (context.mounted) {
          _showPermissionDeniedDialog(context, 'Photos');
        }
        return null;
      }
    }

    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2000,
      maxHeight: 2000,
      imageQuality: 85,
    );

    if (image == null) return null;
    
    // On web, we can't create File from path
    if (kIsWeb) {
      // For web, you might need to handle this differently
      // For now, return null and use FilePicker instead
      return null;
    }
    
    return File(image.path);
  }

  /// Pick PDF file
  Future<File?> pickPDF() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );

    if (result == null || result.files.isEmpty) return null;

    final path = result.files.single.path;
    if (path == null) return null;

    return File(path);
  }

  /// Validate file size
  bool isFileSizeValid(File file, {int maxSizeMB = 10}) {
    final sizeInBytes = file.lengthSync();
    final sizeInMB = sizeInBytes / (1024 * 1024);
    return sizeInMB <= maxSizeMB;
  }

  /// Get file MIME type
  String getMimeType(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }

  void _showPermissionDeniedDialog(BuildContext context, String permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permission Permission Required'),
        content: Text(
          'Please grant $permission permission in settings to use this feature.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}

// Provider
@riverpod
DocumentPickerService documentPickerService(Ref ref) {
  return DocumentPickerService();
}
