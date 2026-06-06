import 'package:thimar/core/imports/core_imports.dart';

class CustomerInfoSection extends StatelessWidget {
  final String name;
  final String phone;

  const CustomerInfoSection({
    super.key,
    required this.name,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.person, color: cs.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'customer_name'.tr(),
                    style: tt.bodyMedium?.copyWith(
                      color: cs.outline,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    name,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Icon(Icons.phone, color: cs.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'phone_number'.tr(),
                    style: tt.bodyMedium?.copyWith(
                      color: cs.outline,
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    phone,
                    style: tt.bodyMedium?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
