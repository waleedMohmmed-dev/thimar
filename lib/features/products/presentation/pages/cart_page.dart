import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/home/domain/entities/cart_item_entity.dart';
import 'package:thimar/features/home/domain/usecases/apply_coupon_use_case.dart';
import 'package:thimar/features/home/domain/usecases/delete_cart_item_use_case.dart';
import 'package:thimar/features/home/domain/usecases/get_cart_use_case.dart';
import 'package:thimar/features/home/domain/usecases/update_cart_item_use_case.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final GetCartUseCase _getCartUseCase = sl<GetCartUseCase>();
  final UpdateCartItemUseCase _updateCartItemUseCase =
      sl<UpdateCartItemUseCase>();
  final DeleteCartItemUseCase _deleteCartItemUseCase =
      sl<DeleteCartItemUseCase>();
  final ApplyCouponUseCase _applyCouponUseCase = sl<ApplyCouponUseCase>();
  final TextEditingController _couponController = TextEditingController();
  double _couponDiscount = 0;
  String? _appliedCouponCode;
  bool _isApplyingCoupon = false;
  late Future<List<CartItemEntity>> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = _fetchCart();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  Future<List<CartItemEntity>> _fetchCart() async {
    final result = await _getCartUseCase(NoParams());
    return result.fold((failure) => [], (items) => items);
  }

  void _refresh() {
    setState(() {
      _cartFuture = _fetchCart();
    });
  }

  Future<void> _updateQuantity(CartItemEntity item, int newAmount) async {
    if (newAmount < 1) return;
    final result = await _updateCartItemUseCase(
      UpdateCartItemParams(itemId: item.id.toString(), amount: newAmount),
    );
    if (!mounted) return;
    result.fold(
      (failure) => context.showErrorSnackBar(failure.message),
      (_) => _refresh(),
    );
  }

  Future<void> _deleteItem(CartItemEntity item) async {
    final result = await _deleteCartItemUseCase(
      DeleteCartItemParams(itemId: item.id.toString()),
    );
    if (!mounted) return;
    result.fold((failure) => context.showErrorSnackBar(failure.message), (_) {
      context.showSuccessSnackBar('تم الحذف بنجاح');
      _refresh();
    });
  }

  Future<void> _applyCoupon() async {
    final code = _couponController.text.trim();
    if (code.isEmpty) return;
    setState(() => _isApplyingCoupon = true);
    final result = await _applyCouponUseCase(ApplyCouponParams(code: code));
    if (!mounted) return;
    result.fold(
      (failure) {
        context.showErrorSnackBar(failure.message);
        setState(() => _isApplyingCoupon = false);
      },
      (data) {
        final discount = (data['discount'] as num?)?.toDouble() ?? 0;
        setState(() {
          _couponDiscount = discount;
          _appliedCouponCode = code;
          _isApplyingCoupon = false;
        });
        context.showSuccessSnackBar('تم تطبيق الكوبون بنجاح');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'سلة التسوق',
          style: tt.headlineSmall?.copyWith(
            color: cs.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: const AppBackButton(),
      ),
      body: FutureBuilder<List<CartItemEntity>>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoading());
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return AppEmptyState(
              icon: Icons.shopping_cart_outlined,
              title: 'السلة فارغة',
              subtitle: 'تصفح المنتجات وأضف ما تريد',
            );
          }

          final subtotal = items.fold(
            0.0,
            (sum, item) => sum + item.price * item.amount,
          );
          final total = subtotal - _couponDiscount;

          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16.w),
                  children: [
                    ...items.map(
                      (item) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: _CartItemCard(
                          item: item,
                          onIncrement: () =>
                              _updateQuantity(item, item.amount + 1),
                          onDecrement: () =>
                              _updateQuantity(item, item.amount - 1),
                          onDelete: () => _deleteItem(item),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Coupon section
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: cs.outline.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 44.h,
                                  child: TextField(
                                    controller: _couponController,
                                    enabled: _appliedCouponCode == null,
                                    textDirection: TextDirection.rtl,
                                    decoration: InputDecoration(
                                      hintText: 'عندك كوبون ؟ ادخل رقم الكوبون',
                                      hintTextDirection: TextDirection.rtl,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12.w,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        borderSide: BorderSide(
                                          color: cs.outline,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        borderSide: BorderSide(
                                          color: cs.outline.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              SizedBox(
                                height: 44.h,
                                child: ElevatedButton(
                                  onPressed: _appliedCouponCode == null
                                      ? _applyCoupon
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: cs.primary,
                                    foregroundColor: cs.onPrimary,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: _isApplyingCoupon
                                      ? SizedBox(
                                          width: 20.r,
                                          height: 20.r,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: cs.onPrimary,
                                          ),
                                        )
                                      : Text(
                                          'تطبيق',
                                          style: tt.labelLarge?.copyWith(
                                            color: cs.onPrimary,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          if (_appliedCouponCode != null) ...[
                            SizedBox(height: 8.h),
                            Text(
                              'تم تطبيق الكوبون بنجاح',
                              style: tt.bodySmall?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Order summary
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: cs.outline.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(
                            context,
                            'اجمالي المنتجات',
                            subtotal.toStringAsFixed(1),
                          ),
                          SizedBox(height: 8.h),
                          _buildSummaryRow(
                            context,
                            'الخصم',
                            _couponDiscount.toStringAsFixed(1),
                            isDiscount: true,
                          ),
                          SizedBox(height: 8.h),
                          Divider(color: cs.outline.withValues(alpha: 0.3)),
                          SizedBox(height: 8.h),
                          _buildSummaryRow(
                            context,
                            'المجموع',
                            total.toStringAsFixed(1),
                            isTotal: true,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    // Checkout button
                    SizedBox(
                      width: double.infinity,
                      height: 54.h,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.primary,
                          foregroundColor: cs.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_bag_outlined, size: 20.r),
                            SizedBox(width: 8.w),
                            Text(
                              'إتمام الطلب',
                              style: tt.labelLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: cs.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: tt.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: cs.onSurfaceVariant,
          ),
        ),
        Text(
          '$value ${'sar'.tr()}',
          style: tt.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDiscount
                ? cs.error
                : isTotal
                ? cs.primary
                : cs.onSurface,
          ),
        ),
      ],
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemEntity item;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onDelete;

  const _CartItemCard({
    required this.item,
    required this.onIncrement,
    required this.onDecrement,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.primary.withAlpha(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: AppImage(
              imageUrl: item.image,
              width: 80.w,
              height: 80.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  '${item.price.toStringAsFixed(1)} ${'sar'.tr()}',
                  style: tt.bodyMedium?.copyWith(
                    color: cs.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          _SmallIconButton(
                            icon: Icons.remove,
                            onTap: onDecrement,
                          ),
                          SizedBox(
                            width: 36.w,
                            child: Center(
                              child: Text(
                                '${item.amount}',
                                style: tt.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: cs.primary,
                                ),
                              ),
                            ),
                          ),
                          _SmallIconButton(icon: Icons.add, onTap: onIncrement),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: onDelete,
                      child: Icon(
                        Icons.delete_outline,
                        color: cs.error,
                        size: 20.r,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _SmallIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: cs.primary.withAlpha(25),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, size: 16.r, color: cs.primary),
      ),
    );
  }
}
