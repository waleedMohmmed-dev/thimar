import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/home/domain/entities/product_entity.dart';
import 'package:thimar/features/home/domain/repositories/home_repository.dart';
import 'package:thimar/features/home/presentation/bloc/home_bloc.dart';
import 'package:thimar/features/home/presentation/bloc/home_event.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<Either<Failure, List<ProductEntity>>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _fetchFavorites();
  }

  Future<Either<Failure, List<ProductEntity>>> _fetchFavorites() {
    final repo = sl<HomeRepository>();
    return repo.getFavoriteProducts();
  }

  void _refresh() {
    setState(() {
      _favoritesFuture = _fetchFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('nav_favorites'.tr())),
      body: FutureBuilder<Either<Failure, List<ProductEntity>>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoading());
          }

          return snapshot.data?.fold(
                (failure) =>
                    AppError(message: failure.message, onRetry: _refresh),
                (products) {
                  if (products.isEmpty) {
                    return Center(
                      child: AppEmptyState(
                        icon: Icons.favorite_border,
                        title: 'no_favorites'.tr(),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _refresh(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GridView.builder(
                        padding: EdgeInsets.only(top: 16.h, bottom: 100.h),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14.h,
                          crossAxisSpacing: 14.w,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            isFavorite: true,
                            onFavoriteToggle: () {
                              context.read<HomeBloc>().add(
                                ProductFavoriteToggled(product.id),
                              );
                              _refresh();
                            },
                          );
                        },
                      ),
                    ),
                  );
                },
              ) ??
              const SizedBox.shrink();
        },
      ),
    );
  }
}
