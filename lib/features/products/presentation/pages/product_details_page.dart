import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';
import 'package:thimar/features/home/domain/entities/rate_entity.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';
import 'package:thimar/features/home/presentation/bloc/home_bloc.dart';
import 'package:thimar/features/home/presentation/bloc/home_event.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  late Future<Either<Failure, ProductEntity>> _detailsFuture;
  late Future<Either<Failure, List<RateEntity>>> _ratesFuture;
  bool _isFavorite = false;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _fetchDetails();
    _ratesFuture = _fetchRates();
  }

  Future<Either<Failure, ProductEntity>> _fetchDetails() {
    final repo = sl<HomeRepository>();
    return repo.getProductById(widget.productId);
  }

  Future<Either<Failure, List<RateEntity>>> _fetchRates() {
    final repo = sl<HomeRepository>();
    return repo.getProductRates(widget.productId);
  }

  void _refresh() {
    setState(() {
      _detailsFuture = _fetchDetails();
      _ratesFuture = _fetchRates();
    });
  }

  void _refreshRates() {
    setState(() {
      _ratesFuture = _fetchRates();
    });
  }

  Future<Either<Failure, void>> _addRate(int value, String comment) {
    final repo = sl<HomeRepository>();
    return repo.addProductRate(widget.productId, value, comment);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Either<Failure, ProductEntity>>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: const AppBackButton(),
              ),
              body: const Center(child: AppLoading()),
            );
          }

          return snapshot.data?.fold(
                (failure) => Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    leading: const AppBackButton(),
                  ),
                  body: AppError(message: failure.message, onRetry: _refresh),
                ),
                (product) {
                  _isFavorite = product.isFavorite;

                  return _ProductDetailsContent(
                    product: product,
                    productId: widget.productId,
                    ratesFuture: _ratesFuture,
                    isFavorite: _isFavorite,
                    quantity: _quantity,
                    onFavoriteToggle: () {
                      context.read<HomeBloc>().add(
                        ProductFavoriteToggled(product.id),
                      );
                      setState(() => _isFavorite = !_isFavorite);
                    },
                    onQuantityChanged: (qty) => setState(() => _quantity = qty),
                    onAddToCart: () {},
                    onRateAdded: _refreshRates,
                    addRate: _addRate,
                  );
                },
              ) ??
              const SizedBox.shrink();
        },
      ),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  final ProductEntity product;
  final String productId;
  final Future<Either<Failure, List<RateEntity>>> ratesFuture;
  final bool isFavorite;
  final int quantity;
  final VoidCallback onFavoriteToggle;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onAddToCart;
  final VoidCallback onRateAdded;
  final Future<Either<Failure, void>> Function(int value, String comment)
  addRate;

  const _ProductDetailsContent({
    required this.product,
    required this.productId,
    required this.ratesFuture,
    required this.isFavorite,
    required this.quantity,
    required this.onFavoriteToggle,
    required this.onQuantityChanged,
    required this.onAddToCart,
    required this.onRateAdded,
    required this.addRate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _HeroSection(
                  imageUrl: product.imageUrl,
                  isFavorite: isFavorite,
                  onFavoriteToggle: onFavoriteToggle,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProductNameRow(
                        name: product.name,
                        unitName: product.unitName,
                      ),
                      SizedBox(height: 12.h),
                      _PriceRow(
                        price: product.price,
                        priceBeforeDiscount: product.priceBeforeDiscount,
                        discount: product.discount,
                      ),
                      SizedBox(height: 20.h),
                      _QuantitySelector(
                        quantity: quantity,
                        onChanged: onQuantityChanged,
                      ),
                      SizedBox(height: 24.h),
                      _SectionDivider(),
                      SizedBox(height: 24.h),
                      _DescriptionSection(description: product.description),
                      SizedBox(height: 24.h),
                      _SectionDivider(),
                      SizedBox(height: 24.h),
                      _ReviewsSection(
                        ratesFuture: ratesFuture,
                        productId: productId,
                        addRate: addRate,
                        onRateAdded: onRateAdded,
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _BottomCartBar(
          price: product.price,
          quantity: quantity,
          onAddToCart: onAddToCart,
        ),
      ],
    );
  }
}

