import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/core/injection/injection.dart';
import 'package:thimar/features/home/domain/entities/category_entity.dart';
import 'package:thimar/features/home/domain/usecases/get_categories_use_case.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({super.key});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  final GetCategoriesUseCase _getCategoriesUseCase =
      sl<GetCategoriesUseCase>();
  late Future<List<CategoryEntity>> _categoriesFuture;

  static const List<Color> _categoryColors = [
    Color(0xFFE8F5E9),
    Color(0xFFFFF3E0),
    Color(0xFFFCE4EC),
    Color(0xFFFFF8E1),
    Color(0xFFE3F2FD),
    Color(0xFFF3E5F5),
  ];

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _fetchCategories();
  }

  Future<List<CategoryEntity>> _fetchCategories() async {
    final result = await _getCategoriesUseCase(NoParams());
    return result.fold((failure) => [], (categories) => categories);
  }

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Container(
                width: 4.w,
                height: 22.h,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                'الأقسام',
                style: tt.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: cs.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 108.h,
          child: FutureBuilder<List<CategoryEntity>>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final categories = snapshot.data ?? [];
              if (categories.isEmpty) return const SizedBox.shrink();
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: categories.length,
                separatorBuilder: (_, _) => SizedBox(width: 16.w),
                itemBuilder: (context, i) {
                  final cat = categories[i];
                  final color =
                      _categoryColors[i % _categoryColors.length];
                  return CategoryCard(
                    label: cat.name,
                    imagePath: cat.media,
                    backgroundColor: color,
                    isNetworkImage: true,
                    onTap: () => context.push(
                      '${AppRoutes.categoryProducts}/${cat.id}?name=${Uri.encodeQueryComponent(cat.name)}',
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
