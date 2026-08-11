import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../core/theme/evermore_theme.dart';

/// Copies a picked image into the app's permanent documents directory
/// and returns the new persistent path. The picker's raw path can live
/// in a cache directory that gets cleared, so we never store that
/// directly.
Future<String> persistPickedImage(XFile picked) async {
  final docsDir = await getApplicationDocumentsDirectory();
  final ext = picked.path.split('.').last;
  final destPath =
      '${docsDir.path}/profile_photo_${DateTime.now().millisecondsSinceEpoch}.$ext';
  final bytes = await picked.readAsBytes();
  final file = File(destPath);
  await file.writeAsBytes(bytes);
  return destPath;
}

/// Circular avatar that shows a photo if [photoPath] is set, otherwise
/// initials derived from [name]. Tapping opens a bottom sheet to choose
/// a new photo from the gallery, take one with the camera, or remove
/// the current photo.
class AvatarPicker extends StatelessWidget {
  final String? photoPath;
  final String name;
  final double size;
  final ValueChanged<String?> onChanged;

  const AvatarPicker({
    super.key,
    required this.photoPath,
    required this.name,
    required this.onChanged,
    this.size = 88,
  });

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '';
    final parts = trimmed.split(RegExp(r'\s+'));
    final first = parts.first.isNotEmpty ? parts.first[0] : '';
    final second = parts.length > 1 && parts[1].isNotEmpty ? parts[1][0] : '';
    return (first + second).toUpperCase();
  }

  Future<void> _openPicker(BuildContext context) async {
    final picker = ImagePicker();
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: EvermoreTheme.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: EvermoreTheme.primary),
                title: const Text('Choose from gallery', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
                  if (picked != null) {
                    final path = await persistPickedImage(picked);
                    onChanged(path);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined, color: EvermoreTheme.primary),
                title: const Text('Take a photo', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () async {
                  Navigator.pop(sheetContext);
                  final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
                  if (picked != null) {
                    final path = await persistPickedImage(picked);
                    onChanged(path);
                  }
                },
              ),
              if (photoPath != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  title: const Text('Remove photo', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.redAccent)),
                  onTap: () {
                    Navigator.pop(sheetContext);
                    onChanged(null);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoPath != null && File(photoPath!).existsSync();

    return GestureDetector(
      onTap: () => _openPicker(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: hasPhoto ? null : EvermoreTheme.heroGradient,
              image: hasPhoto
                  ? DecorationImage(image: FileImage(File(photoPath!)), fit: BoxFit.cover)
                  : null,
              boxShadow: EvermoreTheme.cardShadow,
            ),
            child: hasPhoto
                ? null
                : Center(
                    child: _initials.isNotEmpty
                        ? Text(
                            _initials,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: size * 0.34,
                            ),
                          )
                        : Icon(Icons.person_outline_rounded, color: Colors.white, size: size * 0.42),
                  ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: EvermoreTheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 14),
            ),
          ),
        ],
      ),
    );
  }
}