class _HeroSection extends StatelessWidget {
  final String imageUrl;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _HeroSection({
    required this.imageUrl,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return SizedBox(
      height: 380.h,
      width: double.infinity,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32.r)),
            child: AppImage(
              imageUrl: imageUrl,
              height: 380.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            left: 16.w,
            child: Container(
              width: 44.r,
              height: 44.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(40),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const AppBackButton(),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8.h,
            right: 16.w,
            child: GestureDetector(
              onTap: onFavoriteToggle,
              child: Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(40),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? cs.primary : Colors.grey,
                  size: 22.r,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 80.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withAlpha(120)],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductNameRow extends StatelessWidget {
  final String name;
  final String unitName;

  const _ProductNameRow({required this.name, required this.unitName});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            name,
            style: tt.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: cs.primary,
              height: 1.3,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: cs.primary.withAlpha(25),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: cs.primary.withAlpha(50)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.shopping_bag_outlined, size: 14.r, color: cs.primary),
              SizedBox(width: 4.w),
              Text(
                unitName,
                style: tt.labelSmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final double price;
  final double? priceBeforeDiscount;
  final double? discount;

  const _PriceRow({
    required this.price,
    this.priceBeforeDiscount,
    this.discount,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      children: [
        Text(
          price.toStringAsFixed(1),
          style: tt.headlineMedium?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w900,
            fontSize: 28.sp,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          'sar'.tr(),
          style: tt.bodyMedium?.copyWith(
            color: cs.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (priceBeforeDiscount != null && priceBeforeDiscount! > price) ...[
          SizedBox(width: 12.w),
          Text(
            '${priceBeforeDiscount!.toStringAsFixed(1)} ${'sar'.tr()}',
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              decoration: TextDecoration.lineThrough,
              decorationColor: cs.error,
              decorationThickness: 2,
            ),
          ),
        ],
        if (discount != null && discount! > 0) ...[
          SizedBox(width: 10.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFFF6B6B), Color(0xFFEE4444)],
              ),
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF6B6B).withAlpha(80),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              '-${(discount! * 100).round()}%',
              style: tt.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuantitySelector extends StatefulWidget {
  final int quantity;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({required this.quantity, required this.onChanged});

  @override
  State<_QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<_QuantitySelector> {
  late int _qty;

  @override
  void initState() {
    super.initState();
    _qty = widget.quantity;
  }

  @override
  void didUpdateWidget(covariant _QuantitySelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.quantity != widget.quantity) {
      _qty = widget.quantity;
    }
  }

  void _decrement() {
    if (_qty > 1) {
      setState(() => _qty--);
      widget.onChanged(_qty);
    }
  }

  void _increment() {
    setState(() => _qty++);
    widget.onChanged(_qty);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Row(
      children: [
        Text(
          'الكمية',
          style: tt.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: cs.primary,
          ),
        ),
        const Spacer(),
        Container(
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Row(
            children: [
              _QuantityButton(
                icon: Icons.remove,
                onTap: _decrement,
                isDisabled: _qty <= 1,
              ),
              SizedBox(
                width: 56.w,
                child: Center(
                  child: Text(
                    '$_qty',
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: cs.primary,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              _QuantityButton(icon: Icons.add, onTap: _increment),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDisabled;

  const _QuantityButton({
    required this.icon,
    required this.onTap,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44.r,
        height: 44.r,
        decoration: BoxDecoration(
          color: isDisabled ? Colors.grey.shade200 : cs.primary.withAlpha(25),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(
          icon,
          size: 20.r,
          color: isDisabled ? Colors.grey.shade400 : cs.primary,
        ),
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [cs.primary.withAlpha(80), Colors.transparent],
              ),
            ),
          ),
        ),
        Container(
          width: 6.r,
          height: 6.r,
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          decoration: BoxDecoration(color: cs.primary, shape: BoxShape.circle),
        ),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, cs.primary.withAlpha(80)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DescriptionSection extends StatelessWidget {
  final String description;

  const _DescriptionSection({required this.description});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    if (description.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'description'.tr(),
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest.withAlpha(80),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: cs.primary.withAlpha(25)),
          ),
          child: Text(
            description,
            style: tt.bodyMedium?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.4,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  final Future<Either<Failure, List<RateEntity>>> ratesFuture;
  final String productId;
  final Future<Either<Failure, void>> Function(int value, String comment)
  addRate;
  final VoidCallback onRateAdded;

  const _ReviewsSection({
    required this.ratesFuture,
    required this.productId,
    required this.addRate,
    required this.onRateAdded,
  });

  void _showAddRateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) => _AddRateSheet(addRate: addRate, onRateAdded: onRateAdded),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4.w,
              height: 24.h,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'التقييمات',
              style: tt.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: cs.primary,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'عرض الكل',
                    style: tt.bodySmall?.copyWith(
                      color: cs.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(Icons.arrow_forward_ios, size: 12.r, color: cs.primary),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        FutureBuilder<Either<Failure, List<RateEntity>>>(
          future: ratesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 160.h,
                child: const Center(child: AppLoading()),
              );
            }

            final rates =
                snapshot.data?.fold(
                  (failure) => <RateEntity>[],
                  (data) => data,
                ) ??
                <RateEntity>[];

            if (rates.isEmpty) {
              return _EmptyReviews(onAddTap: () => _showAddRateSheet(context));
            }

            return SizedBox(
              height: 160.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: rates.length,
                separatorBuilder: (_, _) => SizedBox(width: 12.w),
                itemBuilder: (context, i) {
                  final review = rates[i];
                  return _ReviewCard(review: review);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class _EmptyReviews extends StatelessWidget {
  final VoidCallback onAddTap;

  const _EmptyReviews({required this.onAddTap});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest.withAlpha(80),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: cs.primary.withAlpha(25)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.rate_review_outlined,
            size: 40.r,
            color: cs.primary.withAlpha(150),
          ),
          SizedBox(height: 8.h),
          Text(
            'لا توجد تقييمات بعد',
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 44.h,
            child: ElevatedButton.icon(
              onPressed: onAddTap,
              icon: Icon(Icons.star_outline, size: 18.r),
              label: Text(
                'أضف تقييمك',
                style: tt.labelLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddRateSheet extends StatefulWidget {
  final Future<Either<Failure, void>> Function(int value, String comment)
  addRate;
  final VoidCallback onRateAdded;

  const _AddRateSheet({required this.addRate, required this.onRateAdded});

  @override
  State<_AddRateSheet> createState() => _AddRateSheetState();
}

class _AddRateSheetState extends State<_AddRateSheet> {
  int _rating = 0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) return;

    setState(() => _isSubmitting = true);

    final result = await widget.addRate(_rating, _commentController.text);

    if (!mounted) return;

    result.fold(
      (failure) {
        context.showErrorSnackBar(failure.message);
        setState(() => _isSubmitting = false);
      },
      (_) {
        widget.onRateAdded();
        context.pop();
        context.showSuccessSnackBar('تم إضافة التقييم بنجاح');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, bottom + 16.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: cs.onSurfaceVariant.withAlpha(80),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'تقييم المنتج',
            style: tt.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: cs.primary,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Icon(
                    i < _rating ? Icons.star : Icons.star_border,
                    size: 40.r,
                    color: const Color(0xFFFFB800),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          TextField(
            controller: _commentController,
            maxLines: 3,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: 'اكتب تعليقك...',
              filled: true,
              fillColor: cs.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: _rating == 0 || _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.primary,
                foregroundColor: cs.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: _isSubmitting
                  ? SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: cs.onPrimary,
                      ),
                    )
                  : Text(
                      'إرسال التقييم',
                      style: tt.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final RateEntity review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Container(
      width: 220.w,
      padding: EdgeInsets.all(14.w),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20.r,
                backgroundImage: NetworkImage(review.clientImage),
                onBackgroundImageError: (_, _) {},
                child: Icon(Icons.person, size: 20.r, color: cs.primary),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  review.clientName.isNotEmpty ? review.clientName : 'مستخدم',
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.primary,
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < review.value ? Icons.star : Icons.star_border,
                size: 14.r,
                color: const Color(0xFFFFB800),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: Text(
              review.comment,
              style: tt.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
                height: 1.3,
                fontSize: 12.sp,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomCartBar extends StatelessWidget {
  final double price;
  final int quantity;
  final VoidCallback onAddToCart;

  const _BottomCartBar({
    required this.price,
    required this.quantity,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;
    final total = price * quantity;

    return Container(
      padding: EdgeInsets.fromLTRB(
        20.w,
        12.h,
        20.w,
        MediaQuery.of(context).padding.bottom + 12.h,
      ),
      decoration: BoxDecoration(
        color: cs.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'المجموع',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Text(
                        total.toStringAsFixed(1),
                        style: tt.titleLarge?.copyWith(
                          color: cs.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 22.sp,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'sar'.tr(),
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 180.w,
              height: 54.h,
              child: ElevatedButton(
                onPressed: onAddToCart,
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
                    Icon(Icons.shopping_cart_outlined, size: 20.r),
                    SizedBox(width: 8.w),
                    Text(
                      'أضف إلى السلة',
                      style: tt.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
