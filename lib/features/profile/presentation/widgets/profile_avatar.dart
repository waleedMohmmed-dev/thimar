import 'dart:io';
import 'package:thimar/core/imports/core_imports.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onTap;

  const ProfileAvatar({super.key, this.imagePath, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: _AvatarImage(imagePath: imagePath),
        ),
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final String? imagePath;

  const _AvatarImage({this.imagePath});

  @override
  Widget build(BuildContext context) {
    if (imagePath != null && imagePath!.isNotEmpty) {
      if (imagePath!.startsWith('http://') ||
          imagePath!.startsWith('https://')) {
        return Image.network(
          imagePath!,
          width: 120.w,
          height: 120.w,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const _DefaultAvatar(),
        );
      }
      return Image.file(
        File(imagePath!),
        width: 120.w,
        height: 120.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const _DefaultAvatar(),
      );
    }
    return const _DefaultAvatar();
  }
}

class _DefaultAvatar extends StatelessWidget {
  const _DefaultAvatar();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Container(
      width: 120.w,
      height: 120.w,
      color: cs.surfaceContainerHighest,
      child: Icon(
        Icons.person,
        size: 60.r,
        color: cs.onSurface,
      ),
    );
  }
}
