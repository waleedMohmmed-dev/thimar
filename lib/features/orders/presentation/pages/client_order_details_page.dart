import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/orders/domain/entities/order_entity.dart';
import 'package:thimar/features/orders/domain/usecases/get_client_order_details_use_case.dart';
import 'package:thimar/features/orders/presentation/widgets/order_card.dart';

class ClientOrderDetailsPage extends StatefulWidget {
  final String orderId;
  const ClientOrderDetailsPage({super.key, required this.orderId});

  @override
  State<ClientOrderDetailsPage> createState() => _ClientOrderDetailsPageState();
}

class _ClientOrderDetailsPageState extends State<ClientOrderDetailsPage> {
  final GetClientOrderDetailsUseCase _useCase =
      sl<GetClientOrderDetailsUseCase>();
  Future<OrderEntity>? _future;

  @override
  void initState() {
    super.initState();
    _future = _fetch();
  }

  Future<OrderEntity> _fetch() async {
    final result = await _useCase(int.parse(widget.orderId));
    return result.fold((failure) => throw Exception(failure.message), (o) => o);
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
      ),
      body: FutureBuilder<OrderEntity>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoading());
          }
          if (snapshot.hasError) {
            return AppError(
              message: snapshot.error?.toString() ?? 'unexpected_error'.tr(),
              onRetry: () => setState(() => _future = _fetch()),
            );
          }
          final order = snapshot.data!;
          return ListView(
            padding: EdgeInsets.all(16.w),
            children: [
              OrderCard(order: order),
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
            ],
          );
        },
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
