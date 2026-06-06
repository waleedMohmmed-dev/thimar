import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/imports/packages_imports.dart';

class AddressPickerSection extends StatelessWidget {
  final String? selectedAddress;
  final VoidCallback onAddAddress;

  const AddressPickerSection({
    super.key,
    required this.selectedAddress,
    required this.onAddAddress,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onAddAddress,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'choose_delivery_address'.tr(),
                style: tt.bodyLarge?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add, color: cs.primary, size: 24.sp),
                onPressed: onAddAddress,
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: onAddAddress,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              border: Border.all(color: cs.primary, width: 1.5),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    selectedAddress ?? 'choose_delivery_address'.tr(),
                    style: tt.bodyMedium?.copyWith(
                      color: selectedAddress != null ? cs.primary : cs.outline,
                      fontSize: 14.sp,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.expand_more, color: cs.primary, size: 20.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
