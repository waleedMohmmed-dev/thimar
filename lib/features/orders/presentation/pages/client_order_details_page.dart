import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/core/services/tab_navigation_service.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/usecases/delete_client_order_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_client_order_details_use_case.dart';
import 'package:thimar/features/orders/domain/usecases/get_order_products_use_case.dart';
import 'package:thimar/features/orders/presentation/widgets/order_card.dart';

class ClientOrderDetailsPage extends StatefulWidget {
  final String orderId;
  const ClientOrderDetailsPage({super.key, required this.orderId});

  @override
  State<ClientOrderDetailsPage> createState() => _ClientOrderDetailsPageState();
}

class _ClientOrderDetailsPageState extends State<ClientOrderDetailsPage> {
  final _detailsUseCase = sl<GetClientOrderDetailsUseCase>();
  final _productsUseCase = sl<GetOrderProductsUseCase>();
  final _deleteUseCase = sl<DeleteClientOrderUseCase>();
  late Future<OrderEntity> _orderFuture;
  late Future<List<dynamic>> _productsFuture;
  bool _isDeleting = false;

  @override
  void initState() {
    super.initState();
    _orderFuture = _fetchOrder();
    _productsFuture = _fetchProducts();
  }

  Future<OrderEntity> _fetchOrder() async {
    final result = await _detailsUseCase(int.parse(widget.orderId));
    return result.fold((failure) => throw Exception(failure.message), (o) => o);
  }

  Future<List<dynamic>> _fetchProducts() async {
    final result = await _productsUseCase(int.parse(widget.orderId));
    return result.fold((failure) => [], (list) => list);
  }

  Future<void> _deleteOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الطلب'),
        content: const Text('هل أنت متأكد من حذف هذا الطلب؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _isDeleting = true);

    final result = await _deleteUseCase(int.parse(widget.orderId));

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() => _isDeleting = false);
        context.showErrorSnackBar(failure.message);
      },
      (_) {
        TabNavigationService.navigateToTab(1);
        context.go(AppRoutes.home);
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
          'تفاصيل الطلب',
          style: tt.headlineSmall?.copyWith(
            color: cs.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: const AppBackButton(),
        actions: [
          IconButton(
            icon: _isDeleting
                ? SizedBox(
                    width: 20.w,
                    height: 20.h,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cs.error,
                    ),
                  )
                : Icon(Icons.delete_outline, color: cs.error),
            onPressed: _isDeleting ? null : _deleteOrder,
          ),
        ],
      ),
      body: FutureBuilder<OrderEntity>(
        future: _orderFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoading());
          }
          if (snapshot.hasError) {
            return AppError(
              message: snapshot.error?.toString() ?? 'unexpected_error'.tr(),
              onRetry: () => setState(() {
                _orderFuture = _fetchOrder();
                _productsFuture = _fetchProducts();
              }),
            );
          }
          final order = snapshot.data!;
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              OrderCard(order: order),
              SizedBox(height: 16.h),

              if (order.address != null || order.deliveryDate != null) ...[
                _buildSection(
                  context,
                  'بيانات التوصيل',
                  [
                    if (order.address != null && order.address!.isNotEmpty)
                      _buildInfoRow(cs, tt, 'العنوان', order.address!),
                    if (order.deliveryDate != null && order.deliveryDate!.isNotEmpty)
                      _buildInfoRow(cs, tt, 'التاريخ', order.deliveryDate!),
                    if (order.deliveryTime != null && order.deliveryTime!.isNotEmpty)
                      _buildInfoRow(cs, tt, 'الوقت', order.deliveryTime!),
                  ],
                ),
                SizedBox(height: 16.h),
              ],

              FutureBuilder<List<dynamic>>(
                future: _productsFuture,
                builder: (context, prodSnapshot) {
                  final products = prodSnapshot.data ?? [];
                  if (products.isEmpty) return const SizedBox.shrink();
                  return _buildSection(
                    context,
                    'المنتجات',
                    products.map((p) {
                      final name = p['name']?.toString() ?? '';
                      final url = p['url']?.toString() ?? '';
                      final qty = p['quantity']?.toString() ?? '1';
                      final price = p['price']?.toString() ?? '';
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          children: [
                            if (url.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.r),
                                child: AppImage(
                                  imageUrl: url,
                                  width: 48.w,
                                  height: 48.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if (url.isNotEmpty) SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (name.isNotEmpty)
                                    Text(
                                      name,
                                      style: tt.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  if (qty.isNotEmpty)
                                    Text(
                                      'الكمية: $qty',
                                      style: tt.bodySmall?.copyWith(
                                        color: cs.onSurfaceVariant,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (price.isNotEmpty)
                              Text(
                                '$price ₪',
                                style: tt.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: cs.primary,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
              SizedBox(height: 16.h),

              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: cs.surface,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ملخص الطلب',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.primary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildRow(cs, tt, 'إجمالي المنتجات',
                        '${order.productsTotal ?? order.total.toStringAsFixed(1)} ${'sar'.tr()}'),
                    SizedBox(height: 6.h),
                    _buildRow(cs, tt, 'التوصيل',
                        '${order.deliveryPrice ?? '0'} ${'sar'.tr()}'),
                    if (order.discount != null && order.discount!.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      _buildRow(cs, tt, 'الخصم',
                          '-${order.discount} ${'sar'.tr()}',
                          isDiscount: true),
                    ],
                    SizedBox(height: 6.h),
                    Divider(color: cs.outline.withValues(alpha: 0.3)),
                    SizedBox(height: 6.h),
                    _buildRow(cs, tt, 'المجموع',
                        '${order.total.toStringAsFixed(1)} ${'sar'.tr()}',
                        isTotal: true),
                  ],
                ),
              ),

              if (order.notes != null && order.notes!.isNotEmpty) ...[
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: cs.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ملاحظات',
                        style: tt.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        order.notes!,
                        style: tt.bodyMedium?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (order.status == OrderStatus.pendingApproval ||
                  order.status == OrderStatus.preparing) ...[
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: cs.error,
                      side: BorderSide(color: cs.error),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: _isDeleting ? null : _deleteOrder,
                    icon: _isDeleting
                        ? SizedBox(
                            width: 20.w,
                            height: 20.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: cs.error,
                            ),
                          )
                        : const Icon(Icons.delete_outline),
                    label: Text(
                      'حذف الطلب',
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 16.h),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    final cs = context.colorScheme;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: cs.outline.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
          SizedBox(height: 12.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(ColorScheme cs, TextTheme tt, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          Text(
            value,
            style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    ColorScheme cs,
    TextTheme tt,
    String label,
    String value, {
    bool isDiscount = false,
    bool isTotal = false,
  }) {
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
          value,
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
