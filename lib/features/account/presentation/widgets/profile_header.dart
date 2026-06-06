import 'dart:io';

import 'package:thimar/core/imports/core_imports.dart';

class ProfileHeader extends StatelessWidget {
  final dynamic user;
  final VoidCallback onImagePick;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.onImagePick,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
      child: Column(
        children: [
          // Profile Picture
          GestureDetector(
            onTap: onImagePick,
            child: Container(
              width: 100.w,
              height: 100.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: _ProfileImage(user: user),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          // User Name
          Text(
            user?.name ?? 'user_name'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          // User Phone
          Text(
            user?.phone ?? '+966 00 0000000',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

}

class _ProfileImage extends StatelessWidget {
  final dynamic user;

  const _ProfileImage({required this.user});

  @override
  Widget build(BuildContext context) {
    if (user?.profileImage != null && user!.profileImage!.isNotEmpty) {
      final imagePath = user.profileImage!;
      if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const _DefaultAvatar(),
        );
      }
      return Image.file(
        File(imagePath),
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
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(Icons.person, size: 50.sp, color: Colors.grey[600]),
      ),
    );
  }
}
