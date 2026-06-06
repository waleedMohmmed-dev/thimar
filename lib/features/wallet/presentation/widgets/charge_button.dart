import 'package:thimar/core/imports/core_imports.dart';
import 'package:thimar/features/wallet/presentation/widgets/dashed_border_painter.dart';

class ChargeButton extends StatelessWidget {
  const ChargeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = context.colorScheme;
    final tt = context.textTheme;

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(15.r),
      child: CustomPaint(
        painter: DashedBorderPainter(color: cs.primary, borderRadius: 15.r),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Center(
            child: Text(
              'charge_now'.tr(),
              style: tt.titleMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
