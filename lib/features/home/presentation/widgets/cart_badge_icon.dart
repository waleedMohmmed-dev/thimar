import 'package:thimar/core/imports/core_imports.dart';

class CartBadgeIcon extends StatelessWidget {
  const CartBadgeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return GestureDetector(
      onTap: () => context.goCart(),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(Icons.shopping_cart_outlined, color: cs.primary),
          ),
          PositionedDirectional(
            end: 3,
            top: 0,
            child: Container(
              width: 16.w,
              height: 16.w,
              decoration: BoxDecoration(
                color: cs.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '0',
                  style: tt.bodySmall?.copyWith(
                    color: context.colorScheme.onPrimary,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
