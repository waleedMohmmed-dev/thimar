import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/home/presentation/widgets/cart_badge_icon.dart';

class HomeTopHeader extends StatelessWidget {
  const HomeTopHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [CartBadgeIcon()],
      ),
    );
  }
}
