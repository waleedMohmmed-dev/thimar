import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';
import 'package:thimar/features/home/domain/usecases/get_category_products_use_case.dart';

class CategoryProductsPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  final GetCategoryProductsUseCase _getCategoryProductsUseCase =
      sl<GetCategoryProductsUseCase>();
  late Future<Either<Failure, List<ProductEntity>>> _productsFuture;
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _favoriteIds = {};
  List<ProductEntity>? _allProducts;
  List<ProductEntity> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<Either<Failure, List<ProductEntity>>> _fetchProducts() {
    return _getCategoryProductsUseCase(widget.categoryId);
  }

  void _onSearchChanged(String query) {
    if (_allProducts == null) return;
    setState(() {
      _filteredProducts = query.isEmpty
          ? _allProducts!
          : _allProducts!
              .where((p) =>
                  p.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  void _refresh() {
    setState(() {
      _productsFuture = _fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: tt.headlineSmall?.copyWith(
            color: cs.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        leading: const AppBackButton(),
      ),
      body: FutureBuilder<Either<Failure, List<ProductEntity>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoading());
          }

          return snapshot.data?.fold(
            (failure) => AppError(message: failure.message, onRetry: _refresh),
            (products) {
              if (products.isEmpty) {
                return AppEmptyState(
                  icon: Icons.search_off_outlined,
                  title: 'no_products'.tr(),
                  subtitle: 'check_back_later'.tr(),
                );
              }

              if (_allProducts == null) {
                _allProducts = products;
                _filteredProducts = products;
              }

              final displayProducts = _searchController.text.isEmpty
                  ? products
                  : _filteredProducts;

              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            controller: _searchController,
                            onChanged: _onSearchChanged,
                            fillColor: cs.surfaceContainerHighest,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                            hintText: 'ابحث عن ماتريد؟',
                            prefixIcon: Icons.search,
                            suffixWidget:
                                _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.clear,
                                          color: Colors.grey[400],
                                          size: 20.r,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          _onSearchChanged('');
                                        },
                                      )
                                    : null,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          decoration: BoxDecoration(
                            color: cs.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.tune, color: cs.primary),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: displayProducts.isEmpty
                          ? AppEmptyState(
                              icon: Icons.search_off_outlined,
                              title: 'no_results'.tr(),
                              subtitle: 'try_different_keywords'.tr(),
                            )
                          : GridView.builder(
                              itemCount: displayProducts.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 14.h,
                                crossAxisSpacing: 14.w,
                                childAspectRatio: 0.72,
                              ),
                              itemBuilder: (context, index) {
                                final product = displayProducts[index];
                                return ProductCard(
                                  product: product,
                                  isFavorite:
                                      _favoriteIds.contains(product.id),
                                  onTap: () {
                                    context.push(
                                      '${AppRoutes.productDetails}/${product.id}',
                                    );
                                  },
                                  onFavoriteToggle: () {
                                    setState(() {
                                      if (_favoriteIds.contains(product.id)) {
                                        _favoriteIds.remove(product.id);
                                      } else {
                                        _favoriteIds.add(product.id);
                                      }
                                    });
                                  },
                                  onAddToCart: () {
                                    context.showSnackBar(
                                      'added_to_cart'.tr(),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ),
                ],
              );
            },
          ) ?? const SizedBox.shrink();
        },
      ),
    );
  }
}
