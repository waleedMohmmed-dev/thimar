import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/addresses/domain/entities/address_entity.dart';
import 'package:thimar/features/addresses/presentation/cubit/addresses_cubit.dart';
import 'package:thimar/features/addresses/presentation/pages/add_address_page.dart';

class AddressPickerSection extends StatefulWidget {
  final AddressEntity? selectedAddress;
  final ValueChanged<AddressEntity> onAddressSelected;

  const AddressPickerSection({
    super.key,
    this.selectedAddress,
    required this.onAddressSelected,
  });

  @override
  State<AddressPickerSection> createState() => _AddressPickerSectionState();
}

class _AddressPickerSectionState extends State<AddressPickerSection> {
  late AddressesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<AddressesCubit>()..loadAddresses();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
              onPressed: () => _navigateToAddAddress(context),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        BlocBuilder<AddressesCubit, AddressesState>(
          bloc: _cubit,
          builder: (context, state) {
            if (state is AddressesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is AddressesError) {
              return Text(
                state.message,
                style: tt.bodyMedium?.copyWith(color: cs.error),
              );
            }
            if (state is AddressesLoaded) {
              if (state.addresses.isEmpty) {
                return GestureDetector(
                  onTap: () => _navigateToAddAddress(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: cs.primary, width: 1.5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'choose_delivery_address'.tr(),
                            style: tt.bodyMedium?.copyWith(
                              color: cs.outline,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.expand_more,
                          color: cs.primary,
                          size: 20.sp,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return _buildAddressList(context, state.addresses);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildAddressList(
    BuildContext context,
    List<AddressEntity> addresses,
  ) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      children: addresses.map((address) {
        final isSelected = widget.selectedAddress?.id == address.id;
        return GestureDetector(
          onTap: () => widget.onAddressSelected(address),
          child: Container(
            margin: EdgeInsets.only(bottom: 8.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? cs.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected ? cs.primary : cs.outline,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: isSelected ? cs.primary : cs.outline,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address.displayName,
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurface,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        address.location,
                        style: tt.bodySmall?.copyWith(
                          color: cs.outline,
                          fontSize: 12.sp,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check_circle, color: cs.primary, size: 20.sp),
                if (!isSelected)
                  GestureDetector(
                    onTap: () => _confirmDelete(context, address),
                    child: Icon(
                      Icons.delete_outline,
                      color: cs.error,
                      size: 20.sp,
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _navigateToAddAddress(BuildContext context) async {
    final result = await Navigator.of(context).push<AddressEntity>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: _cubit,
          child: const AddAddressPage(),
        ),
      ),
    );

    if (result != null && mounted) {
      widget.onAddressSelected(result);
    }
  }

  void _confirmDelete(BuildContext context, AddressEntity address) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'حذف العنوان',
          style: tt.titleLarge?.copyWith(
            color: cs.error,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذا العنوان؟',
          style: tt.bodyMedium?.copyWith(color: cs.onSurface),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'إلغاء',
              style: tt.bodyMedium?.copyWith(color: cs.outline),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _cubit.deleteAddress(address.id);
            },
            child: Text(
              'حذف',
              style: tt.bodyMedium?.copyWith(
                color: cs.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
