import 'dart:io';

import 'package:thimar/core/imports/core_imports.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadField extends StatelessWidget {
  final String label;
  final File? selectedImage;
  final ValueChanged<File?> onImageSelected;

  const ImageUploadField({
    super.key,
    required this.label,
    required this.selectedImage,
    required this.onImageSelected,
  });

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (pickedFile != null) {
      onImageSelected(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: double.infinity,
            height: 85.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: cs.outline, width: 1.5),
              color: cs.surface,
            ),
            child: selectedImage != null
                ? _buildPreview(cs)
                : _buildPlaceholder(cs),
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: tt.bodySmall?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
            fontSize: 11.sp,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholder(ColorScheme cs) {
    return Center(
      child: Icon(Icons.camera_alt_outlined, size: 28.r, color: cs.outline),
    );
  }

  Widget _buildPreview(ColorScheme cs) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.r),
          child: Image.file(
            selectedImage!,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 4.h,
          left: 4.w,
          child: GestureDetector(
            onTap: () => onImageSelected(null),
            child: Container(
              padding: EdgeInsets.all(2.r),
              decoration: BoxDecoration(
                color: cs.error,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.close, size: 14.r, color: cs.onError),
            ),
          ),
        ),
      ],
    );
  }
}
